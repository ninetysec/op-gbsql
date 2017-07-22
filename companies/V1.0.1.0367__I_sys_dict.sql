-- auto gen by cherry 2017-07-21 19:16:38
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'rebate_status', '4', '5', '挂账', NULL, 't' where NOT EXISTS (select dict_code from sys_dict where module='fund' and dict_type='rebate_status' and dict_code='4');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'backwater', '10', '返水', NULL, 't'
where 'backwater' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'favorable', '11', '优惠', NULL, 't'
where 'favorable' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'refund_fee', '12', '返手续费', NULL, 't'
where 'refund_fee' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'recommend', '13', '推荐', NULL, 't'
where 'recommend' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'poundage', '14', '行政费用', NULL, 't'
where 'poundage' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');
