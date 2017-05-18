-- auto gen by cherry 2017-05-16 19:47:34
--https://api.dinpay.com
--http://3rd.pay.api.com/dinpay-pay
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
) SELECT
	'126',
	'dinpay_zfb',
	'智付（支付宝）',
	'file:/data/impl-jars/pay/pay-dinpay.jar',
	'org.soul.pay.impl.DinPayZFBApi',
	'20170515',
	'{"pro":{"payUrl":"http://3rd.pay.api.com/dinpay-pay/gateway/api/scanpay","queryOrderUrl":"http://3rd.pay.api.com/dinpay-pay/query"},"test":{"payUrl":"https://api.dinpay.com/gateway/api/scanpay","queryOrderUrl":"https://query.dinpay.com/query"}}'
WHERE
	NOT EXISTS (
		SELECT
			channel_code
		FROM
			pay_api_provider
		WHERE
			channel_code = 'dinpay_zfb'
	);