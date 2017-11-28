-- auto gen by cherry 2016-02-21 15:10:05
ALTER TABLE "user_task_reminder" ALTER COLUMN "param_value" TYPE varchar(500) COLLATE "default";

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '614', '体育推荐', 'sportRecommendedSite/list.html', '体育推荐', '6', NULL, '14', 'mcenter', 'content:', '1', 'icon-tiyutuijian', 't', 'f', 't'
WHERE '614' not in(SELECT id FROM sys_resource);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select  '4001', '首页顶部-新消息', 'operation/announcementMessage/messageList.html', '首页顶部-新消息', '40', NULL, NULL, 'mcenter', 'index:announcementMessage', '2', NULL, 'f', 'f', 't'
where '4001' not in (
        select id from sys_resource
);