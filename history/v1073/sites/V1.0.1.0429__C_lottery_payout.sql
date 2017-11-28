-- auto gen by cherry 2017-04-21 21:18:32
DROP function if EXISTS "lottery_payout"(expect text, lottery_code text, p_com_url text);
CREATE OR REPLACE FUNCTION "lottery_payout"(expect text, lottery_code text, p_com_url text)

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



BEGIN



IF expect = ''  or lottery_code='' THEN

return 'faild';

END IF;



--if lottery_code like '%ssc' then

	SELECT lottery_payout_ssc(expect,lottery_code,p_com_url) INTO reslut_value;

--end if;



--raise notice '参数: %,%', expect,lottery_code;

--查询该彩种当期的所有中奖记录结果

--queryResultSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || expect || ''' and code=''' || lottery_code || '''' ;



--将中奖记录

--UPDATE lottery_bet_order b SET payout =bet_amount*odd,payout_time = now(), status='2'  FROM

--(SELECT * from dblink(p_com_url,queryResultSql) as  tempTable(expect VARCHAR,code VARCHAR,playcode VARCHAR,betcode VARCHAR,winningNum VARCHAR)) t  WHERE b.expect = t.expect  AND b.bet_code=t.betcode;

--GET DIAGNOSTICS v_count = ROW_COUNT;

--raise notice '更新投注记录共%条', v_count;

raise notice '调用过程结果：%',reslut_value;



  return reslut_value;



END;







$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "lottery_payout"(expect text, lottery_code text, p_com_url text) IS '彩票派彩';





CREATE OR REPLACE FUNCTION "lottery_payout_ssc"(lottery_expect text, lottery_code text, p_com_url text)

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



BEGIN

raise notice '参数: %,%', lottery_expect,lottery_code;

IF lottery_expect = ''  or lottery_code='' THEN

return 'failed';

END IF;

--查询该彩种当期的所有中奖记录结果

queryResultSql = 'select expect,code,play_code,bet_code,winning_num from lottery_winning_record where  expect = ''' || lottery_expect  || ''' and code=''' || lottery_code || '''' ;

queryResultSql = 'select array_to_json(array_agg(row_to_json(t))) from ('||queryResultSql||') t';

for unsettled in

	SELECT * from dblink(p_com_url,queryResultSql) as unsettled_temp(lotteryResultJson VARCHAR)

loop

	lotteryResultJson = unsettled.lotteryResultJson;

end loop;

--raise notice '中奖记录JSON串：%', lotteryResultJson;



if lotteryResultJson is null or lotteryResultJson = '' then

	raise notice '中奖记录JSON串为空，不再进行派彩';

	return 'failed';

end if;

--对中奖记录进行派彩

for resultJson in

	select json_array_elements(lotteryResultJson::json)

loop

	select resultJson::json->>'expect' into p_expect;

	select resultJson::json->>'code' into p_code;

	select resultJson::json->>'play_code' into p_play_code;

	select resultJson::json->>'bet_code' into p_bet_code;

	select resultJson::json->>'winning_num' into p_winning_num;



	queryResultSql = 'select * from lottery_bet_order where expect = '''||p_expect||''' and code = '''||p_code||''' and play_code='''||p_play_code||''' and bet_code='''||p_bet_code||''' and bet_num = '''||p_winning_num||''' and status='''||1||'''';

	for lotteryBetOrder in EXECUTE queryResultSql

	loop

		update lottery_bet_order  set payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=bet_amount*odd where id=lotteryBetOrder.id;

		--更新API余额

		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id;

	end loop;



end loop;

--对未中奖记录进行派彩

for resultJson in

	select json_array_elements(lotteryResultJson::json)

loop

	select resultJson::json->>'expect' into p_expect;

	select resultJson::json->>'code' into p_code;

	select resultJson::json->>'play_code' into p_play_code;

	select resultJson::json->>'bet_code' into p_bet_code;

	select resultJson::json->>'winning_num' into p_winning_num;



	update lottery_bet_order  set payout =0,payout_time = now(), status='2',effective_trade_amount=bet_amount

			where expect = p_expect and code = p_code and play_code=p_play_code and bet_code=p_bet_code and bet_num <> p_winning_num and status='1';

		GET DIAGNOSTICS v_count = ROW_COUNT;

		if v_count>0 THEN

			raise notice '更新未中奖投注记录共%条', v_count;

		end IF;



end loop;

for lotteryBetOrder in

	SELECT * FROM lottery_bet_order WHERE expect = lottery_expect and status='2'

loop

	--插入资金记录

	--投注记录已结算且派彩金额大于0且资金记录表还没有记录的才处理

	DELETE from lottery_transaction where source_id=lotteryBetOrder.id;

	select count(1) from lottery_transaction where source_id=lotteryBetOrder.id into v_count;

	IF (v_count is null or v_count = 0) and lotteryBetOrder.payout>0 THEN

			INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id)

				VALUES( lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select money from player_api where player_id=lotteryBetOrder.user_id and api_id=22),

				lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id);

	END IF;

	queryResultSql = 'select array_to_json(array_agg(row_to_json(t))) from (select * from lottery_bet_order where id='||lotteryBetOrder.id||') t';

	for lotteryResultJson in EXECUTE queryResultSql

	loop

		resultJson = lotteryResultJson;

	end loop;

	--更新投注记录表

	update player_game_order set profit_amount=(COALESCE(lotteryBetOrder.payout,0)-COALESCE(lotteryBetOrder.bet_amount,0)),payout_time=lotteryBetOrder.payout_time,effective_trade_amount=lotteryBetOrder.effective_trade_amount,

		update_time=now(),order_state='settle',result_json=resultJson where bet_id = lotteryBetOrder.id::text;



end loop;



return 'success';



END;







$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;

COMMENT ON FUNCTION "lottery_payout_ssc"(lottery_expect text, lottery_code text, p_com_url text) IS '时时彩派彩';

CREATE TABLE IF not EXISTS "lottery_bet_order" (
"id" serial4  NOT NULL PRIMARY KEY,

"expect" varchar(32) COLLATE "default",

"username" varchar(32) COLLATE "default",

"bet_time" timestamp(6),

"code" varchar(32) COLLATE "default",

"play_code" varchar(32) COLLATE "default",

"bet_code" varchar(32) COLLATE "default",

"bet_num" varchar(32) COLLATE "default",

"odd" numeric(20,3),

"bet_amount" numeric(20,2),

"payout" numeric(20,2),

"payout_time" timestamp(6),

"status" varchar(32) COLLATE "default",

"terminal" varchar(32) COLLATE "default",

"memo" varchar(50) COLLATE "default",

"user_id" int4,

"effective_trade_amount" numeric(20,2)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_bet_order" IS '投注记录表';

COMMENT ON COLUMN "lottery_bet_order"."id" IS '主键';

COMMENT ON COLUMN "lottery_bet_order"."expect" IS '期数';

COMMENT ON COLUMN "lottery_bet_order"."username" IS '玩家账号';

COMMENT ON COLUMN "lottery_bet_order"."bet_time" IS '投注时间';

COMMENT ON COLUMN "lottery_bet_order"."code" IS '投注彩种';

COMMENT ON COLUMN "lottery_bet_order"."play_code" IS '彩种玩法';

COMMENT ON COLUMN "lottery_bet_order"."bet_code" IS '投注玩法';

COMMENT ON COLUMN "lottery_bet_order"."bet_num" IS '投注号码,多个号码逗号隔开';

COMMENT ON COLUMN "lottery_bet_order"."odd" IS '赔率';

COMMENT ON COLUMN "lottery_bet_order"."bet_amount" IS '投注金额';

COMMENT ON COLUMN "lottery_bet_order"."payout" IS '派彩金额';

COMMENT ON COLUMN "lottery_bet_order"."payout_time" IS '派彩时间';

COMMENT ON COLUMN "lottery_bet_order"."status" IS '结算状态(待结算，已结算，撤单)';

COMMENT ON COLUMN "lottery_bet_order"."terminal" IS '终端标示';

COMMENT ON COLUMN "lottery_bet_order"."memo" IS '投注内容描述';

COMMENT ON COLUMN "lottery_bet_order"."user_id" IS '玩家ID';

COMMENT ON COLUMN "lottery_bet_order"."effective_trade_amount" IS '有效交易量';

CREATE TABLE IF NOT EXISTS "lottery_transaction" (

"id" serial4 NOT NULL PRIMARY KEY,

"user_id" int4,

"username" varchar(32) COLLATE "default",

"transaction_type" varchar(32) COLLATE "default",

"money" numeric(20,3),

"balance" numeric(20,2),

"transaction_time" timestamp(6),

"terminal" varchar(32) COLLATE "default",

"memo" varchar(50) COLLATE "default",

"source_id" int4

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_transaction" IS '彩票资金记录表';

COMMENT ON COLUMN "lottery_transaction"."id" IS '主键';

COMMENT ON COLUMN "lottery_transaction"."user_id" IS '玩家ID';

COMMENT ON COLUMN "lottery_transaction"."username" IS '玩家账号';

COMMENT ON COLUMN "lottery_transaction"."transaction_type" IS '交易类型 (投注，派彩，存款，提款)';

COMMENT ON COLUMN "lottery_transaction"."money" IS '交易金额,有正负';

COMMENT ON COLUMN "lottery_transaction"."balance" IS '钱包余额';

COMMENT ON COLUMN "lottery_transaction"."transaction_time" IS '交易时间';

COMMENT ON COLUMN "lottery_transaction"."terminal" IS '终端标示';

COMMENT ON COLUMN "lottery_transaction"."memo" IS '备注';

COMMENT ON COLUMN "lottery_transaction"."source_id" IS '交易来源ID';