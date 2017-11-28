-- auto gen by george 2017-11-03 17:47:54
UPDATE user_player up
   SET recharge_total = t.recharge_amount, recharge_count = t.num
  FROM (
        SELECT player_id, SUM(recharge_amount) recharge_amount, count(id) num
          FROM player_recharge
					WHERE recharge_status='2' or recharge_status='5'
         GROUP BY player_id
        ) t
  WHERE up.id = t.player_id;