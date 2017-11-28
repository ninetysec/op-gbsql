-- auto gen by cherry 2017-07-27 16:37:23
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '70403', '未开奖查询', 'lotteryResult/queryAllLotteryResultNotOpen.html', '未开奖查询', '704', '', '3', 'boss', 'lottery:notopen', '2', '', 'f', 't', 't'
where 70403 not in(SELECT id from sys_resource where id=70403);