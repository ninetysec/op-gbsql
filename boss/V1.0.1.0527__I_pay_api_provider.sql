-- auto gen by linsen 2018-03-12 10:11:08

--久通 by Leo
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'jiutong', '久通（网银）', 'file:/data/impl-jars/pay/pay-jiutong.jar', 'org.soul.pay.impl.JiutongPayWYApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/jiutong-pay/api/pay.action","queryOrderUrl":"http://3rd.pay.api.com/jiutong-pay/api/queryPayResult.action"},"test":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'jiutong');

--天逸付 by Leo
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'tianyifu_jd', '天逸付（京东钱包）', 'file:/data/impl-jars/pay/pay-tianyifu.jar', 'org.soul.pay.impl.TianyifuPayJDApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/tianyifu-pay/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/tianyifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.fengyinchess.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.zgmyb.top/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'tianyifu_jd');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'tianyifu_qq', '天逸付（QQ钱包）', 'file:/data/impl-jars/pay/pay-tianyifu.jar', 'org.soul.pay.impl.TianyifuPayQQApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/tianyifu-pay/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/tianyifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.fengyinchess.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.zgmyb.top/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'tianyifu_qq');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'tianyifu_zfbh5', '天逸付（支付宝WAP）', 'file:/data/impl-jars/pay/pay-tianyifu.jar', 'org.soul.pay.impl.TianyifuPayZFBWAPApi', '20170904091954', '{"pro":{"payUrl":"http://cashier.fengyinchess.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/tianyifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.fengyinchess.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.zgmyb.top/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'tianyifu_zfbh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'tianyifu_zfbwap', '天逸付（支付宝H5）', 'file:/data/impl-jars/pay/pay-tianyifu.jar', 'org.soul.pay.impl.TianyifuPayZFBH5Api', '20170904091954', '{"pro":{"payUrl":"http://cashier.fengyinchess.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/tianyifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.fengyinchess.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.zgmyb.top/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'tianyifu_zfbwap');

