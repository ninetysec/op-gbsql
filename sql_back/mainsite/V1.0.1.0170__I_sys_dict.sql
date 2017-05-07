-- auto gen by cheery 2015-12-23 16:24:32
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'maintenance_charges', '1', '维护费', NULL, 't'
where 'maintenance_charges' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'ensure_consume', '2', '保底消费', NULL, 't'
where 'ensure_consume' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'return_profit', '3', '返还盈利', NULL, 't'
where 'return_profit' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'reduction_maintenance_fee', '4', '减免维护费', NULL, 't'
where 'reduction_maintenance_fee' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'pending', '5', '上期未结', NULL, 't'
where 'pending' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'rakeback_offers', '6', '返水优惠', NULL, 't'
where 'rakeback_offers' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'offers_recommended', '7', '优惠及推荐', NULL, 't'
where 'offers_recommended' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'back_charges', '8', '返手续费', NULL, 't'
where 'back_charges' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'operation', 'project_code', 'rebate', '9', '佣金', NULL, 't'
 where 'rebate' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'project_code');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '84', '3', '国际电话区号:越南', NULL, 't'
where '84' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '852', '4', '国际电话区号:中国香港', NULL, 't'
where '852' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '60', '5', '国际电话区号:马来西亚', NULL, 't'
where '60' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '65', '6', '国际电话区号:新加坡', NULL, 't'
where '65' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '81', '7', '国际电话区号:日本', NULL, 't'
where '81' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '82', '8', '国际电话区号:韩国', NULL, 't'
where '82' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '853', '9', '国际电话区号:澳门', NULL, 't'
where '853' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '63', '10', '国际电话区号:菲律宾', NULL, 't'
where '63' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '855', '11', '国际电话区号:柬埔寨', NULL, 't'
where '855' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '66', '12', '国际电话区号:泰国', NULL, 't'
where '66' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '91', '13', '国际电话区号:印度', NULL, 't'
where '91' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'phone_code', '62', '14', '国际电话区号:印度尼西亚', NULL, 't'
where '62' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'phone_code');



