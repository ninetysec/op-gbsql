-- auto gen by cherry 2017-03-09 11:03:38
UPDATE player_game_order SET agentusername=(SELECT agentusername FROM user_player where id=player_id),
agentid=(SELECT agentid FROM user_player where id=player_id),topagentid=(SELECT topagentid FROM user_player where id=player_id),
topagentusername=(SELECT topagentusername FROM user_player where id=player_id)
WHERE agentid is NULL AND topagentid is NULL;
