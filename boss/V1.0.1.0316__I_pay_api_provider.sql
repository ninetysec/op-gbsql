-- auto gen by cherry 2017-03-27 20:14:20

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '85',
		'xtc_zfb',
		'新天诚支付（支付宝）',
		'file:/data/impl-jars/pay/pay-xtc.jar',
		'org.soul.pay.impl.XtcPayZFBApi',
		'201601041954',
		'{"pro":{"payUrl":"http://api.xtcpay.cn/PayBank.aspx","queryOrderUrl":""},"test":{"payUrl":"http://api.xtcpay.cn/PayBank.aspx","queryOrderUrl":""}}'
	WHERE not EXISTS(SELECT id from pay_api_provider where id=85);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '84',
		'xtc_wx',
		'新天诚支付（微信）',
		'file:/data/impl-jars/pay/pay-xtc.jar',
		'org.soul.pay.impl.XtcPayWXApi',
		'201601041954',
		'{"pro":{"payUrl":"http://api.xtcpay.cn/PayBank.aspx","queryOrderUrl":""},"test":{"payUrl":"http://api.xtcpay.cn/PayBank.aspx","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=84);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '83',
		'xtc',
		'新天诚支付（网银）',
		'file:/data/impl-jars/pay/pay-xtc.jar',
		'org.soul.pay.impl.XtcPayWYApi',
		'201601041954',
		'{"pro":{"payUrl":"http://api.xtcpay.cn/PayBank.aspx","queryOrderUrl":""},"test":{"payUrl":"http://api.xtcpay.cn/PayBank.aspx","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=83);