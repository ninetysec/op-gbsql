-- auto gen by bruce 2016-10-15 14:17:41
INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
  SELECT 'orange_online', now(), '0', '/vPayAccount/list.html?search.type=2', 'pay', '橙色预警-线上支付', NULL, 'warm'
  WHERE 'orange_online' not in (SELECT dict_code FROM user_task_reminder);
INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
  SELECT 'red_online', now(), '0', '/vPayAccount/list.html?search.type=2', 'pay', '红色预警-线上支付', NULL, 'warm'
  WHERE 'red_online' not in (SELECT dict_code FROM user_task_reminder);
INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
  SELECT 'freeze_online', now(), '0', '/vPayAccount/list.html?search.type=2&search.status=3', 'pay', '账户冻结-线上支付', NULL, 'warm'
  WHERE 'freeze_online' not in (SELECT dict_code FROM user_task_reminder);