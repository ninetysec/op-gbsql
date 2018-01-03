-- auto gen by cherry 2017-07-24 14:33:26
ALTER TABLE rakeback_bill DROP CONSTRAINT IF EXISTS rakeback_bill_ct_uc;

SELECT redo_sqls($$
ALTER TABLE rakeback_bill ADD CONSTRAINT rakeback_bill_st_uc UNIQUE(start_time);
ALTER TABLE rakeback_api ADD CONSTRAINT rakeback_player_rpag_uc UNIQUE(rakeback_bill_id, player_id, api_id, game_type);
$$);

