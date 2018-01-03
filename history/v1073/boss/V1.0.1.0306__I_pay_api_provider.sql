-- auto gen by cherry 2017-03-07 20:12:52
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '77', 'xunbao', '讯宝支付（网银）', 'file:/data/impl-jars/pay/pay-xunbao.jar', 'org.soul.pay.impl.XunbaoPayWYApi', '20170301', '{"pro":{"payUrl":"http://gateway.xunbaopay9.com/chargebank.aspx","queryOrderUrl":"http://3rd.pay.api.com/xunbao-pay/Search.aspx"},"test":{"payUrl":"http://gateway.xunbaopay9.com/chargebank.aspx","queryOrderUrl":"http://gateway.xunbaopay9.com/Search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunbao');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '78', 'xunbao_wx', '讯宝支付（微信）', 'file:/data/impl-jars/pay/pay-xunbao.jar', 'org.soul.pay.impl.XunbaoPayWXApi', '20170301', '{"pro":{"payUrl":"http://gateway.xunbaopay9.com/chargebank.aspx","queryOrderUrl":"http://3rd.pay.api.com/xunbao-pay/Search.aspx"},"test":{"payUrl":"http://gateway.xunbaopay9.com/chargebank.aspx","queryOrderUrl":"http://gateway.xunbaopay9.com/Search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunbao_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '79', 'xunbao_zfb', '讯宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-xunbao.jar', 'org.soul.pay.impl.XunbaoPayZFBApi', '20170301', '{"pro":{"payUrl":"http://gateway.xunbaopay9.com/chargebank.aspx","queryOrderUrl":"http://3rd.pay.api.com/xunbao-pay/Search.aspx"},"test":{"payUrl":"http://gateway.xunbaopay9.com/chargebank.aspx","queryOrderUrl":"http://gateway.xunbaopay9.com/Search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunbao_zfb');