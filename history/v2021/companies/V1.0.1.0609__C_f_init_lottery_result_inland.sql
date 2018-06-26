-- auto gen by marz 2018-05-02 11:18:02
DROP FUNCTION IF EXISTS "f_init_lottery_result_inland"(lottery_date date);
CREATE OR REPLACE FUNCTION "f_init_lottery_result_inland"(lottery_date date)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者   内容
--v1.01  2018/01/01  Marz  初始化国内彩开奖结果

*/
declare
handicapRecord RECORD;--盘口信息集合
lotteryExpect VARCHAR;--期数
lotteryType VARCHAR;--彩票类型
openingTime TIMESTAMP;--开盘时间
closeTime TIMESTAMP;--封盘时间
lotteryTime TIMESTAMP;--开奖时间
maxExpectPk10 VARCHAR;--北京pk10期数
maxExpectBJKL8 VARCHAR;--北京快乐８期数
maxExpectFc3d VARCHAR;--福彩3D期数
maxExpectTtcpl3 VARCHAR;--体彩排列3期数
BEGIN


SELECT MAX(expect) FROM lottery_result WHERE  code = 'bjpk10' AND open_time <= ( lottery_date :: TIMESTAMP - INTERVAL '8 h') INTO maxExpectPk10;
SELECT MAX(expect) FROM lottery_result WHERE  code = 'bjkl8' AND open_time <= ( lottery_date :: TIMESTAMP - INTERVAL '8 h') INTO maxExpectBJKL8;
SELECT MAX(expect) FROM lottery_result WHERE  code = 'fc3d' AND open_time <= ( lottery_date :: TIMESTAMP - INTERVAL '8 h') INTO maxExpectFc3d;
SELECT MAX(expect) FROM lottery_result WHERE  code = 'tcpl3' AND open_time <= ( lottery_date :: TIMESTAMP - INTERVAL '8 h') INTO maxExpectTtcpl3;


raise notice '当期pk10的开奖期数为 %', maxExpectPk10;
raise notice '当期北京快乐8的开奖期数为 %', maxExpectBJKL8;
raise notice '当期福彩3D的开奖期数为 %', maxExpectFc3d;
raise notice '当期体彩排列3的开奖期数为 %', maxExpectTtcpl3;

FOR handicapRecord in SELECT * FROM lottery_handicap ORDER BY code,lottery_time
loop
openingTime  = NULL;
closeTime = NULL;
lotteryTime =NULL;

IF handicapRecord.code = 'bjpk10' THEN
lotteryExpect = (handicapRecord.expect :: INT + maxExpectPk10::INT) :: VARCHAR ;
lotteryType = 'pk10';
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;


IF handicapRecord.code = 'bjkl8' THEN
lotteryExpect = (handicapRecord.expect :: INT + maxExpectBJKL8::INT) :: VARCHAR ;
 lotteryType = 'keno';
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

IF handicapRecord.code = 'xy28' THEN
lotteryExpect = (handicapRecord.expect :: INT + maxExpectBJKL8::INT) :: VARCHAR ;
 lotteryType = 'xy28';
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
END IF;


IF handicapRecord.code = 'xjssc' THEN
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
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

IF handicapRecord.code = 'gxk3' OR handicapRecord.code = 'jsk3' THEN
lotteryExpect = to_char(lottery_date, 'yyMMdd')  || handicapRecord.expect;
lotteryType = 'k3';
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

IF handicapRecord.code = 'gdkl10' THEN
lotteryExpect = to_char(lottery_date, 'yyyyMMdd')  || handicapRecord.expect;
lotteryType = 'sfc';
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

IF handicapRecord.code = 'cqxync'  THEN
lotteryExpect = to_char(lottery_date, 'yyyyMMdd')  || handicapRecord.expect;
lotteryType = 'sfc';
IF handicapRecord.expect::INT <=13 THEN
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
ELSE
openingTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;
END IF;

IF handicapRecord.code = 'fc3d' THEN
lotteryExpect = (handicapRecord.expect :: INT + maxExpectFc3d::INT) :: VARCHAR ;
lotteryType = 'pl3';
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
closeTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.close_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
lotteryTime =to_timestamp(to_char(lottery_date, 'yyyyMMdd') || to_char( handicapRecord.lottery_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
END IF;

IF  handicapRecord.code = 'tcpl3' THEN
lotteryExpect = (handicapRecord.expect :: INT + maxExpectTtcpl3::INT) :: VARCHAR ;
lotteryType = 'pl3';
openingTime =to_timestamp(to_char(lottery_date - INTERVAL '1 d', 'yyyyMMdd') || to_char( handicapRecord.open_time, 'HH24MISS'), 'YYYYMMddHH24MISS');
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


COMMENT ON FUNCTION "f_init_lottery_result_inland"(lottery_date date) IS '初始化国内彩开奖结果';