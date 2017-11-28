/**
* 根据计算周期统计各代理的分摊费用(返水、优惠、推荐、返手续费)
* @author Lins
* @date 2015.11.13
* 参数1.返佣主表键值
* 参数2.开始时间
* 参数3.结束时间
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
*/
--drop function gamebox_expense_gather(int,TIMESTAMP,TIMESTAMP,text,text);
create or replace function gamebox_expense_gather(keyId int,startTime TIMESTAMP,endTime TIMESTAMP,row_split_char text,col_split_char text) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	agent_id text:='';
	money float:=0.00;
BEGIN
		FOR rec IN
			select u.owner_id,t.fund_type,sum(t.transaction_money) as transaction_money from player_transaction t,sys_user u
			where fund_type in ('backwater','favourable','recommend','refund_fee')
			and t.player_id=u.id and t.status='success'
			and t.create_time>=startTime and t.create_time<endTime
			group by u.owner_id,t.fund_type
		 LOOP
			agent_id=rec.owner_id::text;
			money=rec.transaction_money;
			IF isexists(hash,agent_id) THEN
				param=hash->agent_id;
				--param=param||'^&^'||rec.fund_type||'^'||money::text;
				param=param||row_split_char||rec.fund_type||col_split_char||money::text;
			ELSE
				param=rec.fund_type||col_split_char||money::text;
			END IF;
			select agent_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
		--raise info '%',hash;

	--统计各代理返佣.
		FOR rec IN
			select player_id,sum(rebate_total) as rebate_total
			from settlement_rebate_detail
			where settlement_rebate_id=keyId
			GROUP BY player_id
		LOOP

			agent_id=rec.player_id::text;
			--raise info 'agent_id:%',agent_id;
			money=rec.rebate_total;
			IF isexists(hash,agent_id) THEN
				param=hash->agent_id;
				param=param||row_split_char||'rebate'||col_split_char||money::text;
			ELSE
				param='rebate'||col_split_char||money::text;
			END IF;

			select agent_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
		raise info '统计当前周期内各代理的各种费用信息.完成';
		RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(keyId int,startTime TIMESTAMP,endTime TIMESTAMP,row_split_char text,col_split_char text) IS '返佣-代理的分摊费用(返水、优惠、推荐、返手续费)计算-Lins';