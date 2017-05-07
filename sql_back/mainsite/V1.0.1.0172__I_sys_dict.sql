-- auto gen by cheery 2015-12-23 16:36:49
INSERT INTO "sys_dict" ("module","dict_type","dict_code","order_num","remark","parent_code","active")
	SELECT 'notice', 'manual_event_type', 'GROUP_SEND', NULL, '信息群发', NULL, 't'
where 'GROUP_SEND' NOT IN (SELECT dict_code FROM sys_dict where dict_type = 'manual_event_type' AND dict_code = 'GROUP_SEND');

select redo_sqls($$
  ALTER TABLE sys_user ADD COLUMN freeze_user int4;
$$);
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN disabled_user int4;
$$);
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN disabled_time timestamp;
$$);
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN freeze_time timestamp;
$$);

COMMENT ON COLUMN "sys_user"."freeze_time" IS '冻结操作时间';
COMMENT ON COLUMN "sys_user"."freeze_user" IS '冻结操作人id';

COMMENT ON COLUMN "sys_user"."disabled_user" IS '停用操作人id';

COMMENT ON COLUMN "sys_user"."disabled_time" IS '停用时间';