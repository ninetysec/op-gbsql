-- auto gen by wayne 2016-09-12 23:00:00
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '26', 'tonghui_wx', NULL, 'file:/data/impl-jars/pay-tonghui.jar', 'org.soul.pay.impl.TonghuiPayWXApi', '20160912',
    '{"pro":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"http://3rd.pay.api.com/tonghui-pay/query"},"test":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"https://pay.41.cn/query"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='tonghui_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '27', 'tonghui_zfb', NULL, 'file:/data/impl-jars/pay-tonghui.jar', 'org.soul.pay.impl.TonghuiPayZFBApi', '20160912',
    '{"pro":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"http://3rd.pay.api.com/tonghui-pay/query"},"test":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"https://pay.41.cn/query"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='tonghui_zfb');

UPDATE "pay_api_provider" SET "ext_json"='{"pro":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"http://3rd.pay.api.com/tonghui-pay/query"},"test":{"payUrl":"https://pay.41.cn/gateway","queryOrderUrl":"https://pay.41.cn/query"}}'
  WHERE channel_code='tonghui';
