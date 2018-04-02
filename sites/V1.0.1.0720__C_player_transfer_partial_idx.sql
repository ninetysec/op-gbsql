-- auto gen by linsen 2018-03-30 17:18:45
-- by laser
CREATE INDEX IF NOT EXISTS player_transfer_partial_idx ON player_transfer(user_id, api_id) WHERE transfer_source = 'recovery';