-- auto gen by jerry 2016-12-27 21:54:15


INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT  'analyze', 'analyze_player', 'static_time_end', '0', '0', NULL, '最近统计时间', '', 't', NULL
where 'static_time_end' not in(select param_code from sys_param where "module"='analyze' and param_type='analyze_player');
INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT  'analyze', 'analyze_player', 'deposit_count', '0', '0', NULL, '近30天存款次数大于或等于设定的值', '', 't', NULL
where 'deposit_count' not in(select param_code from sys_param where "module"='analyze' and param_type='analyze_player');
INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT  'analyze', 'analyze_player', 'deposit', '0', '0', NULL, '近30天存款金额大于或等于设定的值', NULL, 't', NULL
where 'deposit' not in(select param_code from sys_param where "module"='analyze' and param_type='analyze_player');
INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT  'analyze', 'analyze_player', 'effective', '0', '0', NULL, '近30天有效投注额大于或等于设定的值', '', 't', NULL
where 'effective' not in(select param_code from sys_param where "module"='analyze' and param_type='analyze_player');



