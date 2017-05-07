-- auto gen by longer 2015-11-24 15:18:54

drop TABLE IF EXISTS ctt_material;
drop TABLE IF EXISTS ctt_material_detail;


CREATE TABLE IF NOT EXISTS ctt_material_pic (
  id SERIAL4 PRIMARY KEY NOT NULL,
  pic CHARACTER VARYING(500), -- 图片路径
  create_time TIMESTAMP WITHOUT TIME ZONE, -- 创建时间
  download_count INTEGER, -- 下载次数
  language CHARACTER VARYING(32), -- 类型（1文字，2图片）
  status BOOLEAN DEFAULT true, -- 状态
  title CHARACTER VARYING(100), -- 图片标题
  create_user INTEGER NOT NULL, -- 创建用户id
  update_time TIMESTAMP(6) WITHOUT TIME ZONE, -- 更新时间
  update_user INTEGER, -- 更新用户id
  group_code CHARACTER VARYING(32) -- 分组代码,guid
);
COMMENT ON TABLE ctt_material_pic IS '推广素材表--tom';
COMMENT ON COLUMN ctt_material_pic.pic IS '图片路径';
COMMENT ON COLUMN ctt_material_pic.create_time IS '创建时间';
COMMENT ON COLUMN ctt_material_pic.download_count IS '下载次数';
COMMENT ON COLUMN ctt_material_pic.language IS '类型（1文字，2图片）';
COMMENT ON COLUMN ctt_material_pic.status IS '状态';
COMMENT ON COLUMN ctt_material_pic.title IS '图片标题';
COMMENT ON COLUMN ctt_material_pic.create_user IS '创建用户id';
COMMENT ON COLUMN ctt_material_pic.update_time IS '更新时间';
COMMENT ON COLUMN ctt_material_pic.update_user IS '更新用户id';
COMMENT ON COLUMN ctt_material_pic.group_code IS '分组代码,guid';

CREATE TABLE IF NOT EXISTS  ctt_material_text (
  id SERIAL4 PRIMARY KEY NOT NULL ,
  language CHARACTER VARYING(32), -- 语言（dict的code）
  title CHARACTER VARYING(100), -- 标题
  content CHARACTER VARYING(20000), -- 内容
  create_time TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, -- 创建时间
  status BOOLEAN DEFAULT true, -- 状态
  create_user INTEGER NOT NULL, -- 创建用户id
  update_time TIMESTAMP(6) WITHOUT TIME ZONE,
  update_user INTEGER, -- 更新用户id
  group_code CHARACTER VARYING(32) -- 分组代码,guid
);
COMMENT ON TABLE ctt_material_text IS '推广素材文字表--lorne';
COMMENT ON COLUMN ctt_material_text.id IS '主键';
COMMENT ON COLUMN ctt_material_text.language IS '语言（dict的code）';
COMMENT ON COLUMN ctt_material_text.title IS '标题';
COMMENT ON COLUMN ctt_material_text.content IS '内容';
COMMENT ON COLUMN ctt_material_text.create_time IS '创建时间';
COMMENT ON COLUMN ctt_material_text.status IS '状态';
COMMENT ON COLUMN ctt_material_text.create_user IS '创建用户id';
COMMENT ON COLUMN ctt_material_text.update_user IS '更新用户id';
COMMENT ON COLUMN ctt_material_text.group_code IS '分组代码,guid';