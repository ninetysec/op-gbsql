-- auto gen by cherry 2016-09-12 14:52:03
 select redo_sqls($$
	alter table ctt_logo add COLUMN flash_logo_path CHARACTER VARYING(1000);
	ALTER TABLE ctt_logo   ADD COLUMN is_read boolean;
	ALTER TABLE ctt_logo   ADD COLUMN is_remove boolean;
	ALTER TABLE ctt_document   ADD COLUMN is_read boolean;
	ALTER TABLE ctt_document   ADD COLUMN is_remove boolean;
	ALTER TABLE activity_message   ADD COLUMN is_read boolean;
	ALTER TABLE activity_message   ADD COLUMN is_remove boolean;
$$);

COMMENT ON COLUMN ctt_logo.flash_logo_path is 'Flash LOGO图片地址';
COMMENT ON COLUMN ctt_logo.is_read  IS '是否已读';
COMMENT ON COLUMN ctt_logo.is_remove  IS '是否下架';
COMMENT ON COLUMN ctt_document.is_read  IS '是否已读';
COMMENT ON COLUMN ctt_document.is_remove  IS '是否下架';
COMMENT ON COLUMN activity_message.is_read  IS '是否已读';
COMMENT ON COLUMN activity_message.is_remove  IS '是否下架';

drop view if exists v_ctt_logo_user;

CREATE OR REPLACE VIEW "v_ctt_logo_user" AS

 SELECT a.id,

    a.name,

    a.start_time,

    a.end_time,

    a.create_user,

    a.create_time,

    a.update_user,

    a.update_time,

        CASE

            WHEN (( SELECT count(1) AS count

               FROM ctt_logo l

              WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.publish_time

               FROM ctt_logo l

              WHERE (l.check_parent_id = a.id))

            ELSE a.publish_time

        END AS publish_time,

    a.is_default,

    a.check_user_id,

    a.check_time,

    a.reason_title,

    a.reason_content,

    a.author,

    b.user_type,

    b.username,

    a.is_delete,

    a.check_parent_id,

		CASE

				WHEN (( SELECT count(1) AS count

					 FROM ctt_logo l

					WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.check_status

					 FROM ctt_logo l

					WHERE (l.check_parent_id = a.id))

				ELSE a.check_status

		END AS check_status,

		CASE

				WHEN (( SELECT count(1) AS count

					 FROM ctt_logo l

					WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.path

					 FROM ctt_logo l

					WHERE (l.check_parent_id = a.id))

				ELSE a.path

		END AS path,

    a.is_read,

    a.is_remove,

    CASE

				WHEN (( SELECT count(1) AS count

					 FROM ctt_logo l

					WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.flash_logo_path

					 FROM ctt_logo l

					WHERE (l.check_parent_id = a.id))

				ELSE a.flash_logo_path

		END AS flash_logo_path

   FROM (( SELECT l.id,

            l.name,

            l.path,

            l.start_time,

            l.end_time,

            l.create_user,

            l.create_time,

            l.update_user,

            l.update_time,

            l.publish_time,

            l.is_default,

            l.check_user_id,

            l.check_status,

            l.check_time,

            l.reason_title,

            l.reason_content,

            l.is_delete,

            l.check_parent_id,

            COALESCE(l.update_user, l.create_user) AS author,

            l.is_read,

            l.is_remove,

            l.flash_logo_path

           FROM ctt_logo l) a

     LEFT JOIN sys_user b ON ((a.author = b.id)))

  WHERE (a.check_parent_id IS NULL);

COMMENT ON VIEW "v_ctt_logo_user" IS 'LOGO提交审核人信息--river';

drop view if exists v_ctt_document_user;

CREATE OR REPLACE VIEW "v_ctt_document_user" AS
 SELECT a.id,

    a.parent_id,

    a.create_user_id,

    a.create_time,

    a.build_in,

    a.status,

    a.update_user_id,

    a.update_time,

    a.check_user_id,

    a.check_status,

    a.check_time,

    a.publish_time,

    a.reason_title,

    a.reason_content,

    a.author,

    b.user_type,

    b.username,

    a.is_delete,

    a.is_read,

    a.is_remove

   FROM (( SELECT l.id,

            l.parent_id,

            l.create_user_id,

            l.create_time,

            l.build_in,

            l.status,

            l.update_user_id,

            l.update_time,

            l.check_user_id,

            l.check_status,

            l.check_time,

            l.publish_time,

            l.reason_title,

            l.reason_content,

            l.is_delete,

            COALESCE(l.update_user_id, l.create_user_id) AS author,

            l.is_read,

            l.is_remove

           FROM ctt_document l) a

     LEFT JOIN sys_user b ON ((a.author = b.id)));

COMMENT ON VIEW "v_ctt_document_user" IS '文案提交审核人信息 river';

drop view if exists v_activity_message_user;

CREATE OR REPLACE VIEW "v_activity_message_user" AS

 SELECT a.id,

    a.start_time,

    a.end_time,

    a.activity_state,

    a.create_time,

    a.user_id,

    a.user_name,

    a.activity_classify_key,

    a.activity_type_code,

    a.is_display,

    a.is_deleted,

    a.update_user_id,

    a.update_time,

    a.check_user_id,

    a.check_status,

    a.check_time,

    a.reason_title,

    a.reason_content,

    a.author,

    b.user_type,

    b.username,a.is_read,a.is_remove

   FROM (( SELECT l.id,

            l.start_time,

            l.end_time,

            l.activity_state,

            l.create_time,

            l.user_id,

            l.user_name,

            l.activity_classify_key,

            l.activity_type_code,

            l.is_display,

            l.is_deleted,

            l.update_user_id,

            l.update_time,

            l.check_user_id,

            l.check_status,

            l.check_time,

            l.reason_title,

            l.reason_content,

            COALESCE(l.update_user_id, l.user_id) AS author,

            l.is_read,

            l.is_remove

           FROM activity_message l) a

     LEFT JOIN sys_user b ON ((a.author = b.id)));

COMMENT ON VIEW "v_activity_message_user" IS '优惠活动信息视图 river';

drop view if exists v_activity_message;

CREATE OR REPLACE VIEW "v_activity_message" AS

 SELECT a.id,

    b.name,

    a.activity_state,

    a.start_time,

    a.end_time,

    a.activity_classify_key,

    c.activity_name,

    c.activity_version,

    a.is_display,

    c.activity_cover,

    ( SELECT count(1) AS count

           FROM activity_player_apply d

          WHERE ((d.activity_message_id = a.id) AND ((d.check_state)::text = '1'::text))) AS acount,

    b.code,

    c.activity_description,

    e.is_audit,

    b.logo,

    b.introduce,

        CASE

            WHEN ((a.start_time <= now()) AND (a.end_time >= now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text

            WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text

            WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text

            WHEN ((a.activity_state)::text = 'draft'::text) THEN 'notStarted'::text

            ELSE NULL::text

        END AS states,

    a.is_deleted,

    a.check_status,

    ((e.rank)::text || ','::text) AS rankid,

    a.create_time,

    e.preferential_amount_limit,

    e.is_all_rank,

    c.activity_affiliated,

    a.order_num,

    e.deposit_way,a.is_read,a.is_remove

   FROM (((activity_message a

     LEFT JOIN activity_type b ON (((a.activity_type_code)::text = (b.code)::text)))

     LEFT JOIN activity_message_i18n c ON ((c.activity_message_id = a.id)))

     LEFT JOIN activity_rule e ON ((e.activity_message_id = a.id)));