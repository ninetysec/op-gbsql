-- auto gen by admin 2016-07-13 09:39:30
DELETE FROM notice_tmpl WHERE event_type LIKE '%SCHEDULE%';

UPDATE user_task_reminder SET task_url='/fund/deposit/company/list.html'  WHERE dict_code='recharge';