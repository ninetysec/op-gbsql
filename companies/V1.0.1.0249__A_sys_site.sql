-- auto gen by alvin 2017-02-19 11:31:42
select redo_sqls($$
       ALTER TABLE sys_site ADD COLUMN belong_to_idc VARCHAR(10) default 'A' not null;
$$);
COMMENT ON COLUMN sys_site.belong_to_idc IS '站点归属IDC';
update sys_site set belong_to_idc='A';
