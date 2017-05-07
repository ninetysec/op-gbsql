-- auto gen by Kevice 2015-09-01

-- 新增字段default_currency
select redo_sqls($$
    ALTER TABLE sys_user ADD COLUMN default_currency character varying(3);
  $$);
COMMENT ON COLUMN sys_user.default_currency IS '默认币种代码，字典类型currency(common模块)';