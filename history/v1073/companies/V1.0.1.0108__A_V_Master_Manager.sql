-- auto gen by tony 2016-06-07 15:07:01
DROP VIEW if exists v_master_manage;

CREATE OR REPLACE VIEW v_master_manage AS
 SELECT sys_user.id,
    sys_user.username,
    sys_user.status,
    sys_user.freeze_type,
    sys_user.freeze_start_time,
    sys_user.freeze_end_time,
    ( SELECT a.username
           FROM sys_user a
          WHERE sys_user.freeze_user = a.id) AS freeze_username,
    sys_user.freeze_time,
    ( SELECT a.username
           FROM sys_user a
          WHERE sys_user.disabled_user = a.id) AS disabled_username,
    sys_user.disabled_time,
    sys_user.create_time,
    0::bigint AS isonline,
    sys_user.freeze_content
   FROM sys_user
  WHERE sys_user.user_type::text = '2'::text;

COMMENT ON VIEW v_master_manage
  IS '站长账号管理视图实体 -- tom';

