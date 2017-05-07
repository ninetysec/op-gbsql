-- auto gen by orange 2016-01-08 18:32:22
--玩家取款表添加字段
select redo_sqls($$
        ALTER TABLE "player_withdraw" ADD COLUMN "audit_type" varchar(128);
$$);

COMMENT ON COLUMN "player_withdraw"."audit_type" IS '自动稽核/手动稽核：model:fund;type:audit_type';