-- auto gen by cherry 2016-07-18 14:48:45
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '16', 'sfoo', NULL, 'file:/data/impl-jars/pay-sfoo.jar', 'org.soul.pay.impl.SfooPayWYApi', '20160718',
'{"pro":{"payUrl":"http://gw.3yzf.com/v4.aspx","queryOrderUrl":"http://3rd.pay.api.com/sfoopay-pay/pay/v4Query.aspx"},"test":{"payUrl":"http://gw.3yzf.com/v4.aspx","queryOrderUrl":"http://gw.3yzf.com/v4Query.aspx"}}'
WHERE not EXISTS (SELECT channel_code FROM pay_api_provider where channel_code='sfoo');


INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '17', 'sfoo_wx', NULL, 'file:/data/impl-jars/pay-sfoo.jar', 'org.soul.pay.impl.SfooPayWXApi', '20160718',
'{"pro":{"payUrl":"http://gw.3yzf.com/v4.aspx","queryOrderUrl":"http://3rd.pay.api.com/sfoopay-pay/wxpay/v4Query.aspx"},"test":{"payUrl":"http://gw.3yzf.com/v4.aspx","queryOrderUrl":"http://gw.3yzf.com/v4Query.aspx"}}'
WHERE not EXISTS (SELECT channel_code FROM pay_api_provider where channel_code='sfoo_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '18', 'sfoo_zfb', NULL, 'file:/data/impl-jars/pay-sfoo.jar', 'org.soul.pay.impl.SfooPayZFBApi', '20160718',
'{"pro":{"payUrl":"http://gw.3yzf.com/v4.aspx","queryOrderUrl":"http://3rd.pay.api.com/sfoopay-pay/zfbpay/v4Query.aspx"},"test":{"payUrl":"http://gw.3yzf.com/v4.aspx","queryOrderUrl":"http://gw.3yzf.com/v4Query.aspx"}}'
WHERE not EXISTS (SELECT channel_code FROM pay_api_provider where channel_code='sfoo_zfb');
