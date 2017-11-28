-- auto gen by brave 2016-10-08 14:37:49
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '30', 'rfupay_zfb', '锐付支付（支付宝）', 'file:/data/impl-jars/pay-rfupay.jar', 'org.soul.pay.impl.RfuPayZFBApi', '20161016', '{"pro":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"},"test":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"}}'
  WHERE NOT EXISTS (select id from pay_api_provider where id = 30);
