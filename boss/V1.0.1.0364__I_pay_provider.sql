-- auto gen by cherry 2017-07-04 09:24:08
--http://47.90.116.117:90
--http://3rd.pay.api.com/qingyifu-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'qingyifu_wx', '轻易付（微信）', 'file:/data/impl-jars/pay/pay-qingyifu.jar', 'org.soul.pay.impl.QingyifuPayWXApi', '20170629',
'{"pro":{"payUrl":"http://3rd.pay.api.com/qingyifu-pay/api/pay.action","queryOrderUrl":"http://3rd.pay.api.com/qingyifu-pay/api/queryPayResult.action"},"test":{"payUrl":"http://47.90.116.117:90/api/pay.action","queryOrderUrl":"http://47.90.116.117:90/api/queryPayResult.action"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qingyifu_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'qingyifu_zfb', '轻易付（支付宝）', 'file:/data/impl-jars/pay/pay-qingyifu.jar', 'org.soul.pay.impl.QingyifuPayZFBApi', '20170629',
'{"pro":{"payUrl":"http://3rd.pay.api.com/qingyifu-pay/api/pay.action","queryOrderUrl":"http://3rd.pay.api.com/qingyifu-pay/api/queryPayResult.action"},"test":{"payUrl":"http://47.90.116.117:90/api/pay.action","queryOrderUrl":"http://47.90.116.117:90/api/queryPayResult.action"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'qingyifu_zfb');