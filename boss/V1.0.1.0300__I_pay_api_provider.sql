-- auto gen by cherry 2017-03-01 13:57:23
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '74', 'anfu', '安付支付（网银）', 'file:/data/impl-jars/pay/pay-anfu.jar', 'org.soul.pay.impl.AnfuPayWYApi', '20170301', '{"pro":{"payUrl":"http://gw.91anfu.com/payment.aspx","queryOrderUrl":"http://3rd.pay.api.com/anfu-pay/orderquery.aspx"},"test":{"payUrl":"http://gw.91anfu.com/payment.aspx","queryOrderUrl":"http://gw.91anfu.com/orderquery.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'anfu');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '75', 'anfu_wx', '安付支付（微信）', 'file:/data/impl-jars/pay/pay-anfu.jar', 'org.soul.pay.impl.AnfuPayWXApi', '20170301', '{"pro":{"payUrl":"http://gw.91anfu.com/payment.aspx","queryOrderUrl":"http://3rd.pay.api.com/anfu-pay/orderquery.aspx"},"test":{"payUrl":"http://gw.91anfu.com/payment.aspx","queryOrderUrl":"http://gw.91anfu.com/orderquery.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'anfu_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '76', 'anfu_zfb', '安付支付（支付宝）', 'file:/data/impl-jars/pay/pay-anfu.jar', 'org.soul.pay.impl.AnfuPayZFBApi', '20170301', '{"pro":{"payUrl":"http://gw.91anfu.com/payment.aspx","queryOrderUrl":"http://3rd.pay.api.com/anfu-pay/orderquery.aspx"},"test":{"payUrl":"http://gw.91anfu.com/payment.aspx","queryOrderUrl":"http://gw.91anfu.com/orderquery.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'anfu_zfb');

DELETE FROM site_sub_job where sub_job_code='site_job_001';

UPDATE site_sub_job set prefix_job_id = NULL where prefix_job_id = 1;