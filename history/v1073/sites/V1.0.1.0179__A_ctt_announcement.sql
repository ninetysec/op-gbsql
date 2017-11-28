-- auto gen by admin 2016-06-27 14:46:35
 select redo_sqls($$
        ALTER TABLE ctt_announcement  ADD COLUMN announcement_type varchar(2);
$$);

COMMENT ON COLUMN ctt_announcement.announcement_type IS '公告类型';

update ctt_announcement set announcement_type='1' where announcement_type is null;

update sys_resource set icon='icon-logoguanli' where id=602;

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

            WHEN (now() > ca.end_time) THEN 'expired'::text

            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 'wait'::text

            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 'using'::text

            ELSE NULL::text

        END AS use_status,

        CASE

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

            WHEN (now() > ca.end_time) THEN 3

            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2

            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1

            WHEN (ca.order_num IS NOT NULL) THEN 0

            ELSE NULL::integer

        END, ca.order_num DESC NULLS LAST, ca.create_time DESC))::integer AS my_order_num

   FROM ctt_carousel ca

  ORDER BY

        CASE

            WHEN (now() > ca.end_time) THEN 3

            WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2

            WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1

            WHEN (ca.order_num IS NOT NULL) THEN 0

            ELSE NULL::integer

        END, ca.type, ca.order_num, ca.create_time DESC;

COMMENT ON VIEW "v_ctt_carousel" IS '轮播广告视图 add by river';