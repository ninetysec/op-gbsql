-- auto gen by cherry 2017-02-28 09:13:38
--http://api.r1pay.com/
--http://3rd.pay.api.com/ronge-pay/
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '68',
		'rongepay_zfb',
		'融e付-支付宝',
		'file:/data/impl-jars/pay/pay-rongepay.jar',
		'org.soul.pay.impl.RongEPayZFBApi',
		'201601041954',
		'{"pro":{"payUrl":"http://api.r1pay.com/api/bapi.aspx","queryOrderUrl":"http://3rd.pay.api.com/ronge-pay/api/checkorder.aspx"},"test":{"payUrl":"http://api.r1pay.com/api/bapi.aspx","queryOrderUrl":"http://api.r1pay.com/api/checkorder.aspx"}}'
	WHERE not EXISTS(SELECT id from pay_api_provider where id=68);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '69',
		'rongepay_wx',
		'融e付-微信',
		'file:/data/impl-jars/pay/pay-rongepay.jar',
		'org.soul.pay.impl.RongEPayWXApi',
		'201601041954',
		'{"pro":{"payUrl":"http://api.r1pay.com/api/bapi.aspx","queryOrderUrl":"http://3rd.pay.api.com/ronge-pay/api/checkorder.aspx"},"test":{"payUrl":"http://api.r1pay.com/api/bapi.aspx","queryOrderUrl":"http://api.r1pay.com/api/checkorder.aspx"}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=69);

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT 73, 'jiupay_zfb', '久付（支付宝）', 'file:/data/impl-jars/pay/pay-9pay.jar', 'org.soul.pay.impl.JiuPayZFBApi', '201601041954', '{"pro":{"payUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/jiupay-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi"}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=73);


INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '70', 'hfb', '惠付宝支付（网银）', 'file:/data/impl-jars/pay/pay-hfb.jar', 'org.soul.pay.impl.HfbPayWYApi', '20170222', '{"pro":{"payUrl":"http://3rd.pay.api.com/hfb-pay/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/hfb-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://trade.hfbpay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://trade.hfbpay.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'hfb');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '71', 'hfb_wx', '惠付宝支付（微信）', 'file:/data/impl-jars/pay/pay-hfb.jar', 'org.soul.pay.impl.HfbPayWXApi', '20170222', '{"pro":{"payUrl":"http://3rd.pay.api.com/hfb-pay/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/hfb-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://trade.hfbpay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://trade.hfbpay.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'hfb_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '72', 'hfb_zfb', '惠付宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-hfb.jar', 'org.soul.pay.impl.HfbPayZFBApi', '20170222', '{"pro":{"payUrl":"http://3rd.pay.api.com/hfb-pay/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/hfb-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://trade.hfbpay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://trade.hfbpay.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'hfb_zfb');