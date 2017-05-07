-- auto gen by bruce 2016-10-10 20:56:50
UPDATE "user_task_reminder" SET "task_url"='/vPayAccount/list.html?search.type=2' WHERE "dict_code"='oneSituation' AND "parent_code"='pay';
UPDATE "user_task_reminder" SET "task_url"='/vPayAccount/list.html?search.type=2' WHERE "dict_code"='twoSituation' AND "parent_code"='pay';

update sys_param set param_value = true,default_value=true where param_type='visit' and param_code='visit.management.center';