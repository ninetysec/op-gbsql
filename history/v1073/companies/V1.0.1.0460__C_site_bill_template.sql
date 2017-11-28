-- auto gen by george 2017-11-01 17:39:20
CREATE TABLE IF NOT EXISTS site_bill_template(
	id serial4 not null PRIMARY key,
	site_id int,
	file_name varchar(64),
	path varchar(256),
	create_user int,
	create_time TIMESTAMP(6),
	update_user int,
	update_time TIMESTAMP(6),
	remark text
);

COMMENT ON COLUMN site_bill_template.id IS '主键';
COMMENT ON COLUMN site_bill_template.site_id IS '站点id';
COMMENT ON COLUMN site_bill_template.file_name IS '模板名称';
COMMENT ON COLUMN site_bill_template.path IS '文件路径';
COMMENT ON COLUMN site_bill_template.create_user IS '创建人';
COMMENT ON COLUMN site_bill_template.create_time IS '创建时间';
COMMENT ON COLUMN site_bill_template.update_user IS '修改人';
COMMENT ON COLUMN site_bill_template.update_time IS '修改时间';
COMMENT ON COLUMN site_bill_template.remark IS '备注';