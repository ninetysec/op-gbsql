-- auto gen by brave 2016-10-16 17:29:30

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '31', 'heepay_wx', '汇付宝支付（微信）', 'file:/data/impl-jars/pay-heepay.jar', 'org.soul.pay.impl.HeePayWXApi', '201610165', '{"pro":{"payUrl":"https://pay.heepay.com/Payment/Index.aspx","queryOrderUrl":"https://query.heepay.com/Payment/Query.aspx"},"test":{"payUrl":"https://pay.heepay.com/Payment/Index.aspx","queryOrderUrl":"https://query.heepay.com/Payment/Query.aspx"}}'
WHERE NOT EXISTS (select id from pay_api_provider where id = 31);
