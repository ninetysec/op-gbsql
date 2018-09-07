-- auto gen by linsen 2018-07-23 20:23:44
--APP版本记录表添加站点类型 by gavin
 select redo_sqls($$
    ALTER TABLE "app_version_log" ADD COLUMN "box_type" VARCHAR(20);
$$);

COMMENT ON COLUMN "app_version_log"."box_type" IS '站点类型';

