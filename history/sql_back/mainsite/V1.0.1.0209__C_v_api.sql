-- auto gen by cherry 2016-01-06 14:53:10
DROP VIEW IF EXISTS v_api;
CREATE OR REPLACE VIEW "v_api" AS
 SELECT a1.id,
    a1.status,
    a1.order_num,
    a1.maintain_start_time,
    a1.maintain_end_time,
    a1.code,
    a1.domain,
    ( SELECT string_agg((a.api_type_id)::text, ','::text) AS type1
           FROM api_type_relation a
          WHERE (a.api_id = a1.id)) AS first_category,
    ( SELECT string_agg((api_gametype_relation.game_type)::text, ','::text) AS type2
           FROM api_gametype_relation
          WHERE (api_gametype_relation.api_id = a1.id)) AS second_category,
    (( SELECT count(1) AS count
           FROM game gm
          WHERE (gm.api_id = a1.id)))::integer AS game_count,
    (( SELECT count(1) AS count
           FROM site_api sa
          WHERE (sa.api_id = a1.id)))::integer AS site_count,
    a2.id AS api_i18n_id,
    a2.name,
    a2.cover,
    a2.introduce_status,
    a2.introduce_content,
    a2.locale
   FROM (api a1
     LEFT JOIN api_i18n a2 ON ((a1.id = a2.api_id)))
  ORDER BY a1.id;
COMMENT ON VIEW "v_api" IS 'API视图 add by river';

DROP VIEW IF EXISTS v_game;
CREATE OR REPLACE VIEW "v_game" AS
 SELECT a1.id,
    a1.api_id,
    a1.game_type,
    a1.order_num,
    a1.url,
    a1.status,
    a1.code,
    a1.api_type_id,
    a1.maintain_start_time,
    a1.maintain_end_time,
    a2.id AS game_i18n_id,
    a2.name,
    a2.cover,
    a2.locale,
    a2.introduce_status,
    a2.game_introduce
   FROM (game a1
     LEFT JOIN game_i18n a2 ON ((a1.id = a2.game_id)))
  ORDER BY a1.id;
COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';


CREATE TABLE IF NOT EXISTS sys_export
(
  id serial4 NOT NULL, -- 主键
  service character varying(100), -- 服务对象
  method character varying(100), -- 服务方法
  export_type character varying(50), -- 导出类型
  file_name character varying(50) NOT NULL, -- 导出文件名
  file_suffix character varying(12) NOT NULL, -- 文件后缀
  export_condition bytea, -- 筛选条件
  create_time timestamp(6) without time zone, -- 创建时间
  status character varying(32), -- 状态
  code character varying(20), -- 密码
  origin_confition character varying(1000), -- 原始条件
  param character varying(255), -- 参数类型
  file_path character varying(500), -- 文件路径
  username character varying(32) NOT NULL, -- 导出用户
  site_id integer, -- 站点ID
  CONSTRAINT sys_export_pkey PRIMARY KEY (id)
);

COMMENT ON TABLE sys_export IS '导出数据历史表--River';
COMMENT ON COLUMN sys_export.id IS '主键';
COMMENT ON COLUMN sys_export.service IS '服务对象';
COMMENT ON COLUMN sys_export.method IS '服务方法';
COMMENT ON COLUMN sys_export.export_type IS '导出类型';
COMMENT ON COLUMN sys_export.file_name IS '导出文件名';
COMMENT ON COLUMN sys_export.file_suffix IS '文件后缀';
COMMENT ON COLUMN sys_export.export_condition IS '筛选条件';
COMMENT ON COLUMN sys_export.create_time IS '创建时间';
COMMENT ON COLUMN sys_export.status IS '状态';
COMMENT ON COLUMN sys_export.code IS '密码';
COMMENT ON COLUMN sys_export.origin_confition IS '原始条件';
COMMENT ON COLUMN sys_export.param IS '参数类型';
COMMENT ON COLUMN sys_export.file_path IS '文件路径';
COMMENT ON COLUMN sys_export.username IS '导出用户';
COMMENT ON COLUMN sys_export.site_id IS '站点ID';

DROP INDEX IF EXISTS in_sys_export_create_time;
  CREATE INDEX "in_sys_export_create_time" ON "sys_export" USING btree (create_time);

--添加导出权限
insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 50301,'资金记录导出','report/fundsLog/exportRecords.html','',503,'',1,'mcenter','test:view','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 50301);

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 50201,'交易记录导出','report/gameTransaction/exportRecords.html','',502,'',1,'mcenter','test:view','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 50201);