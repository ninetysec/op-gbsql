-- auto gen by wayne 2016-11-08 19:54:31
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '35', 'okpay', 'OK付（网银）', 'file:/data/impl-jars/pay-okpay.jar', 'org.soul.pay.impl.OkPayWYApi', '20161108', '{"pro":{"payUrl":"https://gateway.okfpay.com/Gate/payindex.aspx","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"},"test":{"payUrl":"https://gateway.okfpay.com/Gate/payindex.aspx","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 35);

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '36', 'okpay_wx', 'OK付（微信）', 'file:/data/impl-jars/pay-okpay.jar', 'org.soul.pay.impl.OkPayWXApi', '20161108', '{"pro":{"payUrl":"https://gateway.okfpay.com/Gate/payindex.aspx","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"},"test":{"payUrl":"https://gateway.okfpay.com/Gate/payindex.aspx","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 36);
  
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '37', 'okpay_zfb', 'OK付（支付宝）', 'file:/data/impl-jars/pay-okpay.jar', 'org.soul.pay.impl.OkPayZFBApi', '20161108', '{"pro":{"payUrl":"https://gateway.okfpay.com/Gate/payindex.aspx","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"},"test":{"payUrl":"https://gateway.okfpay.com/Gate/payindex.aspx","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 37);

