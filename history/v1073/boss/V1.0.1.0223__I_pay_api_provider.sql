-- auto gen by wayne 2016-11-13 21:57:31
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '38', 'funpay', '乐盈支付（网银）', 'file:/data/impl-jars/pay-funpay.jar', 'org.soul.pay.impl.FunPayWYApi', '20161113', '{"pro":{"payUrl":"https://www.funpay.com/website/pay.htm","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"},"test":{"payUrl":"https://www.funpay.com/website/pay.htm","queryOrderUrl":"http://3rd.pay.api.com/funpay-pay/website/queryOrderResult.htm"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'funpay');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '39', 'funpay_wx', '乐盈支付（微信）', 'file:/data/impl-jars/pay-funpay.jar', 'org.soul.pay.impl.FunPayWXApi', '20161113', '{"pro":{"payUrl":"https://www.funpay.com/website/pay.htm","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"},"test":{"payUrl":"https://www.funpay.com/website/pay.htm","queryOrderUrl":"http://3rd.pay.api.com/funpay-pay/website/queryOrderResult.htm"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'funpay_wx');
  
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '40', 'funpay_zfb', '乐盈支付（支付宝）', 'file:/data/impl-jars/pay-funpay.jar', 'org.soul.pay.impl.FunPayZFBApi', '20161113', '{"pro":{"payUrl":"https://www.funpay.com/website/pay.htm","queryOrderUrl":"http://3rd.pay.api.com/okpay-pay/Gate/Search.ashx"},"test":{"payUrl":"https://www.funpay.com/website/pay.htm","queryOrderUrl":"http://3rd.pay.api.com/funpay-pay/website/queryOrderResult.htm"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'funpay_zfb');

