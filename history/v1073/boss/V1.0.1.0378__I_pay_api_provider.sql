-- auto gen by cherry 2017-07-10 16:34:53
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'leefu_wx', '乐付支付（微信）', 'file:/data/impl-jars/pay/pay-leefu.jar', 'org.soul.pay.impl.LeeFuPayWXApi', '20170705',
'{"pro":{"payUrl":"https://service.lepayle.com/api/md5/gateway","queryOrderUrl":"http://3rd.pay.api.com/leefu-pay/api/md5/gateway"},"test":{"payUrl":"https://service.lepayle.com/api/md5/gateway","queryOrderUrl":"https://service.lepayle.com/api/md5/gateway"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'leefu_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'leefu_zfb', '乐付支付（支付宝）', 'file:/data/impl-jars/pay/pay-leefu.jar', 'org.soul.pay.impl.LeeFuPayZFBApi', '20170705',
'{"pro":{"payUrl":"https://service.lepayle.com/api/md5/gateway","queryOrderUrl":"http://3rd.pay.api.com/leefu-pay/api/md5/gateway"},"test":{"payUrl":"https://service.lepayle.com/api/md5/gateway","queryOrderUrl":"https://service.lepayle.com/api/md5/gateway"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'leefu_zfb');