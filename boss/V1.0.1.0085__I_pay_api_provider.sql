-- auto gen by cherry 2016-07-15 10:12:19
INSERT INTO  "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '15', 'dinpay_wx', NULL, 'file:/data/impl-jars/pay-dinpay.jar', 'org.soul.pay.impl.DinPayWxApi', '20160707', '{"pro":{"payUrl":"http://3rd.pay.api.com/dinpay-pay/wxpay/gateway/api/weixin",
"queryOrderUrl":"http://3rd.pay.api.com/dinpay-pay/wxquery/query"},"test":{"payUrl":"http://3rd.pay.api.com/dinpay-pay/wxpay/gateway/api/weixin","queryOrderUrl":"http://3rd.pay.api.com/dinpay-pay/wxquery/query"}}'
WHERE not EXISTS (SELECT id FROM pay_api_provider where id=15);
