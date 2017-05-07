-- auto gen by longer 2016-01-06 13:38:29

update sys_user set default_timezone = regexp_replace(default_timezone, '(GMT[-+])(\d)$','\10\2:00');
update sys_user set default_timezone = regexp_replace(default_timezone, 'UTC','GMT');