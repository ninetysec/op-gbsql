-- auto gen by cherry 2017-07-18 15:43:11
DROP FUNCTION IF EXISTS "f_init_lottery_result"(lottery_date date);
CREATE OR REPLACE FUNCTION "f_init_lottery_result"(lottery_date date)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
handicapRecord RECORD;--盘口信息集合
handicapLhcRecord RECORD;--六合彩盘口信息集合
lotteryExpect VARCHAR;--期数
lotteryType VARCHAR;--期数
openingTime TIMESTAMP;--开盘时间
closeTime TIMESTAMP;--封盘时间
lotteryTime TIMESTAMP;--开奖时间
maxExpectPk10 VARCHAR;--北京pk10期数
v_count int;
BEGIN

raise notice '开始初始化开奖结果数据，开奖日期为 %', lottery_date :: TIMESTAMP;



SELECT MAX(expect) FROM lottery_result WHERE  code = 'bjpk10' AND open_time <= ( lottery_date :: TIMESTAMP - INTERVAL '8 h') INTO maxExpectPk10;

raise notice '当期pk10的开奖期数为 %', maxExpectPk10;

--六合彩期数初始化
FOR handicapLhcRecord in SELECT * FROM lottery_handicap_lhc h WHERE lottery_time >= lottery_date :: TIMESTAMP  AND NOT EXISTS (SELECT * FROM lottery_result  r WHERE  r.expect = h.expect ) ORDER BY lottery_time
loop
IF NOT EXISTS (SELECT * FROM lottery_result WHERE expect = handicapLhcRecord.expect AND code = handicapLhcRecord.code) THEN
INSERT INTO lottery_result (expect, code, type, open_code, open_time, close_time, opening_time)
VALUES (handicapLhcRecord.expect, handicapLhcRecord.code, 'lhc', NULL, handicapLhcRecord.lottery_time, handicapLhcRecord.close_time, handicapLhcRecord.open_time);
END IF;
END loop;
--其他彩种期数初始化
FOR handicapRecord in SELECT * FROM lottery_handicap ORDER BY code,lottery_time
loop
openingTime  := NULL;
closeTime = NULL;
lotteryTime =NULL;

IF handicapRecord.code = 'bjpk10' THEN
lotteryExpect = (handicapRecord.expect :: INT + maxExpectPk10::INT) :: VARCHAR ;
lotteryType = 'pk10';
--raise notice '% , %',to_char(lottery_date, 'yyyyMMdd')  || to_char( handicapRecord.open_time, 'HHMISS'  )
-- ,to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HHMISS'), 'YYYYMMddHH24MISS') ;
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

--重庆时时彩24期之前需要处理开奖日期
IF handicapRecord.code = 'cqssc' THEN

lotteryExpect = to_char(lottery_date, 'yyyyMMdd')  || handicapRecord.expect;
lotteryType = 'ssc';

IF handicapRecord.expect::INT <24 THEN
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
ELSEIF handicapRecord.expect::INT = 24 THEN
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
ELSE
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;
--raise notice '% , %',to_char(lottery_date, 'yyyyMMdd')  || to_char( handicapRecord.open_time, 'HHMISS'  )
-- ,to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HHMISS'), 'YYYYMMddHH24MISS') ;
END IF;


IF handicapRecord.code = 'tjssc' OR handicapRecord.code = 'xjssc' THEN
lotteryExpect = to_char(lottery_date, 'yyyyMMdd')  || handicapRecord.expect;
lotteryType = 'ssc';
IF handicapRecord.expect::INT = 1 THEN
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
ELSE
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;


IF handicapRecord.code = 'ahk3' OR  handicapRecord.code = 'hbk3' THEN
lotteryExpect = to_char(lottery_date, 'yyyyMMdd')  || handicapRecord.expect;
lotteryType = 'k3';
--raise notice '% , %',to_char(lottery_date, 'yyyyMMdd')  || to_char( handicapRecord.open_time, 'HHMISS'  )
-- ,to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HHMISS'), 'YYYYMMddHH24MISS') ;
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

IF handicapRecord.code = 'gxk3' OR handicapRecord.code = 'jsk3' THEN
lotteryExpect = to_char(lottery_date, 'yyMMdd')  || handicapRecord.expect;
lotteryType = 'k3';
--raise notice '% , %',to_char(lottery_date, 'yyyyMMdd')  || to_char( handicapRecord.open_time, 'HHMISS'  )
-- ,to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HHMISS'), 'YYYYMMddHH24MISS') ;
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

--raise notice '期数:%,开盘时间:%,封盘时间:%,开奖时间:%', lotteryExpect,openingTime,closeTime,lotteryTime;

IF lotteryTime IS NOT NULL AND NOT EXISTS (SELECT * FROM lottery_result WHERE expect = lotteryExpect AND code = handicapRecord.code) THEN
INSERT INTO lottery_result (expect, code, type, open_code, open_time, close_time, opening_time)
VALUES (lotteryExpect, handicapRecord.code, lotteryType, NULL, lotteryTime, closeTime, openingTime);
END IF;
end loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_init_lottery_result"(lottery_date date) IS '初始化开奖结果';