-- auto gen by linsen 2018-05-01 17:53:57
--添加是否是彩池游戏字段；by carl
select redo_sqls($$
	ALTER TABLE game ADD COLUMN jackpot BOOLEAN;
	ALTER TABLE site_game ADD COLUMN jackpot BOOLEAN;
  $$);
COMMENT ON COLUMN game.jackpot IS '是否是彩池游戏：true 是';
COMMENT ON COLUMN site_game.jackpot IS '是否是彩池游戏：true 是';

--初始化彩池游戏
update game set jackpot = true where code in ('hb','ashadv','aogs','ftsis','athn','furf','kolymp','hrcls','bl','ashbob','ct','ctiv','ashcpl','mobdt','dlm','esm','ashfta','fcgz','ftg','fbr','fow','frtf','fdtjg','fmn','fnfrj','ges','glrj','grel','gos','gro','hk','aztec','jpgt','lndg','kfp','lm','ashlob','nian','pnp','phot','ririshc','sib','sol','slion','cnpr','tht','ashglss','lvb','ashtmd','wlcsh','zcjbjp','1227','1401','1339','1194','1397','1358','1220','1154','1093','1116','1391','1387','1026');

update site_game set jackpot = true where code in ('hb','ashadv','aogs','ftsis','athn','furf','kolymp','hrcls','bl','ashbob','ct','ctiv','ashcpl','mobdt','dlm','esm','ashfta','fcgz','ftg','fbr','fow','frtf','fdtjg','fmn','fnfrj','ges','glrj','grel','gos','gro','hk','aztec','jpgt','lndg','kfp','lm','ashlob','nian','pnp','phot','ririshc','sib','sol','slion','cnpr','tht','ashglss','lvb','ashtmd','wlcsh','zcjbjp','1227','1401','1339','1194','1397','1358','1220','1154','1093','1116','1391','1387','1026');

--v_game试图添加彩池游戏字段
drop view IF EXISTS v_game;

CREATE OR REPLACE VIEW "v_game" AS
 SELECT a1.id,
    a1.api_id,
    a1.game_type,
    a1.order_num,
    a1.url,
    a1.status,
    a1.code,
    a1.api_type_id,
    a1.maintain_start_time,
    a1.maintain_end_time,
    a2.id AS game_i18n_id,
    a2.name,
    a2.cover,
    a2.locale,
    a2.introduce_status,
    a2.game_introduce,
    a1.support_terminal,
    a1.can_try,
    a1.game_3d,
    a1.game_line,
    a1.game_rtp,
    a2.background_cover,
    a1.game_score,
    a1.game_score_number,
    a1.game_collect_number,
    a1.game_view,
    a1.jackpot
   FROM (game a1
     LEFT JOIN game_i18n a2 ON ((a1.id = a2.game_id)))
  ORDER BY a1.id;

COMMENT ON VIEW  "v_game" IS '游戏列表视图 add by river';
