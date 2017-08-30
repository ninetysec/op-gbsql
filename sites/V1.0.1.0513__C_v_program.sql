-- auto gen by cherry 2017-08-30 09:10:35
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