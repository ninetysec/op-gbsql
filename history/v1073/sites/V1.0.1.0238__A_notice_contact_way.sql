-- auto gen by cherry 2016-08-29 20:58:02
select redo_sqls($$
		alter table notice_contact_way add COLUMN __clean__ varchar(300);

		COMMENT ON COLUMN notice_contact_way.__clean__ is '用来备份联系方式';
$$);
