-- auto gen by kevice 2015-09-22 11:21:58

select redo_sqls($$
   ALTER TABLE sys_user ADD COLUMN city character varying(32);
$$);
COMMENT ON COLUMN sys_user.city IS '城市';