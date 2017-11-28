select redo_sqls($$
     ALTER TABLE api ADD COLUMN terminal varchar(2);
$$);

COMMENT ON COLUMN api.terminal IS '支持终端：0-全部终端，1-PC，2-移动';

DROP VIEW IF EXISTS v_api;
CREATE OR REPLACE VIEW "v_api" AS 
 SELECT a1.id,
    a1.status,
    a1.order_num,
    a1.maintain_start_time,
    a1.maintain_end_time,
    a1.code,
    a1.domain,
    a1.transferable,
    ( SELECT string_agg((a.api_type_id)::text, ','::text) AS type1
           FROM api_type_relation a
          WHERE (a.api_id = a1.id)) AS first_category,
    ( SELECT string_agg((api_gametype_relation.game_type)::text, ','::text) AS type2
           FROM api_gametype_relation
          WHERE (api_gametype_relation.api_id = a1.id)) AS second_category,
    (( SELECT count(1) AS count
           FROM game gm
          WHERE (gm.api_id = a1.id)))::integer AS game_count,
    (( SELECT count(1) AS count
           FROM site_api sa
          WHERE (sa.api_id = a1.id)))::integer AS site_count,
    a2.id AS api_i18n_id,
    a2.name,
    a2.cover,
    a2.introduce_status,
    a2.introduce_content,
    a2.locale,
	a1.terminal
   FROM (api a1
     LEFT JOIN api_i18n a2 ON ((a1.id = a2.api_id)))
  ORDER BY a1.id;

COMMENT ON VIEW "v_api" IS 'API视图 add by river';

-- site_api
select redo_sqls($$
    ALTER TABLE site_api ADD COLUMN terminal varchar(2);
$$);
COMMENT ON COLUMN site_api.terminal IS '支持终端：0-全部终端，1-PC，2-移动';

DROP VIEW IF EXISTS v_site_api;
CREATE OR REPLACE VIEW "v_site_api" AS 
 SELECT t.id,
		t.site_id,
		t.status,
		(SELECT COUNT(1) FROM site_game sg WHERE (sg.api_id = t.id)) AS game_count,
		'0' AS player_count,
		t.api_id,
		t.api_status,
		t.api_real_status,
		t.maintain_start_time,
		t.maintain_end_time,
		t.terminal
   FROM (SELECT sa.id,
				sa.site_id,
				sa.api_id,
				sa.status,
				sa.order_num,
				sa.code,
				sa.terminal,
				api.status AS api_status,
				CASE
					WHEN (now() > api.maintain_start_time AND now() < api.maintain_end_time) THEN 'maintain'
					ELSE api.status
				END AS api_real_status,
				api.maintain_start_time,
				api.maintain_end_time
           FROM site_api sa
           LEFT JOIN api ON sa.api_id = api."id") t;

COMMENT ON VIEW "v_site_api" IS '站点API视图--river';

-- site_game
select redo_sqls($$
    ALTER TABLE site_game ADD COLUMN support_terminal varchar(2);
		ALTER TABLE site_game ADD COLUMN code varchar(64);
$$);

COMMENT ON COLUMN site_game.support_terminal IS '支持终端：1-PC，2-移动';
COMMENT ON COLUMN site_game.code IS '游戏代号';

-- update site_game
UPDATE site_game SET support_terminal=game.support_terminal, code=game.code FROM game WHERE game.id = site_game.game_id AND site_game.support_terminal IS NULL;

-- f_init_site_game
DROP FUNCTION IF EXISTS f_init_site_game(int4);
CREATE OR REPLACE FUNCTION f_init_site_game(
	siteid int4
) RETURNS void AS $BODY$

declare
v_count int;

BEGIN
	--拷贝总控的game到具体站点
	INSERT INTO site_game (site_id,game_id, api_id, game_type, order_num, url, status, api_type_id, support_terminal, code)
	SELECT siteid,id, api_id, game_type, order_num, url, status,api_type_id, support_terminal, code from game g WHERE NOT EXISTS (select * from site_game s WHERE g.id=s.game_id and s.site_id=siteid);
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

