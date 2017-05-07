-- auto gen by cherry 2016-07-26 21:47:39

INSERT INTO  "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '51', 'allscore_wx', NULL, 'CN', '3', '商银信-微信支付', NULL, '商银信', 't',NULL, '2', NULL
WHERE NOT EXISTS (SELECT bank_name  FROM bank where bank_name='allscore_wx');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'allscore_wx', '51', '商银信-微信支付', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='allscore_wx');

INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain")
SELECT '12', 'normal', '12', NULL, NULL, '12', ''
WHERE not EXISTS (SELECT id from api where id=12);

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '12', '0', now(), '0', now(), 'f'
where not EXISTS(SELECT id from api_order_log where api_id=12 and type='0');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT  '12', '0', now(), '1', now(), 'f'
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=12 and type='1');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '12', '0', now(), '2', now(), 'f'
WHERE not EXISTS(SELECT id from api_order_log where api_id=12 and type='2');