-- auto gen by george 2018-01-11 10:13:16
UPDATE sys_param SET operate='0' WHERE param_code='is_lottery_site' AND param_type='system_settings' AND module='setting';
UPDATE sys_param SET operate='0' WHERE param_code='is_cash' AND param_type='withdraw_type' AND module='setting';
UPDATE sys_param SET operate='0' WHERE param_code='is_bitcoin' AND param_type='withdraw_type' AND module='setting';
UPDATE sys_param SET operate='0' WHERE param_code='auto_pay' AND param_type='api_setting' AND module='setting';
UPDATE sys_param SET operate='0' WHERE param_code='export_players' AND param_type='export' AND module='setting';