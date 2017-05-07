-- auto gen by gamebox 2016-08-22 20:33:40
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '21', 'rfupay', '锐付支付（网银）', 'file:/data/impl-jars/pay-rfupay.jar', 'org.soul.pay.impl.RfuPayWYApi', '20160822',
    '{"pro":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"},"test":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='rfupay');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '22', 'rfupay_wx', '锐付支付（微信）', 'file:/data/impl-jars/pay-rfupay.jar', 'org.soul.pay.impl.RfuPayWXApi', '20160822',
    '{"pro":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"},"test":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='rfupay_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '23', '9pay', '久付（网银）', 'file:/data/impl-jars/pay-9pay.jar', 'org.soul.pay.impl.JiuPayWYApi', '20160822',
    '{"pro":{"payUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='9pay');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '24', '9pay_wx', '久付（微信）', 'file:/data/impl-jars/pay-9pay.jar', 'org.soul.pay.impl.JiuPayWXApi', '20160822',
    '{"pro":{"payUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"https://9pay.9payonline.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='9pay_wx');


UPDATE "pay_api_provider" SET remarks='宝付' where channel_code='baofoo';
UPDATE "pay_api_provider" SET remarks='环迅3.0' where channel_code='ips_3';
UPDATE "pay_api_provider" SET remarks='融宝' where channel_code='reapal';
UPDATE "pay_api_provider" SET remarks='国付宝' where channel_code='gopay';
UPDATE "pay_api_provider" SET remarks='币币支付老平台' where channel_code='bbpay_old';
UPDATE "pay_api_provider" SET remarks='币币支付新平台' where channel_code='bbpay_new';
UPDATE "pay_api_provider" SET remarks='易宝' where channel_code='yeepay';
UPDATE "pay_api_provider" SET remarks='环迅7.0' where channel_code='ips_7';
UPDATE "pay_api_provider" SET remarks='智付（网银）' where channel_code='dinpay';
UPDATE "pay_api_provider" SET remarks='快捷通' where channel_code='kjt';
UPDATE "pay_api_provider" SET remarks='摩宝（网银）' where channel_code='mobao';
UPDATE "pay_api_provider" SET remarks='摩宝（微信）' where channel_code='mobao_wx';
UPDATE "pay_api_provider" SET remarks='摩宝（支付宝）' where channel_code='mobao_zfb';
UPDATE "pay_api_provider" SET remarks='汇潮支付' where channel_code='ecpss';
UPDATE "pay_api_provider" SET remarks='智付（微信）' where channel_code='dinpay_wx';
UPDATE "pay_api_provider" SET remarks='闪付（网银）' where channel_code='sfoo';
UPDATE "pay_api_provider" SET remarks='闪付（微信）' where channel_code='sfoo_wx';
UPDATE "pay_api_provider" SET remarks='闪付（支付宝）' where channel_code='sfoo_zfb';
UPDATE "pay_api_provider" SET remarks='商银信（微信）' where channel_code='allscore_wx';
UPDATE "pay_api_provider" SET remarks='通汇支付' where channel_code='tonghui';


