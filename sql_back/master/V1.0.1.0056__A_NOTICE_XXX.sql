-- auto gen by kevice 2015-09-08 21:25:32

select redo_sqls($$
  ALTER TABLE notice_text ADD COLUMN tmpl_title CHARACTER VARYING(128);
  ALTER TABLE notice_text ADD COLUMN tmpl_content text;
  ALTER TABLE notice_text ADD COLUMN create_username CHARACTER VARYING(32);
  ALTER TABLE notice_send ADD COLUMN orig_send_id integer;
  ALTER TABLE notice_send ADD COLUMN create_time timestamp without time zone NOT NULL;
  ALTER TABLE notice_send ADD COLUMN update_time timestamp without time zone NOT NULL;
  ALTER TABLE notice_send ADD COLUMN timing timestamp without time zone NOT NULL;
  ALTER TABLE notice_receive ADD COLUMN tmpl_params CHARACTER VARYING(128);
  ALTER TABLE notice_receive ADD COLUMN receiver_username CHARACTER VARYING(32);
$$);
COMMENT ON COLUMN notice_text.tmpl_title IS '模板标题';
COMMENT ON COLUMN notice_text.tmpl_content IS '模板内容';
COMMENT ON COLUMN notice_send.orig_send_id IS '源发送id, 当将comet作为一种提醒方式时有值';
COMMENT ON COLUMN notice_receive.tmpl_params IS '模板参数(与具体用户相关的)json串';
COMMENT ON COLUMN notice_receive.receiver_username IS '接收者账号';
COMMENT ON COLUMN notice_text.create_username IS '创建用户账号';
COMMENT ON COLUMN notice_send.create_time IS '创建时间';
COMMENT ON COLUMN notice_send.update_time IS '更新时间';
COMMENT ON COLUMN notice_send.timing IS '定时发布的时间，为空表示立即发布';

