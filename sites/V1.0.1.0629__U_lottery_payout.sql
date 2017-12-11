-- auto gen by fei 2017-12-11 14:54:33
CREATE OR REPLACE FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, p_com_url text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- expect 期数
  -- lottery_code 彩种代号
  -- p_com_url 数据源地址
	--运行函数
	--select lottery_payout('2017041062','cqssc','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')
*/

DECLARE

opencodeSql  VARCHAR;--开奖结果查询sql
opencode  VARCHAR;--开奖结果查询sql
winningRecordSql VARCHAR;--中奖结果查询sql
lotteryResultJson VARCHAR;--所有中奖结果 JSON串
unsettled RECORD;--数据库连接

lotteryParameter json;--优惠活动信息
queryResultSql VARCHAR;--查询sql
v_count int;--sql执行影响条数
reslut_value varchar;--返回结果
lotteryBetOrder RECORD;--开奖结果

MSG_FAILD text:= 'faild';--开奖成功
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN

IF lottery_expect = ''  or lottery_code='' THEN
return MSG_FAILD;
END IF;
--查询当期该彩种的所有中奖记录
opencodeSql = 'select open_code from lottery_result where expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;
winningRecordSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;
winningRecordSql = 'select array_to_json(array_agg(row_to_json(t))) from ('||winningRecordSql||') t';

perform dblink_connect_u('mainsite', p_com_url);
SELECT * from dblink('mainsite', opencodeSql) as opencode_temp(opencode VARCHAR) INTO opencode;
SELECT * from dblink('mainsite', winningRecordSql) as unsettled_temp(lotteryResultJson VARCHAR) INTO lotteryResultJson;
perform dblink_disconnect('mainsite');

IF lotteryResultJson is null or lotteryResultJson = '' THEN
  RETURN MSG_FAILD;
END IF;
lotteryParameter = json_build_object('expect',lottery_expect,'code',lottery_code,'opencode',opencode);

raise notice '中奖记录为:%', lotteryResultJson;
raise notice '开奖参数为:%', lotteryParameter;

if lottery_code like '%ssc' then
	SELECT lottery_payout_ssc(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%lhc' then
	SELECT lottery_payout_lhc(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%pk10' OR lottery_code='xyft' then
	SELECT lottery_payout_pk10(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%k3' then
	SELECT lottery_payout_k3(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'cqxync' or lottery_code = 'gdkl10' then
	SELECT lottery_payout_sfc(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'fc3d' or lottery_code = 'tcpl3' then
	SELECT lottery_payout_pl3(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'bjkl8' then
	SELECT lottery_payout_keno(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'xy28' then
	SELECT lottery_payout_xy28(lotteryResultJson,lotteryParameter) INTO reslut_value;
ELSE
--其它彩种待处理
end if;
--派彩大于0的需要更新api余额，生成资金记录
FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
    UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22 AND NOT EXISTS (SELECT id FROM lottery_transaction WHERE source_id=lotteryBetOrder.id AND transaction_type='2');
    INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩' WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type in('2','7'));
END loop;

IF reslut_value = MSG_SUCCESS THEN
--更新player_game_order的同时更新未稽核中间表
with pgo as (
update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.effective_trade_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,
		update_time=now(),order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),result_json=(select array_to_json(array_agg(row_to_json(t))) json from (select * from lottery_bet_order o where o.id=lo.id) t)
			FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect
			RETURNING po.id, po.api_id, po.bet_id, po.player_id, po.effective_trade_amount, po.payout_time, po.order_state
    )
		INSERT INTO player_game_order_not_audit (id, api_id, bet_id, player_id, effective_trade_amount, payout_time, order_state)
		SELECT id, api_id, bet_id, player_id, effective_trade_amount, payout_time, order_state
		FROM pgo
		ON CONFLICT (id)
		DO UPDATE
		SET player_id= excluded.player_id,
		effective_trade_amount = excluded.effective_trade_amount,
		payout_time = excluded.payout_time,
		order_state = excluded.order_state;

END IF;
raise notice '调用过程结果：%',reslut_value;
  return reslut_value;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, p_com_url text) IS '彩票派彩';
