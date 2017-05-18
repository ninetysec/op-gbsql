-- auto gen by cherry 2017-05-18 09:27:35
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
) SELECT
	'132',
	'tianchuang_wx',
	'天创（微信）',
	'file:/data/impl-jars/pay/pay-tianchuang.jar',
	'org.soul.pay.impl.TianchuangPayWXApi',
	'20170515',
	'{"pro":{"payUrl":"http://www.18shun.com/Pay_Index.html","queryOrderUrl":""},"test":{"payUrl":"http://www.18shun.com/Pay_Index.html","queryOrderUrl":""}}'
WHERE
	NOT EXISTS (
		SELECT
			channel_code
		FROM
			pay_api_provider
		WHERE
			channel_code = 'tianchuang_wx'
	);

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '133', 'tianchuang_zfb', '天创（支付宝）', 'file:/data/impl-jars/pay/pay-tianchuang.jar', 'org.soul.pay.impl.TianchuangPayZFBApi', '20170515', '{"pro":{"payUrl":"http://www.18shun.com/Pay_Index.html","queryOrderUrl":""},"test":{"payUrl":"http://www.18shun.com/Pay_Index.html","queryOrderUrl":""}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'tianchuang_zfb');

--http://a.bjdpay.com:8209
--http://3rd.pay.api.com:8209/xunjietong-pay
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '127', 'xunjietong_wx', '迅捷通（微信）', 'file:/data/impl-jars/pay/pay-xunjietong.jar', 'org.soul.pay.impl.XunjietongPayWXApi', '20170515', '{"pro":{"payUrl":"http://3rd.pay.api.com/xunjietong-pay/payapi/passivePay","queryOrderUrl":"http://3rd.pay.api.com/xunjietong-pay/payapi/qrcodeQuery"},"test":{"payUrl":"http://a.bjdpay.com:8209/payapi/passivePay","queryOrderUrl":"http://a.bjdpay.com:8209/payapi/qrcodeQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunjietong_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '128', 'xunjietong_zfb', '迅捷通（支付宝）', 'file:/data/impl-jars/pay/pay-xunjietong.jar', 'org.soul.pay.impl.XunjietongPayZFBApi', '20170515', '{"pro":{"payUrl":"http://3rd.pay.api.com/xunjietong-pay/payapi/passivePay","queryOrderUrl":"http://3rd.pay.api.com/xunjietong-pay/payapi/qrcodeQuery"},"test":{"payUrl":"http://a.bjdpay.com:8209/payapi/passivePay","queryOrderUrl":"http://a.bjdpay.com:8209/payapi/qrcodeQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xunjietong_zfb');

