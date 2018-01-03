-- auto gen by cherry 2017-05-18 17:13:29
DROP FUNCTION IF EXISTS "lottery_payout_k3"(lottery_expect text, lottery_code text, p_com_url text);

CREATE OR REPLACE FUNCTION "lottery_payout_k3"(lottery_expect text, lottery_code text, p_com_url text)

  RETURNS "pg_catalog"."varchar" AS $BODY$



  /*版本更新说明



  -- lottery_expect 期数



  -- lottery_code 彩种代号



  -- p_com_url 数据源地址



	--运行函数



	--select lottery_payout('2017041062','jsk3','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')



*/







DECLARE



lotteryResult RECORD;--开奖结果



lotteryBetOrder RECORD;--开奖结果



winningRecordSql VARCHAR;--开奖结果查询sql



queryResultSql VARCHAR;--查询sql



v_count int;--sql执行影响条数



unsettled RECORD;--数据库连接



lotteryResultJson VARCHAR;--所有中奖结果 JSON串



resultJson VARCHAR;--单个中奖结果JSON串



p_expect VARCHAR;--期数



p_code VARCHAR;--彩种



p_play_code VARCHAR;--玩法



p_bet_code VARCHAR;--下注内容



p_winning_num VARCHAR;--中奖号码







ERROR_PARAMETER text:='01';--参数错误



ERROR_NOT_NEED text:='02';--无需派彩



ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果



SUCCESS text:= 'success';--开奖成功



BEGIN







--判断是否需要开奖派彩



IF lottery_expect = ''  or lottery_code='' THEN



RETURN ERROR_PARAMETER;



END IF;







IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN



RETURN ERROR_NOT_NEED;



END IF;







winningRecordSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;



winningRecordSql = 'select array_to_json(array_agg(row_to_json(t))) from ('||winningRecordSql||') t';

raise notice 'winningRecordSql值：%',winningRecordSql;



FOR unsettled in



	SELECT * from dblink(p_com_url,winningRecordSql) as unsettled_temp(lotteryResultJson VARCHAR)



loop



	lotteryResultJson = unsettled.lotteryResultJson;



END loop;







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







		UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;







	END loop;







--中奖记录之外的投注派彩全部为0



UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;







--派彩大于0的需要更新api余额，生成资金记录



FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0



loop



		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;



		INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)



				VALUES( lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select money from player_api where player_id=lotteryBetOrder.user_id and api_id=22),



				lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩');



END loop;







return SUCCESS;



END;



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "lottery_payout_k3"(lottery_expect text, lottery_code text, p_com_url text) IS '快3派彩';





DROP FUNCTION IF EXISTS "lottery_payout_lhc"(lottery_expect text, lottery_code text, p_com_url text);

CREATE OR REPLACE FUNCTION "lottery_payout_lhc"(lottery_expect text, lottery_code text, p_com_url text)

  RETURNS "pg_catalog"."varchar" AS $BODY$

  /*版本更新说明

  -- lottery_expect 期数

  -- lottery_code 彩种代号

  -- p_com_url 数据源地址

	--运行函数

	--select lottery_payout('2017041062','hklhc','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')

*/



DECLARE

lotteryResult RECORD;--开奖结果

lotteryBetOrder RECORD;--开奖结果

winningRecordSql VARCHAR;--开奖结果查询sql

queryResultSql VARCHAR;--查询sql

v_count int;--sql执行影响条数

unsettled RECORD;--数据库连接

lotteryResultJson VARCHAR;--所有中奖结果 JSON串

resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数

p_code VARCHAR;--彩种

p_play_code VARCHAR;--玩法

p_bet_code VARCHAR;--下注内容

p_winning_num VARCHAR;--中奖号码



ERROR_PARAMETER text:='01';--参数错误

ERROR_NOT_NEED text:='02';--无需派彩

ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果

SUCCESS text:= 'success';--开奖成功



BEGIN



--判断是否需要开奖派彩

IF lottery_expect = ''  or lottery_code='' THEN

RETURN ERROR_PARAMETER;

END IF;



IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN

RETURN ERROR_NOT_NEED;

END IF;



winningRecordSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;

winningRecordSql = 'select array_to_json(array_agg(row_to_json(t))) from ('||winningRecordSql||') t';

FOR unsettled in

	SELECT * from dblink(p_com_url,winningRecordSql) as unsettled_temp(lotteryResultJson VARCHAR)

loop

	lotteryResultJson = unsettled.lotteryResultJson;

END loop;



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

		IF p_winning_num='和' THEN

    UPDATE lottery_bet_order  SET payout =bet_amount,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num  like p_winning_num;

		ELSE

		UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;

		END IF;

	END loop;



--中奖记录之外的投注派彩全部为0

UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;



--派彩大于0的需要更新api余额，生成资金记录

FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0

loop

		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;

		INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)

				VALUES( lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select money from player_api where player_id=lotteryBetOrder.user_id and api_id=22),

				lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩');

END loop;



return SUCCESS;

END;

$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "lottery_payout_lhc"(lottery_expect text, lottery_code text, p_com_url text) IS '六合彩派彩';







DROP FUNCTION IF EXISTS "lottery_payout_pk10"(lottery_expect text, lottery_code text, p_com_url text);

