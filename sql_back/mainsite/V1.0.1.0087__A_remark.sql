-- auto gen by cheery 2015-11-19 15:12:47
CREATE TABLE IF NOT EXISTS remark (
  id SERIAL4 PRIMARY KEY NOT NULL , -- 主键
  remark_content CHARACTER VARYING(20000), -- 备注内容
  remark_time TIMESTAMP(6) WITHOUT TIME ZONE, -- 创建时间
  model CHARACTER VARYING(32), -- 模块名
  remark_title CHARACTER VARYING(256), -- 备注标题
  remark_type CHARACTER VARYING(32), -- 备注类型 sys_dict Model：common,Dict_type：remark_type
  entity_user_id INTEGER, -- 被操作实体的所属用户ID
  operator_id INTEGER, -- 操作员id
  entity_id INTEGER -- 业务实体id
);
COMMENT ON TABLE remark IS '玩家备注表 --orange';
COMMENT ON COLUMN remark.id IS '主键';
COMMENT ON COLUMN remark.remark_content IS '备注内容';
COMMENT ON COLUMN remark.remark_time IS '创建时间';
COMMENT ON COLUMN remark.model IS '模块名';
COMMENT ON COLUMN remark.remark_title IS '备注标题';
COMMENT ON COLUMN remark.remark_type IS '备注类型 sys_dict Model：common,Dict_type：remark_type';
COMMENT ON COLUMN remark.entity_user_id IS '被操作实体的所属用户ID';
COMMENT ON COLUMN remark.operator_id IS '操作员id';
COMMENT ON COLUMN remark.entity_id IS '业务实体id';

CREATE OR REPLACE VIEW v_remark AS SELECT t1.id,
                                            t1.remark_content,
                                            t1.remark_time,
                                            t1.model,
                                            t1.remark_title,
                                            t1.remark_type,
                                            t1.entity_user_id,
                                            t1.operator_id,
                                            t1.entity_id,
                                            t2.username AS entity_username,
                                            t3.username AS operator
                                          FROM remark t1
                                          LEFT JOIN sys_user t2 ON t2.id = t1.entity_id
                                                 LEFT JOIN sys_user t3 ON t3.id = t1.operator_id;
COMMENT ON VIEW v_remark IS '玩家备注视图 --orange';