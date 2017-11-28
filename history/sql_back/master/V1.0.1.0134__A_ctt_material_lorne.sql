-- auto gen by loong 2015-10-22 11:15:23
select redo_sqls($$
    ALTER TABLE "user_bankcard" ADD COLUMN "bank_deposit" varchar(200);
    ALTER TABLE "user_player" ADD COLUMN "create_channel" varchar(1);
  $$);

UPDATE sys_resource SET URL='agent/settlementRebate/report.html' WHERE name='返佣统计'   and subsys_code='mcenterAgent';

COMMENT ON COLUMN "user_bankcard"."bank_deposit" IS '开户行';
COMMENT ON COLUMN "user_player"."create_channel" IS '''创建渠道 字典create_channel'';';

UPDATE sys_resource SET URL='cttMaterial/list.html' WHERE name='推广素材'   and subsys_code='mcenterAgent';
UPDATE "sys_resource" SET "url"='agentAccount/myAccount.html' WHERE ("id"='3502');

INSERT INTO sys_param (MODULE,param_type,param_code,param_value,DEFAULT_value,order_num,remark,active)
  SELECT 'agent','material','login_code','<frame name="footer" scrolling="no" noresize target="main" src="{0}" style="border-style: solid; border-width: 1px; padding: 0">','<frame name="footer" scrolling="no" noresize target="main" src="{0}" style="border-style: solid; border-width: 1px; padding: 0">',1,'内嵌式登录代码',true
  where 'login_code' not in (SELECT param_code from sys_param where module = 'mcenterAgent' and param_type = 'material');




-- Table: ctt_material

-- DROP TABLE ctt_material;
CREATE TABLE IF NOT EXISTS ctt_material
(
  id serial NOT NULL,
  pic character varying(500), -- 图片路径
  create_time timestamp without time zone, -- 创建时间
  download_count integer, -- 下载次数
  type character varying(10), -- 类型（1文字，2图片）
  status boolean, -- 状态
  CONSTRAINT ctt_material_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ctt_material
  OWNER TO postgres;
COMMENT ON TABLE ctt_material
  IS '推广素材表--lorne';
COMMENT ON COLUMN ctt_material.pic IS '图片路径';
COMMENT ON COLUMN ctt_material.create_time IS '创建时间';
COMMENT ON COLUMN ctt_material.download_count IS '下载次数';
COMMENT ON COLUMN ctt_material.type IS '类型（1文字，2图片）';
COMMENT ON COLUMN ctt_material.status IS '状态';

-- Table: ctt_material_detail

-- DROP TABLE ctt_material_detail;
CREATE TABLE IF NOT EXISTS ctt_material_detail
(
  id serial NOT NULL,
  material_id integer, -- ctt_material主键
  language character varying(32), -- 语言（dict的code）
  title character varying(100), -- 标题
  content character varying(20000), -- 内容
  CONSTRAINT ctt_material_detail_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ctt_material_detail
  OWNER TO postgres;
COMMENT ON TABLE ctt_material_detail
  IS '推广素材明细表--lorne';
COMMENT ON COLUMN ctt_material_detail.material_id IS 'ctt_material主键';
COMMENT ON COLUMN ctt_material_detail.language IS '语言（dict的code）';
COMMENT ON COLUMN ctt_material_detail.title IS '标题';
COMMENT ON COLUMN ctt_material_detail.content IS '内容';

