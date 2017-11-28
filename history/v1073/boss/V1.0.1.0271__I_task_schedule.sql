-- auto gen by cherry 2016-12-28 11:51:23
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class",
"job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time",
"update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT '盈利预警', NULL, NULL, 'so.wwb.gamebox.service.company.SiteQuotaWarningJob',
'execute', 't', '1', '0 0 0/1 * * ?', 't',
'全站任务', '2016-02-21 10:07:04.153', NULL,
'all-004', 'f', 'f', NULL, NULL
WHERE not EXISTS(SELECT id FROM task_schedule where job_code='all-004');


ALTER TABLE pay_api_provider ALTER COLUMN channel_code type varchar(32);

--http://zfb.h8pay.com/
--http://3rd.pay.api.com/xunfuntong-pay/zfbpay
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
) SELECT
	'55',
	'xunfutong_zfb',
	'讯付通（支付宝）',
	'file:/data/impl-jars/pay/pay-xunfutong.jar',
	'org.soul.pay.impl.XunFuTongPayZFBApi',
	'2016122111',
	'{"pro":{"payUrl":"http://3rd.pay.api.com/xunfuntong-pay/zfbpay/api/pay.action","queryOrderUrl":""},"test":{"payUrl":"http://zfb.h8pay.com/api/pay.action","queryOrderUrl":""}}'
WHERE
	NOT EXISTS (
		SELECT
			ID
		FROM
			pay_api_provider
		WHERE
			ID = 55
	);

--http://wx.h8pay.com
--http://3rd.pay.api.com/xunfuntong-pay/wxpay
INSERT INTO "pay_api_provider" (
	"id",
	"channel_code",
	"remarks",
	"jar_url",
	"api_class",
	"jar_version",
	"ext_json"
) SELECT
	'56',
	'xunfutong_wx',
	'讯付通（微信）',
	'file:/data/impl-jars/pay/pay-xunfutong.jar',
	'org.soul.pay.impl.XunFuTongPayWXApi',
	'2016122111',
	'{"pro":{"payUrl":"http://3rd.pay.api.com/xunfuntong-pay/wxpay/api/pay.action","queryOrderUrl":""},"test":{"payUrl":"http://wx.h8pay.com/api/pay.action","queryOrderUrl":""}}'
WHERE
	NOT EXISTS (
		SELECT
			ID
		FROM
			pay_api_provider
		WHERE
			ID = 56
	);

--讯付通（支付宝WAP）暂不上
--INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
--SELECT '57', 'xunfutong-wap_zfb', '讯付通（支付宝WAP）', 'file:/data/impl-jars/pay/pay-xunfutong.jar', 'org.soul.pay.impl.XunFuTongPayZFBWapApi', '2016122111', '{"pro":{"payUrl":"http://zfbwap.h8pay.com/api/pay.action","queryOrderUrl":""},"test":{"payUrl":"http://zfbwap.h8pay.com/api/pay.action","queryOrderUrl":""}}'
--WHERE not EXISTS(SELECT id FROM pay_api_provider WHERE id=57);
