-- auto gen by kevice 2015-09-07 15:46:59

CREATE TABLE IF NOT EXISTS notice_unreceived
(
  id integer NOT NULL, -- 主键
  user_id integer NOT NULL, -- 用户id
  send_ids text NOT NULL, -- 发送的消息id(以半角逗号分隔)
  publish_method character varying(16) NOT NULL, -- 发布方式代码，字典类型publish_method(notice模块)
  create_time timestamp without time zone NOT NULL, -- 创建时间
  update_time timestamp without time zone, -- 更新时间
  CONSTRAINT pk_notice_unreceived PRIMARY KEY (id),
  CONSTRAINT uq_notice_unreceived_user_id_publish_method UNIQUE (user_id, publish_method)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE notice_unreceived
  OWNER TO postgres;
COMMENT ON TABLE notice_unreceived
  IS '还未收到的消息 -- Kevice';
COMMENT ON COLUMN notice_unreceived.id IS '主键';
COMMENT ON COLUMN notice_unreceived.user_id IS '用户id';
COMMENT ON COLUMN notice_unreceived.send_ids IS '发送的消息id(以半角逗号分隔)';
COMMENT ON COLUMN notice_unreceived.publish_method IS '发布方式代码，字典类型publish_method(notice模块)';
COMMENT ON COLUMN notice_unreceived.create_time IS '创建时间';
COMMENT ON COLUMN notice_unreceived.update_time IS '更新时间';

