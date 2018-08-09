-- auto gen by linsen 2018-07-27 14:36:37
-- 修复2018-07-04、2018-07-25返水账单因为玩家更改代理线统计player_count错误

UPDATE rakeback_bill SET player_count=player_lssuing_count + player_reject_count, lssuing_state='all_pay' WHERE period IN ( '2018-07-24', '2018-07-25') AND player_count < player_lssuing_count + player_reject_count;