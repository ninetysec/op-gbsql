-- auto gen by cherry 2017-06-09 11:03:10
--目标地址：https://pay.beeepay.com/payment/gateway

--3rd配置的地址：http://3rd.pay.api.com/bifu-pay/payment/gateway

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '139', 'bifu', '必付支付（网银）', 'file:/data/impl-jars/pay/pay-bifu.jar', 'org.soul.pay.impl.BifuPayWYApi', '20170603',
'{"pro":{"payUrl":"https://pay.beeepay.com/payment/gateway","queryOrderUrl":"http://3rd.pay.api.com/bifu-pay/payment/gateway"},"test":{"payUrl":"https://pay.beeepay.com/payment/gateway","queryOrderUrl":"https://pay.beeepay.com/payment/gateway"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'bifu');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '140', 'bifu_wx', '必付支付（微信）', 'file:/data/impl-jars/pay/pay-bifu.jar', 'org.soul.pay.impl.BifuPayWXApi', '20170603',
'{"pro":{"payUrl":"http://3rd.pay.api.com/bifu-pay/payment/gateway","queryOrderUrl":"http://3rd.pay.api.com/bifu-pay/payment/gateway"},"test":{"payUrl":"https://pay.beeepay.com/payment/gateway","queryOrderUrl":"https://pay.beeepay.com/payment/gateway"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'bifu_wx');


INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '141', 'bifu_zfb', '必付支付（支付宝）', 'file:/data/impl-jars/pay/pay-bifu.jar', 'org.soul.pay.impl.BifuPayZFBApi', '20170603',
'{"pro":{"payUrl":"http://3rd.pay.api.com/bifu-pay/payment/gateway","queryOrderUrl":"http://3rd.pay.api.com/bifu-pay/payment/gateway"},"test":{"payUrl":"https://pay.beeepay.com/payment/gateway","queryOrderUrl":"https://pay.beeepay.com/payment/gateway"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'bifu_zfb');

  INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '145', 'baijie', '百捷支付（网银）', 'file:/data/impl-jars/pay/pay-baijie.jar', 'org.soul.pay.impl.BaijiePayWYApi', '20170606', '{"pro":{"payUrl":"http://vip.batpay.com.cn/bank/","queryOrderUrl":""},"test":{"payUrl":"http://vip.batpay.com.cn/bank/","queryOrderUrl":"http://vip.batpay.com.cn/bank/"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'baijie');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '146', 'baijie_wx', '百捷支付（微信）', 'file:/data/impl-jars/pay/pay-baijie.jar', 'org.soul.pay.impl.BaijiePayWXApi', '20170606', '{"pro":{"payUrl":"http://vip.batpay.com.cn/bank/","queryOrderUrl":""},"test":{"payUrl":"http://vip.batpay.com.cn/bank/","queryOrderUrl":"http://vip.batpay.com.cn/bank/"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'baijie_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '147', 'baijie_zfb', '百捷支付（支付宝）', 'file:/data/impl-jars/pay/pay-baijie.jar', 'org.soul.pay.impl.BaijiePayZFBApi', '20170606', '{"pro":{"payUrl":"http://vip.batpay.com.cn/bank/","queryOrderUrl":""},"test":{"payUrl":"http://vip.batpay.com.cn/bank/","queryOrderUrl":"http://vip.batpay.com.cn/bank/"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'baijie_zfb');

 --http://api.hebaobill.com/
--http://3rd.pay.api.com/hebao-pay/
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '130', 'hebao_wx', '荷包支付（微信）', 'file:/data/impl-jars/pay/pay-hebao.jar', 'org.soul.pay.impl.HebaoPayWXApi', '20170515', '{"pro":{"payUrl":"http://3rd.pay.api.com/hebao-pay/gateway","queryOrderUrl":"http://3rd.pay.api.com/hebao-pay/query"},"test":{"payUrl":"http://api.hebaobill.com/gateway","queryOrderUrl":"http://api.hebaobill.com/query"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'hebao_wx');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '131', 'hebao_zfb', '荷包支付（支付宝）', 'file:/data/impl-jars/pay/pay-hebao.jar', 'org.soul.pay.impl.HebaoPayZFBApi', '20170515', '{"pro":{"payUrl":"http://3rd.pay.api.com/hebao-pay/gateway","queryOrderUrl":"http://3rd.pay.api.com/hebao-pay/query"},"test":{"payUrl":"http://api.hebaobill.com/gateway","queryOrderUrl":"http://api.hebaobill.com/query"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'hebao_zfb');

  --https://gateway.zbpay.cc
--http://3rd.pay.api.com/zbpay-pay
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '151', 'zbpay_wy', '众宝支付（网银）', 'file:/data/impl-jars/pay/pay-zbpay.jar', 'org.soul.pay.impl.ZbPayWYApi', '20170605', '{"pro":{"payUrl":"https://gateway.zbpay.cc/GateWay/CashierDesk.aspx","queryOrderUrl":"http://3rd.pay.api.com/zbpay-pay/search.aspx"},"test":{"payUrl":"https://gateway.zbpay.cc/GateWay/CashierDesk.aspx","queryOrderUrl":"https://gateway.zbpay.cc/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'zbpay_wy');

INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '152', 'zbpay_wx', '众宝支付（微信）', 'file:/data/impl-jars/pay/pay-zbpay.jar', 'org.soul.pay.impl.ZbPayWXApi', '20170605', '{"pro":{"payUrl":"https://gateway.zbpay.cc/GateWay/index.aspx","queryOrderUrl":"http://3rd.pay.api.com/zbpay-pay/search.aspx"},"test":{"payUrl":"https://gateway.zbpay.cc/GateWay/index.aspx","queryOrderUrl":"https://gateway.zbpay.cc/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'zbpay_wx');


INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT '153', 'zbpay_zfb', '众宝支付（支付宝）', 'file:/data/impl-jars/pay/pay-zbpay.jar', 'org.soul.pay.impl.ZbPayZFBApi', '20170605', '{"pro":{"payUrl":"https://gateway.zbpay.cc/GateWay/index.aspx","queryOrderUrl":"http://3rd.pay.api.com/zbpay-pay/search.aspx"},"test":{"payUrl":"https://gateway.zbpay.cc/GateWay/index.aspx","queryOrderUrl":"https://gateway.zbpay.cc/search.aspx"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'zbpay_zfb');

