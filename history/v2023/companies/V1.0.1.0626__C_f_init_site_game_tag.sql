-- auto gen by steffan 2018-05-23 18:00:36 add by younger
DROP FUNCTION IF EXISTS "f_init_site_game_tag"(siteid int4);
CREATE OR REPLACE FUNCTION "f_init_site_game_tag"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
--拷贝总控的game_tag到具体站点
DELETE FROM site_game_tag where site_id = siteid;
INSERT INTO site_game_tag (site_id,game_id,tag_id)
SELECT siteid,game_id,tag_id FROM game_tag g WHERE NOT EXISTS(SELECT * FROM site_game_tag s WHERE g.game_id=s.game_id and g.tag_id=s.tag_id and s.site_id=siteid) and EXISTS (SELECT game_id from site_game sg where sg.game_id=g.game_id);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_game_tag 数量 %', v_count;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;