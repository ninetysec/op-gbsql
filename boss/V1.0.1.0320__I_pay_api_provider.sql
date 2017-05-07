-- auto gen by cherry 2017-04-15 14:11:04
--http://pay.szzhangzhi.cn/
--http://3rd.pay.api.com/zhangzhifu-pay/
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '106',
		'zhangzhifu_zfb',
		'掌支付（支付宝）',
		'file:/data/impl-jars/pay/pay-zhangzhifu.jar',
		'org.soul.pay.impl.ZhangZhiFuPayZFBApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/zhangzhifu-pay/gateway/","queryOrderUrl":""},"test":{"payUrl":"http://pay.szzhangzhi.cn/gateway","queryOrderUrl":""}}'
	WHERE not EXISTS(SELECT id from pay_api_provider where id=106);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '107',
		'zhangzhifu_wx',
		'掌支付（微信）',
		'file:/data/impl-jars/pay/pay-zhangzhifu.jar',
		'org.soul.pay.impl.ZhangZhiFuPayWXApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/zhangzhifu-pay/gateway/","queryOrderUrl":""},"test":{"payUrl":"http://pay.szzhangzhi.cn/gateway/","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=107);

--http://api.amxmy.top/trade
--http://3rd.pay.api.com/amx-pay/
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '108',
		'amx_zfb',
		'艾米森（支付宝）',
		'file:/data/impl-jars/pay/pay-amx.jar',
		'org.soul.pay.impl.AmxPayZFBApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/amx-pay/pay_v2","queryOrderUrl":"http://3rd.pay.api.com/amx-pay/query"},"test":{"payUrl":"http://api.amxmy.top/trade/pay_v2","queryOrderUrl":"http://api.amxmy.top/trade/query"}}'
	WHERE not EXISTS(SELECT id from pay_api_provider where id=108);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '109',
		'amx_wx',
		'艾米森（微信）',
		'file:/data/impl-jars/pay/pay-amx.jar',
		'org.soul.pay.impl.AmxPayWXApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/amx-pay/pay_v2","queryOrderUrl":"http://3rd.pay.api.com/amx-pay/query"},"test":{"payUrl":"http://api.amxmy.top/trade/pay_v2","queryOrderUrl":"http://api.amxmy.top/trade/query"}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=109);

--https://api.mch.weixin.qq.com/
--http://3rd.pay.api.com/weixin-pay/
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '110',
		'weixin_wx',
		'财付通（微信）',
		'file:/data/impl-jars/pay/pay-weixin.jar',
		'org.soul.pay.impl.WeixinPayApiWXApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/weixin-pay/pay/unifiedorder","queryOrderUrl":"http://3rd.pay.api.com/weixin-pay/pay/orderquery"},"test":{"payUrl":"https://api.mch.weixin.qq.com/pay/unifiedorder","queryOrderUrl":"https://api.mch.weixin.qq.com/pay/orderquery"}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=110);

--pay-lexinfu
--https://openapi.unionpay95516.cc/
--http://3rd.pay.api.com/lexinfu-pay/
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '111',
		'lexinfu',
		'乐信付（网银）',
		'file:/data/impl-jars/pay/pay-lexinfu.jar',
		'org.soul.pay.impl.LeXinFuPayWYApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/lexinfu-pay/pre.lepay.api/order/add","queryOrderUrl":""},"test":{"payUrl":"https://openapi.unionpay95516.cc/pre.lepay.api/order/add","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=111);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '112',
		'lexinfu_zfb',
		'乐信付（支付宝）',
		'file:/data/impl-jars/pay/pay-lexinfu.jar',
		'org.soul.pay.impl.LeXinFuPayZFBApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/lexinfu-pay/pre.lepay.api/order/add","queryOrderUrl":""},"test":{"payUrl":"https://openapi.unionpay95516.cc/pre.lepay.api/order/add","queryOrderUrl":""}}'
	WHERE not EXISTS(SELECT id from pay_api_provider where id=112);

INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
)
SELECT '113',
		'lexinfu_wx',
		'乐信付（微信）',
		'file:/data/impl-jars/pay/pay-lexinfu.jar',
		'org.soul.pay.impl.LeXinFuPayWXApi',
		'20170323',
		'{"pro":{"payUrl":"http://3rd.pay.api.com/lexinfu-pay/pre.lepay.api/order/add","queryOrderUrl":""},"test":{"payUrl":"https://openapi.unionpay95516.cc/pre.lepay.api/order/add","queryOrderUrl":""}}'
WHERE not EXISTS(SELECT id from pay_api_provider where id=113);