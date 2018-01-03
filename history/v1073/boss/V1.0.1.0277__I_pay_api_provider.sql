-- auto gen by brave 2017-01-04 11:53:01
INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '58', 'helibaowy', '合利宝支付（网银）', 'file:/data/impl-jars/pay/pay-helibao.jar', 'org.soul.pay.impl.HelibaoPayWYApi', '201601041954', '{"pro":{"payUrl":"http://api.99juhe.com/trx-service/online/api.action","queryOrderUrl":"http://3rd.pay.api.com/helibao-pay/trx-service/online/api.action"},"test":{"payUrl":"http://api.99juhe.com/trx-service/online/api.action","queryOrderUrl":"http://api.99juhe.com/trx-service/online/api.action"}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE channel_code = 'helibaowy');

INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '59', 'helibao_wx', '合利宝支付（微信）', 'file:/data/impl-jars/pay/pay-helibao.jar', 'org.soul.pay.impl.HelibaoPayWXApi', '201601041954', '{"pro":{"payUrl":"http://3rd.pay.api.com/helibao-pay/trx-service/appPay/api.action","queryOrderUrl":"http://3rd.pay.api.com/helibao-pay/trx-service/appPay/api.action"},"test":{"payUrl":"http://api.99juhe.com/trx-service/appPay/api.action","queryOrderUrl":"http://api.99juhe.com/trx-service/appPay/api.action"}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE channel_code = 'helibao_wx');

INSERT INTO "pay_api_provider"
("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '60', 'helibao_zfb', '合利宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-helibao.jar', 'org.soul.pay.impl.HelibaoPayZFBApi', '201601041954', '{"pro":{"payUrl":"http://3rd.pay.api.com/helibao-pay/trx-service/appPay/api.action","queryOrderUrl":"http://3rd.pay.api.com/helibao-pay/trx-service/appPay/api.action"},"test":{"payUrl":"http://api.99juhe.com/trx-service/appPay/api.action","queryOrderUrl":"http://api.99juhe.com/trx-service/appPay/api.action"}}'
WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE channel_code = 'helibao_zfb');