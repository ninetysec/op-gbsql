-- auto gen by brave 2016-11-28 13:20:58
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '46', 'xunhuibaopay_wx', '迅汇宝支付（微信）', 'file:/data/impl-jars/pay-xunhuibao.jar', 'org.soul.pay.impl.XunhuibaoPayWXApi', '2016112610', '{"pro":{"payUrl":"http://pay.x6pay.com:8082/posp-api/passivePay","queryOrderUrl":"http://3rd.pay.api.com/xunhuibao-pay/posp-api/qrcodeQuery"},"test":{"payUrl":"http://pay.x6pay.com:8082/posp-api/passivePay","queryOrderUrl":"http://pay.x6pay.com:8082/posp-api/qrcodeQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunhuibaopay_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '47', 'xunhuibaopay_zfb', '迅汇宝支付（支付宝）', 'file:/data/impl-jars/pay-xunhuibao.jar', 'org.soul.pay.impl.XunhuibaoPayZFBApi', '2016112610', '{"pro":{"payUrl":"http://pay.x6pay.com:8082/posp-api/passivePay","queryOrderUrl":"http://3rd.pay.api.com/xunhuibao-pay/posp-api/qrcodeQuery"},"test":{"payUrl":"http://pay.x6pay.com:8082/posp-api/passivePay","queryOrderUrl":"http://pay.x6pay.com:8082/posp-api/qrcodeQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunhuibaopay_zfb');