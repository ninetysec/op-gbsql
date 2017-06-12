-- auto gen by cherry 2017-06-10 17:46:24
CREATE SEQUENCE if not EXISTS "pay_api_provider_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 149
 CACHE 1;
ALTER TABLE "pay_api_provider" ALTER COLUMN "id" SET DEFAULT nextval('pay_api_provider_id_seq'::regclass);

--https://api.caimao9.com
--http://3rd.pay.api.com/caimao-pay/pay
--https://query.caimao9.com
--http://3rd.pay.api.com/caimao-pay/query
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT 'caimao_wy', '财猫支付（网银）', 'file:/data/impl-jars/pay/pay-caimao.jar', 'org.soul.pay.impl.CaimaoPayWYApi', '20170227', '{"pro":{"payUrl":"http://3rd.pay.api.com/caimao-pay/pay/gateway?input_charset=UTF-8","queryOrderUrl":"http://3rd.pay.api.com/caimao-pay/query/query"},"test":{"payUrl":"https://pay.caimao9.com/gateway?input_charset=UTF-8","queryOrderUrl":"https://query.caimao9.com/query"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'caimao_wy');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT 'caimao_wx', '财猫支付（微信）', 'file:/data/impl-jars/pay/pay-caimao.jar', 'org.soul.pay.impl.CaimaoPayWXApi', '20170227', '{"pro":{"payUrl":"http://3rd.pay.api.com/caimao-pay/pay/gateway/api/scanpay","queryOrderUrl":"http://3rd.pay.api.com/caimao-pay/query/query"},"test":{"payUrl":"https://api.caimao9.com/gateway/api/scanpay","queryOrderUrl":"https://query.caimao9.com/query"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'caimao_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT 'caimao_zfb', '财猫支付（支付宝）', 'file:/data/impl-jars/pay/pay-caimao.jar', 'org.soul.pay.impl.CaimaoPayZFBApi', '20170227', '{"pro":{"payUrl":"http://3rd.pay.api.com/caimao-pay/pay/gateway/api/scanpay","queryOrderUrl":"http://3rd.pay.api.com/caimao-pay/query/query"},"test":{"payUrl":"https://api.caimao9.com/gateway/api/scanpay","queryOrderUrl":"https://query.caimao9.com/query"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'caimao_zfb');
