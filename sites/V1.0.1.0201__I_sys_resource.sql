-- auto gen by cherry 2016-07-15 10:23:59
delete from sys_resource;

INSERT INTO "sys_resource" VALUES ('1', '首页', 'home/homeIndex.html', '管理首页', null, null, '1', 'mcenter', 'mcenter:index', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2', '角色', null, '角色管理', null, null, '2', 'mcenter', 'mcenter:role', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3', '资金', null, '资金管理', null, null, '3', 'mcenter', 'mcenter:fund', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('4', '运营', null, '运营管理', null, null, '4', 'mcenter', 'mcenter:operate', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('5', '统计', null, '统计报表', null, null, '5', 'mcenter', 'mcenter:report', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('6', '内容', null, '内容管理', null, null, '6', 'mcenter', 'mcenter:content', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('7', '系统', null, '系统设置', null, null, '8', 'mcenter', 'mcenter:system', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('8', '经营', null, '经营分析', null, null, '7', 'mcenter', 'mcenter:manage', '1', '', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('21', '总代首页', 'topAgent/topAgentIndex.html', '总代管理-总代中心首页', null, '', '1', 'mcenterTopAgent', 'topagent:index', '1', 'icon-shouye', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('22', '代理管理', 'topAgentAgent/list.html', '总代管理-代理管理', null, '', '2', 'mcenterTopAgent', 'topagent:agent', '1', 'icon-dailiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('23', '报表记录', '', '', null, '', '3', 'mcenterTopAgent', 'topagent:report', '1', 'icon-log', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('24', '消息公告', 'topAgentGameAnnouncement/topAgentMessageList.html', '', null, '', '4', 'mcenterTopAgent', 'topagent:annoucement', '1', 'icon-xiaoxigonggao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('25', '账号管理', '', '', null, '', '5', 'mcenterTopAgent', 'topagent:account', '1', 'icon-wodezhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('31', '代理首页', 'agent/agentIndex.html', '代理中心首页', null, '', '1', 'mcenterAgent', 'agent:index', '1', 'icon-shouye', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('32', '玩家管理', 'agentPlayer/list.html', '代理中心-玩家管理', null, '', '2', 'mcenterAgent', 'agent:player', '1', 'icon-wanjiaguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('33', '报表记录', '', '报表记录', null, '', '3', 'mcenterAgent', 'agent:report', '1', 'icon-log', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('34', '消息公告', 'agentGameAnnouncement/agentMessageList.html', '消息公告', null, '', '4', 'mcenterAgent', 'agent:announcment', '1', 'icon-xiaoxigonggao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('35', '账号管理', '', '账号管理', null, '', '5', 'mcenterAgent', 'agent:account', '1', 'icon-wodezhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('40', '首页', '', '首页', null, null, '0', 'pcenter', '', '2', 'home', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('41', '钱包转账', 'fund/playerTransfer/transfers.html', '玩家中心-钱包转账', null, null, '1', 'pcenter', 'pcenter:transfers', '1', 'home', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('42', '存款专区', 'fund/playerRecharge/recharge.html', '玩家中心-存款专区', null, null, '2', 'pcenter', 'pcenter:deposit', '1', 'deposit', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('43', '取款专区', 'player/withdraw/withdrawList.html', '玩家中心-取款专区', null, null, '3', 'pcenter', 'pcenter:withdraw', '1', 'withdraw', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('44', '资金记录', 'fund/transaction/list.html', '玩家中心-资金记录', null, null, '4', 'pcenter', 'pcenter:fundrecord', '1', 'capital', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('45', '投注记录', 'vPlayerGameOrder/apiList.html?type=history', '玩家中心-投注记录', null, null, '5', 'pcenter', 'pcenter:betorder', '1', 'gamerecord', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('46', '优惠记录', 'preferential/list.html', '玩家中心-优惠记录', null, null, '6', 'pcenter', 'pcenter:preferential', '1', 'sale', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('47', '消息公告', 'operation/pAnnouncementMessage/gameNotice.html', '玩家中心-消息公告', null, null, '7', 'pcenter', 'pcenter:announcement', '1', 'info', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('48', '个人资料', 'personInfo/index.html', '玩家中心-个人资料', null, null, '8', 'pcenter', 'pcenter:account', '1', 'accout', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('49', '推荐好友', 'playerRecommendAward/recommend.html', '玩家中心-推荐好友', null, null, '9', 'pcenter', 'pcenter:recommend', '1', 'recommend', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('201', '在线玩家', 'vPlayerOnline/list.html', '在线玩家', '2', '', '5', 'mcenter', 'role:online', '1', 'icon-zaixianwanjia', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('202', '玩家管理', 'player/list.html', '玩家管理', '2', null, '1', 'mcenter', 'role:player', '1', 'icon-wanjiaguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('203', '层级设置', 'vPlayerRankStatistics/list.html', '层级设置', '2', null, '4', 'mcenter', 'role:rank', '1', 'icon-cengjishezhi', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('204', '代理管理', 'vUserAgentManage/list.html', '代理管理', '2', null, '2', 'mcenter', 'role:agent', '1', 'icon-dailiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('206', '总代管理', 'vUserTopAgentManage/list.html', '总代管理', '2', null, '3', 'mcenter', 'role:topagent', '1', 'icon-zongdaiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('207', '玩家咨询', 'operation/announcementMessage/advisoryList.html', '玩家咨询列表', '2', null, '7', 'mcenter', 'role:advisory', '1', 'icon-wanjiazixun', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('301', '公司入款审核', 'fund/deposit/company/list.html', '公司存款', '3', null, '1', 'mcenter', 'fund:companydeposit', '1', 'icon-gongsirukuanshenhe', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('302', '线上支付记录', 'fund/deposit/online/list.html', '线上存款', '3', null, '2', 'mcenter', 'fund:onlinedeposit', '1', 'icon-xianshangzhifujilu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('303', '玩家取款审核', 'fund/withdraw/withdrawList.html', '提现记录', '3', null, '3', 'mcenter', 'fund:playerwithdraw', '1', 'icon-wanjiaqukuanshenhe', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('304', '代理取款审核', 'fund/vAgentWithdrawOrder/agentList.html', '代理取款审核', '3', '', '4', 'mcenter', 'fund:agentwithdraw', '1', 'icon-dailiqukuanshenhe', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('305', '手动存取', 'fund/artificial/addChoose.html', '手动存取', '3', null, '5', 'mcenter', 'fund:artificial', '1', 'icon-shoudongcunti', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('306', '玩家检测', 'fund/playerDetect/userPlayView.html', '玩家检测', '2', null, '6', 'mcenter', 'fund:playerdetect', '1', 'icon-wanjiajiance', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('401', '活动管理', 'operation/activity/list.html', '活动管理', '4', null, '1', 'mcenter', 'operate:activity', '1', 'icon-huodongguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('402', '信息群发', 'operation/massInformation/chooseType.html', '信息群发', '6', '', '2', 'mcenter', 'operate:massinfo', '1', 'icon-xinxiqunfa', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('403', '消息公告', 'operation/announcementMessage/messageList.html', '消息公告', '7', null, '1', 'mcenter', 'operate:announcement', '1', 'icon-xiaoxigonggao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('404', '返佣结算', 'operation/rebate/list.html', '站长推广', '3', '', '6', 'mcenter', 'operate:rebate', '1', 'icon-fanyongjiesuan', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('405', '返水结算', 'operation/rakebackBill/list.html', '返水结算', '3', null, '7', 'mcenter', 'operate:rakeback', '1', 'icon-fanshuijiesuan', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('406', '结算账单', 'operation/stationbill/list.html', '结算管理', '3', '', '8', 'mcenter', 'operate:bill', '1', 'icon-jiesuanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('501', '经营报表', 'report/operate/operateIndex.html', '统计报表-经营报表', '5', null, '1', 'mcenter', 'report:operate', '1', 'icon-jingyingbaobiao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('502', '投注记录', 'report/gameTransaction/list.html', '运营报表', '5', null, '2', 'mcenter', 'report:betorder', '1', 'icon-jiaoyijilu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('503', '资金记录', 'report/fundsLog/list.html', '日志管理', '5', '', '3', 'mcenter', 'report:fundrecord', '1', 'icon-zijinjilu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('504', '返水统计', 'report/rakeback/rakebackIndex.html', '日志管理', '5', '', '4', 'mcenter', 'report:rakeback', '1', 'icon-fanshuitongji', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('505', '返佣统计', 'report/rebate/rebateIndex.html', '统计报表-佣金报表', '5', '', '5', 'mcenter', 'report:rebate', '1', 'icon-fanyongtongji', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('506', '日志查询', 'report/log/logList.html', '日志管理', '5', '', '6', 'mcenter', 'report:log', '1', 'icon-rizhichaxun', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('601', '文案管理', 'vCttDocument/list.html', '文案管理', '6', null, '6', 'mcenter', 'content:document', '1', 'icon-wenanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('602', 'LOGO管理', 'cttLogo/list.html', 'LOGO管理', '6', null, '7', 'mcenter', 'content:logo', '1', 'icon-logoguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('603', '资讯管理', 'test', '资讯管理', '6', null, '3', 'mcenter', 'content:', '1', 'icon-zixunguanli', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('604', '广告管理', 'content/vCttCarousel/list.html', '轮播广告', '6', null, '4', 'mcenter', 'content:carousel', '1', 'icon-lunboguanggao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('605', '浮动图管理', 'cttFloatPic/list.html', '浮动图管理', '6', null, '5', 'mcenter', 'content:floatpic', '1', 'icon-fudongtu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('606', '站点栏目', 'asd', '站点栏目', '6', null, '6', 'mcenter', 'content:', '1', 'icon-zhandianlanmu', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('607', '公告栏管理', 'cttAnnouncement/list.html', '公告管理', '6', null, '1', 'mcenter', 'content:announcement', '1', 'icon-gonggaolanguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('608', '游戏管理', 'vSiteApiType/list.html', '游戏管理', '6', null, '3', 'mcenter', 'content:game', '1', 'icon-youxiguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('609', '模板管理', 'test', '模板管理', '6', null, '9', 'mcenter', 'content:', '1', 'icon-mobanguanli', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('610', '公司入款账户', 'vPayAccount/list.html?search.type=1', '支付管理', '4', null, '2', 'mcenter', 'content:companyaccount', '1', 'icon-gongsirukuanzhanghu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('611', '线上支付账户', 'vPayAccount/list.html?search.type=2', '支付管理', '4', '', '3', 'mcenter', 'content:onlineaccount', '1', 'icon-xianshangzhifuzhanghu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('612', '域名管理', 'content/sysDomain/list.html', '域名管理', '7', null, '6', 'mcenter', 'content:domain', '1', 'icon-yumingguanli', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('613', '推广素材', 'cttMaterialText/list.html', '站长中心-内容-推广素材', '6', null, '8', 'mcenter', 'content:material', '1', 'icon-tuiguangsucai', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('614', '体育推荐', 'sportRecommendedSite/list.html', '体育推荐', '6', null, '9', 'mcenter', 'content:sportRecommended', '1', 'icon-tiyutuijian', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('701', '站点参数', 'param/basicSettingIndex.html', '站点参数', '7', null, '2', 'mcenter', 'system:basicsetting', '1', 'icon-zhandiancanshu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('702', '我的账号', 'myAccount/myAccount.html', '我的账号', '7', '', '10', 'mcenter', 'system:myaccount', '1', 'icon-wodezhanghao', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('703', '子账号', 'subAccount/list.html', '系统账号', '7', null, '5', 'mcenter', 'system:subaccount', '1', 'icon-xitongzhanghao', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('704', '返佣设置', 'rebateSet/list.html', '返佣设置', '4', null, '4', 'mcenter', 'system:rebate', '1', 'icon-fanyongshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('705', '返水设置', 'setting/vRakebackSet/list.html', '系统设置-返水设置', '4', null, '5', 'mcenter', 'system:rakeback', '1', 'icon-fanshuishezhi', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('706', '分摊设置', 'param/apportion.html', '分摊设置', '4', '', '6', 'mcenter', 'system:apportion', '1', 'icon-fentanshezhi', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('707', '推荐设置', 'param/getRecommended.html', '推荐设置', '4', '', '7', 'mcenter', 'system:recommended', '1', 'icon-tuijianshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('708', '访问设置', 'siteConfineArea/list.html', '访问设置', '7', null, '7', 'mcenter', 'system:confinearea', '1', 'icon-fangwenshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('709', '接口设置', 'vNoticeEmailRank/list.html', '接口设置', '7', null, '8', 'mcenter', 'system:interface', '1', 'icon-jiekoushezhi', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('710', '信息模板', 'noticeTmpl/tmpIndex.html', '信息模板', '7', null, '9', 'mcenter', 'system:noticetmpl', '1', 'icon-xinximoban', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('711', '联系人管理', 'vSiteContacts/list.html', '联系人管理', '7', null, '11', 'mcenter', 'system:contacts', '1', 'icon-lianxirenguanli', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('712', '导出任务列表', 'share/exports/exportHistoryList.html', '导出任务列表-by River', '7', null, '12', 'mcenter', 'system:export', '1', 'icon-fangwenshezhi', 't', 'f', 'f');

INSERT INTO "sys_resource" VALUES ('713', '注册设置', 'param/getFieldSort.html', '注册设置', '7', null, '3', 'mcenter', 'system:register', '1', 'icon-zhuceshezhi', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('714', '客服参数', 'siteCustomerService/list.html', '客服参数', '7', null, '4', 'mcenter', 'system:customer', '1', 'icon-kefucansu', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2201', '新增', 'agentEdit/create.html', '代理管理-新增代理', '22', '', null, 'mcenterTopAgent', 'topagent:agent_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2202', '编辑', 'agentEdit/edit.html', '代理管理-编辑', '22', '', null, 'mcenterTopAgent', 'topagent:agent_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2203', '审核', 'topAgentAgent/toCheck.html', '代理管理-审核', '22', '', null, 'mcenterTopAgent', 'topagent:agent_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2301', '占成统计', 'topagent/report/occupy/reportIndex.html', '统计报表-占成统计', '23', '', '1', 'mcenterTopAgent', 'report:occupy', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2302', '投注记录', 'report/gameTransaction/list.html?search.searchCondition=false', '', '23', '', '3', 'mcenterTopAgent', 'report:bet', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2303', '经营报表', 'report/operate/operateIndex.html', '统计报表-经营报表', '23', '', '2', 'mcenterTopAgent', 'report:operate', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2501', '子账号', 'subAccount/list.html', '', '25', '', '2', 'mcenterTopAgent', 'account:subaccount', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2502', '登录日志', 'topAgentAccount/myAccount.html', '我的账号', '25', '', '1', 'mcenterTopAgent', 'account:myaccount', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2503', '结算账单', 'account/stationbill/list.html', '', '25', '', '3', 'mcenterTopAgent', 'account:bill', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('2504', '推广素材', 'topCttMaterial/list.html', '', '25', '', '4', 'mcenterTopAgent', 'account:material', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3301', '投注记录', 'report/gameTransaction/list.html?search.searchCondition=false', '报表记录-交易记录', '33', '', '3', 'mcenterAgent', 'report:betorder', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3303', '经营报表', 'report/operate/operateIndex.html', '报表记录-经营报表', '33', '', '2', 'mcenterAgent', 'report:operate', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3304', '返佣统计', 'report/rebate/agentRebate.html', '报表记录-返佣统计', '33', '', '1', 'mcenterAgent', 'report:rebate', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3501', '子账号', 'subAccount/list.html', '账号管理-子账号', '35', '', '2', 'mcenterAgent', 'account:subaccount', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3502', '我的账号', 'agentAccount/myAccount.html', '账号管理-我的账号', '35', '', '1', 'mcenterAgent', 'account:myaccount', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3503', '推广素材', 'cttMaterial/list.html', '账号管理-推广素材', '35', '', '4', 'mcenterAgent', 'account:material', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('3504', '账户资金', 'vAgentFundRecord/list.html', '账号管理-账户资金', '35', '', '3', 'mcenterAgent', 'account:fund', '1', null, 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('4001', '首页顶部-新消息', 'operation/announcementMessage/messageList.html', '首页顶部-新消息', '40', null, null, 'mcenter', 'index:announcementMessage', '2', null, 'f', 'f', 't');

INSERT INTO "sys_resource" VALUES ('4301', '确认取款', 'player/withdraw/pleaseWithdraw.html', '确认取款', '43', null, '1', 'pcenter', 'fund:deposit_confirm', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('4801', '编辑玩家信息', 'personalInfo/edit.html', '编辑玩家信息', '48', null, '1', 'pcenter', 'account:edit', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20101', '强制踢出', 'player/view/offlineForced.html', '在线玩家-强制踢出', '201', null, null, 'mcenter', 'role:online_offline', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20201', '玩家管理-导出', 'player/exportRecords.html', '玩家管理-导出', '202', null, null, 'mcenter', 'role:player_export', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20202', '账号冻结', 'share/account/freezeAccount.html', '玩家管理-账号冻结', '202', null, null, 'mcenter', 'role:player_freezeaccout', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20203', '编辑', 'player/getVUserPlayer.html', '玩家管理-编辑', '202', '', null, 'mcenter', 'role:player_edit', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20204', '账号停用', 'share/account/disabledAccount.html', '玩家管理-账号停用', '202', null, null, 'mcenter', 'role:player_disabledaccount', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20205', '取消冻结账号', 'share/account/cancelAccountFreeze.html', '玩家管理-取消冻结账号', '202', null, null, 'mcenter', 'role:player_cancelfreezeaccount', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20206', '余额冻结', 'share/account/freezeBalance.html', '玩家管理-余额冻结', '202', null, null, 'mcenter', 'role:player_freezebalance', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20207', '取消冻结余额', 'share/account/toCancelBalanceFreeze.html', '玩家管理-取消冻结余额', '202', null, null, 'mcenter', 'role:player_cancelfreezebalance', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20208', '玩家详细资料', 'player/playerViewDetail.html', '玩家管理-玩家详细资料（显示隐藏字段）', '202', '', null, 'mcenter', 'role:player_detail', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20209', '修改玩家姓名', 'player/updateRealName.html', '玩家管理-修改玩家姓名', '202', '', null, 'mcenter', 'role:player_editusername', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20222', '玩家管理-清除联系方式', 'userPlayer/export.html', '玩家管理-清除联系方式', '202', null, null, 'mcenter', 'role:player_cleanup', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20301', '删除', 'playerRank/rank_delete.html', '层级设置-删除层级', '203', null, null, 'mcenter', 'role:rank_delete', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20302', '新增', 'playerRank/add.html', '层级设置-新增层级', '203', '', null, 'mcenter', 'role:rank_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('20401', '新增', 'userAgent/create.html', '代理管理-新增代理', '204', '', null, 'mcenter', 'role:agent_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('20402', '编辑', 'userAgent/edit.html', '代理管理-编辑代理', '204', '', null, 'mcenter', 'role:agent_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('20403', '审核', 'userAgent/toCheck.html', '代理管理-审核代理', '204', '', null, 'mcenter', 'role:agent_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('20404', '查看代理详情的联系方式', 'userAgent/agent/veiwDetail.html', '查看代理详情的联系方式', '204', '', '1', 'mcenter', 'role:agent_veiwdetail', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('20601', '新增', 'userAgent/editTopAgent.html', '总代管理-新增总代', '206', '', null, 'mcenter', 'role:topagent_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('20602', '编辑', 'userAgent/editTopAgent.html', '总代管理-编辑总代', '206', '', null, 'mcenter', 'role:topagent_edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('20603', '查看总代详情的联系方式', 'userAgent/topagent/veiwDetail.html', '查看总代详情的联系方式', '206', '', '1', 'mcenter', 'role:topagent_veiwdetail', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('30101', '审核', 'fund/companyDespoit/checkIndex.html', '公司入款审核-审核', '301', '', null, 'mcenter', 'fund:companydeposit_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('30201', '审核通过', 'fund/rechargeOnline/confirmCheck.html', '线上支付记录-审核通过', '302', '', null, 'mcenter', 'fund:onlinedeposit_checksuc', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('30202', '审核失败', 'fund/rechargeOnline/checkFailure.html', '线上支付记录-审核失败', '302', '', null, 'mcenter', 'fund:onlinedeposit_checkfai', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('30301', '审核', 'fund/withdraw/withdrawAuditView.html', '玩家取款审核-审核', '303', '', null, 'mcenter', 'fund:playerwithdraw_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('30401', '审核', 'fund/vAgentWithdrawOrder/agentAudit.html', '代理取款审核-审核', '304', '', null, 'mcenter', 'fund:agentwithdraw_check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('40101', '删除活动信息', 'operation/activity/deleteActivity.html', '活动管理-删除', '401', null, null, 'mcenter', 'operate:activity_delete', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('40102', '创建活动', 'operation/activityType/customList.html', '活动管理-创建活动', '401', '', null, 'mcenter', 'operate:activity_add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('40103', '优惠审核', 'operation/vActivityPlayerApply/activityPlayerApply.html', '活动管理-优惠审核', '401', '', null, 'mcenter', 'operate:activity_checkapply', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('40401', '结算', 'operation/rebate/clearing.html', '返佣结算-结算', '404', '', null, 'mcenter', 'operate:rebate_settle', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('40501', '结算', 'operation/rakebackBill/settlement.html', '返水结算-结算', '405', '', null, 'mcenter', 'operate:rakeback_settle', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('40601', '修改应付', 'operation/stationbill/toUpdateAmountPayable.html', '结算账单-修改应付', '406', '', null, 'mcenter', 'operate:bill_modify', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('50201', '投注记录导出', 'report/gameTransaction/exportRecords.html', '交易记录-导出', '502', '', null, 'mcenter', 'report:betorder_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('50301', '资金记录导出', 'report/fundsLog/exportRecords.html', '资金记录-导出', '503', '', null, 'mcenter', 'report:fundrecord_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('50401', '返水统计导出', 'report/rakeback/detail/exportRecords.html', '返水统计-导出', '504', '', null, 'mcenter', 'report:rakeback_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('50501', '返佣统计导出', 'report/rebate/detail/exportRecords.html', '返佣统计-导出', '505', '', null, 'mcenter', 'report:rebate_export', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('60801', 'API资金回收', 'vSiteGame/withdrawBalance.html', 'API资金回收', '608', '', '1', 'mcenter', 'content:game:withdrawBalance', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61001', '收款账户-删除', 'payAccount/deleteAccount.html', '收款账户-删除', '610', null, null, 'mcenter', 'content:companyaccount_delete', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61101', '线上支付-编辑', 'payAccount/onLineEdit.html', '线上支付编辑', '611', null, null, 'mcenter', 'content:onlineaccount_edit', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61102', '公司入款-编辑', 'payAccount/companyEdit.html', '公司入款-编辑', '611', null, null, 'mcenter', 'content:payaccount_edit', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61103', '收款账户层级删除', 'vPayAccount/delpayrank.html', '收款账户层级删除', '611', '', null, 'mcenter', 'content:payaccount_delete', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61201', '域名管理-新增', 'content/sysDomain/create.html', '域名管理-新增', '612', null, null, 'mcenter', 'content:domain_add', '2', null, 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61202', '代理域名-新增', 'content/sysDomain/agentCreate.html', '代理域名-新增', '612', '', null, 'mcenter', 'content:domain_agentadd', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61203', '域名管理-默认编辑', 'content/sysDomain/mainManagerEdit.html', '域名管理-默认编辑', '612', '', null, 'mcenter', 'content:domain_defaultedit', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('61204', '域名管理-编辑', 'content/sysDomain/domainEdit.html', '域名管理-编辑', '612', '', null, 'mcenter', 'content:domain_edit', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('70302', '权限查看', 'subAccount/role.html', '子账号-角色设置', '703', '', null, 'mcenter', 'system:subaccount_role', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('70501', '返水设置-改变状态', 'setting/rakebackSet/changeStatus.html', '系统设置-返水设置-改变状态', '705', null, null, 'mcenter', 'system:rakeback_changestatus', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" VALUES ('70801', '限制地区', 'siteConfineArea/list.html', '访问设置-限制地区', '708', '', '8', 'mcenter', 'system:confinearea_limitarea', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('70802', '限制访问站点IP', 'siteConfineIp/list.html', '访问设置-限制访问站点IP', '708', '', '8', 'mcenter', 'system:confinearea_limitsite', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('70803', '允许访问站点IP', 'siteConfineIp/list.html', '访问设置-允许访问站点IP', '708', '', '8', 'mcenter', 'system:confinearea_permitsite', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('70804', '允许访问管理中心IP', 'siteConfineIp/list.html', '访问设置-允许访问管理中心IP', '708', '', '8', 'mcenter', 'system:confinearea_permit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('250102', '权限查看', 'subAccount/role.html', '子账号-角色设置', '2501', '', null, 'mcenterTopAgent', 'system:subaccount_role', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" VALUES ('350102', '权限查看', 'subAccount/role.html', '子账号-角色设置', '3501', '', null, 'mcenterAgent', 'system:subaccount_role', '2', '', 't', 'f', 't');

