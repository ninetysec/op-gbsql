-- auto gen by tony 2016-06-10 22:20:38
  select redo_sqls($$
    ALTER TABLE sys_user ADD COLUMN session_key character varying(40);
  $$);
  select redo_sqls($$
      COMMENT ON COLUMN sys_user.session_key IS '用户的session_key,online_session_id将被删除';
  $$);