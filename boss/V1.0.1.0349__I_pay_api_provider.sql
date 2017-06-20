-- auto gen by cherry 2017-06-19 11:27:24
--http://www.master-egg.cn
--http://3rd.pay.api.com/xuntongbao-pay
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xuntongbao_wy', '讯通宝支付（网银）', 'file:/data/impl-jars/pay/pay-xuntongbao.jar', 'org.soul.pay.impl.XuntongbaoPayWYApi', '20170603', '{"pro":{"payUrl":"http://www.master-egg.cn/GateWay/ReceiveBank.aspx","queryOrderUrl":"http://3rd.pay.api.com/xuntongbao-pay/GateWay/ReceiveOrderSelect.aspx"},"test":{"payUrl":"http://www.master-egg.cn/GateWay/ReceiveBank.aspx","queryOrderUrl":"http://www.master-egg.cn/GateWay/ReceiveOrderSelect.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xuntongbao_wy');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xuntongbao_wx', '讯通宝支付（微信）', 'file:/data/impl-jars/pay/pay-xuntongbao.jar', 'org.soul.pay.impl.XuntongbaoPayWXApi', '20170603', '{"pro":{"payUrl":"http://www.master-egg.cn/GateWay/ReceiveBank.aspx","queryOrderUrl":"http://3rd.pay.api.com/xuntongbao-pay/GateWay/ReceiveOrderSelect.aspx"},"test":{"payUrl":"http://www.master-egg.cn/GateWay/ReceiveBank.aspx","queryOrderUrl":"http://www.master-egg.cn/GateWay/ReceiveOrderSelect.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xuntongbao_wx');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xuntongbao_zfb', '讯通宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-xuntongbao.jar', 'org.soul.pay.impl.XuntongbaoPayZFBApi', '20170603', '{"pro":{"payUrl":"http://www.master-egg.cn/GateWay/ReceiveBank.aspx","queryOrderUrl":"http://3rd.pay.api.com/xuntongbao-pay/GateWay/ReceiveOrderSelect.aspx"},"test":{"payUrl":"http://www.master-egg.cn/GateWay/ReceiveBank.aspx","queryOrderUrl":"http://www.master-egg.cn/GateWay/ReceiveOrderSelect.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xuntongbao_zfb');