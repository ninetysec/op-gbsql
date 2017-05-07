-- auto gen by cherry 2016-07-14 16:33:04
DROP INDEX if  EXISTS idx_player_withdraw_withdraw_status_id;
CREATE INDEX IF NOT EXISTS idx_player_withdraw_withdraw_status_id
    ON player_withdraw USING btree (withdraw_status, id DESC);