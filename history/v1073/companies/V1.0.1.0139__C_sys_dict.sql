-- auto gen by cherry 2016-07-30 16:52:37
DELETE FROM sys_dict where "module"='fund' and dict_type='withdraw_type' and parent_code='191';

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'withdraw_type', 'manual_deposit', '5', '人工存取:人工存取', 'artificial', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict where module='fund' and dict_type='withdraw_type' and dict_code='manual_deposit');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'withdraw_type', 'manual_favorable', '6', '人工存取:优惠活动', 'artificial', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict where module='fund' and dict_type='withdraw_type' and dict_code='manual_favorable');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'withdraw_type', 'manual_rakeback', '7', '人工存取:返水', 'artificial', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict where module='fund' and dict_type='withdraw_type' and dict_code='manual_rakeback');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'withdraw_type', 'manual_payout', '8', '人工存取:派彩', 'artificial', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict where module='fund' and dict_type='withdraw_type' and dict_code='manual_payout');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'withdraw_type', 'manual_other', '9', '人工存取:其他', 'artificial', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict where module='fund' and dict_type='withdraw_type' and dict_code='manual_other');