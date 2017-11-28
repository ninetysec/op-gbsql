-- auto gen by cherry 2016-03-02 10:42:48
--重整sys_resource表

TRUNCATE TABLE sys_resource;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('1', '首页', '', '', NULL, '', '1', 'boss', 'boss:index', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('2', '服务', '', '服务', NULL, '', '2', 'boss', 'boss:serve', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('3', '平台', '', '', NULL, '', '3', 'boss', 'boss:platform', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('4', '报表', '', '', NULL, '', '4', 'boss', 'boss:report', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('5', '运维', '', '', NULL, '', '5', 'boss', 'boss:maintenance', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('6', '系统', '', '', NULL, '', '6', 'boss', 'boss:system', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('201', '域名审核', 'sysDomainCheck/list.html?search.checkStatus=pending', '域名审核', '2', '', '1', 'boss', 'serve:domain', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('202', '模板管理', '', '模板管理', '2', '', '2', 'boss', 'serve:', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('203', '发布公告', 'vSystemAnnouncement/systemNotice.html', '发布公告', '2', '', '3', 'boss', 'serve:announcement', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('204', 'API管理', 'vApi/list.html', 'API管理', '2', '', '4', 'boss', 'serve:apimanage', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('205', '支付接口', 'payApi/list.html', '支付接口', '2', '', '5', 'boss', 'serve:payapi', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('206', '体育推荐', 'vSportRecommended/list.html', '体育推荐', '2', '', '6', 'boss', 'serve:sportrecommended', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('207', '新手引导', 'vHelpDocument/list.html', '新手引导', '2', NULL, '7', 'boss', 'serve:helpdocument', '1', NULL, 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('301', '运营商管理', 'platform/operatorsManage/list.html', '', '3', '', '1', 'boss', 'platform:operatemanage', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('302', '平台管理', 'vPlatformManage/list.html', '总控-平台-平台管理', '3', '', '2', 'boss', 'platform:platformmanage', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('303', '包网方案', 'vContractScheme/list.html', '总控-平台-包网方案', '3', '', '3', 'boss', 'platform:contractscheme', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('304', '模板管理', '', '', '3', '', '4', 'boss', 'platform:', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('401', '统计报表', 'report/statistical/index/boss.html', '总控运营商报表', '4', '', '1', 'boss', 'report:statistical', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('402', '运营报表', 'report/operate/operateIndex.html', '统计报表-经营报表', '4', '', '2', 'boss', 'report:operate', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('403', '交易记录', 'report/gameTransaction/transacListPre.html', '', '4', '', '3', 'boss', 'report:betorder', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('404', '资金记录', 'report/fundsLog/fundsListPre.html', '', '4', '', '4', 'boss', 'report:fundrecord', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('405', '返水统计', 'report/rakeback/rakebackIndex.html', '统计报表-返水统计', '4', '', '5', 'boss', 'report:rakeback', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('406', '返佣统计', 'report/rebate/rebateIndex.html', '统计报表-返水统计', '4', '', '6', 'boss', 'report:rebate', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('407', '日志查询', 'report/log/logList.html', '统计报表-日志查询', '4', '', '7', 'boss', 'report:log', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('501', '任务调度', 'taskSchedule/list.html', '', '5', '', '1', 'boss', 'maintenance:taskschedule', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('502', 'MQ异常消息', 'mqExceptionMsg/list.html', '', '5', '', '2', 'boss', 'maintenance:exception', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('503', '规则文件', 'sysRuleFile/fromView.html', NULL, '5', NULL, '3', 'boss', 'maintenance:rulefile', '1', NULL, 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('504', '审计日志', 'sysAuditLog/fromMongo.html', '', '5', '', '4', 'boss', 'maintenance:log', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('505', '服务器管理', 'svrServers/list.html', '', '5', '', '5', 'boss', 'maintenance:servers', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('506', '意见反馈', 'systemFeedback/list.html', '意见反馈', '5', NULL, '6', 'boss', 'maintenance:feedback', '1', NULL, 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('507', '组件监控', 'Monitor/list.html', '组件监控', '5', '', '7', 'boss', 'maintenance:monitor', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('601', '系统参数', '', '', '6', '', '2', 'boss', 'system:', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('602', '子账号', 'subAccount/list.html', '', '6', '', '3', 'boss', 'system:subaccount', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('603', '我的账号', 'sys/account/index.html', '', '6', '', '4', 'boss', 'system:myaccount', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('604', '偏好设置', '', '', '6', '', '5', 'boss', 'system:', '1', '', 'f', 't', 'f');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('605', '客服参数', 'boss/siteCustomerService/list.html', '', '6', '', '6', 'boss', 'system:customerservice', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('606', '访问限制', 'siteConfineIp/list.html', '', '6', '', '7', 'boss', 'system:confine', '1', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('607', '货币管理', 'setting/currency/curyList.html', '货币管理', '6', NULL, '1', 'boss', 'system:currency', '1', NULL, 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20101', '通过', 'sysDomainCheck/treatmentSuccess.html', '域名审核-通过', '201', '', NULL, 'boss', 'serve:domain:success', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20102', '失败', 'sysDomainCheck/failureMsg.html', '域名审核-失败', '201', '', NULL, 'boss', 'serve:domain:failure', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20401', '管理保存', 'api/saveManage.html', 'API管理-管理-保存', '204', '', NULL, 'boss', 'serve:apimanage:manage:save', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20501', '支付接口启用', 'payApi/changeUseStatus.html', '支付接口-启用', '205', NULL, NULL, 'boss', 'serve:payapi:use', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20601', '新增赛事', 'sportRecommended/create.html', '体育推荐-新增赛事', '206', '', NULL, 'boss', 'serve:sportrecommended:add', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20602', '球队管理', 'sport/team/list.html', '体育推荐-球队管理', '206', '', NULL, 'boss', 'serve:sportrecommended:team', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20603', '编辑', 'sportRecommended/edit.html', '体育推荐-编辑', '206', '', NULL, 'boss', 'serve:sportrecommended:edit', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20604', '删除', 'sportRecommended/delete.html', '体育推荐-删除', '206', '', NULL, 'boss', 'serve:sportrecommended:del', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20701', '新增问题', 'helpDocument/create.html', '新手引导-新增问题', '207', '', NULL, 'boss', 'serve:helpdocument:add', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20702', '分类管理', 'helpTypeI18n/showHelpTypeList.html', '新手引导-分类管理', '207', '', NULL, 'boss', 'serve:helpdocument:type', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20703', '编辑', 'helpDocument/edit.html', '新手引导-编辑', '207', '', NULL, 'boss', 'serve:helpdocument:edit', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('20704', '删除', 'helpDocument/deleteHelpDocument.html', '新手引导-删除', '207', '', NULL, 'boss', 'serve:helpdocument:del', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30101', '新增', 'platform/operatorsManage/create.html', '运营商管理-新增', '301', '', NULL, 'boss', 'platform:operatemanage:add', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30102', '运营商取消冻结', 'platform/operatorsManage/cancelFreeze.html', '运营商管理-取消冻结', '301', '', NULL, 'boss', 'platform:operatemanage:cancelfre', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30103', '停用运营商', 'platform/operatorsManage/previewDisabled.html', '运营商管理-停用', '301', '', NULL, 'boss', 'platform:operatorsmanage:stop', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30104', '重置登录密码', 'platform/operatorsManage/resetPwd.html', '运营商管理-重置登录密码', '301', NULL, NULL, 'boss', 'platform:operatemanage:resetpwd', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30105', '重置安全密码', 'platform/operatorsManage/resetPermissionPwd.html', '运营商管理-重置安全密码', '301', '', NULL, 'boss', 'platform:operatemanage:resetPer', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30106', '查看运营商联系方式', 'platform/operatorsManage/viewContact.html', '运营商管理-查看联系方式', '301', NULL, NULL, 'boss', 'platform:operatemanage:contact', '2', NULL, 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30201', '查看联系人的联系方式', 'vPlatformManage/detail/viewMoreContract.html', '平台管理-查看联系方式', '302', '', NULL, 'boss', 'platform:platformmanage:mcontact', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30202', '平台停用', 'vPlatformManage/siteStop.html', '平台管理-平台停用', '302', '', NULL, 'boss', 'platform:platformmanage:stopplat', '2', '', 't', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30203', '平台维护', 'vPlatformManage/siteMaintain.html', '平台管理-平台维护', '302', '', NULL, 'boss', 'platform:platformmanage:maintain', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30301', '新增', 'vContractScheme/create.html', '包网方案-新增', '303', '', NULL, 'boss', 'platform:contractscheme:add', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30302', '编辑', 'vContractScheme/editContract.html', '包网方案-编辑', '303', '', NULL, 'boss', 'platform:contractscheme:edit', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('30303', '删除', 'vContractScheme/delete.html', '包网方案-删除', '303', '', NULL, 'boss', 'platform:contractscheme:del', '2', '', 'f', 't', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60201', '新增', 'subAccount/create.html', '子账号-新增', '602', '', NULL, 'boss', 'system:subaccount:add', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60202', '角色设置', 'subAccount/role.html', '子账号-角色设置', '602', '', NULL, 'boss', 'system:subaccount:role', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60203', '编辑', 'subAccount/edit.html', '子账号-编辑', '602', '', NULL, 'boss', 'system:subaccount:edit', '2', '', 't', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60501', '新增', 'boss/siteCustomerService/create.html', '客服参数-新增', '605', '', NULL, 'boss', 'system:customerservice:add', '2', '', 'f', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60601', '新增', 'siteConfineIp/create.html', '访问限制-新增', '606', '', NULL, 'boss', 'system:confine:add', '2', '', 'f', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60602', '设置', 'siteConfineIp/getSettingParam.html', '访问限制-设置', '606', '', NULL, 'boss', 'system:confine:set', '2', '', 'f', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60603', '编辑', 'siteConfineIp/edit.html', '访问限制-编辑', '606', '', NULL, 'boss', 'system:confine:edit', '2', '', 'f', 'f', 't');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") VALUES ('60701', '设置汇率', 'setting/currency/updateRate.html', '货币管理-设置汇率', '607', '', NULL, 'boss', 'system:currency:rate', '2', '', 't', 'f', 't');