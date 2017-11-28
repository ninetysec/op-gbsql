-- auto gen by cheery 2015-11-02 13:54:16
ALTER TABLE "site_api" ALTER COLUMN "id" DROP DEFAULT;

DROP SEQUENCE IF EXISTS site_api_id_seq;

DROP VIEW IF EXISTS v_player_advisory;

CREATE OR REPLACE VIEW "v_player_advisory" AS
SELECT
    A . ID,
    A .advisory_type,
    A .advisory_title,
    A .advisory_content,
    A .advisory_time,
    A .player_id,
    A .reply_count,
    A .question_type,
    A .continue_quiz_id,
    A .continue_quiz_count,
    A .latest_time,
    A .status,
    s.username,
    reg.reply_title,
    reg.reply_content,
    reg.reply_time,
    reg.user_id
  FROM
    player_advisory A
    LEFT JOIN sys_user s ON A .player_id = s. ID
    LEFT JOIN (
                SELECT
                  t2. ID,
                  t2.reply_title,
                  t2.reply_content,
                  t2.reply_time,
                  t2.user_id,
                  t2.player_advisory_id
                FROM
                  (
                    SELECT
                      MAX (player_advisory_reply. ID) AS ID
                    FROM
                      player_advisory_reply
                    GROUP BY
                      player_advisory_reply.player_advisory_id
                  ) t1
                  LEFT JOIN player_advisory_reply t2 ON t1. ID = t2. ID
                ORDER BY
                  t2.player_advisory_id DESC
              ) reg ON
                      reg.player_advisory_id = A . ID
  ORDER BY
    A . ID DESC;

ALTER TABLE "v_player_advisory" OWNER TO "postgres";
COMMENT ON VIEW v_player_advisory IS '咨询视图';

