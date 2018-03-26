-- auto gen by cherry 2018-03-26 16:22:35
--删除皇家体育的玩家脏数据（条件：vuz 开头，且api_id =21 ）
DELETE  FROM player_api where api_id =21 AND (money=0 or money is NULL) AND player_id in(SELECT user_id FROM player_api_account WHERE account like 'vuz%' AND api_id=21);

DELETE  FROM player_api_account WHERE api_id =21 AND account like 'vuz%' AND user_id not in(SELECT player_id from player_api WHERE api_id=21 AND money>0);

