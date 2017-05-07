-- auto gen by bruce 2016-10-01 11:29:44
DROP VIEW If EXISTS v_player_tag_all;
CREATE OR REPLACE VIEW "v_player_tag_all" AS
   SELECT
        a.id,
        a.player_id,
        a.tag_id,
        b.tag_name,
        b.tag_type,
        b.tag_describe,
        u.default_locale,
        u.username,
        u.status,
        b.built_in
       FROM player_tag a
         LEFT JOIN tags b ON a.tag_id = b.id
         LEFT JOIN sys_user u ON a.player_id = u.id;