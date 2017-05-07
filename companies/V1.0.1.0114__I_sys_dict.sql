-- auto gen by fei 2016-06-19 17:02:56
INSERT INTO sys_dict ("module", dict_type, dict_code, order_num, remark, parent_code, active)
SELECT 'operation', 'activity_apply_check_status', '4', 5, '玩家申请优惠状态：未达优惠条件', NULL, TRUE
WHERE '4' NOT IN (SELECT dict_code FROM sys_dict WHERE "module"='operation' AND dict_type='activity_apply_check_status');
