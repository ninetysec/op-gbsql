-- auto gen by linsen 2018-04-19 10:35:13
-- 添加短信 信息签名 by carl
SELECT redo_sqls($$
	ALTER TABLE sms_interface ADD COLUMN signature character varying(60);
$$);
COMMENT ON COLUMN "sms_interface"."signature" IS '信息签名';