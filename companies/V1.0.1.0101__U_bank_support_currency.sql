-- auto gen by admin 2016-05-25 19:19:48
update bank_support_currency set currency_code='CNY' where bank_code='other';

update help_type_i18n set "name"='极速存款' where help_type_id=10;

INSERT INTO "user_task_reminder" ( "dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")

SELECT 'addLogo', NULL, '0', '/vSiteContent/list.html', 'examine', 'LOGO审核', NULL, NULL

WHERE 'addLogo' NOT IN (SELECT dict_code FROM user_task_reminder WHERE dict_code='addLogo');



INSERT INTO "user_task_reminder" ( "dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")

SELECT 'activity', NULL, '0', '/vSiteContent/list.html', 'examine', '优惠活动审核', NULL, NULL

WHERE 'activity' NOT IN (SELECT dict_code FROM user_task_reminder WHERE dict_code='activity');



INSERT INTO "user_task_reminder" ( "dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")

SELECT 'copywriter', NULL, '0', '/vSiteContent/list.html', 'examine', '文案审核', NULL, NULL

WHERE 'copywriter' NOT IN (SELECT dict_code FROM user_task_reminder WHERE dict_code='copywriter');