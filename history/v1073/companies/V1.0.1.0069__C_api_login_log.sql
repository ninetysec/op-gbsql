-- auto gen by admin 2016-04-10 20:47:41
--创建api_login_log
CREATE TABLE IF not EXISTS  "api_login_log" (
"id" SERIAL4 NOT NULL,
"api_id" int4 NOT NULL,
"user_api_account" varchar(32),
"login_time" timestamp(6),
CONSTRAINT "api_login_log_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "api_login_log" IS 'API登录记录';

COMMENT ON COLUMN "api_login_log"."id" IS '主键';

COMMENT ON COLUMN "api_login_log"."api_id" IS 'API表Id';

COMMENT ON COLUMN "api_login_log"."user_api_account" IS '用户API账号';

COMMENT ON COLUMN "api_login_log"."login_time" IS '登录时间';

--更新函数f_init_site_data
DROP FUNCTION if EXISTS f_init_site_data(siteid int4);

CREATE OR REPLACE FUNCTION "f_init_site_data"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
--拷贝总控的api和game到具体站点

INSERT INTO site_api (site_id,api_id,status,order_num,code,maintain_start_time,maintain_end_time)
SELECT siteid,id,status,order_num,code,maintain_start_time,maintain_end_time FROM api a WHERE NOT EXISTS(SELECT * FROM site_api s WHERE a.id=s.api_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api数量 %', v_count;

INSERT INTO site_api_i18n (site_id, api_id, name, local, logo1, logo2, cover)
SELECT siteid, api_id,name, locale, logo1, logo2, cover from api_i18n a WHERE NOT EXISTS (select * from site_api_i18n s WHERE a.api_id=s.api_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api_i18n数量 %', v_count;

INSERT INTO site_api_type (site_id, api_type_id, url, parameter, order_num, status)
SELECT siteid,id, url, parameter, order_num,'normal' from api_type a WHERE NOT EXISTS (select * from site_api_type s WHERE a.id=s.api_type_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api_type数量 %', v_count;

INSERT INTO site_api_type_i18n (site_id, api_type_id, name, local, cover)
SELECT siteid, api_type_id, name, local, cover from api_type_i18n a WHERE NOT EXISTS (select * from site_api_type_i18n s WHERE a.api_type_id=s.api_type_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api_type_i18n数量 %', v_count;

INSERT INTO site_api_type_relation (site_id, api_id, api_type_id)
SELECT siteid, api_id, api_type_id from api_type_relation a WHERE api_id not in(SELECT api_id FROM site_api_type_relation s WHERE s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api_type_relation数量 %', v_count;

INSERT INTO site_game (site_id,game_id, api_id, game_type, order_num, url, status, api_type_id)
SELECT siteid,id, api_id, game_type, order_num, url, status,api_type_id from game g WHERE NOT EXISTS (select * from site_game s WHERE g.id=s.game_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_game数量 %', v_count;

INSERT INTO site_game_i18n (site_id, game_id, name, local, cover, introduce_status, game_introduce)
SELECT siteid, game_id, name, locale, cover, introduce_status, game_introduce from game_i18n g WHERE NOT EXISTS (select * from site_game_i18n s WHERE g.game_id=s.game_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_game_i18n数量 %', v_count;

INSERT INTO site_customer_service (site_id, code, name, parameter, status, create_time, create_user, built_in)  select
	siteid, 'K001', '默认客服', '', true, now(), '0', true where 'K001' not in(select code from site_customer_service where site_id=23) ;
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_customer_service 数量 %', v_count;

INSERT INTO site_contacts_position (site_id, name, create_user, create_time, built_in)  select
	siteid,name,create_user, create_time, false from  site_contacts_position  where site_id=0 and built_in=true and name not in(select name from site_contacts_position where site_id= siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_contacts_position 数量 %', v_count;

INSERT INTO site_i18n ( "module", "type", "key", "locale", "value", "site_id","built_in") SELECT
	module,type,key,locale,value,siteid,FALSE FROM 	site_i18n WHERE	site_id = 0 AND module = 'setting' AND type = 'system_settings' AND built_in = TRUE AND value not in (SELECT value from site_i18n where site_id = siteid AND  module = 'setting' AND type = 'system_settings');
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_i18n 数量 %', v_count;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


select redo_sqls($$
ALTER TABLE api_login_log add COLUMN site_id int4;
$$);
COMMENT on COLUMN api_login_log.site_id is '站点id';