-- auto gen by loong 2015-10-29 11:46:48
-- jeff

-- 修改菜单
update  sys_resource set url = '/vsubAccount/list.html',name = '子账号' where "name" like '系统账号' and subsys_code = 'mcenterTopAgent' and url <> '/vsubAccount/list.html';
update  sys_resource set url = '/subAccount/list.html',name = '子账号' where "name" like '系统账号' and subsys_code = 'mcenterAgent' and url <> '/subAccount/list.html';
update  sys_resource set url = '/account/stationbill/list.html',name = '结算账单' where "name" = '结算账单' and subsys_code = 'mcenterTopAgent' and url <> '/account/stationbill/list.html';

-- 创建视图
DROP VIEW IF EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account  as
---是否包含重要角色
SELECT
	su.user_type,
	su. ID,
	su.username,
	su.status,
	su.create_time,
  su.real_name,
	array_to_json(array(SELECT name FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) roles,
	array_to_json(array(SELECT id FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) role_ids,
	(SELECT CASE WHEN count(1) > 0 then true else false end built_in FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) and built_in )built_in
FROM
	sys_user su
where su.user_type in ('21','221','231') and status in ('1','2');
COMMENT ON VIEW "v_sub_account" IS '子账户视图';

----
CREATE TABLE IF NOT EXISTS "sys_role_default_resource" (
	id serial4 NOT NULL,
	"role_id" int4 NOT NULL,
	"resource_id" int4 NOT NULL,
	CONSTRAINT "sys_role_default_resource_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "sys_role_default_resource" OWNER TO "postgres";

COMMENT ON TABLE "sys_role_default_resource" IS '默认角色-资源关联表--jeff';

COMMENT ON COLUMN "sys_role_default_resource"."id" IS '主键';

COMMENT ON COLUMN "sys_role_default_resource"."role_id" IS '角色id';

COMMENT ON COLUMN "sys_role_default_resource"."resource_id" IS '资源id';

----其他角色都置为非系统默认
WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT 'default_role_service', '1','mcenterAgent','t'   where 'default_role_service' not in (SELECT name from sys_role where subsys_code = 'mcenterAgent')
RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenterAgent')sr on TRUE where r.id NOTNULL
RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;


WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT 'default_role_redact', '1','mcenterAgent','t' where 'default_role_redact' not in (SELECT name from sys_role where subsys_code = 'mcenterAgent')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenterAgent')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;


WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT  'default_role_recharge', '1','mcenterAgent','t'  where 'default_role_recharge' not in (SELECT name from sys_role where subsys_code = 'mcenterAgent')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenterAgent')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;

-----------添加默认角色 - 总理
WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT 'default_role_service', '1','mcenterTopAgent','t'   where 'default_role_service' not in (SELECT name from sys_role where subsys_code = 'mcenterTopAgent')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenterTopAgent')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;


WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT 'default_role_redact', '1','mcenterTopAgent','t' where 'default_role_redact' not in (SELECT name from sys_role where subsys_code = 'mcenterTopAgent')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenterTopAgent')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;


WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT  'default_role_recharge', '1','mcenterTopAgent','t'  where 'default_role_recharge' not in (SELECT name from sys_role where subsys_code = 'mcenterTopAgent')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenterTopAgent')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;

