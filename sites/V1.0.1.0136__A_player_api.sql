-- auto gen by admin 2016-05-06 21:35:40
 select redo_sqls($$
        ALTER TABLE player_api ADD COLUMN task_status bool DEFAULT FALSE;
$$);

COMMENT on COLUMN player_api.task_status is '是否在任务进行回收中';

DROP VIEW IF EXISTS v_player_api;
CREATE OR REPLACE VIEW  "v_player_api" AS
 SELECT t1.api_id,
    t1.user_id,
    t1.user_name,
    t1.account,
    t1.currency,
    t1.locale,
    t1.last_login_ip,
    t1.last_login_time,
    t1.additional_result,
    t1.password,
    t2.id,
    t2.abnormal_reason,
    t2.is_transaction,
    t2.last_recovery_status,
    t2.last_recovery_time,
    t2.money,
    t2.synchronization_status,
    t2.synchronization_time,
		t2.task_status,
    ( SELECT t3.transfer_state
           FROM player_transfer t3
          WHERE ((t3.user_id = t1.user_id) AND (t3.api_id = t1.api_id) AND ((t3.transfer_source)::text = 'recovery'::text))
          ORDER BY t3.id DESC
         LIMIT 1) AS transfer_state
   FROM (player_api_account t1
     LEFT JOIN player_api t2 ON (((t1.api_id = t2.api_id) AND (t1.user_id = t2.player_id))));

COMMENT ON VIEW "v_player_api" IS 'playerApi视图--cherry';

UPDATE "sys_resource" SET "url"='fund/transaction/list.html' where permission='fund:fundrecord' and subsys_code='pcenter';
