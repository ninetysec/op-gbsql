-- auto gen by cheery 2015-11-18 02:01:05
---------------------------start 存款优惠计算-----------------------------------------
--存款优惠计算入口
CREATE OR REPLACE FUNCTION f_preferential_deposit(activitymessageid integer, money numeric)
  RETURNS SETOF record AS
  $BODY$
declare
    rec_temp record;
		rec	RECORD;--返回结果集
		rec_preferential RECORD;--该活动的优惠规则
		order_num int;--满足的优惠档次
   exceSql VARCHAR;
BEGIN
select f_deposit_amount(activitymessageid, money ) into order_num;
exceSql = 'SELECT T.preferential_form,T.preferential_value,T.preferential_audit	FROM	activity_way_relation T WHERE T.activity_message_id=' || activitymessageid  ||' AND T.order_column=' || order_num  ;
FOR rec IN EXECUTE exceSql
loop
RETURN NEXT rec;
END loop;
RETURN;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100
ROWS 1000;
ALTER FUNCTION f_preferential_deposit(integer, numeric)
OWNER TO postgres;
COMMENT ON FUNCTION "f_preferential_deposit"(activitymessageid integer, money numeric) IS '存款优惠计算入口';


--存款金额规则优惠结果计算
CREATE OR REPLACE FUNCTION f_deposit_amount(activitymessageid integer, money numeric)
  RETURNS integer AS
  $BODY$
declare
			order_num int;-- 满足的档次
			sql_text VARCHAR;--查询语句
			rec	RECORD;--查询结果集
BEGIN


sql_text = 'select t.order_column from activity_preferential_relation t where t.activity_message_id = ' || activitymessageid  || ' and t.preferential_value <= ' ||  money  ||' ORDER BY order_column DESC LIMIT 1;';

EXECUTE sql_text INTO order_num;

RETURN  COALESCE(order_num, 0);
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION f_deposit_amount(integer, numeric)
OWNER TO postgres;
COMMENT ON FUNCTION "f_deposit_amount"(activitymessageid integer, money numeric) IS '存款金额规则优惠结果计算';

-------------------------end 存款优惠计算-------------------------------------------