-- auto gen by cherry 2016-02-21 15:05:20
CREATE OR REPLACE VIEW "v_sport_team" AS
 SELECT a.id,
    a.team_logo,
    b.team_name,
    b.local
   FROM (sport_team a
     LEFT JOIN sport_team_i18n b ON ((b.sport_team_id = a.id)));

COMMENT ON VIEW  "v_sport_team" IS '球队管理 add by eagle';