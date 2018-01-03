-- auto gen by cherry 2016-11-21 20:03:45
CREATE INDEX IF NOT EXISTS player_advisory_read_idx1 ON player_advisory_read (player_advisory_id);

DROP VIEW IF EXISTS v_player_advisory;
CREATE OR REPLACE VIEW v_player_advisory AS
SELECT pa.id,
       (SELECT array_to_json(array_agg(par.*)) AS array_to_json
          FROM ( SELECT user_id
                   FROM player_advisory_read
                  WHERE player_advisory_id = pa.id AND player_advisory_reply_id IS NULL
               ) par
       )::TEXT AS read_user_id,
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
       pa.player_delete
  FROM player_advisory pa
       LEFT JOIN sys_user su ON pa.player_id = su.id
       LEFT JOIN (SELECT id,
                         reply_title,
                         reply_content,
                         reply_time,
                         user_id,
                         player_advisory_id
                    FROM player_advisory_reply pari
                   WHERE id = (SELECT max(id) FROM player_advisory_reply WHERE player_advisory_id = pari.player_advisory_id)
                 ) reg ON reg.player_advisory_id = pa.id;

COMMENT ON VIEW v_player_advisory IS '咨询视图-orange-Edit by Leisure';