-- auto gen by cherry 2016-02-05 11:39:41
DROP view IF EXISTS v_player_tag_all;

CREATE OR REPLACE VIEW v_player_tag_all AS

 SELECT a.id,

    a.player_id,

    a.tag_id,

    b.tag_name,

    b.tag_type,

    b.tag_describe,

    u.default_locale,

    u.username,

		u.status

   FROM ((player_tag a

     LEFT JOIN tags b ON ((a.tag_id = b.id)))

     LEFT JOIN sys_user u ON ((a.player_id = u.id)));