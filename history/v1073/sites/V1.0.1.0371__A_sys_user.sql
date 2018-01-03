-- auto gen by cherry 2017-01-07 16:39:10
ALTER TABLE sys_user DROP CONSTRAINT IF EXISTS "sys_user_username_subsys_code_key";
ALTER TABLE sys_user ADD CONSTRAINT "sys_user_username_subsys_code_key" UNIQUE ("username", "subsys_code", "status");