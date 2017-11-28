-- auto gen by cheery 2015-11-17 11:56:44
--创建文案表 add by River 2015-11-17
CREATE TABLE IF NOT EXISTS ctt_document
(
  id             SERIAL4, -- 主键
  parent_id      INTEGER, -- 父项id
  create_user_id INTEGER, -- 创建人id
  create_time    TIMESTAMP WITHOUT TIME ZONE, -- 创建时间
  build_in       BOOLEAN, -- 是否系统默认
  status         CHARACTER VARYING(255), -- 启用状态content.draft_status(已启用,已停用)
  update_user_id INTEGER, -- 更新人id
  update_time    TIMESTAMP WITHOUT TIME ZONE, -- 更新时间
  check_user_id  INTEGER, -- 审核人id
  check_status   CHARACTER VARYING(255), -- 审核状态content.check_status(通过,失败,待审核)
  check_time     TIMESTAMP WITHOUT TIME ZONE, -- 审核时间
  publish_time   TIMESTAMP WITHOUT TIME ZONE, -- 发布时间
  CONSTRAINT ctt_document_pkey PRIMARY KEY (id)
);
COMMENT ON COLUMN ctt_document.id IS '主键';
COMMENT ON COLUMN ctt_document.parent_id IS '父项id';
COMMENT ON COLUMN ctt_document.create_user_id IS '创建人id';
COMMENT ON COLUMN ctt_document.create_time IS '创建时间';
COMMENT ON COLUMN ctt_document.build_in IS '是否系统默认';
COMMENT ON COLUMN ctt_document.status IS '启用状态content.draft_status(已启用,已停用)';
COMMENT ON COLUMN ctt_document.update_user_id IS '更新人id';
COMMENT ON COLUMN ctt_document.update_time IS '更新时间';
COMMENT ON COLUMN ctt_document.check_user_id IS '审核人id';
COMMENT ON COLUMN ctt_document.check_status IS '审核状态content.check_status(通过,失败,待审核)';
COMMENT ON COLUMN ctt_document.check_time IS '审核时间';
COMMENT ON COLUMN ctt_document.publish_time IS '发布时间';

--创建文案国际化表 add by River 2015-11-17
CREATE TABLE IF NOT EXISTS ctt_document_i18n
(
  id              SERIAL4, -- 主键
  document_id     INTEGER, -- 文案信息ID
  title           CHARACTER VARYING(100), -- 标题
  content         CHARACTER VARYING(20000), -- 内容
  content_default CHARACTER VARYING(20000), -- 默认内容
  local           CHARACTER VARYING(5), -- 语言版本
  CONSTRAINT ctt_document_i18n_pkey PRIMARY KEY (id)
);
COMMENT ON COLUMN ctt_document_i18n.id IS '主键';
COMMENT ON COLUMN ctt_document_i18n.document_id IS '文案信息ID';
COMMENT ON COLUMN ctt_document_i18n.title IS '标题';
COMMENT ON COLUMN ctt_document_i18n.content IS '内容';
COMMENT ON COLUMN ctt_document_i18n.content_default IS '默认内容';
COMMENT ON COLUMN ctt_document_i18n.local IS '语言版本';

--创建文案视图 add by River 2015-11-17
DROP VIEW IF EXISTS v_ctt_document;
CREATE OR REPLACE VIEW v_ctt_document AS
  SELECT
    t.id,
    t.parent_id,
    t.create_user_id,
    t.create_time,
    t.build_in,
    t.status,
    t.update_user_id,
    t.update_time,
    t.check_user_id,
    t.check_status,
    t.check_time,
    t.publish_time,
    (SELECT count(1) AS languagecount
     FROM ctt_document_i18n a
     WHERE a.document_id = t.id) AS language_count,
    (SELECT count(1) AS childcount
     FROM ctt_document b
     WHERE b.parent_id = t.id)   AS child_count
  FROM ctt_document t
  ORDER BY t.build_in DESC;

--收款账户表添加字段
select redo_sqls($$
  ALTER TABLE "pay_account" ADD COLUMN "channel_json" varchar(500);
$$);

COMMENT ON COLUMN "pay_account"."channel_json" IS '第三方接口的参数json[{column:"字段",value:"值"}]';
