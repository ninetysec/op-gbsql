-- auto gen by cherry 2017-06-29 14:35:49
--http://cashier.duoduopal.com
--http://3rd.pay.api.com/duoduo-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'duoduo', '多多支付（网银）', 'file:/data/impl-jars/pay/pay-duoduo.jar', 'org.soul.pay.impl.DuoduoPayWYApi', '20170628',
'{"pro":{"payUrl":"http://cashier.duoduopal.com/payment/","queryOrderUrl":"http://3rd.pay.api.com/duoduo-pay/query/"},"test":{"payUrl":"http://cashier.duoduopal.com/payment/","queryOrderUrl":"http://cashier.duoduopal.com/query/"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'duoduo');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'duoduo_wx', '多多支付（微信）', 'file:/data/impl-jars/pay/pay-duoduo.jar', 'org.soul.pay.impl.DuoduoPayWXApi', '20170628',
'{"pro":{"payUrl":"http://cashier.duoduopal.com/payment/","queryOrderUrl":"http://3rd.pay.api.com/duoduo-pay/query/"},"test":{"payUrl":"http://cashier.duoduopal.com/payment/","queryOrderUrl":"http://cashier.duoduopal.com/query/"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'duoduo_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'duoduo_zfb', '多多支付（支付宝）', 'file:/data/impl-jars/pay/pay-duoduo.jar', 'org.soul.pay.impl.DuoduoPayZFBApi', '20170628',
'{"pro":{"payUrl":"http://cashier.duoduopal.com/payment/","queryOrderUrl":"http://3rd.pay.api.com/duoduo-pay/query/"},"test":{"payUrl":"http://cashier.duoduopal.com/payment/","queryOrderUrl":"http://cashier.duoduopal.com/query/"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'duoduo_zfb');


