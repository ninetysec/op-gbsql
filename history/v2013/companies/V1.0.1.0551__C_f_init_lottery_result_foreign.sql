-- auto gen by marz 2018-02-15 19:19:17
DROP FUNCTION IF EXISTS "f_init_lottery_result_foreign"(lottery_date date);
CREATE OR REPLACE FUNCTION "f_init_lottery_result_foreign"(lottery_date date)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者   内容
--v1.01  2018/01/01  Marz  初始化国外彩开奖结果

*/
declare
handicapRecord RECORD;--盘口信息集合
lotteryExpect VARCHAR;--期数
lotteryType VARCHAR;--彩票类型
openingTime TIMESTAMP;--开盘时间
closeTime TIMESTAMP;--封盘时间
lotteryTime TIMESTAMP;--开奖时间
BEGIN


FOR handicapRecord in SELECT * FROM lottery_handicap ORDER BY code,lottery_time
loop
openingTime  = NULL;
closeTime = NULL;
lotteryTime =NULL;

IF handicapRecord.code = 'xyft' THEN
lotteryExpect = to_char(lottery_date, 'yyyyMMdd')  || handicapRecord.expect;
lotteryType = 'pk10';
IF handicapRecord.expect::INT = 1 THEN
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
ELSE
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;


raise notice '彩种:%,期数:%,开盘时间:%,封盘时间:%,开奖时间:%', handicapRecord.code,lotteryExpect,openingTime,closeTime,lotteryTime;


IF lotteryTime IS NOT NULL AND NOT EXISTS (SELECT * FROM lottery_result WHERE expect = lotteryExpect AND code = handicapRecord.code) THEN
INSERT INTO lottery_result (expect, code, type, open_code, open_time, close_time, opening_time)
VALUES (lotteryExpect, handicapRecord.code, lotteryType, NULL, lotteryTime, closeTime, openingTime);
END IF;
end loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "f_init_lottery_result_foreign"(lottery_date date) IS '初始化国外彩开奖结果';