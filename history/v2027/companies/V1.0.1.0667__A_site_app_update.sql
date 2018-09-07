-- auto gen by linsen 2018-07-23 20:24:41
--APP应用更新表添加站点类型 by gavin
 select redo_sqls($$
    ALTER TABLE "site_app_update" ADD COLUMN "box_type" VARCHAR(20) default 'GB';
$$);

COMMENT ON COLUMN "site_app_update"."box_type" IS '站点类型';
