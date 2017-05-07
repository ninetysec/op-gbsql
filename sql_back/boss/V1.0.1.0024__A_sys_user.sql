-- auto gen by cheery 2015-12-10 09:28:50
select redo_sqls($$
   ALTER TABLE sys_user ADD COLUMN freeze_title varchar(128);
   ALTER TABLE sys_user ADD COLUMN freeze_content TEXT;
$$);

COMMENT ON COLUMN sys_user.freeze_title IS '账号冻结标题';

COMMENT ON COLUMN sys_user.freeze_content IS '账号冻结内容';
