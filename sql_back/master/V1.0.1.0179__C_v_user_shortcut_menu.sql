-- auto gen by cheery 2015-11-09 07:09:21
COMMENT ON COLUMN "tags"."tag_type" IS '类别(type=0 玩家标签)';

-----修改玩家快捷菜单视图
DROP VIEW IF EXISTS v_user_shortcut_menu;
CREATE VIEW v_user_shortcut_menu as
  SELECT usu.id,
    usu.user_id,
    usu.resource_id,
    usu.sort,
    sr.name AS resource_name,
    usu.is_default,
    usu.is_delete,
    usu."position",
    sr.url,
    sr.icon
  FROM (user_shortcut_menu usu
    LEFT JOIN sys_resource sr ON ((usu.resource_id = sr.id)));

DROP VIEW IF EXISTS v_ctt_carousel;
CREATE OR REPLACE VIEW v_ctt_carousel AS
  SELECT
    ca.id,
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
    CASE
    WHEN (ca.status <> true) THEN 'stop'::text -- 停用
    WHEN (now() > ca.end_time) THEN 'expired'::text --过期
    WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 'wait'::text --待
    WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 'using'::text
    ELSE NULL::text  END AS use_status,
    CASE
    WHEN (ca.status <> true) THEN 4 --stop
    WHEN (now() > ca.end_time) THEN 3 --expired
    WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2
    WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1
    ELSE NULL::integer
    END AS list_order,
    (SELECT array_to_json(array_agg(row_to_json(aa))) from (select name as name,"language" as language from ctt_carousel_language where carousel_id =  ca.id)aa)::text i18n_json,
    row_number() OVER(partition by ca.type ORDER BY CASE
                                                    WHEN (ca.status <> true) THEN 4 --stop
                                                    WHEN (now() > ca.end_time) THEN 3 --expired
                                                    WHEN ((now() < ca.end_time) AND (now() < ca.start_time)) THEN 2
                                                    WHEN ((now() < ca.end_time) AND (now() > ca.start_time)) THEN 1
                                                    ELSE NULL::integer
                                                    END asc,order_num desc  NULLS last,create_time desc) ::INTEGER AS order_num
  FROM
    ctt_carousel ca
  ORDER BY list_order asc,ca.order_num desc NULLS last,create_time desc;