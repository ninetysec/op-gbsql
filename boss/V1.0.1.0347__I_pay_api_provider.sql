-- auto gen by cherry 2017-06-14 15:54:06
--http://newpay.yunfux.cn
--http://3rd.pay.api.com/yunfux-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yunfux_wx', '云付盟支付（微信）', 'file:/data/impl-jars/pay/pay-yunfux.jar', 'org.soul.pay.impl.YunfuPayWXApi', '20170607', '{"pro":{"payUrl":"http://3rd.pay.api.com/yunfux-pay/pay/api/pay/gateway","queryOrderUrl":""},"test":{"payUrl":"http://newpay.yunfux.cn/pay/api/pay/gateway","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yunfux_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yunfux_zfb', '云付盟支付（支付宝）', 'file:/data/impl-jars/pay/pay-yunfux.jar', 'org.soul.pay.impl.YunfuPayZFBApi', '20170607', '{"pro":{"payUrl":"http://3rd.pay.api.com/yunfux-pay/pay/api/pay/gateway","queryOrderUrl":""},"test":{"payUrl":"http://newpay.yunfux.cn/pay/api/pay/gateway","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yunfux_zfb');