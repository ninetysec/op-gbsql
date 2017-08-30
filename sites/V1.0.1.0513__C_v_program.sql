-- auto gen by cherry 2017-08-30 09:10:35

--DROP TABLE IF EXISTS user_topagent_rebate;
CREATE TABLE IF NOT EXISTS user_topagent_rebate (
id serial4 PRIMARY KEY,
user_id int4 NOT NULL,
rebate_id int4 NOT NULL
)
;

COMMENT ON TABLE user_topagent_rebate IS '总代返佣方案';
COMMENT ON COLUMN user_topagent_rebate.user_id IS '总代ID';
COMMENT ON COLUMN user_topagent_rebate.rebate_id IS '返佣方案表ID';

CREATE INDEX user_topagent_rebate_rebate_id_idx ON user_topagent_rebate USING btree (rebate_id);
CREATE INDEX user_topagent_rebate_user_id_idx ON user_topagent_rebate USING btree (user_id);


COMMENT ON TABLE user_agent_rebate IS '代理返佣方案';
COMMENT ON COLUMN user_agent_rebate.user_id IS '代理ID';
COMMENT ON COLUMN user_agent_rebate.rebate_id IS '返佣方案表ID';

--INSERT INTO user_topagent_rebate(user_id, rebate_id) SELECT user_id, rebate_id FROM user_agent_rebate WHERE user_id IN (SELECT id FROM sys_user WHERE user_type = '22');

WITH d AS (
  DELETE FROM user_agent_rebate WHERE user_id IN (SELECT id FROM sys_user WHERE user_type = '22')
  RETURNING * 
)
INSERT INTO user_topagent_rebate(user_id, rebate_id) SELECT user_id, rebate_id FROM d ORDER BY user_id, rebate_id;


DROP VIEW IF EXISTS v_program;
CREATE OR REPLACE VIEW "v_program" AS
 SELECT a.id,
    a.user_id,
    a.rakeback_id AS program_id,
    b.name,
    b.status,
    'rakeback'::text AS type
   FROM (user_agent_rakeback a
     LEFT JOIN rakeback_set b ON ((a.rakeback_id = b.id)))
UNION
 SELECT a.id,
    a.user_id,
    a.rebate_id AS program_id,
    b.name,
    b.status,
    'rebate'::text AS type
   FROM (user_agent_rebate a
     LEFT JOIN rebate_set b ON ((a.rebate_id = b.id)))
UNION
 SELECT a.id,
    a.user_id,
    a.rebate_id AS program_id,
    b.name,
    b.status,
    'rebate'::text AS type
   FROM (user_topagent_rebate a
     LEFT JOIN rebate_set b ON ((a.rebate_id = b.id)));

COMMENT ON VIEW "v_program" IS '代理/总代-返水/返佣方案汇总视图--lorne';
