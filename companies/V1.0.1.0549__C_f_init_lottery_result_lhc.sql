-- auto gen by marz 2018-02-15 19:18:33
DROP FUNCTION IF EXISTS "f_init_lottery_result_lhc"(lottery_date date);
CREATE OR REPLACE FUNCTION "f_init_lottery_result_lhc"(lottery_date date)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者   内容
--v1.01  2018/02/15  Marz  初始化六合彩开奖结果

*/
declare
handicapLhcRecord RECORD;--六合彩盘口信息集合
lotteryExpect VARCHAR;--期数
lotteryType VARCHAR;--彩票类型
openingTime TIMESTAMP;--开盘时间
closeTime TIMESTAMP;--封盘时间
lotteryTime TIMESTAMP;--开奖时间
v_count int;
BEGIN

--六合彩期数初始化
FOR handicapLhcRecord in SELECT * FROM lottery_handicap_lhc h WHERE lottery_time >= lottery_date :: TIMESTAMP  AND NOT EXISTS (SELECT * FROM lottery_result  r WHERE  r.expect = h.expect and h.code=r.code) ORDER BY lottery_time
loop
IF NOT EXISTS (SELECT * FROM lottery_result WHERE expect = handicapLhcRecord.expect AND code = handicapLhcRecord.code) THEN
raise notice '彩种:%,期数:%,开盘时间:%,封盘时间:%,开奖时间:%', handicapLhcRecord.code,handicapLhcRecord.expect,handicapLhcRecord.lottery_time,handicapLhcRecord.close_time,handicapLhcRecord.open_time;
INSERT INTO lottery_result (expect, code, type, open_code, open_time, close_time, opening_time)
VALUES (handicapLhcRecord.expect, handicapLhcRecord.code, 'lhc', NULL, handicapLhcRecord.lottery_time, handicapLhcRecord.close_time, handicapLhcRecord.open_time);
END IF;
END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "f_init_lottery_result_lhc"(lottery_date date) IS '初始化六合彩开奖结果';