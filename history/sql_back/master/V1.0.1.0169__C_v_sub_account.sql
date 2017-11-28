-- auto gen by cheery 2015-11-05 06:40:57
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
    array_to_json(array(SELECT name FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) roles,
    array_to_json(array(SELECT id FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) role_ids,
    (SELECT CASE WHEN count(1) > 0 then true else false end built_in FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) and built_in )built_in,
    su.owner_id
  FROM
    sys_user su
  where su.user_type in ('21','221','231') and status in ('1','2');
COMMENT ON VIEW "v_sub_account" IS '子账户视图';