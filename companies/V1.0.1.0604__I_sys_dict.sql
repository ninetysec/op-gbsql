-- auto gen by linsen 2018-04-26 20:48:19
-- 风控标示添加支付职业投诉 by linsen

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select  'player', 'risk_data_type', 'PAY_PROFESSIONAL_COMPLAINT', '4', '支付职业投诉', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type='risk_data_type' and dict_code='PAY_PROFESSIONAL_COMPLAINT');