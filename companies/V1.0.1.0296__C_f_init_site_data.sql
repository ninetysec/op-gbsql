-- auto gen by cherry 2017-06-08 11:40:28
DROP FUNCTION IF EXISTS "f_init_site_data"(siteid int4);
CREATE OR REPLACE FUNCTION "f_init_site_data"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
--拷贝总控的api和game到具体站点

INSERT INTO site_api (site_id,api_id,status,order_num,code,maintain_start_time,maintain_end_time,transferable,terminal)
SELECT siteid,id,status,order_num,code,maintain_start_time,maintain_end_time,transferable,terminal FROM api a WHERE NOT EXISTS(SELECT * FROM site_api s WHERE a.id=s.api_id and s.site_id=siteid);
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

INSERT INTO site_api_type_relation (site_id, api_id, api_type_id,order_num)
SELECT siteid, api_id, api_type_id,order_num from api_type_relation a WHERE NOT EXISTS (SELECT * FROM site_api_type_relation s WHERE a.api_id = s.api_id AND a.api_type_id = s.api_type_id AND s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api_type_relation数量 %', v_count;

INSERT INTO site_api_type_relation_i18n (relation_id, name, local,site_id,api_id,api_type_id)
SELECT s.id,a.name,a.local,s.site_id,a.api_id,a.api_type_id FROM site_api_type_relation s,api_type_relation_i18n a WHERE s.api_id=a.api_id AND s.api_type_id=a.api_type_id AND site_id=siteid AND NOT EXISTS (SELECT * FROM site_api_type_relation_i18n si WHERE s.id=si.relation_id);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_api_type_relation_i18n数量 %', v_count;

INSERT INTO site_game (site_id,game_id, api_id, game_type, order_num, url, status, api_type_id,support_terminal,code)
SELECT siteid,id, api_id, game_type, order_num, url, status,api_type_id,support_terminal,code from game g WHERE NOT EXISTS (select * from site_game s WHERE g.id=s.game_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_game数量 %', v_count;

INSERT INTO site_game_i18n (site_id, game_id, name, local, cover, introduce_status, game_introduce)
SELECT siteid, game_id, name, locale, cover, introduce_status, game_introduce from game_i18n g WHERE NOT EXISTS (select * from site_game_i18n s WHERE g.game_id=s.game_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_game_i18n数量 %', v_count;


INSERT INTO site_customer_service (site_id, code, name, parameter, status, create_time, create_user, built_in,type)
select siteid, code, name, '' parameter , status, now(), create_user, built_in,type from site_customer_service where site_id=0 and built_in =true and not exists (select * from site_customer_service s where s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_customer_service 数量 %', v_count;


INSERT INTO site_contacts_position (site_id, name, create_user, create_time, built_in)  select
	siteid,name,create_user, create_time, false from  site_contacts_position  where site_id=0 and built_in=true and name not in(select name from site_contacts_position where site_id= siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_contacts_position 数量 %', v_count;

INSERT INTO site_i18n ( "module", "type", "key", "locale", "value", "site_id","built_in") SELECT
	module,type,key,locale,value,siteid,FALSE FROM 	site_i18n WHERE	site_id = 0 AND module = 'setting' AND type = 'system_settings' AND built_in = TRUE AND value not in (SELECT value from site_i18n where site_id = siteid AND  module = 'setting' AND type = 'system_settings');
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_i18n 系统设置信息数量 %', v_count;

INSERT INTO site_i18n ( "module", "type", "key", "locale", "value", "site_id","default_value","built_in") SELECT
	module,type,key,locale,value,siteid,default_value,FALSE FROM 	site_i18n WHERE	site_id = 0 AND module = 'setting' AND (type = 'service_terms' OR "type"='service_terms_agent')AND built_in = TRUE AND NOT EXISTS (SELECT * from site_i18n where site_id = siteid AND  module = 'setting' AND (type = 'service_terms' OR "type"='service_terms_agent'));
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_i18n 玩家和代理注册条件数量 %', v_count;

INSERT INTO site_game_tag (site_id,game_id,tag_id)
SELECT siteid,game_id,tag_id FROM game_tag g WHERE NOT EXISTS(SELECT * FROM site_game_tag s WHERE g.game_id=s.game_id and g.tag_id=s.tag_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_game_tag 数量 %', v_count;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_init_site_data"(siteid int4) IS '同步站点信息';