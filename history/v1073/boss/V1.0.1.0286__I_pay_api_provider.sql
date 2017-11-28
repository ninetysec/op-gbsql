-- auto gen by cherry 2017-01-17 14:24:15
--https://trade.gannun.cn
--http://3rd.pay.api.com/lefu-pay/
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '65',
		'lefu_zfb',
		'乐付宝支付（支付宝）',
		'file:/data/impl-jars/pay/pay-lefu.jar',
		'org.soul.pay.impl.LeFuPayZFBApi',
		'201601041954',
		'{"pro":{"payUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/lefu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi"}}'
	WHERE not EXISTS(SELECT id from pay_api_provider where id=65);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '66',
		'lefu_wx',
		'乐付宝支付（微信）',
		'file:/data/impl-jars/pay/pay-lefu.jar',
		'org.soul.pay.impl.LeFuPayWXApi',
		'201601041954',
		'{"pro":{"payUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/lefu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi"}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=66);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '67',
		'lefu',
		'乐付宝支付（网银）',
		'file:/data/impl-jars/pay/pay-lefu.jar',
		'org.soul.pay.impl.LeFuPayWYApi',
		'201601041954',
		'{"pro":{"payUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/lefu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://trade.gannun.cn/cgi-bin/netpayment/pay_gate.cgi"}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=67);

