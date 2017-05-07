-- auto gen by brave 2016-10-18 13:57:14
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '32', 'ybpay', '银宝支付（网银）', 'file:/data/impl-jars/pay-ybpay.jar', 'org.soul.pay.impl.YBPayWYApi', '20161018', '{"pro":{"payUrl":"http://wytj.9vpay.com/PayBank.aspx","queryOrderUrl":""},"test":{"payUrl":"http://wytj.9vpay.com/PayBank.aspx","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 32);