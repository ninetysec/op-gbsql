-- auto gen by cherry 2018-01-05 16:30:27
select redo_sqls($$
    ALTER TABLE sys_param add COLUMN "operate" int4;
$$);

COMMENT on COLUMN sys_param.operate is '操作权限，boss:0, 站长:1  全部支持:2';