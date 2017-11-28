-- auto gen by brave 2016-12-16 01:33:08
INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '52', 'xinbei', '新贝支付（网银）', 'file:/data/impl-jars/pay-xinbei.jar', 'org.soul.pay.impl.XinbeiPayWYApi', '2016121405', '{"pro":{"payUrl":"https://gws.xbeionline.com/Gateway/XbeiPay","queryOrderUrl":""},"test":{"payUrl":"https://gws.xbeionline.com/Gateway/XbeiPay","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE channel_code = 'xinbei');

INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '53', 'xinbei_wx', '新贝支付（微信）', 'file:/data/impl-jars/pay-xinbei.jar', 'org.soul.pay.impl.XinbeiPayWXApi', '2016121405', '{"pro":{"payUrl":"https://gws.xbeionline.com/Gateway/XbeiPay","queryOrderUrl":""},"test":{"payUrl":"https://gws.xbeionline.com/Gateway/XbeiPay","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE channel_code = 'xinbei_wx');

INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '54', 'xinbei_zfb', '新贝支付（支付宝）', 'file:/data/impl-jars/pay-xinbei.jar', 'org.soul.pay.impl.XinbeiPayZFBApi', '2016121405', '{"pro":{"payUrl":"https://gws.xbeionline.com/Gateway/XbeiPay","queryOrderUrl":""},"test":{"payUrl":"https://gws.xbeionline.com/Gateway/XbeiPay","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE channel_code = 'xinbei_zfb');