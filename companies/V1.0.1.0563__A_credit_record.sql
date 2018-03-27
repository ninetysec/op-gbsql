-- auto gen by linsen 2018-02-28 20:35:10
--买分记录添加撤销人记录
 select redo_sqls($$
    ALTER TABLE credit_record ADD COLUMN "cancel_user" int4;
                ALTER TABLE credit_record ADD COLUMN "cancel_user_name" varchar(32);
                ALTER TABLE credit_record ADD COLUMN "cancel_time" timestamp(6);
                COMMENT ON COLUMN credit_record."cancel_user" IS '撤销用户ID';
                COMMENT ON COLUMN credit_record."cancel_user_name" IS '撤销人账号';
                COMMENT ON COLUMN credit_record."cancel_time" IS '撤销时间';
$$);


