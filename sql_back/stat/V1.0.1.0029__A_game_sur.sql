-- auto gen by longer 2015-12-23 19:06:14


select redo_sqls($$
  ALTER TABLE "game_survey" ADD COLUMN "api_type_id" int4;
$$);

ALTER TABLE "game_survey" DROP COLUMN IF EXISTS "game_type_parent";