--先疯 by Leo
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng', '先疯（网银）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayWYApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_wyh5', '先疯（网银H5）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayWYH5Api', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_wyh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_jd', '先疯（京东钱包）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayJDApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_jd');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_yl', '先疯（银联扫码）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayYLApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_yl');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_ylh5', '先疯（银联扫码H5）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayYLH5Api', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_ylh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_wxh5', '先疯（微信H5）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayWXH5Api', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_wxh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_qq', '先疯（QQ钱包）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayQQApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_qq');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_zfb', '先疯（支付宝）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayZFBApi', '20170904091954', '{"pro":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_zfb');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_zfbh5', '先疯（支付宝H5）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayZFBH5Api', '20170904091954', '{"pro":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_zfbh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'xianfeng_wx', '先疯（微信）', 'file:/data/impl-jars/pay/pay-xianfeng.jar', 'org.soul.pay.impl.XianfengPayWXApi', '20170904091954', '{"pro":{"payUrl":"http://3rd.pay.api.com/xianfeng-pay/Business/pay","queryOrderUrl":"http://3rd.pay.api.com/xianfeng-pay/BusinessQuery"},"test":{"payUrl":"http://pay.xfengpay.com/Business/pay","queryOrderUrl":"http://pay.xfengpay.com/BusinessQuery"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'xianfeng_wx');

--易达 by Leo
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yida', '易达（网银）', 'file:/data/impl-jars/pay/pay-yida.jar', 'org.soul.pay.impl.YidaPayWYApi', '20170904091954', '{"pro":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/yida-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yida');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yida_qq', '易达（QQ钱包）', 'file:/data/impl-jars/pay/pay-yida.jar', 'org.soul.pay.impl.YidaPayQQApi', '20170904091954', '{"pro":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/yida-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yida_qq');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yida_qqwap', '易达（QQ钱包WAP）', 'file:/data/impl-jars/pay/pay-yida.jar', 'org.soul.pay.impl.YidaPayQQWAPApi', '20170904091954', '{"pro":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/yida-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yida_qqwap');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yida_kj', '易达（网银快捷）', 'file:/data/impl-jars/pay/pay-yida.jar', 'org.soul.pay.impl.YidaPayKJApi', '20170904091954', '{"pro":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/yida-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cloud.kuruibo.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yida_kj');

--游久 by Leo
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youjiu_qqh5', '游久（QQ钱包H5）', 'file:/data/impl-jars/pay/pay-youjiu.jar', 'org.soul.pay.impl.YoujiuPayQQH5Api', '20170904091954', '{"pro":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://3rd.pay.api.com/youjiu-pay/Pay_Trade_query.html"},"test":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://www.u9pay.com//Pay_Trade_query.html"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youjiu_qqh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youjiu_qq', '游久（QQ钱包）', 'file:/data/impl-jars/pay/pay-youjiu.jar', 'org.soul.pay.impl.YoujiuPayQQApi', '20170904091954', '{"pro":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://3rd.pay.api.com/youjiu-pay/Pay_Trade_query.html"},"test":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://www.u9pay.com//Pay_Trade_query.html"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youjiu_qq');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youjiu_zfb', '游久（支付宝）', 'file:/data/impl-jars/pay/pay-youjiu.jar', 'org.soul.pay.impl.YoujiuPayZFBApi', '20170904091954', '{"pro":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://3rd.pay.api.com/youjiu-pay/Pay_Trade_query.html"},"test":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://www.u9pay.com//Pay_Trade_query.html"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youjiu_zfb');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youjiu_zfbh5', '游久（支付宝H5）', 'file:/data/impl-jars/pay/pay-youjiu.jar', 'org.soul.pay.impl.YoujiuPayZFBH5Api', '20170904091954', '{"pro":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://3rd.pay.api.com/youjiu-pay/Pay_Trade_query.html"},"test":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://www.u9pay.com//Pay_Trade_query.html"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youjiu_zfbh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youjiu_wx', '游久（微信）', 'file:/data/impl-jars/pay/pay-youjiu.jar', 'org.soul.pay.impl.YoujiuPayWXApi', '20170904091954', '{"pro":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://3rd.pay.api.com/youjiu-pay/Pay_Trade_query.html"},"test":{"payUrl":"http://www.u9pay.com/Pay_Index.html","queryOrderUrl":"http://www.u9pay.com//Pay_Trade_query.html"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youjiu_wx');

--优米付 by snake
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu', '优米付（网银）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayWYApi', '20170904091954', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_wxh5', '优米付（微信H5）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayWXH5Api', '20170904091954', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_wxh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_wxwap', '优米付（微信WAP）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayWXWAPApi', '20170904091954', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_wxwap');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_zfbh5', '优米付（支付宝H5）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayZFBH5Api', '20170904091954', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_zfbh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_zfbwap', '优米付（支付宝WAP）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayZFBWAPApi', '20170904091954', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_zfbwap');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_qqh5', '优米付（QQ钱包H5）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayQQH5Api', '20170904091956', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_qqh5');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_qqwap', '优米付（QQ钱包WAP）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayQQWAPApi', '20170904091954', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_qqwap');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_yl', '优米付（银联扫码）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayYLApi', '20170904091956', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_yl');

INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'youmifu_jdh5', '优米付（京东钱包H5）', 'file:/data/impl-jars/pay/pay-youmifu.jar', 'org.soul.pay.impl.YoumifuPayJDH5Api', '20170904091956', '{"pro":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://3rd.pay.api.com/youmifu-pay/cgi-bin/netpayment/pay_gate.cgi"},"test":{"payUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi","queryOrderUrl":"http://cashier.youmifu.com/cgi-bin/netpayment/pay_gate.cgi"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'youmifu_jdh5');


--亿起付  by  holeter
INSERT INTO "pay_api_provider" ("channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
  SELECT 'yiqifu', '亿起付（网银）', 'file:/data/impl-jars/pay/pay-yiqifu.jar', 'org.soul.pay.impl.YiqifuPayWYApi', '20170904091953', '{"pro":{"payUrl":"https://pay.yiqpay.com/gateway?input_charset=UTF-8","queryOrderUrl":"https://pay.yiqpay.com/gateway"},"test":{"payUrl":"https://pay.yiqpay.com/gateway?input_charset=UTF-8","queryOrderUrl":"https://query.yiqpay.com/query"}}'
  WHERE NOT EXISTS (select channel_code from pay_api_provider where channel_code = 'yiqifu');

