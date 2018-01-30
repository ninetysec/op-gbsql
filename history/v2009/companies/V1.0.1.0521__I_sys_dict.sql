-- auto gen by george 2018-01-16 20:27:38

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select  'common', 'domain_check_result_status', 'WALLED_OFF', '1', '被墙', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='WALLED_OFF');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'BE_HIJACKED', '2', '被劫持', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='BE_HIJACKED');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'UNRESOLVED', '3', '未解析', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='UNRESOLVED');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'SERVER_UNREACHABLE', '4', '服务器不通', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='SERVER_UNREACHABLE');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'UNKNOWN_ERR', '5', '未知错误', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='UNKNOWN_ERR');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'NORMAL', '5', '正常', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='NORMAL');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'UNAUTHORIZED', '6', '域名未授权', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='UNAUTHORIZED');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'domain_check_result_status', 'REDIRECT', '7', '被跳转', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='domain_check_result_status' and dict_code='REDIRECT');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'isp', 'CMCC', '1', '移动', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='isp' and dict_code='CMCC');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'isp', 'CUCC', '2', '联通', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='isp' and dict_code='CUCC');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'isp', 'CTCC', '3', '电信', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='isp' and dict_code='CTCC');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select 'common', 'isp', 'BGP', '4', 'BGP', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='isp' and dict_code='BGP');
