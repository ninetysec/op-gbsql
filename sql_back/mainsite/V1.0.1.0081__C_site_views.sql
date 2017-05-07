-- auto gen by longer 2015-11-18 15:03:56

DROP VIEW if EXISTS v_site_api;

CREATE OR REPLACE VIEW v_site_api AS
  SELECT t.id,
    t.site_id,
    t.status,
    ( SELECT count(1) AS count
      FROM site_game a
      WHERE a.api_id = t.id) AS game_count,
    '0' AS player_count
  FROM site_api t;

ALTER TABLE v_site_api
OWNER TO postgres;
COMMENT ON VIEW v_site_api
IS '站点API视图--river';

DROP VIEW if EXISTS v_site_api_type;

CREATE OR REPLACE VIEW v_site_api_type AS
  SELECT t.id,
    t.site_id,
    ( SELECT count(1) AS apicount
      FROM site_api_type_relation a
      WHERE a.api_type_id = t.id) AS api_count,
    0 AS player_count,
    t.order_num,
    t.status
  FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;

ALTER TABLE v_site_api_type
OWNER TO postgres;
COMMENT ON VIEW v_site_api_type
IS '站点API类型视图--river';

DROP VIEW if EXISTS  v_site_api_type_relation;

CREATE OR REPLACE VIEW v_site_api_type_relation AS
  SELECT t.id,
    t.site_id,
    t.api_id,
    t.api_type_id,
    t.game_count,
    t.player_count,
    t.status,
    t.order_num
  FROM ( SELECT a1.id,
           a1.site_id,
           a1.api_id,
           a1.api_type_id,
           a2.game_count,
           a2.player_count,
           a2.status,
           a1.order_num
         FROM site_api_type_relation a1
           LEFT JOIN ( SELECT t1.id,
                         t1.site_id,
                         t1.status,
                         ( SELECT count(1) AS count
                           FROM site_game a
                           WHERE a.api_id = t1.id AND a.site_id = t1.site_id) AS game_count,
                         0 AS player_count
                       FROM site_api t1) a2 ON a1.api_id = a2.id) t
  ORDER BY t.api_type_id, t.status DESC, t.order_num;

ALTER TABLE v_site_api_type_relation
OWNER TO postgres;

DROP VIEW if EXISTS  v_site_contacts;

CREATE OR REPLACE VIEW v_site_contacts AS
  SELECT a.id,
    a.site_id,
    a.name,
    a.mail,
    a.phone,
    a.position_id,
    a.sex,
    a.create_time,
    a.create_user,
    b.name AS position_name
  FROM site_contacts a
    LEFT JOIN site_contacts_position b ON a.position_id = b.id;

ALTER TABLE v_site_contacts
OWNER TO postgres;
COMMENT ON VIEW v_site_contacts
IS '系统联系人视图-lorne';


DROP VIEW if EXISTS  v_site_game;

CREATE OR REPLACE VIEW v_site_game AS
  SELECT t.id,
    t.site_id,
    t.api_id,
    t.game_type,
    t.views,
    t.game_type_parent,
    t.order_num,
    t.url,
    t.status,
    0 AS player_count,
    0 AS yesterday_count
  FROM site_game t
  ORDER BY t.status DESC, t.order_num;

ALTER TABLE v_site_game
OWNER TO postgres;
COMMENT ON VIEW v_site_game
IS '站点游戏视图-lorne';


DROP VIEW if EXISTS  v_site_master_manage;

CREATE OR REPLACE VIEW v_site_master_manage AS
  SELECT su.id,
    su.username,
    su.nickname,
    su.sex,
    ( SELECT count(1) AS count
      FROM sys_site
      WHERE sys_site.sys_user_id = su.id) AS site_num,
    su.status,
    su.last_login_time,
    su.create_time,
    ctct.user_id,
    ctct.mobile_phone,
    ctct.mail,
    ctct.qq,
    ctct.msn,
    ctct.skype,
    ue.referrals,
    su.memo,
    su.last_login_ip,
    su.birthday,
    su.constellation
  FROM sys_user su
    LEFT JOIN user_extend ue ON su.id = ue.id
    LEFT JOIN ( SELECT ct.user_id,
                  ct.mobile_phone,
                  ct.mail,
                  ct.qq,
                  ct.msn,
                  ct.skype
                FROM crosstab('SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying)) ctct ON su.id = ctct.user_id;

ALTER TABLE v_site_master_manage
OWNER TO postgres;
COMMENT ON VIEW v_site_master_manage
IS '站长管理 --tom';