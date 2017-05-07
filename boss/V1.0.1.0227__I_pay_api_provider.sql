-- auto gen by brave 2016-11-19 11:38:53
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '43', 'qianwangpay', '千网支付（网银）', 'file:/data/impl-jars/pay-qianwang.jar', 'org.soul.pay.impl.QianwangPayWYApi', '20161119', '{"pro":{"payUrl":"http://apika.10001000.com/chargebank.aspx","queryOrderUrl":"http://apika.10001000.com/search.aspx"},"test":{"payUrl":"http://apika.10001000.com/chargebank.aspx","queryOrderUrl":"http://apika.10001000.com/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qianwangpay');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '44', 'qianwangpay_wx', '千网支付（微信）', 'file:/data/impl-jars/pay-qianwang.jar', 'org.soul.pay.impl.QianwangPayWXApi', '20161119', '{"pro":{"payUrl":"http://apika.10001000.com/chargebank.aspx","queryOrderUrl":"http://apika.10001000.com/search.aspx"},"test":{"payUrl":"http://apika.10001000.com/chargebank.aspx","queryOrderUrl":"http://apika.10001000.com/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qianwangpay_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '45', 'qianwangpay_zfb', '千网支付（支付宝）', 'file:/data/impl-jars/pay-qianwang.jar', 'org.soul.pay.impl.QianwangPayZFBApi', '20161119', '{"pro":{"payUrl":"http://apika.10001000.com/chargebank.aspx","queryOrderUrl":"http://apika.10001000.com/search.aspx"},"test":{"payUrl":"http://apika.10001000.com/chargebank.aspx","queryOrderUrl":"http://apika.10001000.com/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qianwangpay_zfb');


