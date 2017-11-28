-- auto gen by cherry 2017-03-06 20:11:17
DELETE FROM monitor_config_relation WHERE config_id in(SELECT id FROM monitor_config WHERE rule_instance in ('quotaProcess','rechargeProcess'));
DELETE FROM monitor_config WHERE rule_instance in ('quotaProcess','rechargeProcess');