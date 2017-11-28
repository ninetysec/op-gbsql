-- auto gen by longer 2016-01-29 09:57:31

drop INDEX IF EXISTS uqx_defense_record_client_id_action_code;
CREATE UNIQUE INDEX uqx_defense_record ON defense_record USING BTREE (client_id,action_code,sys_user_id);