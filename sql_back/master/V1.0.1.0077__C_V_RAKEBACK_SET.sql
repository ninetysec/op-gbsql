-- auto gen by jeff 2015-09-17 14:15:33
--- 创建返水视图
CREATE OR REPLACE VIEW v_rakeback_set AS SELECT
                                    rs. ID,
                                    rs. NAME,
                                    rs.create_time,
                                    rs.status,
                                    (
                                      SELECT
                                    COUNT (1)
                                      FROM
                                        user_player
                                      WHERE
                                        rakeback_id = rs. ID
                                    ) player_count,
                                    COALESCE (uar. COUNT, 0) agent_count
                                  FROM
                                    rakeback_set rs
                                    LEFT JOIN (
                                                SELECT
                                                  COUNT (1),
                                                  rakeback_id
                                                FROM
                                                  user_agent_rakeback
                                                WHERE
                                                  user_id IN (
                                                    SELECT
                                                      ID
                                                    FROM
                                                      user_agent
                                                    WHERE
                                                      parent_id NOTNULL
                                                  )
                                                GROUP BY
                                                  rakeback_id
                                              ) uar ON uar.rakeback_id = rs. ID
                                  WHERE
                                    rs.status <> '2'