-- auto gen by linsen 2018-08-08 17:48:02
--短信接口添加属性 by younger

SELECT redo_sqls($$
ALTER TABLE "sms_interface" ADD COLUMN "app_id" varchar(32);
ALTER TABLE "sms_interface" ADD COLUMN "template_code" varchar(32);
ALTER TABLE "sms_interface" ADD COLUMN "use_status" varchar(2);
$$);

COMMENT ON COLUMN "sms_interface"."app_id" IS '应用ID,个别接口使用';
COMMENT ON COLUMN "sms_interface"."template_code" IS '使用模板编号';
COMMENT ON COLUMN "sms_interface"."use_status" IS '使用状态1使用0停用';
