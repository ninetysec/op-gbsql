-- auto gen by kevice 2015-10-09 21:57:15

DROP VIEW IF EXISTS v_notice_send_text;
CREATE OR REPLACE VIEW v_notice_send_text AS
 SELECT s.id,
    s.text_id,
    s.publish_method,
    s.comet_subscribe_type,
    s.remind_method,
    s.locale,
    s.orig_send_id,
    s.status,
    s.receiver_group_type,
    s.receiver_group_id,
    s.update_time AS send_time,
    s.cron_exp,
    t.title,
    t.content,
    t.create_user,
    t.create_username,
    t.create_time,
    t.event_type,
    t.remarks
   FROM notice_send s
     LEFT JOIN notice_text t ON s.text_id = t.id;

ALTER TABLE v_notice_send_text
  OWNER TO postgres;
COMMENT ON VIEW v_notice_send_text
  IS '发送的通知信息';

ALTER TABLE notice_send DROP COLUMN IF EXISTS timing;


select redo_sqls($$
   ALTER TABLE notice_receiver_group ADD COLUMN name_column character varying(64);
   ALTER TABLE notice_text ADD COLUMN publish_method character varying(16);
$$);
COMMENT ON COLUMN notice_receiver_group.name_column IS '群组名称在具体群组表中的字段名';
COMMENT ON COLUMN notice_text.publish_method IS '发布方式代码，字典类型publish_method(notice模块)';


update notice_receiver_group set name_column = 'rank_name' where id = 1;
update notice_receiver_group set define_table = 'v_player_tag_all', name_column = 'tag_name' where id = 3;
update notice_receiver_group set name_column = 'name' where id = 5;
update notice_receiver_group set name_column = 'username' where id = 6;

ALTER TABLE notice_receiver_group ALTER COLUMN name_column SET NOT NULL;




