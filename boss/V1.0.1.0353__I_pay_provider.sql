-- auto gen by cherry 2017-06-20 09:23:55
--https://api.m.upay7.com
--http://3rd.pay.api.com/qpay-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'qianyou_wx', 'QPay（微信）', 'file:/data/impl-jars/pay/pay-qianyou.jar', 'org.soul.pay.impl.QianyouPayWXApi', '20170615', '{"pro":{"payUrl":"https://api.m.upay7.com/scancode/order/request","queryOrderUrl":"https://api.m.upay7.com/order/query"},"test":{"payUrl":"https://api.m.upay7.com/scancode/order/request","queryOrderUrl":"https://api.m.upay7.com/order/query"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qianyou_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'qianyou_zfb', 'QPay（支付宝）', 'file:/data/impl-jars/pay/pay-qianyou.jar', 'org.soul.pay.impl.QianyouPayZFBApi', '20170615', '{"pro":{"payUrl":"https://api.m.upay7.com/scancode/order/request","queryOrderUrl":"https://api.m.upay7.com/order/query"},"test":{"payUrl":"https://api.m.upay7.com/scancode/order/request","queryOrderUrl":"https://api.m.upay7.com/order/query"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qianyou_zfb');