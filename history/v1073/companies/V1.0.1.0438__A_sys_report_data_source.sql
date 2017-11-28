-- auto gen by Tony 2017-10-06 16:54:17
CREATE TABLE if not EXISTS "sys_report_datasource" (
"id" int4 NOT NULL,
"name" varchar(16) COLLATE "default",
"url" varchar(128) COLLATE "default" NOT NULL,
"username" varchar(32) COLLATE "default" NOT NULL,
"password" varchar(128) COLLATE "default" NOT NULL,
"initial_size" int4 DEFAULT 0 NOT NULL,
"max_active" int4 DEFAULT 8 NOT NULL,
"min_idle" int4 DEFAULT 1 NOT NULL,
"max_wait" int4,
"remark" varchar(128) COLLATE "default",
"ip" varchar(32) COLLATE "default",
"port" int4,
"dbname" varchar(32) COLLATE "default",
"status" varchar(5) COLLATE "default",
"filters" varchar(128) COLLATE "default",
"connection_properties" varchar(512) COLLATE "default",
"remote_ip" varchar(32) COLLATE "default",
"remote_port" int4,
"idc" varchar(1) COLLATE "default",
"remote_url" varchar(128) COLLATE "default",
CONSTRAINT "pk_sys_report_datasource" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "sys_report_datasource" IS '数据源--Kevice';

COMMENT ON COLUMN "sys_report_datasource"."id" IS '数据源id';

COMMENT ON COLUMN "sys_report_datasource"."name" IS '数据源名称';

COMMENT ON COLUMN "sys_report_datasource"."url" IS '连接url';

COMMENT ON COLUMN "sys_report_datasource"."username" IS '用户名';

COMMENT ON COLUMN "sys_report_datasource"."password" IS '用户名密码';

COMMENT ON COLUMN "sys_report_datasource"."initial_size" IS '初始化时建立物理连接的个数。初始化发生在显示调用init方法，或者第一次getConnection时';

COMMENT ON COLUMN "sys_report_datasource"."max_active" IS '最大连接池数量';

COMMENT ON COLUMN "sys_report_datasource"."min_idle" IS '最小连接池数量';

COMMENT ON COLUMN "sys_report_datasource"."max_wait" IS '获取连接时最大等待时间，单位毫秒';

COMMENT ON COLUMN "sys_report_datasource"."remark" IS '备注';

COMMENT ON COLUMN "sys_report_datasource"."ip" IS '数据库IP';

COMMENT ON COLUMN "sys_report_datasource"."port" IS '数据库端口';

COMMENT ON COLUMN "sys_report_datasource"."dbname" IS '数据库名称';

COMMENT ON COLUMN "sys_report_datasource"."status" IS '状态,枚举,[1, 正常],[2, 停用],[3, 冻结(不记录表)],[4, 未激活/未审核],[5,审核失败]';

COMMENT ON COLUMN "sys_report_datasource"."filters" IS '过滤器,使用逗号隔开,如:config,stat,wall';

COMMENT ON COLUMN "sys_report_datasource"."connection_properties" IS '链接参数';

COMMENT ON COLUMN "sys_report_datasource"."idc" IS '机房标志';

COMMENT ON COLUMN "sys_report_datasource"."remote_url" IS ' 远程数据源链接URL';

insert into sys_report_datasource
select
  "id","name","url","username","password","initial_size",
  "max_active","min_idle","max_wait","remark","ip",
  "port","dbname","status","filters","connection_properties",
  "remote_ip","remote_port","idc","remote_url"
from sys_datasource where id not in(select id from sys_report_datasource);