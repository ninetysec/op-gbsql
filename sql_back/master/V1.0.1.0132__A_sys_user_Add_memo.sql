-- auto gen by longer 2015-10-19 16:32:47

select redo_sqls($$
  alter table sys_user add COLUMN memo CHARACTER VARYING(1000); -- 备注
$$);
COMMENT ON COLUMN sys_user.memo is '备注';