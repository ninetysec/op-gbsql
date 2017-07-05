-- auto gen by cherry 2017-07-05 21:36:08
ALTER TABLE player_transfer DROP CONSTRAINT IF EXISTS uc_player_transfer_api_trans_id;
 select redo_sqls($$
       ALTER TABLE player_transfer ADD CONSTRAINT "uc_player_transfer_apiid_api_trans_id" UNIQUE ("api_id","api_trans_id");
$$);