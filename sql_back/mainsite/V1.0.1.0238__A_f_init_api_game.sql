-- auto gen by cherry 2016-01-19 09:30:33
CREATE OR REPLACE FUNCTION "f_init_api_game"(siteid int4)

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



INSERT INTO site_api_type_relation (site_id, api_id, api_type_id, order_num)

SELECT siteid, api_id, api_type_id,1 from api_type_relation a WHERE NOT EXISTS (select * from site_api_type_relation s WHERE a.api_type_id=s.api_type_id and s.site_id=siteid);

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



END



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



ALTER FUNCTION "f_init_api_game"(siteid int4) OWNER TO "postgres";



COMMENT ON FUNCTION "f_init_api_game"(siteid int4) IS '初始化站点api和game-susu';