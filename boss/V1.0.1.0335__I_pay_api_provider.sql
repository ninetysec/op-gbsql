-- auto gen by cherry 2017-05-25 14:58:06
--http://saascashier.mobaopay.com/
--http://3rd.pay.api.com/xinmobao-pay/
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT '136', 'xinmobao', '新摩宝（网银）', 'file:/data/impl-jars/pay/pay-xinmobao.jar', 'org.soul.pay.impl.XinmobaoPayWYApi', '20170524',
'{"pro":{"payUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/xinmobao-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xinmobao');



INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT '137', 'xinmobao_wx', '新摩宝（微信）', 'file:/data/impl-jars/pay/pay-xinmobao.jar', 'org.soul.pay.impl.XinmobaoPayWXApi', '20170524',
'{"pro":{"payUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/xinmobao-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xinmobao_wx');



INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT '138', 'xinmobao_zfb', '新摩宝（支付宝）', 'file:/data/impl-jars/pay/pay-xinmobao.jar', 'org.soul.pay.impl.XinmobaoPayZFBApi', '20170524',
'{"pro":{"payUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/xinmobao-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://saascashier.mobaopay.com/cgi-bin/netpayment/pay_gate.cgi"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xinmobao_zfb');

