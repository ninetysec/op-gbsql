-- auto gen by water 2018-01-14 21:55:37

drop VIEW if EXISTS v_system_announcement ;

alter table system_announcement ALTER receive_user_type type varchar(30);

CREATE VIEW v_system_announcement AS SELECT s.id,
                                       s.release_mode,
                                       s.publish_time,
                                       s.publish_user_id,
                                       a.local,
                                       a.title,
                                       a.content,
                                       s.announcement_type,
                                       s.publish_platform,
                                       s.publish_user_name,
                                       s.operate_time,
                                       s.api_id,
                                       s.game_id,
                                       s.timing_send,
                                       s.announcement_subtype,
                                       s.site_id,
                                       s.publish_site_id,
                                       s.receive_user_type
                                     FROM ("gb-companies".system_announcement s
                                       LEFT JOIN "gb-companies".system_announcement_i18n a ON ((a.system_announcement_id = s.id)));
COMMENT ON VIEW "gb-companies".v_system_announcement IS '系统公告视图 - Leo';
