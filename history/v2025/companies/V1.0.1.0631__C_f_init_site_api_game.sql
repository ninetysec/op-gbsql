-- auto gen by linsen 2018-06-11 19:44:16
-- 根据站点id、apiid更新同步数据 by kobe
DROP FUNCTION IF EXISTS "f_init_site_api_game"(siteid int4, apiid int4);
CREATE OR REPLACE FUNCTION "f_init_site_api_game"(siteid int4, apiid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
--同步api到站点
INSERT INTO site_api (site_id,api_id, status, order_num, code,maintain_start_time,maintain_end_time,transferable,api_agent_conf,terminal,mobile_order_num)
SELECT siteid,apiid, status, order_num, code, maintain_start_time,maintain_end_time,transferable,NULL,terminal,order_num
from api a WHERE  NOT EXISTS (select * from site_api s WHERE a.id=s.api_id and s.api_id=apiid and s.site_id=siteid) and a.id=apiid;
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_api数量 %', v_count;

INSERT INTO site_api_i18n (site_id, api_id, name, local, logo1, logo2, cover)
SELECT siteid, apiid,name, locale, logo1, logo2, cover from api_i18n a WHERE a.api_id=apiid AND NOT EXISTS (select * from site_api_i18n s WHERE a.api_id=s.api_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_api_i18n数量 %', v_count;

INSERT INTO site_api_type (site_id, api_type_id, url, parameter, order_num, status)
SELECT siteid,a.id, url, parameter, order_num,'normal' from api_type a WHERE NOT EXISTS (select * from site_api_type s WHERE a.id
=s.api_type_id and s.site_id=siteid) and a.id NOT IN (SELECT api_type_id FROM api_type_relation where api_id = apiid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_api_type数量 %', v_count;

INSERT INTO site_api_type_i18n (site_id, api_type_id, name, local, cover)
SELECT siteid, api_type_id, name, local, cover from api_type_i18n a WHERE NOT EXISTS (select * from site_api_type_i18n s WHERE a.api_type_id=s.api_type_id and s.site_id=siteid) and
 a.api_type_id NOT IN (SELECT api_type_id FROM api_type_relation where api_id = apiid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_api_type_i18n数量 %', v_count;

INSERT INTO site_api_type_relation (site_id, api_id, api_type_id,order_num)
SELECT siteid, apiid, api_type_id,order_num from api_type_relation a WHERE a.api_id=apiid AND NOT EXISTS (SELECT * FROM site_api_type_relation s WHERE a.api_id = s.api_id AND a.api_type_id = s.api_type_id AND s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_api_type_relation数量 %', v_count;

INSERT INTO site_api_type_relation_i18n (relation_id, name, local,site_id,api_id,api_type_id)
SELECT s.id,a.name,a.local,s.site_id,apiid,a.api_type_id FROM site_api_type_relation s,api_type_relation_i18n a WHERE s.api_id=apiid AND s.api_id=a.api_id AND s.api_type_id=a.api_type_id AND site_id=siteid AND NOT EXISTS (SELECT * FROM site_api_type_relation_i18n si WHERE s.id=si.relation_id);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_api_type_relation_i18n数量 %', v_count;

INSERT INTO site_game (site_id,game_id, api_id, game_type, order_num, url, status, api_type_id,support_terminal,code)
SELECT siteid,id, apiid, game_type, order_num, url, status,api_type_id,support_terminal,code from game g WHERE g.api_id=apiid AND
 NOT EXISTS (select * from site_game s WHERE g.id=s.game_id and s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增site_game数量 %', v_count;

INSERT INTO site_game_i18n (site_id, game_id, name, local, cover, introduce_status, game_introduce)
SELECT siteid, game_id, name, locale, cover, introduce_status, game_introduce from game_i18n g WHERE game_id IN(SELECT id FROM game WHERE api_id=apiid) AND NOT EXISTS (select * from site_game_i18n s WHERE g.game_id=s.game_id and s.site_id=siteid AND s.local=g.locale);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_game_i18n数量 %', v_count;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "f_init_site_api_game"(siteid int4, apiid int4) IS '根据站点id、apiid更新同步数据';