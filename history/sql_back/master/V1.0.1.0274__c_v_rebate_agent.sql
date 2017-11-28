-- auto gen by tom 2015-12-23 15:08:40
DROP VIEW IF EXISTS v_rebate_agent;
CREATE OR REPLACE VIEW "v_rebate_agent" AS
 SELECT rs.id,
    rs.name,
    rs.status,
    rs.valid_value,
    rs.remark,
    rs.create_time,
    rs.create_user_id,
    ( SELECT count(1) AS count
           FROM user_agent_rebate
          WHERE (rs.id = user_agent_rebate.rebate_id)) AS rebatenum
   FROM rebate_set rs;

ALTER TABLE "v_rebate_agent" OWNER TO "postgres";