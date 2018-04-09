-- auto gen by linsen 2018-03-12 23:07:18

--增加风控标识的字典信息
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select  'player', 'risk_data_type', 'INTEREST_ARBITRAGE', '1', '套利玩家', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type='risk_data_type' and dict_code='INTEREST_ARBITRAGE');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select  'player', 'risk_data_type', 'MONEY_LAUNDERING', '1', '洗水玩家', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type='risk_data_type' and dict_code='MONEY_LAUNDERING');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select  'player', 'risk_data_type', 'MALICIOUS', '1', '恶意玩家', '', 't'
where not EXISTS (SELECT id FROM sys_dict where module='player' and dict_type='risk_data_type' and dict_code='MALICIOUS');