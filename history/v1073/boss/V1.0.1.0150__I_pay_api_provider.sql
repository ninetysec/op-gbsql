-- auto gen by wayne 2016-09-30 11:27:00
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '28', 'jinanpay_wx', '金安付（微信）', 'file:/data/impl-jars/pay-jinanpay.jar', 'org.soul.pay.impl.JinanPayWXApi', '20160930',
    '{"pro":{"payUrl":"http://3rd.pay.api.com/jinanpay-pay/posp-api/passivePay","queryOrderUrl":"http://3rd.pay.api.com/jinanpay-pay/posp-api/qrcodeQuery"},"test":{"payUrl":"http://112.74.230.8:8081/posp-api/passivePay","queryOrderUrl":"http://112.74.230.8:8081/posp-api/qrcodeQuery"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='jinanpay_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '29', 'jinanpay_zfb', '金安付（支付宝）', 'file:/data/impl-jars/pay-jinanpay.jar', 'org.soul.pay.impl.JinanPayZFBApi', '20160930',
    '{"pro":{"payUrl":"http://3rd.pay.api.com/jinanpay-pay/posp-api/passivePay","queryOrderUrl":"http://3rd.pay.api.com/jinanpay-pay/posp-api/qrcodeQuery"},"test":{"payUrl":"http://112.74.230.8:8081/posp-api/passivePay","queryOrderUrl":"http://112.74.230.8:8081/posp-api/qrcodeQuery"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='jinanpay_zfb');

