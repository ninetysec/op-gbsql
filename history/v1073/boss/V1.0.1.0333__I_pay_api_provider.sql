-- auto gen by cherry 2017-05-23 14:51:10
--https://tech.zitopay.com/
--http://3rd.pay.api.com/rongzhifu-pay/
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '134', 'rongzhifu_wx', '融智付支付（微信）', 'file:/data/impl-jars/pay/pay-rongzhifu.jar', 'org.soul.pay.impl.RongzhifuPayWXApi', '20170520',
'{"pro":{"payUrl":"http://3rd.pay.api.com/rongzhifu-pay/service/api/controller/zitopay/topayByMc","queryOrderUrl":"http://3rd.pay.api.com/rongzhifu-pay/service/api/controller/zitopay/findOrder"},"test":{"payUrl":"https://pretech.zitopay.com/service/api/controller/zitopay/topayByMc","queryOrderUrl":"https://pretech.zitopay.com/service/api/controller/zitopay/findOrder"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'rongzhifu_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '135', 'rongzhifu_zfb', '融智付支付（支付宝）', 'file:/data/impl-jars/pay/pay-rongzhifu.jar', 'org.soul.pay.impl.RongzhifuPayZFBApi', '20170520',
'{"pro":{"payUrl":"http://3rd.pay.api.com/rongzhifu-pay/api/controller/zitopay/topayByMc","queryOrderUrl":"http://3rd.pay.api.com/rongzhifu-pay/api/controller/zitopay/findOrder"},"test":{"payUrl":"https://pretech.zitopay.com/service/api/controller/zitopay/topayByMc","queryOrderUrl":"https://pretech.zitopay.com/service/api/controller/zitopay/findOrder"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'rongzhifu_zfb');