-- auto gen by cherry 2016-08-15 15:57:46
CREATE OR REPLACE VIEW v_player_transfer AS
SELECT pt.*,paa.account
FROM player_transfer pt
LEFT JOIN player_api_account paa ON paa.user_id = pt.user_id AND pt.api_id=paa.api_id