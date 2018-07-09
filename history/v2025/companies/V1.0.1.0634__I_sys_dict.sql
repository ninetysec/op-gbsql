-- auto gen by steffan 2018-06-20 20:21:06
INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '43','43', '线上支付账号修改', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='43');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '44','44', '新增模拟账号', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='44');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '45','45', '新增玩家账号', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='45');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '46','46', '新增代理', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='46');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '47','47', '新增总代', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='47');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '48','48', '总代详情修改', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='48');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '49','49', '发布活动', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='49');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '50','50', '公告轮播时间修改', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='50');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '51','51', '删除公告栏公告', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='51');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '52','52', '浮动图启停', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='52');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '53','53', '导出玩家', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='53');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '54','54', '总代占成修改', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='54');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '55','55', '公司入款账户启停', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='55');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '56','56', '额度充值', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='56');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '57','57', '上传支付凭证', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='57');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '58','58', '清除玩家联系方式', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='58');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '59','59', '资金审核通过', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='59');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '60','60', '资金审核失败', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='60');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '61','61', '资金审核拒绝', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='61');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '62','62', '返佣结算清除', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='62');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '63','63', '返佣结算挂账', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='63');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '64','64', '修改风控标签', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='64');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '65','65', '修改手机端背景颜色', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='65');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '66','66', '修改CDN开关和CDN地址', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='66');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '67','67', '修改买分额度上限', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='67');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '68','68', '修改层级存款设置', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='68');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '69','69', '修改层级取款设置', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='69');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '70','70', '删除浮动图', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='70');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '71','71', '同步余额', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='71');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '72','72', '限额修改', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='72');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '73','73', '回收资金', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='73');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '74','74', '修改稽核', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='74');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '74','74', '修改稽核', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='74');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '75','75', '修改导出玩家联系方式设置', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='75');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '76','76', '修改玩家实付返水', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='76');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '77','77', '设置安全密码', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='77');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '78','78', '设置手机号码', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='78');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '79','79', '设置安全问题', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='79');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '80','80', '设置真实姓名', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='80');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '81','81', '修改手机号码', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='81');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 select'log', 'log_type', '82','82', '修改安全问题', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict where module='log' and dict_type = 'log_type' and  dict_code='82');
