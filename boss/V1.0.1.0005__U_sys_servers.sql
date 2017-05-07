-- auto gen by tony 2016-02-15 12:04:10
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select 507, '组件监控', 'Monitor/list.html', '组件监控', '5', '', '7', 'boss', 'test:view', '1', '', 'f', 'f', 't' where not exists(SELECT id FROM sys_resource WHERE id=507); ;


UPDATE "svr_servers" SET "id"='1', "name"='任务调度', "status"='', "description"='', "ip"='127.0.0.1', "port"='7080', "group_id"='10', "type_id"='3', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/schedule', "war_name"='schedule       ', "subsys_code"='schedule' WHERE ("id"='1');
UPDATE "svr_servers" SET "id"='2', "name"='服务层', "status"='', "description"='', "ip"='127.0.0.1', "port"='7080', "group_id"='20', "type_id"='1', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/service', "war_name"='service', "subsys_code"='service' WHERE ("id"='2');
UPDATE "svr_servers" SET "id"='3', "name"='消息推送中心', "status"='', "description"='', "ip"='127.0.0.1', "port"='7080', "group_id"='30', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/mdcenter', "war_name"='mdcenter', "subsys_code"='mdcenter' WHERE ("id"='3');
UPDATE "svr_servers" SET "id"='4', "name"='监控', "status"='', "description"='', "ip"='127.0.0.1', "port"='7080', "group_id"='10', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/monitor', "war_name"='monitor', "subsys_code"='monitor' WHERE ("id"='4');
UPDATE "svr_servers" SET "id"='5', "name"='总控', "status"='', "description"='', "ip"='127.0.0.1', "port"='8080', "group_id"='20', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/boss', "war_name"='boss', "subsys_code"='boss' WHERE ("id"='5');
UPDATE "svr_servers" SET "id"='6', "name"='运营商中心', "status"='', "description"='', "ip"='127.0.0.1', "port"='8080', "group_id"='30', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/ccenter', "war_name"='ccnter', "subsys_code"='ccenter' WHERE ("id"='6');
UPDATE "svr_servers" SET "id"='7', "name"='站长中心', "status"='', "description"='', "ip"='127.0.0.1', "port"='8080', "group_id"='30', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/mcenter', "war_name"='mcenter', "subsys_code"='mcenter' WHERE ("id"='7');
UPDATE "svr_servers" SET "id"='8', "name"='总代中心', "status"='', "description"='', "ip"='127.0.0.1', "port"='8080', "group_id"='10', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/tcenter', "war_name"='tcenter', "subsys_code"='tcenter' WHERE ("id"='8');
UPDATE "svr_servers" SET "id"='9', "name"='代理中心', "status"='', "description"='', "ip"='127.0.0.1', "port"='8080', "group_id"='20', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='/acenter', "war_name"='acenter', "subsys_code"='acenter' WHERE ("id"='9');
UPDATE "svr_servers" SET "id"='10', "name"='站长站', "status"='', "description"='', "ip"='127.0.0.1', "port"='8080', "group_id"='30', "type_id"='2', "sort"='1', "last_active"=NULL, "register_time"=NULL, "context_path"='', "war_name"='msites', "subsys_code"='msites' WHERE ("id"='10');


INSERT INTO "svr_servers" ("id", "name", "status", "description", "ip", "port", "group_id", "type_id", "sort", "last_active", "register_time", "context_path", "war_name", "subsys_code")
select '11', '玩家中心', '', '', '127.0.0.1', '7080', '30', '2', '1', NULL, NULL, '/pcenter', 'pcenter', 'pcenter'  where not exists(SELECT id FROM svr_servers WHERE id=11); ;
