-- auto gen by cherry 2016-02-03 09:59:36
DROP VIEW if EXISTS v_remark;
select redo_sqls($$
	ALTER TABLE remark ADD COLUMN operator varchar(32);
$$);
COMMENT ON COLUMN remark.operator IS '操作员';

UPDATE remark SET operator = (
	SELECT su.username FROM sys_user su WHERE remark.operator_id = su.id LIMIT 1
);