-- auto gen by cherry 2016-03-04 10:11:01
--将同一个eventType的code置为同一个 不区别语言版本
update notice_tmpl SET group_code = '45872c3f0036c74280fd647c683899f1' WHERE event_type ='PLAYER_REGISTER_SUCCESS' AND group_code != '45872c3f0036c74280fd647c683899f1';

update notice_tmpl SET group_code = '2744e8b83fd125c381bef3fc8d0898cd' WHERE event_type ='AGENT_REGISTER_SUCCESS' AND group_code != '2744e8b83fd125c381bef3fc8d0898cd';