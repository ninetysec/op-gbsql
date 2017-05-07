-- auto gen by loong 2015-09-10 13:49:40
COMMENT ON COLUMN "sys_user"."status" IS '状态,枚举:SysUserStatus,[1, 正常],[2, 停用],[3, 冻结(不记录表)],[4, 未激活/未审核],[5,审核失败]';
ALTER TABLE "user_agent" DROP COLUMN IF EXISTS "status";
select redo_sqls($$
    ALTER TABLE "site_language" ADD COLUMN "open_time" timestamp(6);
    COMMENT ON COLUMN "site_language"."open_time" IS '开通时间';
        ALTER TABLE "site_operate_area" ADD COLUMN "open_time" timestamp(6);
    COMMENT ON COLUMN "site_operate_area"."open_time" IS '开通时间';
  $$);

