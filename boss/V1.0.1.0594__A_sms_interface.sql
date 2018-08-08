-- auto gen by linsen 2018-08-08 17:45:28
--短信接口添加属性 by younger

SELECT redo_sqls($$
ALTER TABLE "sms_interface" ADD COLUMN "app_id" varchar(32);
ALTER TABLE "sms_interface" ADD COLUMN "template_code" varchar(32);
ALTER TABLE "sms_interface" ADD COLUMN "use_status" varchar(2);
$$);
COMMENT ON COLUMN "sms_interface"."app_id" IS '应用ID,个别接口使用';
COMMENT ON COLUMN "sms_interface"."template_code" IS '使用模板编号';
COMMENT ON COLUMN "sms_interface"."use_status" IS '使用状态1使用0停用';


INSERT INTO "sms_interface" ("id", "abbr_name", "full_name", "username", "password", "data_key", "request_url", "multiple_split", "remarks", "api_class", "interface_version", "ext_json", "multiple_num", "request_content_type", "response_content_type", "reques_method", "signature", "app_id", "template_code", "use_status")
	SELECT '2', '赛邮', '赛邮短信', NULL, NULL, NULL, 'https://api.mysubmail.com/message/send.json', '', '', 'org.soul.service.smsinterface.imp.SubmailSmsApi', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
WHERE NOT EXISTS (SELECT id FROM sms_interface WHERE id = 2);
