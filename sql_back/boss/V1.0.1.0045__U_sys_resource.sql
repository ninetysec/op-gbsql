-- auto gen by cherry 2016-01-06 15:01:38
UPDATE sys_resource SET url = 'report/rakeback/rakebackIndex.html' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '返水统计' AND parent_id = 4 AND subsys_code = 'boss');

