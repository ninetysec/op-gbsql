-- auto gen by water 2018-01-09 23:34:44

select  redo_sqls ($$
    ALTER TABLE sys_param ADD COLUMN is_switch BOOLEAN ;
    ALTER TABLE sys_param ADD COLUMN operate VARCHAR;
$$);

COMMENT ON COLUMN sys_param.is_switch is 'is switch';
COMMENT ON COLUMN sys_param.operate is 'operate';
