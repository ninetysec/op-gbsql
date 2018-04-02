-- auto gen by linsen 2018-03-28 15:25:46
--修改玩家咨询视图添加玩家手机号 by younger
DROP VIEW IF EXISTS v_player_advisory;
CREATE OR REPLACE VIEW "v_player_advisory" AS
 SELECT pa.id,
    (( SELECT array_to_json(array_agg(par.*)) AS array_to_json
           FROM ( SELECT player_advisory_read.user_id
                   FROM player_advisory_read
                  WHERE ((player_advisory_read.player_advisory_id = pa.id) AND (player_advisory_read.player_advisory_reply_id IS NULL))) par))::text AS read_user_id,
    pa.advisory_type,
    pa.advisory_title,
    pa.advisory_content,
    pa.advisory_time,
    pa.player_id,
    pa.reply_count,
    pa.question_type,
    pa.continue_quiz_id,
    pa.continue_quiz_count,
    pa.latest_time,
    pa.status,
    su.username,
    reg.reply_title,
    reg.reply_content,
    reg.reply_time,
    reg.user_id,
    pa.player_delete,
    uu.username AS reply_username,
     ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = su.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = su.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone_way_status
   FROM (((player_advisory pa
     LEFT JOIN sys_user su ON ((pa.player_id = su.id)))
     LEFT JOIN ( SELECT pari.id,
            pari.reply_title,
            pari.reply_content,
            pari.reply_time,
            pari.user_id,
            pari.player_advisory_id
           FROM player_advisory_reply pari
          WHERE (pari.id = ( SELECT max(player_advisory_reply.id) AS max
                   FROM player_advisory_reply
                  WHERE (player_advisory_reply.player_advisory_id = pari.player_advisory_id)))) reg ON ((reg.player_advisory_id = pa.id)))
     LEFT JOIN sys_user uu ON ((reg.user_id = uu.id)));
COMMENT ON VIEW "v_player_advisory" IS '咨询视图-orange-Edit by Leisure -younger';



--修改玩家在线视图添加手机号 by younger
DROP VIEW IF EXISTS v_player_online;
CREATE OR REPLACE VIEW "v_player_online" AS
 SELECT s.id,
    s.username,
    s.real_name,
    s.login_time,
    s.login_ip,
    s.login_ip_dict_code,
    s.last_active_time,
    s.use_line,
    s.last_login_time,
    s.last_login_ip,
    s.last_login_ip_dict_code,
    s.total_online_time,
    string_agg(((pgl.game_id)::character varying)::text, ','::text) AS gameids,
    string_agg(((pgl.api_id)::character varying)::text, ','::text) AS apiids,
    s.session_key,
    u.wallet_balance,
    u.freezing_funds_balance,
    u.rank_id,
    u.channel_terminal,
    s.terminal,
    u.user_agent_id,
     ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = s.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = s.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone_way_status
   FROM ((user_player u
     JOIN sys_user s ON ((s.id = u.id)))
     LEFT JOIN player_game_log pgl ON (((pgl.user_id = s.id) AND ((pgl.session_key)::text = (s.session_key)::text))))
  WHERE ((s.session_key IS NOT NULL) AND ((s.login_time > s.last_logout_time) OR (s.last_logout_time IS NULL)) AND (s.last_active_time > (now() - '00:30:00'::interval)))
  GROUP BY s.id, s.username, s.real_name, s.login_time, s.login_ip, s.login_ip_dict_code, s.last_active_time, s.use_line, s.last_login_time, s.last_login_ip, s.last_login_ip_dict_code, s.total_online_time, s.session_key, u.wallet_balance, u.freezing_funds_balance, u.rank_id, u.channel_terminal, s.terminal, u.user_agent_id;

COMMENT ON VIEW "v_player_online" IS '在线玩家视图 edit by linsen -younger';