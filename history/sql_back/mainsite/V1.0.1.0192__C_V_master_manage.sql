-- auto gen by tom 2015-12-28 20:21:43
DROP VIEW IF EXISTS v_master_manage;
CREATE OR REPLACE VIEW "v_master_manage" AS
 SELECT sys_user.id,
    sys_user.username,
    sys_user.status,
    sys_user.freeze_type,
    sys_user.freeze_start_time,
    sys_user.freeze_end_time,
    ( SELECT a.username
           FROM sys_user a
          WHERE (sys_user.freeze_user = a.id)) AS freeze_username,
    sys_user.freeze_time,
    ( SELECT a.username
           FROM sys_user a
          WHERE (sys_user.disabled_user = a.id)) AS disabled_username,
    sys_user.disabled_time,
    sys_user.create_time,
    ( SELECT count(1) AS count
           FROM sys_on_line_session
          WHERE (sys_on_line_session.sys_user_id = sys_user.id)) AS isonline,
    sys_user.freeze_content
   FROM sys_user
  WHERE ((sys_user.user_type)::text = '2'::text);

ALTER TABLE "v_master_manage" OWNER TO "postgres";

COMMENT ON VIEW v_master_manage is '站长账号管理视图实体 -- tom';