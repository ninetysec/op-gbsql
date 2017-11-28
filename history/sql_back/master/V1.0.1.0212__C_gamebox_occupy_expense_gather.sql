/**
* 根据计算周期统计各总代的分摊费用(返佣,返水、优惠、推荐、返手续费)
* @author Lins
* @date 2015.11.13
* 参数1.占成主表键值
* 参数2.开始时间
* 参数3.结束时间
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
*/
--drop function gamebox_occupy_expense_gather(INT,TIMESTAMP,TIMESTAMP);
create or replace function gamebox_occupy_expense_gather(keyId int,startTime TIMESTAMP,endTime TIMESTAMP) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	top_agent_id text:='';
	rebate float:=0.00;
	money float:=0.00;
	--发放状态
	issue_state text:='lssuing';
	col_split text:='^';
	row_split text:='^&^';
BEGIN
		--计算返水、优惠、推荐、返手续费

		FOR rec IN
			select a.owner_id,t.fund_type,sum(t.transaction_money) as transaction_money
      from player_transaction t,sys_user u,sys_user a
			where t.fund_type in ('backwater','favourable','recommend','refund_fee')
			and t.player_id=u.id and t.status='success'
			and u.owner_id=a.id
			and t.create_time>=startTime and t.create_time<endTime
			group by a.owner_id,t.fund_type

		 LOOP
			top_agent_id=rec.owner_id::text;
			money=rec.transaction_money;
			IF isexists(hash,top_agent_id) THEN
				param=hash->top_agent_id;
				--param=param||'^&^'||rec.fund_type||'^'||money::text;
				param=param||row_split||rec.fund_type||col_split||money::text;
			ELSE
				param=rec.fund_type||col_split||money::text;
			END IF;
			select top_agent_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
		--raise info '%',hash;

	  --统计各代理返佣.
		FOR rec IN
			select a.owner_id,sum(d.rebate_actual) as rebate_actual
			from  settlement_rebate_agent d,settlement_rebate m,sys_user a
			where d.settlement_rabate_id=m.id and d.agent_id=a.id
			and d.settlement_state=issue_state
			and m.start_time>=startTime and m.end_time<=endTime
			and a.owner_id is not null
			group by a.owner_id
		LOOP

			top_agent_id=rec.owner_id::text;
			money=rec.rebate_actual;
			IF isexists(hash,top_agent_id) THEN
				param=hash->top_agent_id;
				param=param||row_split||'rebate'||col_split||money::text;
			ELSE
				param='rebate'||col_split||money::text;
			END IF;

			select top_agent_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
    --raise info '%',hash;

	  --统计各总代占成.
		FOR rec IN
			select d.top_agent_id,p.username,sum(d.occupy_total) as occupy_total
			,sum(d.effective_transaction) as effective_transaction,sum(d.profit_loss) as profit_loss
			from settlement_occupy_detail d,sys_user p
			where d.settlement_occupy_id=keyId and d.top_agent_id=p.id
			GROUP BY d.top_agent_id,p.username
		LOOP
			top_agent_id=rec.top_agent_id::text;
			--raise info 'agent_id:%',agent_id;
			money=rec.occupy_total;
			--raise info 'API占成:%,有效交易量:%,盈亏:%',money,rec.effective_transaction,rec.profit_loss;
			IF isexists(hash,top_agent_id) THEN
				param=hash->top_agent_id;
				param=param||row_split||'occupy'||col_split||money::text;
				param=param||row_split||'effective_transaction'||col_split||rec.effective_transaction::text;
				param=param||row_split||'profit_amount'||col_split||rec.profit_loss::text;
				param=param||row_split||'username'||col_split||rec.username::text;
			ELSE
				param='occupy'||col_split||money::text;
				param=param||row_split||'effective_transaction'||col_split||rec.effective_transaction::text;
				param=param||row_split||'profit_amount'||col_split||rec.profit_loss::text;
				param=param||row_split||'username'||col_split||rec.username::text;
			END IF;
			select top_agent_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
		--raise info '%',hash;
		raise info '统计当前周期内总代的各种费用信息.完成';
		RETURN hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_expense_gather(keyId int,startTime TIMESTAMP,endTime TIMESTAMP) IS '总代占成-总代的分摊费用(返水、优惠、推荐、返手续费)计算-Lins';