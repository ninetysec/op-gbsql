-- auto gen by kevice 2015-09-09 11:26:37

select redo_sqls($$
  ALTER TABLE sys_user ADD COLUMN region CHARACTER VARYING(32);
$$);
COMMENT ON COLUMN sys_user.region IS '地区，字典类型province(common模块)';