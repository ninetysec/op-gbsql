-- auto gen by wayne 2016-04-12 23:08:40
CREATE TABLE IF NOT EXISTS "pay_api_provider" (
"id" int4 ,
"channel_code" varchar(16) COLLATE "default" NOT NULL,
"remarks" varchar(128) COLLATE "default",
"jar_url" varchar(128) COLLATE "default",
"api_class" varchar(128) COLLATE "default",
"jar_version" varchar(16) COLLATE "default",
"ext_json" varchar(1500) COLLATE "default",
CONSTRAINT "pk_pay_api_provider" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "pay_api_provider" IS '在线支付api提供商 -- wayne';
COMMENT ON COLUMN "pay_api_provider"."id" IS '主键';
COMMENT ON COLUMN "pay_api_provider"."channel_code" IS '简称';
COMMENT ON COLUMN "pay_api_provider"."remarks" IS '备注';
COMMENT ON COLUMN "pay_api_provider"."jar_url" IS '具体实现jar包的url';
COMMENT ON COLUMN "pay_api_provider"."api_class" IS 'api具体实现的类(全类名)';
COMMENT ON COLUMN "pay_api_provider"."jar_version" IS 'jar包版本';
COMMENT ON COLUMN "pay_api_provider"."ext_json" IS 'json格式的扩展信息';

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json") VALUES ('2', 'baofoo', '', 'file:/data/impl-jars/pay-baofoo.jar', 'org.soul.pay.impl.BaofooPayApi', '1', '{"pro":{"payUrl":"https://gw.baofoo.com/payindex","queryOrderUrl":"http://3rd.pay.api.com/baofoo-pay/order/query"},"test":{"payUrl":"https://vgw.baofoo.com/payindex","queryOrderUrl":"https://vgw.baofoo.com/order/query"}}');
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json") VALUES ('3', 'ips_3', '', 'file:/data/impl-jars/pay-ips3.jar', 'org.soul.pay.impl.IPS3PayApi', '1', '{"pro":{"payUrl":"https://pay.ips.com.cn/ipayment.aspx","queryOrderUrl":""},"test":{"payUrl":"http://pay.ips.net.cn/ipayment.aspx","queryOrderUrl":""}}');
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json") VALUES ('4', 'reapal', '', 'file:/data/impl-jars/pay-reapal.jar', 'org.soul.pay.impl.ReapalPayApi', '1', '{"pro":{"payUrl":"http://epay.reapal.com/portal","queryOrderUrl":"http://3rd.pay.api.com/reapal-pay/query/payment"},"test":{"payUrl":"http://epay.reapal.com/portal","queryOrderUrl":"http://3rd.pay.api.com/reapal-pay/query/payment"}}');
