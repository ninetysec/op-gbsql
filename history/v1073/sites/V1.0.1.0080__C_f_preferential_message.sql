-- auto gen by cherry 2016-03-23 09:20:44
DROP FUNCTION if EXISTS f_preferential_message(activitymessageid int4, sitecode varchar);



CREATE OR REPLACE FUNCTION "f_preferential_message"(activitymessageid int4, sitecode varchar)

  RETURNS "pg_catalog"."void" AS $BODY$declare



status  VARCHAR;--活动审核状态



activitytype VARCHAR;--活动类型



activity_status_success VARCHAR := '1';--活动审核状态



type_effective_transaction VARCHAR := 'effective_transaction';--有效交易量的activity_type



type_profit_loss VARCHAR := 'profit_loss';--盈亏送的activity_type



BEGIN



SELECT check_status,activity_type_code FROM activity_message WHERE id = activitymessageid INTO status,activitytype;



raise info '当前审核状态为:%,活动类型为：%',status,activitytype;



IF status != activity_status_success THEN



raise info '活动:%,未审核通过,立即结束计算.',activitymessageid;



RETURN;



END IF;



IF activitytype = type_profit_loss THEN



	PERFORM f_preferential_profitloss(activitymessageid,sitecode);



	RETURN;



ELSEIF activitytype = type_effective_transaction THEN



	PERFORM f_preferential_effecttransaction(activitymessageid,sitecode);



	RETURN;



END IF;



END



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;


COMMENT ON FUNCTION  "f_preferential_message"(activitymessageid int4, sitecode varchar) IS '周期性优惠活动计算入口';