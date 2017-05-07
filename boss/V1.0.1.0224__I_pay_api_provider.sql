-- auto gen by cherry 2016-11-16 10:18:35
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '42', 'allscore_s_wx', '商银信扫码（微信）', 'file:/data/impl-jars/pay-allscore.jar', 'org.soul.pay.impl.AllScorePayApiScanWXApi', '20161112',
'{"pro":{"payUrl":"https://3rd.pay.api.com/allscore-pay/wxpay/olgateway/scan/scanPay.htm","queryOrderUrl":"https://3rd.pay.api.com/allscore-pay/wxpay/olgateway/scan/scanPayQuery.htm"},"test":{"payUrl":"http://211.157.145.8:8090/olgateway/scan/scanPay.htm","queryOrderUrl":"http://211.157.145.8:8090/olgateway/scan/ scanPayQuery.htm"}}'
WHERE NOT EXISTS (SELECT id FROM pay_api_provider where id=42);

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '41', 'allscore_s_zfb', '商银信扫码（支付宝）', 'file:/data/impl-jars/pay-allscore.jar', 'org.soul.pay.impl.AllScorePayApiScanZFBApi', '20161113',
'{"pro":{"payUrl":"https://3rd.pay.api.com/allscore-pay/wxpay/olgateway/scan/scanPay.htm","queryOrderUrl":"https://3rd.pay.api.com/allscore-pay/wxpay/olgateway/scan/scanPayQuery.htm"},"test":{"payUrl":"http://211.157.145.8:8090/olgateway/scan/scanPay.htm","queryOrderUrl":"http://211.157.145.8:8090/olgateway/scan/ scanPayQuery.htm"}}'
WHERE NOT EXISTS (SELECT id FROM pay_api_provider where id=41);


