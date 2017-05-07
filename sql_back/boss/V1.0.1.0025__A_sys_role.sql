-- auto gen by cheery 2015-12-10 08:14:19
update sys_resource set url = 'subAccount/list.html' where name = '系统账号' and url<> 'subAccount/list.html';
update sys_resource set url = 'sys/account/index.html' where name = '我的账号' and url<> 'sys/account/index.html';
--角色表去掉约束
ALTER TABLE "sys_role" ALTER COLUMN "code" DROP NOT NULL;

DELETE FROM sys_resource where parent_id = 602;

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

----

ALTER TABLE "sys_role" ALTER COLUMN "code" DROP NOT NULL;

----

WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT 'default_role_service', '1','boss','t'   where 'default_role_service' not in (SELECT name from sys_role where subsys_code = 'boss')
RETURNING id
)

INSERT INTO sys_role_default_resource (role_id,resource_id)
SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'boss')sr on TRUE where r.id NOTNULL;

WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT 'default_role_redact', '1','boss','t' where 'default_role_redact' not in (SELECT name from sys_role where subsys_code = 'boss')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'boss')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;


WITH rows AS (
	INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
	SELECT  'default_role_recharge', '1','boss','t'  where 'default_role_recharge' not in (SELECT name from sys_role where subsys_code = 'boss')
	RETURNING id
),role_row as(
	INSERT INTO sys_role_default_resource (role_id,resource_id)
	SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'boss')sr on TRUE where r.id NOTNULL
	RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;

DROP VIEW IF EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account as SELECT su.user_type,
    su.id,
    su.username,
    su.status,
    su.create_time,
    su.real_name,
    su.nickname,
    array_to_json(ARRAY( SELECT sys_role.name
           FROM sys_role
          WHERE (sys_role.id IN ( SELECT sys_user_role.role_id
                   FROM sys_user_role
                  WHERE (sys_user_role.user_id = su.id))))) AS roles,
    array_to_json(ARRAY( SELECT sys_role.id
           FROM sys_role
          WHERE (sys_role.id IN ( SELECT sys_user_role.role_id
                   FROM sys_user_role
                  WHERE (sys_user_role.user_id = su.id))))) AS role_ids,
    ( SELECT
                CASE
                    WHEN (count(1) > 0) THEN true
                    ELSE false
                END AS built_in
           FROM sys_role
          WHERE ((sys_role.id IN ( SELECT sys_user_role.role_id
                   FROM sys_user_role
                  WHERE (sys_user_role.user_id = su.id))) AND sys_role.built_in)) AS built_in,
    su.owner_id
   FROM sys_user su
  WHERE (((su.user_type)::text = '01'::text) AND ((su.status)::text = ANY ((ARRAY['1'::character varying, '2'::character varying])::text[])));



DROP TABLE IF EXISTS "notice_contact_way";
CREATE TABLE "notice_contact_way" (
"id" SERIAL4 NOT NULL,
"user_id" int4 NOT NULL,
"contact_type" varchar(3) COLLATE "default" NOT NULL,
"contact_value" varchar(128) COLLATE "default" NOT NULL,
"status" varchar(2) COLLATE "default" NOT NULL,
"priority" int4
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "notice_contact_way" IS '用户联系方式 -- Kevice';
COMMENT ON COLUMN "notice_contact_way"."id" IS '主键';
COMMENT ON COLUMN "notice_contact_way"."user_id" IS '用户id';
COMMENT ON COLUMN "notice_contact_way"."contact_type" IS '联系方式代码，字典类型contact_way_type(notice模块)';
COMMENT ON COLUMN "notice_contact_way"."contact_value" IS '联系方式内容';
COMMENT ON COLUMN "notice_contact_way"."status" IS '状态，字典类型contact_way_status(notice模块)';
COMMENT ON COLUMN "notice_contact_way"."priority" IS '优先级，值越小越高';

-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table notice_contact_way
-- ----------------------------
 select redo_sqls($$
    ALTER TABLE "notice_contact_way" ADD PRIMARY KEY ("id");
$$);
