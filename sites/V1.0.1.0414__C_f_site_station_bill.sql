-- auto gen by cherry 2017-03-21 15:27:47
DROP FUNCTION IF EXISTS "f_site_station_bill"(stat_month text, p_start_time text, p_end_time text);

CREATE OR REPLACE FUNCTION "f_site_station_bill"(stat_month text, p_start_time text, p_end_time text)

  RETURNS "pg_catalog"."json" AS $BODY$

DECLARE

t_start_time 	TIMESTAMP;--查询开始时间

t_end_time 	TIMESTAMP;--查询结束时间

p_year INT :=0; --统计年

p_month INT :=0;--统计月

billRecord RECORD;--API派彩记录

bbinProfitLoss NUMERIC(20,2) :=0;--BBIN派彩

hasBbinRecord BOOLEAN := false;

resultCount int4 := 0;

BEGIN

SELECT substring(stat_month from 1 for 4) INTO p_year;

SELECT substring(stat_month from 6 for 7) INTO p_month;



t_start_time = p_start_time::TIMESTAMP;

t_end_time = p_end_time::TIMESTAMP;



DELETE FROM site_station_bill WHERE bill_year=p_year and bill_month=p_month;



INSERT INTO site_station_bill



(bill_year,bill_month,api_type_id,api_id,profit_loss)



select p_year,p_month,api_type_id,api_id,COALESCE(sum(-profit_amount), 0.00) cc from player_game_order

	where payout_time>=t_start_time and payout_time<t_end_time and order_state='settle' group by api_type_id,api_id;





select count(1) from site_station_bill where bill_year=p_year and bill_month=p_month into resultCount;



return resultCount;

END $BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "f_site_station_bill"(stat_month text, p_start_time text, p_end_time text) IS '站点结算账单';