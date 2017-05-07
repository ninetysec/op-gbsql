-- auto gen by cherry 2016-12-03 15:15:08
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '48', 'yinbang', '银邦支付（网银）', 'file:/data/impl-jars/pay-yinbang.jar', 'org.soul.pay.impl.YinbangPayWYApi', '20161113', '{"pro":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://3rd.pay.api.com/yinbang-pay/website/queryOrderResult.htm"},"test":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://www.goldenpay88.com/gateway/queryPaymentRecord"}}'
WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yinbang');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '49', 'yinbang_wx', '银邦支付（微信）', 'file:/data/impl-jars/pay-yinbang.jar', 'org.soul.pay.impl.YinbangPayWXApi', '20161113', '{"pro":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://3rd.pay.api.com/yinbang-pay/website/queryOrderResult.htm"},"test":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://www.goldenpay88.com/gateway/queryPaymentRecord"}}'
WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yinbang_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '50', 'yinbang_zfb', '银邦支付（支付宝）', 'file:/data/impl-jars/pay-yinbang.jar', 'org.soul.pay.impl.YinbangPayZFBApi', '20161113', '{"pro":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://3rd.pay.api.com/yinbang-pay/website/queryOrderResult.htm"},"test":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://www.goldenpay88.com/gateway/queryPaymentRecord"}}'
WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yinbang_zfb');