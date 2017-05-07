-- auto gen by orange 2015-12-27 17:18:18

DROP VIEW IF EXISTS v_player_advisory;


CREATE OR REPLACE VIEW "v_player_advisory" AS
 SELECT a.id,
    (( SELECT array_to_json(array_agg(row_to_json(aa.*))) AS array_to_json
           FROM ( SELECT player_advisory_read.user_id
                   FROM player_advisory_read
                  WHERE (player_advisory_read.player_advisory_id = a.id)) aa))::text AS read_user_id,
    a.advisory_type,
    a.advisory_title,
    a.advisory_content,
    a.advisory_time,
    a.player_id,
    a.reply_count,
    a.question_type,
    a.continue_quiz_id,
    a.continue_quiz_count,
    a.latest_time,
    a.status,
    s.username,
    reg.reply_title,
    reg.reply_content,
    reg.reply_time,
    reg.user_id
   FROM ((player_advisory a
     LEFT JOIN sys_user s ON ((a.player_id = s.id)))
     LEFT JOIN ( SELECT t2.id,
            t2.reply_title,
            t2.reply_content,
            t2.reply_time,
            t2.user_id,
            t2.player_advisory_id
           FROM (( SELECT max(player_advisory_reply.id) AS id
                   FROM player_advisory_reply
                  GROUP BY player_advisory_reply.player_advisory_id) t1
             LEFT JOIN player_advisory_reply t2 ON ((t1.id = t2.id)))
          ORDER BY t2.player_advisory_id DESC) reg ON ((reg.player_advisory_id = a.id)))
  ORDER BY a.id DESC;

ALTER TABLE "v_player_advisory" OWNER TO "postgres";

COMMENT ON VIEW "v_player_advisory" IS '咨询视图-orange';





