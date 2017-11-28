-- auto gen by admin 2016-06-27 14:47:37
UPDATE sys_resource SET icon = 'home' WHERE id = 41;
UPDATE sys_resource SET icon = 'deposit' WHERE id = 42;
UPDATE sys_resource SET icon = 'withdraw' WHERE id = 43;

DROP VIEW IF EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account AS
SELECT su.id,
	   su.user_type,
       su.username,
       su.status,
       su.create_time,
       su.real_name,
       su.nickname,
       array_to_json(ARRAY(SELECT name FROM sys_role WHERE id IN (SELECT role_id FROM sys_user_role WHERE user_id = su.id))) as roles,
       array_to_json(ARRAY(SELECT id FROM sys_role WHERE id IN (SELECT role_id FROM sys_user_role WHERE user_id = su.id))) as role_ids,
       (SELECT CASE WHEN (count(1) > 0) THEN true ELSE false END as built_in
          FROM sys_role WHERE (id IN (SELECT role_id FROM sys_user_role WHERE user_id = su.id) AND built_in)) as built_in,
       su.owner_id,
	   su.site_id
  FROM sys_user su
 WHERE su.user_type = ANY(ARRAY['21', '221', '231']) AND su.status = ANY(ARRAY['1']);
COMMENT ON VIEW v_sub_account IS 'Jeff - 子账户视图';

  select redo_sqls($$
      ALTER TABLE player_recharge ADD COLUMN recharge_address  VARCHAR(255);
      $$);

COMMENT ON COLUMN player_recharge.recharge_address  is '交易地点';