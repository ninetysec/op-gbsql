-- auto gen by cherry 2017-07-03 09:44:13
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '706', '彩票开奖日志', 'lotteryPayoutRecord/list.html', '彩票开奖日志', '7', NULL, '6', 'boss', 'lottery:payoutrecord', '1', NULL, 'f', 't', 't'
where 706 not in (SELECT id from sys_resource where id=706);