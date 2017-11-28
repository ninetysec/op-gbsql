drop INDEX IF EXISTS index_game_api_log_api_account;
CREATE INDEX IF NOT EXISTS index_game_api_log_api_account ON game_api_log USING btree (api_account,api_id);

drop INDEX IF EXISTS index_game_api_log_type;
CREATE INDEX IF NOT EXISTS index_game_api_log_type ON game_api_log USING btree (type);

drop INDEX IF EXISTS index_game_api_user_id;
CREATE INDEX IF NOT EXISTS index_game_api_user_id ON game_api_log USING btree (user_id);

drop INDEX IF EXISTS index_game_api_user_name;
CREATE INDEX IF NOT EXISTS index_game_api_user_name ON game_api_log USING btree (user_name);

drop INDEX IF EXISTS index_game_api_transaction_no;
CREATE INDEX IF NOT EXISTS index_game_api_transaction_no ON game_api_log USING btree (transaction_no);


drop INDEX IF EXISTS index_game_api_site_id;
CREATE INDEX IF NOT EXISTS index_game_api_site_id ON game_api_log USING btree (site_id);