CREATE OR REPLACE FUNCTION "lottery_payout_pk10"(lottery_expect text, lottery_code text, p_com_url text)

  RETURNS "pg_catalog"."varchar" AS $BODY$

  /*版本更新说明

  -- lottery_expect 期数

  -- lottery_code 彩种代号

  -- p_com_url 数据源地址

	--运行函数

	--select lottery_payout('2017041062','cqssc','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')

*/



DECLARE

lotteryResult RECORD;--开奖结果

lotteryBetOrder RECORD;--开奖结果

winningRecordSql VARCHAR;--开奖结果查询sql

queryResultSql VARCHAR;--查询sql

v_count int;--sql执行影响条数

unsettled RECORD;--数据库连接

lotteryResultJson VARCHAR;--所有中奖结果 JSON串

resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数

p_code VARCHAR;--彩种

p_play_code VARCHAR;--玩法

p_bet_code VARCHAR;--下注内容

p_winning_num VARCHAR;--中奖号码





ERROR_PARAMETER text:='01';--参数错误

ERROR_NOT_NEED text:='02';--无需派彩

ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果

SUCCESS text:= 'success';--开奖成功

BEGIN



--判断是否需要开奖派彩

IF lottery_expect = ''  or lottery_code='' THEN

RETURN ERROR_PARAMETER;

END IF;



IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN

RETURN ERROR_NOT_NEED;

END IF;



winningRecordSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;

winningRecordSql = 'select array_to_json(array_agg(row_to_json(t))) from ('||winningRecordSql||') t';

FOR unsettled in

	SELECT * from dblink(p_com_url,winningRecordSql) as unsettled_temp(lotteryResultJson VARCHAR)

loop

	lotteryResultJson = unsettled.lotteryResultJson;

END loop;



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

		IF p_winning_num='和' THEN

    UPDATE lottery_bet_order  SET payout =bet_amount,payout_time = now(), status='2',effective_trade_amount=bet_amount WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num  like p_winning_num;

		ELSE

		UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;

		END IF;

	END loop;



--中奖记录之外的投注派彩全部为0

UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;



--派彩大于0的需要更新api余额，生成资金记录

FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0

loop

		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;

		INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)

				VALUES( lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select money from player_api where player_id=lotteryBetOrder.user_id and api_id=22),

				lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩');

END loop;



return SUCCESS;

END;

$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "lottery_payout_pk10"(lottery_expect text, lottery_code text, p_com_url text) IS 'PK10派彩';





DROP FUNCTION IF EXISTS "lottery_payout_ssc"(lottery_expect text, lottery_code text, p_com_url text);

CREATE OR REPLACE FUNCTION "lottery_payout_ssc"(lottery_expect text, lottery_code text, p_com_url text)

  RETURNS "pg_catalog"."varchar" AS $BODY$/*版本更新说明

  -- lottery_expect 期数

  -- lottery_code 彩种代号

  -- p_com_url 数据源地址

	--运行函数

	--select lottery_payout('2017041062','cqssc','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')

*/

DECLARE

lotteryResult RECORD;--开奖结果

lotteryBetOrder RECORD;--开奖结果

winningRecordSql VARCHAR;--开奖结果查询sql



queryResultSql VARCHAR;--查询sql



v_count int;--sql执行影响条数

unsettled RECORD;--数据库连接

lotteryResultJson VARCHAR;--所有中奖结果 JSON串

resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数

p_code VARCHAR;--彩种

p_play_code VARCHAR;--玩法

p_bet_code VARCHAR;--下注内容

p_winning_num VARCHAR;--中奖号码

winning_num_arr VARCHAR(3)[]; --组选中奖号码

is_deal BOOLEAN := FALSE;



ERROR_PARAMETER text:='01';--参数错误

ERROR_NOT_NEED text:='02';--无需派彩

ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果

SUCCESS text:= 'success';--开奖成功



BEGIN



--判断是否需要开奖派彩

IF lottery_expect = ''  or lottery_code='' THEN

RETURN ERROR_PARAMETER;

END IF;



IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN

RETURN ERROR_NOT_NEED;

END IF;



winningRecordSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;

winningRecordSql = 'select array_to_json(array_agg(row_to_json(t))) from ('||winningRecordSql||') t';

raise notice 'winningRecordSql值：%',winningRecordSql;

FOR unsettled in

	SELECT * from dblink(p_com_url,winningRecordSql) as unsettled_temp(lotteryResultJson VARCHAR)

loop

	lotteryResultJson = unsettled.lotteryResultJson;

END loop;



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

		IF p_play_code='group_three' THEN

		winning_num_arr = regexp_split_to_array(p_winning_num,'s*');

		p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%';

    raise notice '组选三中奖号码为:%', p_winning_num;

    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num  like p_winning_num;

		ELSEIF p_play_code='group_six' THEN

		winning_num_arr = regexp_split_to_array(p_winning_num,'s*');

    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%'||winning_num_arr[3]||'%';

    raise notice '组选六中奖号码为:%', p_winning_num;

    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num like p_winning_num;

		ELSE

			UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;

		END IF;

	END loop;



--中奖记录之外的投注派彩全部为0

UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount where expect=p_expect AND code=p_code AND status='1' ;



--派彩大于0的需要更新api余额，生成资金记录

FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0

loop

		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;

		INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)

				VALUES( lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select money from player_api where player_id=lotteryBetOrder.user_id and api_id=22),

				lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩');

END loop;



return SUCCESS;

END;

$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "lottery_payout_ssc"(lottery_expect text, lottery_code text, p_com_url text) IS '时时彩派彩';