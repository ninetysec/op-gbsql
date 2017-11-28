-- auto gen by cheery 2015-12-10 08:47:42
DROP TABLE IF EXISTS game_announcement;
DROP TABLE IF EXISTS game_announcement_i18n;
DROP VIEW IF EXISTS v_game_announcement;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
select '4503', '系统公告', 'operation/pAnnouncementMessage/systemNoticeHistory.html', '系统公告', '45', NULL, '2', 'pcenter', '', '1', NULL, 't', 'f'
where 4503 not in (select id from sys_resource where id=4503);

ALTER TABLE "activity_player_preferential"
ALTER COLUMN "preferential_audit" TYPE numeric(20,2);

UPDATE "sys_resource" SET "url"='report/gameTransaction/list.html' WHERE ("id"='502');
UPDATE "sys_resource" SET "url"='report/topagentGameTransaction/list.html?search.searchCondition=false' WHERE ("id"='2302');
UPDATE "sys_resource" SET "url"='report/agentGameTransaction/list.html?search.searchCondition=false' WHERE ("id"='3301');
UPDATE "sys_resource" SET "url"='report/fundsLog/list.html' WHERE ("id"='503');
--删除玩家中心未结算记录菜单
DELETE from sys_resource where "id"='4302';