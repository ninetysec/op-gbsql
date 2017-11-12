-- auto gen by marz 2017-11-07 15:05:54
DROP FUNCTION IF EXISTS "lottery_payout_heavy"(lottery_expect text, lottery_code text, p_com_url text);
CREATE OR REPLACE FUNCTION "lottery_payout_heavy"(lottery_expect text, lottery_code text, p_com_url text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- expect 期数
  -- lottery_code 彩种代号
  -- p_com_url 数据源地址
	--运行函数
	--select lottery_payout_heavy('2017041062','cqssc','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')
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

FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
    UPDATE player_api u SET money = COALESCE(money,0) - COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;
    INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'6',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        now(),lotteryBetOrder.terminal,lotteryBetOrder.id,'重结扣款';
END loop;
    --还原已派彩记录
    UPDATE lottery_bet_order SET payout =null,payout_time =null, status='1',effective_trade_amount=null WHERE expect=lottery_expect AND code=lottery_code AND status='2';


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


FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
    UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;
    INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'7',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'重结派彩';
END loop;

IF reslut_value = MSG_SUCCESS THEN
--更新player_game_order的同时更新未稽核中间表

	update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.effective_trade_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,
		update_time=now(),order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),result_json=(select array_to_json(array_agg(row_to_json(t))) json from (select * from lottery_bet_order o where o.id=lo.id) t)
			FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect;

END IF;
raise notice '调用过程结果：%',reslut_value;
  return reslut_value;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_heavy"(lottery_expect text, lottery_code text, p_com_url text) IS '重结';

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout"(lottery_expect text, lottery_code text, p_com_url text);
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
        lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩' WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type='2');
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

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_xy28"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_xy28"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串
p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码
ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
	RETURN ERROR_NOT_WINNING_RECORD;
END IF;

for resultJson in select json_array_elements(lotteryResultJson::json)
loop
		select resultJson::json->>'expect' into p_expect;
		select resultJson::json->>'code' into p_code;
		select resultJson::json->>'play_code' into p_play_code;
		select resultJson::json->>'bet_code' into p_bet_code;
		select resultJson::json->>'winning_num' into p_winning_num;
    IF p_play_code='xy28_sum3_digital_three' THEN
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 1;
		ELSE
		UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
    END IF;
END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_xy28"(lotteryresultjson text, lotteryparameter json) IS '幸运28派彩';

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_k3"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_k3"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码
winning_num_arr VARCHAR(3)[]; --组选中奖号码

ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
	RETURN ERROR_NOT_WINNING_RECORD;
END IF;

for resultJson in select json_array_elements(lotteryResultJson::json)
loop
		select resultJson::json->>'expect' into p_expect;
		select resultJson::json->>'code' into p_code;
		select resultJson::json->>'play_code' into p_play_code;
		select resultJson::json->>'bet_code' into p_bet_code;
		select resultJson::json->>'winning_num' into p_winning_num;
 IF p_play_code in ('k3_same_num','k3_three_straight')  THEN
IF p_bet_code='k3_danxuan_ertong' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||winning_num_arr[2]||'%|%'||winning_num_arr[3]||'%';
    raise notice '二同号单选中奖号码为:%', p_winning_num;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('k3_fuxuan_ertong','k3_danxuan_santong') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('k3_tongxuan_santong','k3_tongxuan_sanlian') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE p_winning_num = bet_num  and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
	END IF;
ELSEIF p_play_code='k3_diff_num' THEN
IF p_bet_code='k3_erbutong' THEN
UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(regexp_split_to_array(p_winning_num,'s*') ::INT[]  & string_to_array(bet_num, ',') :: INT[], 1)=2 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
UPDATE lottery_bet_order  SET payout =3*odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(regexp_split_to_array(p_winning_num,'s*') ::INT[]  & string_to_array(bet_num, ',') :: INT[], 1)=3 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
ELSEIF p_bet_code='k3_sanbutong' THEN
 winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||',%'||winning_num_arr[2]||',%'||winning_num_arr[3]||'%';
raise notice '三不同中奖号码为:%', p_winning_num;
UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
END IF;
ELSE
		UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
