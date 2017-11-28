-- auto gen by cherry 2017-07-18 21:10:42
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '70401', '手动开奖', 'lotteryResult/openLotteryResult.html', '手动开奖', '704', '', 1, 'boss', 'lottery:opencode_lottery', '2', '', 'f', 't', 't' where 70401 not in (SELECT id from sys_resource where id=70401);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '70402', '初始化开奖结果', 'lotteryResult/initLotteryResult.html', '初始化开奖结果', '704', '', 2, 'boss', 'lottery:opencode_init', '2', '', 'f', 't', 't' where 70402 not in (SELECT id from sys_resource where id=70402);