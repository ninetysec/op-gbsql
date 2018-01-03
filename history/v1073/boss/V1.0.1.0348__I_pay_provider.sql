-- auto gen by cherry 2017-06-16 14:51:45
--http://119.23.249.156:8080
--http://3rd.pay.api.com/baolifu-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT 'baolifu_wy', '宝立付支付（网银）', 'file:/data/impl-jars/pay/pay-baolifu.jar', 'org.soul.pay.impl.BaolifuPayWYApi', '20170603', '{"pro":{"payUrl":"http://119.23.249.156:8080/pp_server/pay","queryOrderUrl":"http://3rd.pay.api.com/baolifu-pay/pp_server/pay"},"test":{"payUrl":"http://119.23.249.156:8080/pp_server/pay","queryOrderUrl":"http://119.23.249.156:8080/pp_server/pay"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'baolifu_wy');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT 'baolifu_wx', '宝立付支付（微信）', 'file:/data/impl-jars/pay/pay-baolifu.jar', 'org.soul.pay.impl.BaolifuPayWXApi', '20170603', '{"pro":{"payUrl":"http://119.23.249.156:8080/pp_server/pay","queryOrderUrl":"http://3rd.pay.api.com/baolifu-pay/pp_server/pay"},"test":{"payUrl":"http://119.23.249.156:8080/pp_server/pay","queryOrderUrl":"http://119.23.249.156:8080/pp_server/pay"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'baolifu_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")

  SELECT 'baolifu_zfb', '宝立付支付（支付宝）', 'file:/data/impl-jars/pay/pay-baolifu.jar', 'org.soul.pay.impl.BaolifuPayZFBApi', '20170603', '{"pro":{"payUrl":"http://119.23.249.156:8080/pp_server/pay","queryOrderUrl":"http://3rd.pay.api.com/baolifu-pay/pp_server/pay"},"test":{"payUrl":"http://119.23.249.156:8080/pp_server/pay","queryOrderUrl":"http://119.23.249.156:8080/pp_server/pay"}}'

  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'baolifu_zfb');

  --https://gw.169.cc
--http://3rd.pay.pai.com/duobao-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'duobaopay_wy', '多宝支付（网银）', 'file:/data/impl-jars/pay/pay-duobao.jar', 'org.soul.pay.impl.DuobaoPayWYApi', '20170613', '{"pro":{"payUrl":"https://gw.169.cc/interface/AutoBank/index.aspx","queryOrderUrl":"http://3rd.pay.api.com/duobao-pay/interface/search.aspx"},"test":{"payUrl":"https://gw.169.cc/interface/AutoBank/index.aspx","queryOrderUrl":"https://gw.169.cc/interface/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'duobaopay_wy');


INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'duobaopay_wx', '多宝支付（微信）', 'file:/data/impl-jars/pay/pay-duobao.jar', 'org.soul.pay.impl.DuobaoPayWXApi', '20170613', '{"pro":{"payUrl":"https://gw.169.cc/interface/AutoBank/index.aspx","queryOrderUrl":"http://3rd.pay.api.com/duobao-pay/interface/search.aspx"},"test":{"payUrl":"https://gw.169.cc/interface/AutoBank/index.aspx","queryOrderUrl":"https://gw.169.cc/interface/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'duobaopay_wx');


INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'duobaopay_zfb', '多宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-duobao.jar', 'org.soul.pay.impl.DuobaoPayZFBApi', '20170613', '{"pro":{"payUrl":"https://gw.169.cc/interface/AutoBank/index.aspx","queryOrderUrl":"http://3rd.pay.api.com/duobao-pay/interface/search.aspx"},"test":{"payUrl":"https://gw.169.cc/interface/AutoBank/index.aspx","queryOrderUrl":"https://gw.169.cc/interface/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'duobaopay_zfb');