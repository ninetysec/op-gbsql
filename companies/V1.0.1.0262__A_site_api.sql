-- auto gen by cherry 2017-03-28 14:48:22
select redo_sqls($$
    ALTER TABLE site_api ADD COLUMN mobile_order_num int4;
$$);
COMMENT ON COLUMN site_api.mobile_order_num is '手机API排序';

UPDATE site_api SET mobile_order_num = 1 WHERE api_id = 9;
UPDATE site_api SET mobile_order_num = 2 WHERE api_id = 16;
UPDATE site_api SET mobile_order_num = 3 WHERE api_id = 10;
UPDATE site_api SET mobile_order_num = 4 WHERE api_id = 17;
UPDATE site_api SET mobile_order_num = 5 WHERE api_id = 5;
UPDATE site_api SET mobile_order_num = 6 WHERE api_id = 7;
UPDATE site_api SET mobile_order_num = 7 WHERE api_id = 1;
UPDATE site_api SET mobile_order_num = 8 WHERE api_id = 8;

UPDATE site_api SET mobile_order_num = 2 WHERE api_id = 3;
UPDATE site_api SET mobile_order_num = 3 WHERE api_id = 6;
UPDATE site_api SET mobile_order_num = 4 WHERE api_id = 15;

UPDATE site_api SET mobile_order_num = 1 WHERE api_id = 12;
UPDATE site_api SET mobile_order_num = 2 WHERE api_id = 19;
UPDATE site_api SET mobile_order_num = 3 WHERE api_id = 4;

UPDATE site_api SET mobile_order_num = 1 WHERE api_id = 2;
UPDATE site_api SET mobile_order_num = 2 WHERE api_id = 11;

UPDATE site_api SET mobile_order_num = 200 WHERE api_id = 14;

DROP VIEW IF EXISTS v_site_api;
CREATE OR REPLACE VIEW "v_site_api" AS
 SELECT t.id,
    t.site_id,
    t.status,
    ( SELECT count(1) AS count
           FROM site_game sg
          WHERE (sg.api_id = t.id)) AS game_count,
    '0' AS player_count,
    t.api_id,
    t.api_status,
    t.api_real_status,
    t.maintain_start_time,
    t.maintain_end_time,
    t.terminal,
		t.mobile_order_num
   FROM ( SELECT sa.id,
            sa.site_id,
            sa.api_id,
            sa.status,
            sa.order_num,
            sa.code,
            sa.terminal,
			sa.mobile_order_num,
            api.status AS api_status,
                CASE
                    WHEN ((now() > api.maintain_start_time) AND (now() < api.maintain_end_time)) THEN 'maintain'::character varying
                    ELSE api.status
                END AS api_real_status,
            api.maintain_start_time,
            api.maintain_end_time
           FROM (site_api sa
             LEFT JOIN api ON ((sa.api_id = api.id)))) t;

COMMENT ON VIEW "v_site_api" IS '站点API视图--river';