END IF;
END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_k3"(lotteryresultjson text, lotteryparameter json) IS '快3派彩';

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_ssc"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_ssc"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码
winning_num_arr VARCHAR(3)[]; --组选中奖号码
temp_str VARCHAR(32); --临时字符串变量



ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
  RETURN ERROR_NOT_WINNING_RECORD;
END IF;

for resultJson in select json_array_elements(lotteryResultJson::json)
loop
    select resultJson::json->>'expect' into p_expect;
    select resultJson::json->>'code' into p_code;
    select resultJson::json->>'play_code' into p_play_code;
    select resultJson::json->>'bet_code' into p_bet_code;
    select resultJson::json->>'winning_num' into p_winning_num;
    IF p_play_code='group_three' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%';
    raise notice '组选三中奖号码为:%', p_winning_num;
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num  like p_winning_num;
    ELSEIF p_play_code='group_six' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%'||winning_num_arr[3]||'%';
    raise notice '组选六中奖号码为:%', p_winning_num;
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num like p_winning_num;
--官方玩法
    ELSEIF p_play_code='ssc_wuxing_zhixuan' THEN
			IF p_bet_code='ssc_wuxing_zhixuan_fs' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='ssc_wuxing_zhixuan_ds' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_sixing_zhixuan' THEN
			IF p_bet_code='ssc_sixing_zhixuan_fs' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='ssc_sixing_zhixuan_ds' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_sanxing_zhixuan' THEN
			IF p_bet_code in ('ssc_sanxing_zhixuan_qsfs','ssc_sanxing_zhixuan_hsfs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zhixuan_qsds','ssc_sanxing_zhixuan_hsds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zhixuan_qszh','ssc_sanxing_zhixuan_hszh')  THEN
				UPDATE lottery_bet_order  SET payout =(odd+odd2+odd3)*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				temp_str = substr(p_winning_num,3);
				UPDATE lottery_bet_order  SET payout =(odd2+odd3)*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like temp_str and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				temp_str = '%|' || substr(p_winning_num,7);
				UPDATE lottery_bet_order  SET payout =odd3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like temp_str and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zhixuan_qshz','ssc_sanxing_zhixuan_hshz')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(p_winning_num, '')::INT[] & string_to_array(bet_num, '|') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zhixuan_qskd','ssc_sanxing_zhixuan_hskd')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_sanxing_zuxuan' THEN
			IF p_bet_code in ('ssc_sanxing_zuxuan_qsz3fs','ssc_sanxing_zuxuan_hsz3fs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qsz3ds','ssc_sanxing_zuxuan_hsz3ds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qsz6fs','ssc_sanxing_zuxuan_hsz6fs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qsz6ds','ssc_sanxing_zuxuan_hsz6ds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qshhzx','ssc_sanxing_zuxuan_hshhzx') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(array_to_string(string_to_array(p_winning_num, ','), '') in bet_num)>0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE  position(array_to_string(string_to_array(p_winning_num, ','), '') in bet_num)>0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qszxhz','ssc_sanxing_zuxuan_hszxhz')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(ARRAY(select sum(unnest) from unnest(string_to_array(p_winning_num, ',')::INT[]))::INT[]  & string_to_array(bet_num, '|') :: INT[], 1) = 1 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(ARRAY(select sum(unnest) from unnest(string_to_array(p_winning_num, ',')::INT[]))::INT[]  & string_to_array(bet_num, '|') :: INT[], 1) = 1 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qszxbd','ssc_sanxing_zuxuan_hszxbd')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(bet_num in p_winning_num) > 0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(bet_num in p_winning_num) > 0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_sanxing_teshu' THEN
			IF p_bet_code in ('ssc_sanxing_zuxuan_qshzws','ssc_sanxing_zuxuan_hshzws') THEN
				UPDATE lottery_bet_order  SET payout =trunc(odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(p_winning_num in bet_num) > 0 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_sanxing_zuxuan_qsts','ssc_sanxing_zuxuan_hsts')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(p_winning_num in bet_num) = 1 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(p_winning_num in bet_num) = 4 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(p_winning_num in bet_num) = 7 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_erxing_zhixuan' THEN
			IF p_bet_code='ssc_erxing_zhixuan_qefs' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='ssc_erxing_zhixuan_qeds'  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='ssc_erxing_zhixuan_qehz'  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(p_winning_num, '')::INT[] & string_to_array(bet_num, '|') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code ='ssc_erxing_zhixuan_qekd' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_erxing_zuxuan' THEN
			IF p_bet_code = 'ssc_erxing_zuxuan_qefs' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code ='ssc_erxing_zuxuan_qeds'  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code ='ssc_erxing_zuxuan_qehz' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(p_winning_num, '')::INT[] & string_to_array(bet_num, '|') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code ='ssc_erxing_zuxuan_qebd' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(bet_num in p_winning_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_yixing' THEN
			IF p_bet_code = 'ssc_yixing_dwd' THEN
				UPDATE lottery_bet_order  SET payout =trunc(odd*5*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 5 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*4*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 4 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 3 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_budingwei_wuxing' THEN
			IF p_bet_code = 'ssc_budingwei_wxsm' THEN
    				raise notice 'ssc_budingwei_wxsm:%', p_winning_num;
				UPDATE lottery_bet_order  SET payout =odd*10*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 5 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*4*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 4 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code ='ssc_budingwei_wxem' THEN
				UPDATE lottery_bet_order  SET payout =odd*10*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 5 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*6*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 4 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_budingwei_sixing' THEN
			IF p_bet_code in ('ssc_budingwei_q4em','ssc_budingwei_h4em') THEN
				UPDATE lottery_bet_order  SET payout =odd*6*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 4 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_budingwei_q4ym','ssc_budingwei_h4ym') THEN
				UPDATE lottery_bet_order  SET payout =odd*4*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 4 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 1 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
	ELSEIF p_play_code='ssc_budingwei_sanxing' THEN
			IF p_bet_code in ('ssc_budingwei_q3em','ssc_budingwei_h3em') THEN
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('ssc_budingwei_q3ym','ssc_budingwei_h3ym') THEN
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 1 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;

		ELSE
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
    END IF;
  END loop;
--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "lottery_payout_ssc"(lotteryresultjson text, lotteryparameter json) IS '时时彩派彩';

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_sfc"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_sfc"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码

ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;

IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
	RETURN ERROR_NOT_WINNING_RECORD;
END IF;
raise notice '%期%开始进行派彩,中奖记录为:%', lottery_expect,lottery_code,lotteryResultJson;
for resultJson in select json_array_elements(lotteryResultJson::json)
loop
		select resultJson::json->>'expect' into p_expect;
		select resultJson::json->>'code' into p_code;
		select resultJson::json->>'play_code' into p_play_code;
		select resultJson::json->>'bet_code' into p_bet_code;
		select resultJson::json->>'winning_num' into p_winning_num;
		IF p_winning_num='平局' THEN
		  UPDATE lottery_bet_order  SET payout =bet_amount,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
		ELSE
		  UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
		END IF;
END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_sfc"(lotteryresultjson text, lotteryparameter json) IS '十分彩派彩';

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_pl3"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_pl3"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码
winning_num_arr VARCHAR(3)[]; --组选中奖号码

ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;

IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
	RETURN ERROR_NOT_WINNING_RECORD;
END IF;
raise notice '%期%开始进行派彩,中奖记录为:%', lottery_expect,lottery_code,lotteryResultJson;
for resultJson in select json_array_elements(lotteryResultJson::json)
loop
		select resultJson::json->>'expect' into p_expect;
		select resultJson::json->>'code' into p_code;
		select resultJson::json->>'play_code' into p_play_code;
		select resultJson::json->>'bet_code' into p_bet_code;
		select resultJson::json->>'winning_num' into p_winning_num;
		 IF p_play_code='pl3_group_three' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%';
    raise notice '组选三中奖号码为:%', p_winning_num;
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num  like p_winning_num;
    ELSEIF p_play_code='pl3_group_six' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%'||winning_num_arr[3]||'%';
    raise notice '组选六中奖号码为:%', p_winning_num;
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num like p_winning_num;

 --官方玩法
    ELSEIF p_play_code='pl3_sanxing_zhixuan' THEN
			IF p_bet_code='pl3_sanxing_zhixuan_fs' THEN
				 winning_num_arr = regexp_split_to_array(p_winning_num,',');
				 p_winning_num =  '%'||winning_num_arr[1]||'%'||'|%'||winning_num_arr[2]||'%'||'|%'||winning_num_arr[3]||'%';
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='pl3_sanxing_zhixuan_ds' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
            ELSEIF p_bet_code in ('pl3_sanxing_zhixuan_hz')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(p_winning_num, '')::INT[] & string_to_array(bet_num, '|') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
   ELSEIF p_play_code='pl3_sanxing_zuxuan' THEN
			IF p_bet_code in ('pl3_sanxing_zuxuan_z3fs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_z3ds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_z6fs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_z6ds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_hhzx') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(array_to_string(string_to_array(p_winning_num, ','), '') in bet_num)>0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE  position(array_to_string(string_to_array(p_winning_num, ','), '') in bet_num)>0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_zxhz')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(ARRAY(select sum(unnest) from unnest(string_to_array(p_winning_num, ',')::INT[]))::INT[]  & string_to_array(bet_num, '|') :: INT[], 1) = 1 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(ARRAY(select sum(unnest) from unnest(string_to_array(p_winning_num, ',')::INT[]))::INT[]  & string_to_array(bet_num, '|') :: INT[], 1) = 1 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
            END IF;
             ELSEIF p_play_code='pl3_erxing_zhixuan' THEN
			IF p_bet_code in ('pl3_erxing_zhixuan_qefs','pl3_erxing_zhixuan_hefs') THEN
				 winning_num_arr = regexp_split_to_array(p_winning_num,',');
				 p_winning_num = '%'||winning_num_arr[1]||'%'||'|%'||winning_num_arr[2]||'%';
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_erxing_zhixuan_qeds','pl3_erxing_zhixuan_heds') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
            ELSEIF p_play_code='pl3_erxing_zuxuan' THEN
			IF p_bet_code in ( 'pl3_erxing_zuxuan_qefs','pl3_erxing_zuxuan_hefs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_erxing_zuxuan_qeds','pl3_erxing_zuxuan_heds') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
            ELSEIF p_play_code='pl3_yixing' THEN
			IF p_bet_code = 'pl3_yixing_dwd' THEN
				UPDATE lottery_bet_order  SET payout =trunc(odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 3 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
            ELSEIF p_play_code='pl3_budingwei_sanxing' THEN
			IF p_bet_code = 'pl3_budingwei_sxym' THEN
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
        UPDATE lottery_bet_order  SET payout =odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
        UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
			 ELSE
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
    END IF;
END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "lottery_payout_pl3"(lotteryresultjson text, lotteryparameter json) OWNER TO "postgres";

---------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_pk10"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_pk10"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码
winning_num_arr VARCHAR(3)[]; --组选中奖号码

ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;

IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
  RETURN ERROR_NOT_WINNING_RECORD;
END IF;

for resultJson in select json_array_elements(lotteryResultJson::json)
loop
    select resultJson::json->>'expect' into p_expect;
    select resultJson::json->>'code' into p_code;
    select resultJson::json->>'play_code' into p_play_code;
    select resultJson::json->>'bet_code' into p_bet_code;
    select resultJson::json->>'winning_num' into p_winning_num;
    IF p_winning_num='平局' THEN
    UPDATE lottery_bet_order  SET payout =bet_amount,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;

--官方玩法
     ELSEIF p_play_code='pk10_qy_zhixuan' THEN
			IF p_bet_code='pk10_zhixuan_qyfs' THEN
				winning_num_arr = regexp_split_to_array(p_winning_num,',');
				p_winning_num = '%'||winning_num_arr[1]||'%';
				UPDATE lottery_bet_order  SET payout =trunc(odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num LIKE p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
    ELSEIF p_play_code='pk10_qe_zhixuan' THEN
			IF p_bet_code='pk10_zhixuan_qefs' THEN
				winning_num_arr = regexp_split_to_array(p_winning_num,',');
				p_winning_num = '%'||winning_num_arr[1]||'%'||'|%'||winning_num_arr[2]||'%';

				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='pk10_zhixuan_qeds' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
		ELSEIF p_play_code='pk10_qs_zhixuan' THEN
			IF p_bet_code='pk10_zhixuan_qsfs' THEN
				winning_num_arr = regexp_split_to_array(p_winning_num,',');
				p_winning_num = '%'||winning_num_arr[1]||'%'||'|%'||winning_num_arr[2]||'%'||'|%'||winning_num_arr[3]||'%';
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='pk10_zhixuan_qsds' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
		ELSEIF p_play_code='pk10_yixing' THEN
			IF p_bet_code = 'pk10_yixing_dwd' THEN
                UPDATE lottery_bet_order  SET payout =trunc(odd*10*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 10 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
                UPDATE lottery_bet_order  SET payout =trunc(odd*9*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 9 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
                UPDATE lottery_bet_order  SET payout =trunc(odd*8*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 8 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
                UPDATE lottery_bet_order  SET payout =trunc(odd*7*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 7 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
                UPDATE lottery_bet_order  SET payout =trunc(odd*6*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 6 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
					UPDATE lottery_bet_order  SET payout =trunc(odd*5*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 5 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
					UPDATE lottery_bet_order  SET payout =trunc(odd*4*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 4 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
					UPDATE lottery_bet_order  SET payout =trunc(odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 3 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
					UPDATE lottery_bet_order  SET payout =trunc(odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
					UPDATE lottery_bet_order  SET payout =trunc(odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
	 ELSE
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
	 END IF;
  END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_pk10"(lotteryresultjson text, lotteryparameter json) IS 'PK10派彩';
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_lhc"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_lhc"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/

DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码

ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;

IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
  RETURN ERROR_NOT_WINNING_RECORD;
END IF;

for resultJson in select json_array_elements(lotteryResultJson::json)
loop
    select resultJson::json->>'expect' into p_expect;
    select resultJson::json->>'code' into p_code;
    select resultJson::json->>'play_code' into p_play_code;
    select resultJson::json->>'bet_code' into p_bet_code;
    select resultJson::json->>'winning_num' into p_winning_num;
    IF p_winning_num='平局' THEN
    UPDATE lottery_bet_order  SET payout =bet_amount,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
ELSEIF p_play_code='lhc_three_in_two' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd2,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3;
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2;
ELSEIF p_play_code='lhc_two_in_special' THEN
	IF position(';' in p_winning_num) > 0 THEN
		UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ';') :: INT[], 1) = 2;
	ELSE
		UPDATE lottery_bet_order  SET payout =bet_amount*odd2,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2;
	END IF;
ELSEIF p_play_code='lhc_sum_zodiac' THEN
    IF p_bet_code = 'lhc_two_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 1 AND array_length(string_to_array(bet_num, ','), 1)  =  2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_three_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 2 AND array_length(string_to_array(bet_num, ','), 1)  =  3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_four_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 3 AND array_length(string_to_array(bet_num, ','), 1)  =  4 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_five_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 4 AND array_length(string_to_array(bet_num, ','), 1)  =  5 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_six_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 5 AND array_length(string_to_array(bet_num, ','), 1)  =  6 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_seven_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 6 AND array_length(string_to_array(bet_num, ','), 1)  =  7 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_eight_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 7 AND array_length(string_to_array(bet_num, ','), 1)  =  8 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_nine_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 8 AND array_length(string_to_array(bet_num, ','), 1)  =  9 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_ten_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 9 AND array_length(string_to_array(bet_num, ','), 1)  =  10 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    ELSEIF p_bet_code = 'lhc_eleven_zodiac' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE array_length(array_remove(string_to_array(bet_num, ','),p_winning_num::TEXT),1) = 10 AND array_length(string_to_array(bet_num, ','), 1)  =  11 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
    END IF;
ELSEIF p_play_code = 'lhc_twelve_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 12;
ELSEIF p_play_code = 'lhc_eleven_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 11;
ELSEIF p_play_code = 'lhc_ten_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 10;
ELSEIF p_play_code = 'lhc_nine_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 9;
ELSEIF p_play_code = 'lhc_eight_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 8;
ELSEIF p_play_code = 'lhc_seven_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 7;
ELSEIF p_play_code = 'lhc_six_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 6;
ELSEIF p_play_code = 'lhc_five_no_in' THEN
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 5;
    ELSE
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
    END IF;
  END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;

return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_lhc"(lotteryresultjson text, lotteryparameter json) IS '六合彩派彩';
