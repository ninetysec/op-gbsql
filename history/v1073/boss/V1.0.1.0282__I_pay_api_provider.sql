-- auto gen by cherry 2017-01-09 16:29:02
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
) SELECT
	'61',
	'yinbang_kj',
	'银邦支付（快捷支付）',
	'file:/data/impl-jars/pay/pay-yinbang.jar',
	'org.soul.pay.impl.YinbangPayKJApi',
	'20161113',
	'{"pro":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://3rd.pay.api.com/yinbang-pay/website/queryOrderResult.htm"},"test":{"payUrl":"http://www.goldenpay88.com/gateway/orderPay","queryOrderUrl":"http://www.goldenpay88.com/gateway/queryPaymentRecord"}}'
WHERE
	NOT EXISTS (
		SELECT
			channel_code
		FROM
			pay_api_provider
		WHERE
			channel_code = 'yinbang_kj'
	);