-- auto gen by cherry 2016-02-22 14:09:05
 select redo_sqls($$
       ALTER TABLE player_transfer ADD COLUMN ip int8
      $$);

COMMENT ON COLUMN player_transfer.ip IS '转账ip地址';

DROP VIEW IF EXISTS v_player_api;
CREATE  or REPLACE VIEW v_player_api AS
 SELECT t1.api_id,
    t1.user_id,
    t1.user_name,
    t1.account,
    t1.currency,
		t1.locale,
		t1.last_login_ip,
		t1.last_login_time,
		t1.additional_result,
		t1."password",
    t2.id,
    t2.abnormal_reason,
    t2.is_transaction,
    t2.last_recovery_status,
    t2.last_recovery_time,
    t2.money,
    t2.synchronization_status,
    t2.synchronization_time
   FROM (player_api_account t1
     LEFT JOIN player_api t2 ON (((t1.api_id = t2.api_id) AND (t1.user_id = t2.player_id))));

COMMENT ON VIEW v_player_api IS 'playerApi视图--cherry';