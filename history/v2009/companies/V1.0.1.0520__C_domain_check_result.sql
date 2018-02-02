-- auto gen by george 2018-01-16 20:24:18

DROP VIEW IF EXISTS v_domain_check_result_statistic;
DROP TABLE IF EXISTS domain_check_result;
DROP TABLE IF EXISTS domain_check_result_batch_log;

DROP SEQUENCE IF EXISTS domain_check_result_batch_log_id_seq;
DROP SEQUENCE IF EXISTS domain_check_result_id_seq;

drop index if exists index_domain_check_result_domain;
drop index if exists index_domain_check_result_site_id;
drop index if exists index_domain_check_result_batch_log;


CREATE SEQUENCE domain_check_result_batch_log_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


CREATE TABLE "domain_check_result_batch_log" (
"id" varchar(32)   DEFAULT nextval('domain_check_result_batch_log_id_seq'::regclass) NOT NULL,
"site_id" int4 NOT NULL,
"check_point_count" int4 NOT NULL,
"status" int4 NOT NULL,
"check_by" varchar(100) ,
"check_time" timestamptz(6) DEFAULT now(),
"create_time" timestamptz(6) DEFAULT now(),
CONSTRAINT "domain_check_result_batch_log_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON COLUMN "domain_check_result_batch_log"."id" IS '主键';

COMMENT ON COLUMN "domain_check_result_batch_log"."site_id" IS 'site id';

COMMENT ON COLUMN "domain_check_result_batch_log"."check_point_count" IS '检测点数量';

COMMENT ON COLUMN "domain_check_result_batch_log"."status" IS '导入状态';

COMMENT ON COLUMN "domain_check_result_batch_log"."check_by" IS '检测人';

COMMENT ON COLUMN "domain_check_result_batch_log"."check_time" IS '检测时间';

COMMENT ON COLUMN "domain_check_result_batch_log"."create_time" IS '入库时间';

COMMENT ON TABLE "domain_check_result_batch_log" IS '域名检测导入日志表-- steffan';

CREATE INDEX "index_domain_check_result_batch_log" ON  "domain_check_result_batch_log" USING btree (site_id);



CREATE SEQUENCE domain_check_result_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 10;



CREATE TABLE "domain_check_result" (
"id" varchar(32)  DEFAULT nextval('domain_check_result_id_seq'::regclass) NOT NULL,
"domain" varchar(100)  NOT NULL,
"site_id" int4 NOT NULL,
"status" varchar(32) NOT NULL,
"detail" varchar(512) ,
"server_province" varchar(32) NOT NULL,
"server_city" varchar(32) ,
"isp" varchar(32) NOT NULL,
CONSTRAINT "domain_check_result_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON COLUMN "domain_check_result"."id" IS '主键';

COMMENT ON COLUMN "domain_check_result"."domain" IS '域名';

COMMENT ON COLUMN "domain_check_result"."site_id" IS '站点id';

COMMENT ON COLUMN "domain_check_result"."status" IS '结果状态';

COMMENT ON COLUMN "domain_check_result"."detail" IS '状态详情';

COMMENT ON COLUMN "domain_check_result"."server_province" IS '省';

COMMENT ON COLUMN "domain_check_result"."server_city" IS '市';

COMMENT ON COLUMN "domain_check_result"."isp" IS '运营商';

COMMENT ON TABLE "domain_check_result" IS '域名检测结果表-- steffan';


CREATE INDEX "index_domain_check_result_domain" ON  "domain_check_result" USING btree (domain);

CREATE INDEX "index_domain_check_result_site_id" ON  "domain_check_result" USING btree (site_id);


CREATE OR REPLACE VIEW "v_domain_check_result_statistic" AS
 SELECT rs.domain,
    rs.page_url,
    sum(
        CASE
            WHEN ((rs.status)::text = 'WALLED_OFF'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS wallof,
    sum(
        CASE
            WHEN ((rs.status)::text = 'BE_HIJACKED'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS behijached,
    sum(
        CASE
            WHEN ((rs.status)::text = 'UNRESOLVED'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS unresolved,
    sum(
        CASE
            WHEN ((rs.status)::text = 'SERVER_UNREACHABLE'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS serverunreachable,
    sum(
        CASE
            WHEN ((rs.status)::text = 'UNAUTHORIZED'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS unauthorized,
    sum(
        CASE
            WHEN ((rs.status)::text = 'REDIRECT'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS redirect,
    sum(
        CASE
            WHEN ((rs.status)::text = 'UNKNOWN_ERR'::text) THEN rs.cnt
            ELSE (0)::bigint
        END) AS unknown
   FROM ( SELECT count(dcr.status) AS cnt,
            dcr.status,
            dcr.domain,
            sd.page_url
           FROM (domain_check_result dcr
             LEFT JOIN sys_domain sd ON (((dcr.domain)::text = (sd.domain)::text)))
          WHERE ((sd.is_enable = true) AND (sd.is_deleted = false) AND ((sd.resolve_status)::text = '5'::text))
          GROUP BY dcr.status, dcr.domain, sd.page_url) rs
  GROUP BY rs.domain, rs.page_url
  ORDER BY rs.domain;

COMMENT ON VIEW "v_domain_check_result_statistic" IS '域名检测统计视图 - steffan';
