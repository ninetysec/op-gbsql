-- auto gen by bruce 2016-09-27 16:52:52
select redo_sqls($$
    ALTER TABLE tags ADD COLUMN built_in bool;
    ALTER TABLE tags ADD COLUMN quantity int4;
$$);
COMMENT ON COLUMN tags.built_in IS '是否内置';
COMMENT ON COLUMN tags.quantity IS 'vip通道人数';

INSERT INTO "tags" ("tag_name", "tag_type", "tag_describe","built_in","quantity") SELECT 'VIP通道', '0', '有该标签的玩家,可使用VIP通道访问站点.VIP通道地址,请咨询客服获取.','t',100
  WHERE 'TRUE' NOT IN (SELECT built_in FROM tags WHERE built_in='TRUE ');

UPDATE tags SET built_in='false' WHERE built_in is NULL;

DROP VIEW IF EXISTS v_player_tag;
CREATE OR REPLACE VIEW "v_player_tag" AS
    SELECT
        t.id,
        t.tag_name,
        t.tag_describe,
        COALESCE(pt.player_count, (0)::bigint) AS player_count,
        t.built_in,
        t.quantity
    FROM (tags t
         LEFT JOIN ( SELECT count(1) AS player_count,
               player_tag.tag_id
               FROM player_tag
              GROUP BY player_tag.tag_id) pt ON ((pt.tag_id = t.id)))
  WHERE (t.tag_type = 0);

COMMENT ON VIEW "v_player_tag" IS '玩家标签视图 -- Jeff';