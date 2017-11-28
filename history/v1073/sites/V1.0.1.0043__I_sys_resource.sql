-- auto gen by cherry 2016-03-04 10:59:05
--重整sys_resource表

TRUNCATE TABLE sys_resource;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('1', '首页', 'home/homeIndex.html', '管理首页', NULL, NULL, '1', 'mcenter', 'mcenter:index', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2', '角色', NULL, '角色管理', NULL, NULL, '2', 'mcenter', 'mcenter:role', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3', '资金', NULL, '资金管理', NULL, NULL, '3', 'mcenter', 'mcenter:fund', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4', '运营', NULL, '运营管理', NULL, NULL, '4', 'mcenter', 'mcenter:operate', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('5', '统计', NULL, '统计报表', NULL, NULL, '5', 'mcenter', 'mcenter:report', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6', '内容', NULL, '内容管理', NULL, NULL, '6', 'mcenter', 'mcenter:content', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('7', '系统', NULL, '系统设置', NULL, NULL, '8', 'mcenter', 'mcenter:system', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('8', '经营', NULL, '经营分析', NULL, NULL, '7', 'mcenter', 'mcenter:manage', '1', '', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('21', '总代首页', 'topAgent/topAgentIndex.html', '总代管理-总代中心首页', NULL, '', '1', 'mcenterTopAgent', 'topagent:index', '1', 'icon-shouye', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('22', '代理管理', 'topAgentAgent/list.html', '总代管理-代理管理', NULL, '', '2', 'mcenterTopAgent', 'topagent:agent', '1', 'icon-dailiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('23', '报表记录', '', '', NULL, '', '3', 'mcenterTopAgent', 'topagent:report', '1', 'icon-log', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('24', '消息公告', 'topAgentGameAnnouncement/topAgentMessageList.html', '', NULL, '', '4', 'mcenterTopAgent', 'topagent:annoucement', '1', 'icon-xiaoxigonggao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('25', '账号管理', '', '', NULL, '', '5', 'mcenterTopAgent', 'topagent:account', '1', 'icon-wodezhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('31', '代理首页', 'agent/agentIndex.html', '代理中心首页', NULL, '', '1', 'mcenterAgent', 'agent:index', '1', 'icon-shouye', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('32', '玩家管理', 'agentPlayer/list.html', '代理中心-玩家管理', NULL, '', '2', 'mcenterAgent', 'agent:player', '1', 'icon-wanjiaguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('33', '报表记录', '', '报表记录', NULL, '', '3', 'mcenterAgent', 'agent:report', '1', 'icon-log', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('34', '消息公告', 'agentGameAnnouncement/agentMessageList.html', '消息公告', NULL, '', '4', 'mcenterAgent', 'agent:announcment', '1', 'icon-xiaoxigonggao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('35', '账号管理', '', '账号管理', NULL, '', '5', 'mcenterAgent', 'agent:account', '1', 'icon-wodezhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40', '首页', '', '首页', NULL, NULL, '1', 'pcenter', '', '2', 'home', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('41', '玩家首页', 'home/homeIndex.html', '玩家首页', NULL, NULL, '1', 'pcenter', 'pcenter:index', '1', 'home', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('42', '资金管理', 'test', '资金管理', NULL, NULL, '2', 'pcenter', 'pcenter:fund', '1', 'capital', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('43', '交易记录', 'test', '交易记录', NULL, NULL, '3', 'pcenter', 'pcenter:betorder', '1', 'gamerecord', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('44', '优惠活动', 'preferential/list.html', '优惠活动', NULL, NULL, '4', 'pcenter', 'pcenter:preferential', '1', 'sale', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('45', '消息公告', '', '消息公告', NULL, NULL, '5', 'pcenter', 'pcenter:announcement', '1', 'info', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('46', '账号管理', 'test', '账号管理', NULL, NULL, '6', 'pcenter', 'pcenter:account', '1', 'accout', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('47', '推荐好友', 'test', '推荐好友', NULL, NULL, '7', 'pcenter', 'pcenter:recommend', '1', 'recommend', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('201', '在线玩家', 'vPlayerOnline/list.html', '在线玩家', '2', '', '5', 'mcenter', 'role:online', '1', 'icon-zaixianwanjia', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('202', '玩家管理', 'player/list.html', '玩家管理', '2', NULL, '1', 'mcenter', 'role:player', '1', 'icon-wanjiaguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('203', '层级设置', 'vPlayerRankStatistics/list.html', '层级设置', '2', NULL, '2', 'mcenter', 'role:rank', '1', 'icon-cengjishezhi', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('204', '代理管理', 'vUserAgentManage/list.html', '代理管理', '2', NULL, '3', 'mcenter', 'role:agent', '1', 'icon-dailiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('206', '总代管理', 'vUserTopAgentManage/list.html', '总代管理', '2', NULL, '4', 'mcenter', 'role:topagent', '1', 'icon-zongdaiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('301', '公司入款审核', 'fund/companyDespoit/list.html?search.rechargeStatus=1', '公司存款', '3', NULL, '1', 'mcenter', 'fund:companydeposit', '1', 'icon-gongsirukuanshenhe', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('302', '线上支付记录', 'fund/rechargeOnline/list.html', '线上存款', '3', NULL, '2', 'mcenter', 'fund:onlinedeposit', '1', 'icon-xianshangzhifujilu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('303', '玩家取款审核', 'fund/withdraw/withdrawList.html', '提现记录', '3', NULL, '3', 'mcenter', 'fund:playerwithdraw', '1', 'icon-wanjiaqukuanshenhe', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('304', '代理取款审核', 'fund/vAgentWithdrawOrder/agentList.html', '代理取款审核', '3', '', '4', 'mcenter', 'fund:agentwithdraw', '1', 'icon-dailiqukuanshenhe', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('305', '手动存提', 'fund/artificial/addChoose.html', '手动存提', '3', NULL, '5', 'mcenter', 'fund:artificial', '1', 'icon-shoudongcunti', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('306', '玩家检测', 'fund/playerDetect/userPlayView.html', '玩家检测', '3', NULL, '6', 'mcenter', 'fund:playerdetect', '1', 'icon-wanjiajiance', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('401', '活动管理', 'operation/activity/list.html', '活动管理', '4', NULL, '1', 'mcenter', 'operate:activity', '1', 'icon-huodongguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('402', '信息群发', 'operation/massInformation/chooseType.html', '信息群发', '4', '', '2', 'mcenter', 'operate:massinfo', '1', 'icon-xinxiqunfa', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('403', '消息公告', 'operation/announcementMessage/messageList.html', '消息公告', '4', NULL, '3', 'mcenter', 'operate:announcement', '1', 'icon-xiaoxigonggao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('404', '返佣结算', 'operation/rebate/list.html', '站长推广', '4', '', '4', 'mcenter', 'operate:rebate', '1', 'icon-fanyongjiesuan', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('405', '返水结算', 'operation/rakebackBill/list.html', '返水结算', '4', NULL, '5', 'mcenter', 'operate:rakeback', '1', 'icon-fanshuijiesuan', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('406', '结算账单', 'operation/stationbill/list.html', '结算管理', '4', '', '6', 'mcenter', 'operate:bill', '1', 'icon-jiesuanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('501', '经营报表', 'report/operate/operateIndex.html', '统计报表-经营报表', '5', NULL, '1', 'mcenter', 'report:operate', '1', 'icon-jingyingbaobiao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('502', '交易记录', 'report/gameTransaction/list.html', '运营报表', '5', NULL, '2', 'mcenter', 'report:betorder', '1', 'icon-jiaoyijilu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('503', '资金记录', 'report/fundsLog/list.html', '日志管理', '5', '', '3', 'mcenter', 'report:fundrecord', '1', 'icon-zijinjilu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('504', '返水统计', 'report/rakeback/rakebackIndex.html', '日志管理', '5', '', '4', 'mcenter', 'report:rakeback', '1', 'icon-fanshuitongji', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('505', '返佣统计', 'report/rebate/rebateIndex.html', '统计报表-佣金报表', '5', '', '5', 'mcenter', 'report:rebate', '1', 'icon-fanyongtongji', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('506', '日志查询', 'report/log/logList.html', '日志管理', '5', '', '6', 'mcenter', 'report:log', '1', 'icon-rizhichaxun', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('601', '文案管理', 'vCttDocument/list.html', '文案管理', '6', NULL, '1', 'mcenter', 'content:document', '1', 'icon-wenanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('602', 'LOGO管理', 'cttLogo/list.html', 'LOGO管理', '6', NULL, '2', 'mcenter', 'content:logo', '1', 'icon-wenanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('603', '资讯管理', 'test', '资讯管理', '6', NULL, '3', 'mcenter', 'content:', '1', 'icon-zixunguanli', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('604', '轮播广告', 'content/vCttCarousel/list.html', '轮播广告', '6', NULL, '4', 'mcenter', 'content:carousel', '1', 'icon-lunboguanggao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('605', '浮动图管理', 'cttFloatPic/list.html', '浮动图管理', '6', NULL, '5', 'mcenter', 'content:floatpic', '1', 'icon-fudongtu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('606', '站点栏目', 'asd', '站点栏目', '6', NULL, '6', 'mcenter', 'content:', '1', 'icon-zhandianlanmu', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('607', '公告栏管理', 'cttAnnouncement/list.html', '公告管理', '6', NULL, '7', 'mcenter', 'content:announcement', '1', 'icon-gonggaolanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('608', '游戏管理', 'vSiteApiType/list.html', '游戏管理', '6', NULL, '8', 'mcenter', 'content:game', '1', 'icon-youxiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('609', '模板管理', 'test', '模板管理', '6', NULL, '9', 'mcenter', 'content:', '1', 'icon-mobanguanli', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('610', '公司入款账户', 'vPayAccount/list.html?search.type=1', '支付管理', '6', NULL, '10', 'mcenter', 'content:companyaccount', '1', 'icon-gongsirukuanzhanghu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('611', '线上支付账户', 'vPayAccount/list.html?search.type=2', '支付管理', '6', '', '11', 'mcenter', 'content:onlineaccount', '1', 'icon-xianshangzhifuzhanghu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('612', '域名管理', 'content/sysDomain/list.html', '域名管理', '6', NULL, '12', 'mcenter', 'content:domain', '1', 'icon-yumingguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('613', '推广素材', 'cttMaterialText/list.html', '站长中心-内容-推广素材', '6', NULL, '13', 'mcenter', 'content:material', '1', 'icon-tuiguangsucai', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('614', '体育推荐', 'sportRecommendedSite/list.html', '体育推荐', '6', NULL, '14', 'mcenter', 'content:sportRecommended', '1', 'icon-tiyutuijian', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('701', '站点参数', 'param/basicSettingIndex.html', '站点参数', '7', NULL, '1', 'mcenter', 'system:basicsetting', '1', 'icon-zhandiancanshu', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('702', '我的账号', 'myAccount/myAccount.html', '我的账号', '7', '', '2', 'mcenter', 'system:myaccount', '1', 'icon-wodezhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('703', '子账号', 'subAccount/list.html', '系统账号', '7', NULL, '3', 'mcenter', 'system:subaccount', '1', 'icon-xitongzhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('704', '返佣设置', 'rebateSet/list.html', '返佣设置', '7', NULL, '4', 'mcenter', 'system:rebate', '1', 'icon-fanyongshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('705', '返水设置', 'setting/vRakebackSet/list.html', '系统设置-返水设置', '7', NULL, '5', 'mcenter', 'system:rakeback', '1', 'icon-fanshuishezhi', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('706', '分摊设置', 'param/apportion.html', '分摊设置', '7', '', '6', 'mcenter', 'system:apportion', '1', 'icon-fentanshezhi', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('707', '推荐设置', 'param/getRecommended.html', '推荐设置', '7', '', '7', 'mcenter', 'system:recommended', '1', 'icon-tuijianshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('708', '访问设置', 'siteConfineArea/list.html', '访问设置', '7', NULL, '8', 'mcenter', 'system:confinearea', '1', 'icon-fangwenshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('709', '接口设置', 'vNoticeEmailRank/list.html', '接口设置', '7', NULL, '9', 'mcenter', 'system:interface', '1', 'icon-jiekoushezhi', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('710', '信息模板', 'noticeTmpl/tmpIndex.html', '信息模板', '7', NULL, '10', 'mcenter', 'system:noticetmpl', '1', 'icon-xinximoban', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('711', '联系人管理', 'vSiteContacts/list.html', '联系人管理', '7', NULL, '11', 'mcenter', 'system:contacts', '1', 'icon-lianxirenguanli', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('712', '导出任务列表', 'share/exports/exportHistoryList.html', '导出任务列表-by River', '7', NULL, '12', 'mcenter', 'system:export', '1', 'icon-fangwenshezhi', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2201', '新增', 'agentEdit/create.html', '代理管理-新增代理', '22', '', NULL, 'mcenterTopAgent', 'topagent:agent_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2202', '编辑', 'agentEdit/edit.html', '代理管理-编辑', '22', '', NULL, 'mcenterTopAgent', 'topagent:agent_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2203', '审核', 'topAgentAgent/toCheck.html', '代理管理-审核', '22', '', NULL, 'mcenterTopAgent', 'topagent:agent_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2301', '占成统计', 'topagent/report/occupy/reportIndex.html', '统计报表-占成统计', '23', '', '1', 'mcenterTopAgent', 'report:occupy', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2302', '交易记录', 'report/topagentGameTransaction/list.html?search.searchCondition=false', '', '23', '', '3', 'mcenterTopAgent', 'report:bet', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2303', '经营报表', 'report/operate/operateIndex.html', '统计报表-经营报表', '23', '', '2', 'mcenterTopAgent', 'report:operate', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2501', '子账号', 'subAccount/list.html', '', '25', '', '2', 'mcenterTopAgent', 'account:subaccount', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2502', '我的账号', 'topAgentAccount/myAccount.html', '我的账号', '25', '', '1', 'mcenterTopAgent', 'account:myaccount', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2503', '结算账单', 'account/stationbill/list.html', '', '25', '', '3', 'mcenterTopAgent', 'account:bill', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2504', '推广素材', 'topCttMaterial/list.html', '', '25', '', '4', 'mcenterTopAgent', 'account:material', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3301', '交易记录', 'report/agentGameTransaction/list.html?search.searchCondition=false', '报表记录-交易记录', '33', '', '3', 'mcenterAgent', 'report:betorder', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3303', '经营报表', 'report/operate/operateIndex.html', '报表记录-经营报表', '33', '', '2', 'mcenterAgent', 'report:operate', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3304', '返佣统计', 'report/rebate/agentRebate.html', '报表记录-返佣统计', '33', '', '1', 'mcenterAgent', 'report:rebate', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3501', '子账号', 'subAccount/list.html', '账号管理-子账号', '35', '', '2', 'mcenterAgent', 'account:subaccount', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3502', '我的账号', 'agentAccount/myAccount.html', '账号管理-我的账号', '35', '', '1', 'mcenterAgent', 'account:myaccount', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3503', '推广素材', 'cttMaterial/list.html', '账号管理-推广素材', '35', '', '4', 'mcenterAgent', 'account:material', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3504', '账户资金', 'vAgentFundRecord/list.html', '账号管理-账户资金', '35', '', '3', 'mcenterAgent', 'account:fund', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4001', '首页顶部-新消息', 'operation/announcementMessage/messageList.html', '首页顶部-新消息', '40', NULL, NULL, 'mcenter', 'index:announcementMessage', '2', NULL, 'f', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4201', '转账', 'fund/playerTransfer/transfers.html', '转账', '42', NULL, '1', 'pcenter', 'fund:transfers', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4202', '存款', 'fund/playerRecharge/recharge.html', '存款', '42', NULL, '2', 'pcenter', 'fund:deposit', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4203', '取款', 'player/withdraw/withdrawList.html', '取款', '42', NULL, '3', 'pcenter', 'fund:withdraw', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4204', '资金记录', 'fund/transaction/chart.html', '资金记录', '42', NULL, '4', 'pcenter', 'fund:fundrecord', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4301', '历史记录', 'vPlayerGameOrder/apiList.html?type=history', '历史记录', '43', NULL, '1', 'pcenter', 'betorder:history', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4501', '站点消息', 'operation/pAnnouncementMessage/messageList.html', '站点消息', '45', NULL, '1', 'pcenter', 'announcement:message', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4502', '系统公告', 'operation/pAnnouncementMessage/systemNoticeHistory.html', '系统公告', '45', NULL, '2', 'pcenter', 'announcement:system', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4503', '游戏公告', 'operation/pAnnouncementMessage/gameNotice.html', '游戏公告', '45', NULL, '3', 'pcenter', 'announcement:game', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4601', '账号设置', 'accountSettings/list.html', '账号设置', '46', NULL, '1', 'pcenter', 'account:setting', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4602', '个人信息', 'personalInfo/view.html', '个人信息', '46', NULL, '2', 'pcenter', 'account:person', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4603', '登录日志', 'loginLog/list.html', '登录日志', '46', NULL, '3', 'pcenter', 'account:loginlog', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4701', '推荐好友', 'playerRecommendAward/recommend.html', '推荐好友', '47', NULL, '1', 'pcenter', 'recommend:friend', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4702', '推荐记录', 'playerRecommendAward/recommendRecord.html', '推荐记录', '47', NULL, '2', 'pcenter', 'recommend:record', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20101', '强制踢出', 'player/view/offlineForced.html', '在线玩家-强制踢出', '201', NULL, NULL, 'mcenter', 'role:online_offline', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20201', '玩家管理-导出', 'player/exportRecords.html', '玩家管理-导出', '202', NULL, NULL, 'mcenter', 'role:player_export', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20202', '账号冻结', 'share/account/freezeAccount.html', '玩家管理-账号冻结', '202', NULL, NULL, 'mcenter', 'role:player_freezeaccout', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20203', '编辑', 'player/getVUserPlayer.html', '玩家管理-编辑', '202', '', NULL, 'mcenter', 'role:player_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20204', '账号停用', 'share/account/disabledAccount.html', '玩家管理-账号停用', '202', NULL, NULL, 'mcenter', 'role:player_disabledaccount', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20205', '取消冻结账号', 'share/account/cancelAccountFreeze.html', '玩家管理-取消冻结账号', '202', NULL, NULL, 'mcenter', 'role:player_cancelfreezeaccount', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20206', '余额冻结', 'share/account/freezeBalance.html', '玩家管理-余额冻结', '202', NULL, NULL, 'mcenter', 'role:player_freezebalance', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20207', '取消冻结余额', 'share/account/cancelBalanceFreeze.html', '玩家管理-取消冻结余额', '202', NULL, NULL, 'mcenter', 'role:player_cancelfreezebalance', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20208', '玩家详细资料', 'player/playerViewDetail.html', '玩家管理-玩家详细资料（显示隐藏字段）', '202', '', NULL, 'mcenter', 'role:player_detail', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20222', '玩家管理-清除联系方式', 'userPlayer/export.html', '玩家管理-清除联系方式', '202', NULL, NULL, 'mcenter', 'role:player_cleanup', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20301', '删除', 'playerRank/rank_delete.html', '层级设置-删除层级', '203', NULL, NULL, 'mcenter', 'role:rank_delete', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20302', '新增', 'playerRank/add.html', '层级设置-新增层级', '203', '', NULL, 'mcenter', 'role:rank_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20401', '新增', 'userAgent/create.html', '代理管理-新增代理', '204', '', NULL, 'mcenter', 'role:agent_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20402', '编辑', 'userAgent/edit.html', '代理管理-编辑代理', '204', '', NULL, 'mcenter', 'role:agent_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20403', '审核', 'userAgent/toCheck.html', '代理管理-审核代理', '204', '', NULL, 'mcenter', 'role:agent_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20601', '新增', 'userAgent/editTopAgent.html', '总代管理-新增总代', '206', '', NULL, 'mcenter', 'role:topagent_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20602', '编辑', 'userAgent/editTopAgent.html', '总代管理-编辑总代', '206', '', NULL, 'mcenter', 'role:topagent_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30101', '审核', 'fund/companyDespoit/checkIndex.html', '公司入款审核-审核', '301', '', NULL, 'mcenter', 'fund:companydeposit_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30201', '审核通过', 'fund/rechargeOnline/confirmCheck.html', '线上支付记录-审核通过', '302', '', NULL, 'mcenter', 'fund:onlinedeposit_checksuc', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30202', '审核失败', 'fund/rechargeOnline/checkFailure.html', '线上支付记录-审核失败', '302', '', NULL, 'mcenter', 'fund:onlinedeposit_checkfai', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30301', '审核', 'fund/withdraw/withdrawAuditView.html', '玩家取款审核-审核', '303', '', NULL, 'mcenter', 'fund:playerwithdraw_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30401', '审核', 'fund/vAgentWithdrawOrder/agentAudit.html', '代理取款审核-审核', '304', '', NULL, 'mcenter', 'fund:agentwithdraw_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40101', '删除活动信息', 'operation/activity/deleteActivity.html', '活动管理-删除', '401', NULL, NULL, 'mcenter', 'operate:activity_delete', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40102', '创建活动', 'operation/activityType/customList.html', '活动管理-创建活动', '401', '', NULL, 'mcenter', 'operate:activity_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40103', '优惠审核', 'operation/vActivityPlayerApply/activityPlayerApply.html', '活动管理-优惠审核', '401', '', NULL, 'mcenter', 'operate:activity_checkapply', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40401', '结算', 'operation/rebate/clearing.html', '返佣结算-结算', '404', '', NULL, 'mcenter', 'operate:rebate_settle', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40501', '结算', 'operation/rakebackBill/settlement.html', '返水结算-结算', '405', '', NULL, 'mcenter', 'operate:rakeback_settle', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('40601', '修改应付', 'operation/stationbill/toUpdateAmountPayable.html', '结算账单-修改应付', '406', '', NULL, 'mcenter', 'operate:bill_modify', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50201', '交易记录导出', 'report/gameTransaction/exportRecords.html', '交易记录-导出', '502', '', NULL, 'mcenter', 'report:betorder_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50301', '资金记录导出', 'report/fundsLog/exportRecords.html', '资金记录-导出', '503', '', NULL, 'mcenter', 'report:fundrecord_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50401', '返水统计导出', 'report/rakeback/detail/exportRecords.html', '返水统计-导出', '504', '', NULL, 'mcenter', 'report:rakeback_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50501', '返佣统计导出', 'report/rebate/detail/exportRecords.html', '返佣统计-导出', '505', '', NULL, 'mcenter', 'report:rebate_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61001', '收款账户-删除', 'payAccount/deleteAccount.html', '收款账户-删除', '610', NULL, NULL, 'mcenter', 'content:companyaccount_delete', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61101', '线上支付-编辑', 'payAccount/onLineEdit.html', '线上支付编辑', '611', NULL, NULL, 'mcenter', 'content:onlineaccount_edit', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61102', '公司入款-编辑', 'payAccount/companyEdit.html', '公司入款-编辑', '611', NULL, NULL, 'mcenter', 'content:payaccount_edit', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61103', '收款账户层级删除', 'vPayAccount/delpayrank.html', '收款账户层级删除', '611', '', NULL, 'mcenter', 'content:payaccount_delete', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61201', '域名管理-新增', 'content/sysDomain/create.html', '域名管理-新增', '612', NULL, NULL, 'mcenter', 'content:domain_add', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61202', '代理域名-新增', 'content/sysDomain/agentCreate.html', '代理域名-新增', '612', '', NULL, 'mcenter', 'content:domain_agentadd', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61203', '域名管理-默认编辑', 'content/sysDomain/mainManagerEdit.html', '域名管理-默认编辑', '612', '', NULL, 'mcenter', 'content:domain_defaultedit', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('61204', '域名管理-编辑', 'content/sysDomain/domainEdit.html', '域名管理-编辑', '612', '', NULL, 'mcenter', 'content:domain_edit', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('70501', '返水设置-改变状态', 'setting/rakebackSet/changeStatus.html', '系统设置-返水设置-改变状态', '705', NULL, NULL, 'mcenter', 'system:rakeback_changestatus', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('70801', '限制地区', 'siteConfineArea/list.html', '访问设置-限制地区', '708', '', '8', 'mcenter', 'system:confinearea_limitarea', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('70802', '限制访问站点IP', 'siteConfineIp/list.html', '访问设置-限制访问站点IP', '708', '', '8', 'mcenter', 'system:confinearea_limitsite', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('70803', '允许访问站点IP', 'siteConfineIp/list.html', '访问设置-允许访问站点IP', '708', '', '8', 'mcenter', 'system:confinearea_permitsite', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('70804', '允许访问管理中心IP', 'siteConfineIp/list.html', '访问设置-允许访问管理中心IP', '708', '', '8', 'mcenter', 'system:confinearea_permit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('250101', '新增', 'subAccount/create.html', '子账号-新增', '2501', '', NULL, 'mcenterTopAgent', 'system:subaccount_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('250102', '角色设置', 'subAccount/role.html', '子账号-角色设置', '2501', '', NULL, 'mcenterTopAgent', 'system:subaccount_role', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('250103', '编辑', 'subAccount/edit.html', '子账号-编辑', '2501', '', NULL, 'mcenterTopAgent', 'system:subaccount_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('350101', '新增', 'subAccount/create.html', '子账号-新增', '3501', '', NULL, 'mcenterAgent', 'system:subaccount_add', '2', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('350102', '角色设置', 'subAccount/role.html', '子账号-角色设置', '3501', '', NULL, 'mcenterAgent', 'system:subaccount_role', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('350103', '编辑', 'subAccount/edit.html', '子账号-编辑', '3501', '', NULL, 'mcenterAgent', 'system:subaccount_edit', '2', '', 't', 'f', 't');