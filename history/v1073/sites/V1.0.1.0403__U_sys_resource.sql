-- auto gen by bruce 2017-03-13 09:31:37
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active")
			 select 'setting', 'rebateSetting', 'settlement.deposit.fee', NULL, 1, '4', '返佣设置-存款手续费比例', NULL, 't'
			 where 'settlement.deposit.fee' not in (select param_code from sys_param where "module"='setting' and param_type='rebateSetting');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active")
			 select 'setting', 'rebateSetting', 'settlement.withdraw.fee', NULL, 1, '5', '返佣设置-取款手续费比例', NULL, 't'
			where 'settlement.withdraw.fee' not in (select param_code from sys_param where "module"='setting' and param_type='rebateSetting');

UPDATE "sys_resource" SET "url"='fund/rebate/list.html', "remark"='返佣结算' WHERE "id"='404';