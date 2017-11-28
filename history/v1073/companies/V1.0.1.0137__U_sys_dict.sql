-- auto gen by cherry 2016-07-28 20:57:41
DELETE FROM sys_dict WHERE "module"='fund' and dict_type='recharge_type' and parent_code='artificial_deposit';

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'manual_deposit', '8', '人工存入:人工存取', 'artificial_deposit', 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='fund' and dict_type='recharge_type' and parent_code='manual_deposit');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'manual_favorable', '9', '手工存入:优惠活动', 'artificial_deposit', 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='fund' and dict_type='recharge_type' and parent_code='manual_favorable');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'manual_rakeback', '10', '手工存入:返水', 'artificial_deposit', 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='fund' and dict_type='recharge_type' and parent_code='manual_rakeback');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'manual_payout', '11', '手工存入:派彩', 'artificial_deposit', 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='fund' and dict_type='recharge_type' and parent_code='manual_payout');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'manual_other', '12', '手工存入:其他', 'artificial_deposit', 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='fund' and dict_type='recharge_type' and parent_code='manual_other');