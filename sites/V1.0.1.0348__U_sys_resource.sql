-- auto gen by cherry 2016-12-11 21:37:42
--修改统计-转账记录权限的值，原来的值与统计-资金记录一致
UPDATE sys_resource SET permission='report:fundTransfer' WHERE id=508;