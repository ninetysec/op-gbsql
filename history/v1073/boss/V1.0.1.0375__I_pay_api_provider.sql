-- auto gen by cherry 2017-07-07 19:25:22
--https://www.jingbaopay.com
--http://3rd.pay.api.com/shunbao-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'shunbao', '顺宝支付（网银）', 'file:/data/impl-jars/pay/pay-shunbao.jar', 'org.soul.pay.impl.ShunbaoPayWYApi', '20170628', '{"pro":{"payUrl":"https://www.jingbaopay.com/api/pay","queryOrderUrl":"http://3rd.pay.api.com/shunbao-pay/api/check"},"test":{"payUrl":"https://www.jingbaopay.com/api/pay","queryOrderUrl":"https://www.jingbaopay.com/api/check"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'shunbao');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'shunbao_wx', '顺宝支付（微信）', 'file:/data/impl-jars/pay/pay-shunbao.jar', 'org.soul.pay.impl.ShunbaoPayWXApi', '20170628', '{"pro":{"payUrl":"https://www.jingbaopay.com/api/pay","queryOrderUrl":"http://3rd.pay.api.com/shunbao-pay/api/check"},"test":{"payUrl":"https://www.jingbaopay.com/api/pay","queryOrderUrl":"https://www.jingbaopay.com/api/check"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'shunbao_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'shunbao_zfb', '顺宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-shunbao.jar', 'org.soul.pay.impl.ShunbaoPayZFBApi', '20170628', '{"pro":{"payUrl":"https://www.jingbaopay.com/api/pay","queryOrderUrl":"http://3rd.pay.api.com/shunbao-pay/api/check"},"test":{"payUrl":"https://www.jingbaopay.com/api/pay","queryOrderUrl":"https://www.jingbaopay.com/api/check"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'shunbao_zfb');


