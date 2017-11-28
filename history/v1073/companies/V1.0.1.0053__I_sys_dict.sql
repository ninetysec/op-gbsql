-- auto gen by cherry 2016-03-15 18:36:01
INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'CHANGE_PLAYER_DATA', NULL, '手动修改玩家资料', NULL, 't'
where 'CHANGE_PLAYER_DATA' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');