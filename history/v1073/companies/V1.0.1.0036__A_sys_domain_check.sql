-- auto gen by cherry 2016-03-02 10:07:42
 select redo_sqls($$
      ALTER TABLE "sys_domain_check" ADD COLUMN "publish_user_type" varchar(32);
     $$);

COMMENT ON COLUMN "sys_domain_check"."publish_user_type" IS '提交人用户类型( 21:站长子账号)';
