-- auto gen by loong 2015-10-14 16:49:50

select redo_sqls($$
    ALTER TABLE "site_i18n" ALTER COLUMN "value" TYPE text COLLATE "default";
    ALTER TABLE "site_i18n" ADD COLUMN "default_value" text COLLATE "default";
$$);

COMMENT ON COLUMN "site_i18n"."default_value" IS '默认值';

