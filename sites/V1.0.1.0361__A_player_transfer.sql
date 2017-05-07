-- auto gen by cherry 2016-12-24 17:08:50
 select redo_sqls($$
       ALTER TABLE player_transfer ADD CONSTRAINT "uc_player_transfer_api_trans_id" UNIQUE ("api_trans_id");
$$);
