-- auto gen by cherry 2016-01-13 14:55:31
CREATE OR REPLACE VIEW v_player_api AS

SELECT t1.api_id,t1.user_id,t1.user_name,t1.account,t1.currency,t2.id,t2.abnormal_reason,t2.is_transaction,t2.last_recovery_status,t2.last_recovery_time,t2.money,t2.synchronization_status,t2.synchronization_time
FROM player_api_account t1
LEFT JOIN player_api t2 ON t1.api_id = t2.api_id AND t1.user_id = t2.player_id;

COMMENT ON VIEW v_player_api IS '玩家API信息视图';

 select redo_sqls($$
       ALTER TABLE player_api_account ADD COLUMN last_login_time timestamp(6);
			ALTER TABLE player_api_account ADD COLUMN additional_result  text;
 $$);

COMMENT ON COLUMN player_api_account.last_login_time IS '最后登录时间';

COMMENT ON COLUMN player_api_account.additional_result IS '其他数据';
