-- auto gen by george 2017-11-17 15:49:20
select redo_sqls ($$
alter table credit_record add column background_added BOOLEAN;
alter table credit_record add column path VARCHAR(255);
alter table credit_record add column remark VARCHAR(128);
$$);
COMMENT ON COLUMN credit_record.background_added IS '是否后台充值操作人';
COMMENT ON COLUMN credit_record.path IS '图片路径';
COMMENT ON COLUMN credit_record.remark IS '备注';