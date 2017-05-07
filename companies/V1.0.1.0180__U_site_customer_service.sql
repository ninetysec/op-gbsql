-- auto gen by bruce 2016-09-17 17:13:20
select redo_sqls($$
	ALTER TABLE site_customer_service ADD COLUMN type int4;
$$);

COMMENT ON COLUMN site_customer_service.type  IS '类型(1:PC端,2:手机端)';