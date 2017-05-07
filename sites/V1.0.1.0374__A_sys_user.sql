-- auto gen by cherry 2017-01-09 15:23:42
ALTER TABLE sys_user DROP CONSTRAINT IF EXISTS "sys_user_username_subsys_code_key";
   select redo_sqls($$
CREATE UNIQUE INDEX sys_user_username_subsys_code_uk ON sys_user ("username", "subsys_code") WHERE "status" = '1';
      $$);