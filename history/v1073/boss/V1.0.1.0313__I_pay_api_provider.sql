-- auto gen by cherry 2017-03-21 11:33:34
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '80', 'shufu', '舒付支付（网银）', 'file:/data/impl-jars/pay/pay-shufu.jar', 'org.soul.pay.impl.ShufuPayWYApi', '20170320011', '{"pro":{"payUrl":"http://m.qianhaisufu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""},"test":{"payUrl":"http://m.qianhaisufu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'shufu');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '81', 'shufu_wx', '舒付支付（微信）', 'file:/data/impl-jars/pay/pay-shufu.jar', 'org.soul.pay.impl.ShufuPayWXApi', '20170320011', '{"pro":{"payUrl":"http://m.qianhaisufu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""},"test":{"payUrl":"http://m.qianhaisufu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'shufu_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '82', 'shufu_zfb', '舒付支付（支付宝）', 'file:/data/impl-jars/pay/pay-shufu.jar', 'org.soul.pay.impl.ShufuPayZFBApi', '20170320011', '{"pro":{"payUrl":"http://m.qianhaisufu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""},"test":{"payUrl":"http://m.qianhaisufu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'shufu_zfb');