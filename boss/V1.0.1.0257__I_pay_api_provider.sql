-- auto gen by cherry 2016-12-14 09:27:16
INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '51', 'allscore', '商银信（网银）', 'file:/data/impl-jars/pay-allscore.jar', 'org.soul.pay.impl.AllscorePayWYApi', '2016121204', '{"pro":{"payUrl":"https://paymenta.allscore.com/olgateway/serviceDirect.htm","queryOrderUrl":"https://3rd.pay.api.com/allscore-pay/wxpay/olgateway/orderQuery.htm"},"test":{"payUrl":"https://paymenta.allscore.com/olgateway/serviceDirect.htm","queryOrderUrl":"http://211.157.145.8:8090/olgateway/orderQuery.htm"}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE id=51);
