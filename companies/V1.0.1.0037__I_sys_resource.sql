-- auto gen by cherry 2016-03-02 10:09:47
--重整sys_resource表

TRUNCATE TABLE sys_resource;



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('1', '首页', 'home/homeIndex.html', '首页', NULL, '', '2', 'ccenter', 'ccenter:index', '1', 'fa-server', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('2', '服务', '', '服务', NULL, '', '2', 'ccenter', 'ccenter:serve', '1', 'fa-server', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('3', '站点', '', '站点', NULL, NULL, '3', 'ccenter', 'ccenter:site', '1', 'fa-gamepad', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('4', '运营', '', '运营', NULL, NULL, '4', 'ccenter', 'ccenter:operate', '1', 'fa-credit-card', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('5', '报表', '', '报表', NULL, NULL, '5', 'ccenter', 'ccenter:report', '1', 'fa-pie-chart', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6', '系统', NULL, '系统', NULL, '', '6', 'ccenter', 'ccenter:system', '1', 'fa-cogs', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('101', '提醒事项', NULL, '', '1', '', '1', 'ccenter', 'index:view', '1', NULL, 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('102', '资金概况', '', '', '1', '', '2', 'ccenter', 'index:view', '1', '', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('103', '站点概况', '', '', '1', '', '3', 'ccenter', 'index:view', '1', '', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('104', 'API游戏', '', '', '1', '', '4', 'ccenter', 'index:view', '1', '', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('105', '权限日志', '', '', '1', '', '5', 'ccenter', 'index:view', '1', '', 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('201', '内容审核', 'vSiteContent/list.html', '内容审核', '2', NULL, '1', 'ccenter', 'serve:content', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('202', '模板管理', NULL, '模板管理', '2', NULL, '2', 'ccenter', 'serve:template', '1', NULL, 't', 'f', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('203', '系统公告', 'systemAnnouncement/systemNotice.html', '系统公告', '2', '', '3', 'ccenter', 'serve:announcement', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('301', '站长管理', 'vSiteMasterManage/list.html', '站长管理', '3', '', '1', 'ccenter', 'site:mastermanage', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('302', '站点管理', 'vSysSiteManage/list.html', '站点管理', '3', '', '2', 'ccenter', 'site:sitemanage', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('401', '结算账单', 'operation/stationbill/list.html', '结算账单', '4', '', '1', 'ccenter', 'operate:bill', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('402', '包网方案', 'vSiteContractScheme/list.html', '包网方案', '4', '', '1', 'ccenter', 'operate:contract', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('403', '消息公告', 'messageAnnouncement/systemMessage.html', '消息公告', '4', '', '1', 'ccenter', 'operate:announcement', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('501', '资金记录', 'report/fundsLog/fundsListPre.html', '资金记录', '5', '', '1', 'ccenter', 'report:fundrecord', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('502', '交易记录', 'report/gameTransaction/transacListPre.html', '交易记录', '5', '', '2', 'ccenter', 'report:betorder', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('503', '经营报表', 'report/operate/operateIndex.html', '运营中心-报表-经营报表', '5', '', '3', 'ccenter', 'report:operate', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('504', '返水统计', 'report/rakeback/rakebackIndex.html', '运营中心-报表-返水统计', '5', '', '4', 'ccenter', 'report:rakeback', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('505', '返佣统计', 'report/rebate/rebateIndex.html', '运营中心-报表-返佣统计', '5', '', '5', 'ccenter', 'report:rebate', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('506', '日志查询', 'report/log/logList.html', '运营中心-报表-日志管理', '5', '', '6', 'ccenter', 'report:log', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('601', '平台参数', 'ccenterParam/basicSettingIndex.html', '平台参数', '6', NULL, '1', 'ccenter', 'system:basic', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('602', '子账号', 'subAccount/list.html', '子账号', '6', '', '2', 'ccenter', 'system:subaccount', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('603', '我的账号', 'sys/account/index.html', '我的账号', '6', '', '3', 'ccenter', 'system:myaccount', '1', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('604', '联系人管理', 'ccenter/vSiteContacts/list.html', '联系人管理', '6', NULL, '4', 'ccenter', 'system:contact', '1', NULL, 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('20101', '审核', 'siteContent/toAuditLogo.html', '内容审核-审核', '201', '', NULL, 'ccenter', 'serve:content:check', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30101', '新增站长', 'vSiteMasterManage/create.html', '站长管理-新增站长', '301', '', NULL, 'ccenter', 'site:mastermanage:addmaster', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30102', '新增站点', 'vSysSiteManage/siteBasic.html', '站长管理-新增站点', '301', '', NULL, 'ccenter', 'site:mastermanage:addsite', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30103', '详细资料', 'vSiteMasterManage/viewMoreDetail.html', '站长管理-详细资料', '301', '', NULL, 'ccenter', 'site:mastermanage:detail', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30104', '账号冻结', 'vMasterManage/freezeAccount.html', '站长管理-账号冻结', '301', '', NULL, 'ccenter', 'site:mastermanage:freezeaccount', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30105', '取消账号冻结', 'vMasterManage/cancelAccountFreeze.html', '站长管理-取消账号冻结', '301', '', NULL, 'ccenter', 'site:mastermanage:cancelfreeze', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30106', '账号停用', 'vMasterManage/disabledAccount.html', '站长管理-账号停用', '301', '', NULL, 'ccenter', 'site:mastermanage:disabled', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30107', '重置密码', 'vMasterManage/resetPwdByHand.html', '站长管理-重置密码', '301', NULL, NULL, 'ccenter', 'site:mastermanage:resetPwdByHand', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30201', '站点维护', 'sysSite/siteMaintain.html', '站点管理-站点维护', '302', '', NULL, 'ccenter', 'site:sitemanage:mintain', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30202', '更换方案', 'sysSite/changeContractScheme.html', '站点管理-更换方案', '302', '', NULL, 'ccenter', 'site:sitemanage:changescheme', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30203', '玩家导入开关', 'site/detail/operateImportPlayers.html', '站点管理-玩家导入开关', '302', '', NULL, 'ccenter', 'site:sitemanage:import', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30204', '站点联系方式', 'site/detail/viewMoreSiteContacts.html', '站点管理-站点联系方式', '302', '', NULL, 'ccenter', 'site:sitemanage:contact', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('30205', '站点停用', 'sysSite/siteStop.html', '站点管理-站点停用', '302', '', NULL, 'ccenter', 'site:sitemanage:stop', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50101', '资金记录导出', 'report/fundsLog/exportRecords.html', '资金记录-导出', '501', '', NULL, 'ccenter', 'report:fundrecord:import', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50201', '交易记录导出', 'report/gameTransaction/exportRecords.html', '交易记录-导出', '502', '', NULL, 'ccenter', 'report:betorder:import', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('50301', '经营报表导出', 'report/operate/exportRecords.html', '经营报表-导出', '503', '', NULL, 'ccenter', 'report:operate:import', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60101', '基础设置', 'ccenterParam/basicSettingIndex.html', '平台参数-基础设置', '601', '', NULL, 'ccenter', 'system:basic:setting', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60102', '客服参数', 'ccenter/siteCustomerService/list.html', '平台参数-客服参数', '601', '', NULL, 'ccenter', 'system:basic:customer', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60103', '域名管理', 'sysDomainOperator/operatorList.html', '平台参数-域名管理', '601', '', NULL, 'ccenter', 'system:basic:domain', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60104', '访问限制', 'siteConfineIp/list.html', '平台参数-访问限制', '601', '', NULL, 'ccenter', 'system:basic:confine', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60105', '偏好设置', 'setting/ccenterPreference/index.html', '平台参数-偏好设置', '601', '', NULL, 'ccenter', 'system:basic:preference', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60201', '新增', 'subAccount/create.html', '子账号-新增', '602', '', NULL, 'ccenter', 'system:subaccount:add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60202', '角色设置', 'subAccount/role.html', '子账号-角色设置', '602', '', NULL, 'ccenter', 'system:subaccount:role', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60203', '编辑', 'subAccount/edit.html', '子账号-编辑', '602', '', NULL, 'ccenter', 'system:subaccount:edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('60401', '新增', 'ccenter/vSiteContacts/create.html', '联系人管理-新增', '604', '', NULL, 'ccenter', 'system:contact:add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6010301', '新增', 'sysDomainOperator/create.html', '域名管理-新增', '60103', '', NULL, 'ccenter', 'system:basic:domain:add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6010302', '删除', 'sysDomainOperator/delDomain.html', '域名管理-删除', '60103', '', NULL, 'ccenter', 'system:basic:domain:del', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6010303', '解绑', 'sysDomainOperator/changeResolveStatus.html', '域名管理-解绑', '60103', '', NULL, 'ccenter', 'system:basic:domain:unbunding', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6010401', '新增', 'siteConfineIp/create.html', '访问限制-新增', '60104', '', NULL, 'ccenter', 'system:basic:confine:add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") VALUES ('6010402', '设置', 'siteConfineIp/getSettingParam.html', '访问限制-设置', '60104', '', NULL, 'ccenter', 'system:basic:confine:set', '2', '', 't', 'f', 't');