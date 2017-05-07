-- auto gen by Alvin 2016-08-16 02:51:07
alter table api_order_log add COLUMN end_id int8 DEFAULT 0;
alter table api_order_log add COLUMN end_time timestamp(6);
alter table api_order_log add COLUMN ext_json VARCHAR(1000);

COMMENT ON COLUMN api_order_log.end_id IS '结束ID';
COMMENT ON COLUMN api_order_log.end_time IS '结束时间';
COMMENT ON COLUMN api_order_log.ext_json IS '扩展具体应用';