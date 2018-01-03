-- auto gen by brave 2016-10-19 11:49:31
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '33', 'ybpay_wx', '银宝支付（微信）', 'file:/data/impl-jars/pay-ybpay.jar', 'org.soul.pay.impl.YBPayWXApi', '201610192', '{"pro":{"payUrl":"http://wytj.9vpay.com/PayBank.aspx","queryOrderUrl":""},"test":{"payUrl":"http://wytj.9vpay.com/PayBank.aspx","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 33);
  
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '34', 'ybpay_zfb', '银宝支付（支付宝）', 'file:/data/impl-jars/pay-ybpay.jar', 'org.soul.pay.impl.YBPayZFBApi', '201610192', '{"pro":{"payUrl":"http://wytj.9vpay.com/PayBank.aspx","queryOrderUrl":""},"test":{"payUrl":"http://wytj.9vpay.com/PayBank.aspx","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 34);

