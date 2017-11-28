-- auto gen by cheery 2015-12-24 15:58:29
CREATE TABLE IF NOT EXISTS api_order_log(
id SERIAL4 NOT NULL PRIMARY KEY ,
api_id int4 NOT NULL,
start_id int8,
update_time TIMESTAMP(6),
type varchar(1),
start_time TIMESTAMP(6)
);

COMMENT ON TABLE api_order_log  IS 'API下单获取记录';

COMMENT ON COLUMN api_order_log.id IS '主键';

COMMENT ON COLUMN api_order_log.api_id IS 'API表Id';

COMMENT ON COLUMN api_order_log.start_id IS '注单最大序列号';

COMMENT ON COLUMN api_order_log.update_time IS '更新时间';

COMMENT ON COLUMN api_order_log.type IS '获取类型：0-新增，1-修改';

comment on COLUMN api_order_log.start_time IS '开始时间';