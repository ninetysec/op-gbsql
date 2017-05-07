-- auto gen by cherry 2017-04-21 20:50:08
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery_type', 'ssc', '1', '重庆时时彩', NULL, 't'
	WHERE 'ssc' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery_type', 'pk10', '2', '北京PK10', NULL, 't'
	WHERE 'pk10' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery_type', 'k3', '3', '江苏快3', NULL, 't'
	WHERE 'k3' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery_type', 'lhc', '4', '香港六合彩', NULL, 't'
	WHERE 'lhc' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery_type');



INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'cqssc', '1', '重庆时时彩', NULL, 't'
	WHERE 'cqssc' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'bjpk10', '2', '北京PK10', NULL, 't'
	WHERE 'bjpk10' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'jsk3', '3', '江苏快3', NULL, 't'
	WHERE 'jsk3' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'hklhc', '4', '香港六合彩', NULL, 't'
	WHERE 'hklhc' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='lottery');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '1', '1', '投注', NULL, 't'
	WHERE '1' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '2', '2', '派彩', NULL, 't'
	WHERE '2' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '3', '3', '存款', NULL, 't'
	WHERE '3' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'transaction_type', '4', '4', '取款', NULL, 't'
	WHERE '4' not in(SELECT dict_code FROM sys_dict WHERE module='lottery' and dict_type='transaction_type');


