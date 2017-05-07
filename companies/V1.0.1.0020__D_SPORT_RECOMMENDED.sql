--球队
create table IF NOT EXISTS sport_team (
	id SERIAL4 NOT NULL,
	team_type varchar(32) NOT  NULL ,
  team_logo varchar(256) NOT  NULL ,
  create_user_id INTEGER NOT  NULL ,
  create_time TIMESTAMP(6) WITHOUT TIME ZONE NOT  NULL,
	PRIMARY KEY (id)
);

COMMENT ON TABLE sport_team IS '球队信息表';
COMMENT ON COLUMN sport_team.id IS '主键';
COMMENT ON COLUMN sport_team.team_type IS '球队分类site_i18n(sport_recommended.team_type)';
COMMENT ON COLUMN sport_team.team_logo IS '球队logo';
COMMENT ON COLUMN sport_team.create_user_id IS '创建人id';
COMMENT ON COLUMN sport_team.create_time IS '创建时间';

-- i18n
create table IF NOT EXISTS sport_team_i18n (
	id SERIAL4 NOT NULL,
  sport_team_id INTEGER NOT  NULL ,
  local varchar(5) NOT  NULL,
  team_name varchar(64) NOT  NULL,
	PRIMARY KEY (id)
);

COMMENT ON TABLE sport_team_i18n IS '球队国际化信息表';
COMMENT ON COLUMN sport_team_i18n.id IS '主键';
COMMENT ON COLUMN sport_team_i18n.sport_team_id IS '球队ID';
COMMENT ON COLUMN sport_team_i18n.local IS '语言版本';
COMMENT ON COLUMN sport_team_i18n.team_name IS '球队名称';


--sport_recommended(赛事推荐表)
create table IF NOT EXISTS sport_recommended (
	id SERIAL4 NOT NULL,
  match_type	varchar(32),
  start_time	TIMESTAMP(6) WITHOUT TIME ZONE,
  time_stone	varchar	(16),
  host_team_type	varchar(32),
  host_team_id	INTEGER,
  host_team_odds	numeric	(20,2),
  concede_points	varchar(8),
  guest_team_type	varchar(32),
  guest_team_id	INTEGER,
  guest_team_odds	numeric	(20,2),
  api_id	INTEGER ,
  game_id	INTEGER ,
  show_start_time	TIMESTAMP(6) WITHOUT TIME ZONE,
  show_end_time	TIMESTAMP(6) WITHOUT TIME ZONE,
  create_user_id	INTEGER,
  create_time	TIMESTAMP(6) WITHOUT TIME ZONE,
	PRIMARY KEY (id)
);
-- time_stone start_time match_type host_team_id host_team_odds concede_points guest_team_id guest_team_odds api_id game_id show_start_time show_end_time
COMMENT ON TABLE sport_recommended IS '赛事推荐表';
COMMENT ON COLUMN sport_recommended.id IS '主键';
COMMENT ON COLUMN sport_recommended.match_type IS '比赛类型site_i18n(sport_recommended.match_type)';
COMMENT ON COLUMN sport_recommended.start_time IS '比赛开始时间';
COMMENT ON COLUMN sport_recommended.time_stone IS '赛事所在时区';
COMMENT ON COLUMN sport_recommended.host_team_type IS '主队分类site_i18n(sport_recommended.team_type)';
COMMENT ON COLUMN sport_recommended.host_team_id IS '主队id';
COMMENT ON COLUMN sport_recommended.host_team_odds IS '主队赔率';
COMMENT ON COLUMN sport_recommended.concede_points IS '让球';
COMMENT ON COLUMN sport_recommended.guest_team_type IS '客队分类site_i18n(sport_recommended.team_type)';
COMMENT ON COLUMN sport_recommended.guest_team_id IS '客队id';
COMMENT ON COLUMN sport_recommended.guest_team_odds IS '客队赔率';
COMMENT ON COLUMN sport_recommended.api_id IS '关联API';
COMMENT ON COLUMN sport_recommended.game_id IS '关联游戏';
COMMENT ON COLUMN sport_recommended.show_start_time IS '展示开始时间';
COMMENT ON COLUMN sport_recommended.show_end_time IS '展示结束时间';
COMMENT ON COLUMN sport_recommended.create_user_id IS '创建人id';
COMMENT ON COLUMN sport_recommended.create_time IS '创建时间';
-- sport_recommended_site(站点启用表)
create table IF NOT EXISTS sport_recommended_site (
	id SERIAL4 NOT NULL,
  site_id INTEGER NOT  NULL ,
  sport_recommended_id INTEGER NOT  NULL,
	PRIMARY KEY (id)
);

COMMENT ON TABLE sport_recommended_site IS '站点启用表';
COMMENT ON COLUMN sport_recommended_site.id IS '主键';
COMMENT ON COLUMN sport_recommended_site.site_id IS '站点id';
COMMENT ON COLUMN sport_recommended_site.sport_recommended_id IS '赛事推荐id';
-- 视图
DROP VIEW IF EXISTS v_sport_recommended;
CREATE VIEW v_sport_recommended as
 	SELECT
		sr.id,
		sr.time_stone,
		sr.start_time,
		sr.match_type,
		sr.host_team_id,
		sr.host_team_odds,
		sr.concede_points,
		sr.guest_team_id,
		sr.guest_team_odds,
		sr.api_id,
		sr.game_id,
		sr.show_start_time,
		sr.show_end_time,
		hst.team_logo host_team_logo,
		gst.team_logo guest_team_logo,
	 (SELECT array_to_json(array_agg(row_to_json(a1))) from (select team_name as name,local as language from sport_team_i18n where sport_team_id =  hst.id)a1)::text host_team_name_json,
	 (SELECT array_to_json(array_agg(row_to_json(aa))) from (select team_name as name,local as language from sport_team_i18n where sport_team_id =  gst.id)aa)::text guest_team_name_json
  --状态
  FROM sport_recommended sr 
	LEFT JOIN sport_team hst on sr.host_team_id = hst.id
	LEFT JOIN sport_team gst on sr.guest_team_id = gst.id;
	COMMENT ON VIEW "v_sport_recommended" IS '赛事推荐视图--Jeff';




