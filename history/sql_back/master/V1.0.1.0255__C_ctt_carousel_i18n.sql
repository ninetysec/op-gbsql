-- auto gen by cheery 2015-12-10 08:55:25
CREATE TABLE IF NOT EXISTS "ctt_carousel_i18n" (
"id" serial4 NOT NULL,
"language" varchar(5),
"name" varchar(40),
"carousel_id" int4,
"cover" varchar(128),
CONSTRAINT "ctt_carousel_i18n_pkey" PRIMARY KEY ("id")
);
COMMENT ON TABLE "ctt_carousel_i18n" IS '轮播广告国际化表 by River';
COMMENT ON COLUMN "ctt_carousel_i18n"."id" IS '主键';
COMMENT ON COLUMN "ctt_carousel_i18n"."language" IS '语言版本';
COMMENT ON COLUMN "ctt_carousel_i18n"."name" IS '图片名称';
COMMENT ON COLUMN "ctt_carousel_i18n"."carousel_id" IS '轮播广告ID';
COMMENT ON COLUMN "ctt_carousel_i18n"."cover" IS '封面';

DROP VIEW IF EXISTS v_ctt_carousel;
CREATE OR REPLACE VIEW "v_ctt_carousel" AS
 SELECT ca.id,
    ca.path,
    ca.start_time,
    ca.end_time,
    ca.create_user,
    ca.create_time,
    ca.update_user,
    ca.update_time,
    ca.publish_time,
    ca.status,
    ca.link,
    ca.type,
    ca.order_num,
        CASE
            WHEN (ca.status <> true) THEN 'stop'::text
            WHEN (now() > ca.end_time) THEN 'expired'::text
            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 'wait'::text
            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 'using'::text
            ELSE NULL::text
        END AS use_status,
        CASE
            WHEN (ca.status <> true) THEN 4
            WHEN (now() > ca.end_time) THEN 3
            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2
            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1
            ELSE NULL::integer
        END AS list_order,
    (( SELECT array_to_json(array_agg(row_to_json(aa.*))) AS array_to_json
           FROM ( SELECT ctt_carousel_i18n.name,
                    ctt_carousel_i18n.cover,
                    ctt_carousel_i18n.language
                   FROM ctt_carousel_i18n
                  WHERE (ctt_carousel_i18n.carousel_id = ca.id)) aa))::text AS i18n_json,
    (row_number() OVER (PARTITION BY ca.type ORDER BY
        CASE
            WHEN (ca.status <> true) THEN 4
            WHEN (now() > ca.end_time) THEN 3
            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2
            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1
            WHEN (ca.order_num IS NOT NULL) THEN 0
            ELSE NULL::integer
        END, ca.order_num DESC NULLS LAST, ca.create_time DESC))::integer AS my_order_num
   FROM ctt_carousel ca
  ORDER BY
        CASE
            WHEN (ca.status <> true) THEN 4
            WHEN (now() > ca.end_time) THEN 3
            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2
            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1
            WHEN (ca.order_num IS NOT NULL) THEN 0
            ELSE NULL::integer
        END, ca.type, ca.order_num, ca.create_time DESC;
COMMENT ON VIEW "v_ctt_carousel" IS '轮播广告视图 add by river';

DROP VIEW IF EXISTS v_ctt_document;
CREATE OR REPLACE VIEW "v_ctt_document" AS
 SELECT t.id,
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
    ( SELECT count(1) AS languagecount
           FROM ctt_document_i18n a
          WHERE (a.document_id = t.id)) AS language_count,
    ( SELECT count(1) AS childcount
           FROM ctt_document b_1
          WHERE (b_1.parent_id = t.id)) AS child_count,
    t.code,
    t.order_num
   FROM ctt_document t
  ORDER BY t.build_in DESC;
COMMENT ON VIEW "v_ctt_document" IS '文案信息视图 add by river';



