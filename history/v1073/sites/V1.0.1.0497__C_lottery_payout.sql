-- auto gen by cherry 2017-08-04 21:57:31
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

lotteryResult RECORD;--开奖结果

queryResultSql VARCHAR;--查询sql

v_count int;--sql执行影响条数

reslut_value varchar;--返回结果



SUCCESS text:= 'success';--开奖成功

BEGIN



IF lottery_expect = ''  or lottery_code='' THEN

return 'faild';

END IF;

if lottery_code like '%ssc' then

	SELECT lottery_payout_ssc(lottery_expect,lottery_code,p_com_url) INTO reslut_value;

ELSEIF lottery_code like '%lhc' then

	SELECT lottery_payout_lhc(lottery_expect,lottery_code,p_com_url) INTO reslut_value;

ELSEIF lottery_code like '%pk10' then

	SELECT lottery_payout_pk10(lottery_expect,lottery_code,p_com_url) INTO reslut_value;

ELSEIF lottery_code like '%k3' then

	SELECT lottery_payout_k3(lottery_expect,lottery_code,p_com_url) INTO reslut_value;

ELSE

--其它彩种待处理

end if;

IF reslut_value = SUCCESS THEN

update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,

		update_time=now(),order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),result_json=(select array_to_json(array_agg(row_to_json(t))) json from (select * from lottery_bet_order o where o.id=lo.id) t)

FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect;

END IF;

raise notice '调用过程结果：%',reslut_value;

  return reslut_value;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, p_com_url text) IS '彩票派彩';