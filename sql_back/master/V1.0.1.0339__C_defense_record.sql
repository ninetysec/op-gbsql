-- auto gen by longer 2016-01-19 10:57:27
--防御功能
CREATE TABLE IF NOT EXISTS defense_record(
  id serial8 PRIMARY KEY ,
  client_id CHARACTER VARYING(50),
  action_code CHARACTER VARYING(50),
  dispose_code CHARACTER VARYING(20),
  dispose_end_time TIMESTAMP WITHOUT TIME ZONE,
  operate_ip BIGINT,
  operate_start_time TIMESTAMP WITHOUT TIME ZONE,
  operate_end_time TIMESTAMP WITHOUT TIME ZONE,
  success_times INTEGER,
  error_times INTEGER,
  description CHARACTER VARYING(500)
);

COMMENT ON TABLE defense_record IS '防御记录表--longer';
COMMENT ON COLUMN defense_record.id IS '主键';
COMMENT ON COLUMN defense_record.client_id IS '主键';
COMMENT ON COLUMN defense_record.action_code IS '功能代码';
COMMENT ON COLUMN defense_record.dispose_code IS '处置代码(控制操作行为)';
COMMENT ON COLUMN defense_record.dispose_end_time IS '处置结束时间';
COMMENT ON COLUMN defense_record.operate_ip IS '操作IP';
COMMENT ON COLUMN defense_record.operate_start_time IS '操作开始时间';
COMMENT ON COLUMN defense_record.operate_end_time IS '操作结束时间';
COMMENT ON COLUMN defense_record.success_times IS '操作成功次数';
COMMENT ON COLUMN defense_record.error_times IS '操作失败次数';
COMMENT ON COLUMN defense_record.description IS '操作描述';

drop INDEX if EXISTS uqx_defense_record_client_id_action_code;
CREATE UNIQUE INDEX uqx_defense_record_client_id_action_code on defense_record (client_id,action_code);
