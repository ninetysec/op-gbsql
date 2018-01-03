-- auto gen by cheery 2015-12-10 08:30:42
UPDATE sys_resource set name = "replace"(name, '账','账') where name LIKE '%账%';
select redo_sqls($$
ALTER TABLE "ctt_document"
ADD COLUMN "code" varchar(128);
$$);
COMMENT ON COLUMN "ctt_document"."code" IS '文案code，默认文案code不能修改';
select redo_sqls($$
ALTER TABLE "ctt_document"
ADD COLUMN "order_num" int4;
$$);
COMMENT ON COLUMN "ctt_document"."order_num" IS '排序字段， 正序';

DROP VIEW IF EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account  as
---是否包含重要角色
SELECT
  su.user_type,
  su. ID,
  su.username,
  su.status,
  su.create_time,
    su.real_name,
    su.nickname,
  array_to_json(array(SELECT name FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) roles,
  array_to_json(array(SELECT id FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) role_ids,
  (SELECT CASE WHEN count(1) > 0 then true else false end built_in FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) and built_in )built_in,
  su.owner_id
FROM
  sys_user su
where su.user_type in ('21','221','231') and status in ('1','2');
COMMENT ON VIEW "v_sub_account" IS '子账户视图--jeff';

DROP VIEW IF EXISTS v_agent_fund_record;
CREATE OR REPLACE VIEW v_agent_fund_record AS
  SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    CASE a.settlement_state
    WHEN 'pending_lssuing'::text THEN '1'::text
    WHEN 'lssuing'::text THEN '2'::text
    WHEN 'reject_lssuing'::text THEN '4'::text
    ELSE 'ONO'::text
    END AS status,
    1 AS type,
    a.settlement_name AS periods,
    a.start_time
  FROM agent_rebate_order a
    LEFT JOIN agent_water_bill b ON a.id = b.order_id WHERE a.settlement_state = 'lssuing'
  UNION
  SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    a.transaction_status AS status,
    2 AS type,
    ''::character varying AS periods,
    now() AS start_time
  FROM agent_withdraw_order a
    LEFT JOIN agent_water_bill b ON a.id = b.order_id;

ALTER TABLE v_agent_fund_record
OWNER TO postgres;
COMMENT ON VIEW v_agent_fund_record
IS '代理资金账户流水--lorne';