-- auto gen by marz 2018-02-15 19:19:56
DROP FUNCTION IF EXISTS "f_init_lottery_result"(lottery_date date);
CREATE OR REPLACE FUNCTION "f_init_lottery_result"(lottery_date date)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者   内容
--v1.01  2018/02/15 Marz  调整调用方式
*/
declare

BEGIN

raise notice '开始初始化开奖结果数据，开奖日期为 %', lottery_date :: TIMESTAMP;

PERFORM f_init_lottery_result_lhc(lottery_date);
PERFORM f_init_lottery_result_own(lottery_date);
PERFORM f_init_lottery_result_foreign(lottery_date);

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_init_lottery_result"(lottery_date date) IS '初始化开奖结果';