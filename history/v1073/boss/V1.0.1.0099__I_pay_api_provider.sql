-- auto gen by gamebox 2016-08-13 14:55:40
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '20', 'tonghui', NULL, 'file:/data/impl-jars/pay-tonghui.jar', 'org.soul.pay.impl.TonghuiPayApi', '20160813',
    '{"pro":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"https://pay.41.cn/query"},"test":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"https://pay.41.cn/query"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='tonghui');
