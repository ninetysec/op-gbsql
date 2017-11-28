-- auto gen by cherry 2017-07-05 11:56:43

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yuanqi_wx', '元启支付（微信）', 'file:/data/impl-jars/pay/pay-yuanqi.jar', 'org.soul.pay.impl.YuanqiPayWXApi', '20170628', '{"pro":{"payUrl":"http://m.yuanqifu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""},"test":{"payUrl":"http://m.yuanqifu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yuanqi_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yuanqi_zfb', '元启支付（支付宝）', 'file:/data/impl-jars/pay/pay-yuanqi.jar', 'org.soul.pay.impl.YuanqiPayZFBApi', '20170628', '{"pro":{"payUrl":"http://m.yuanqifu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""},"test":{"payUrl":"http://m.yuanqifu.com:28080/YFServlet/recvMerchant","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yuanqi_zfb');

