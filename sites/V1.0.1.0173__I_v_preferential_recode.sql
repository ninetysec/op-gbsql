-- auto gen by bruce 2016-06-16 11:23:41
drop view if EXISTS v_preferential_recode;
CREATE OR REPLACE VIEW v_preferential_recode AS
SELECT e.id,
    e.activity_message_id,
    e.user_id,
    e.user_name,
    e.apply_time,
    e.check_state,
    e.start_time,
    e.end_time,
    e.activity_name,
    e.activity_version,
    e.activity_type_code,
	  e.is_audit,
    d.preferential_value,
    d.preferential_audit
   FROM (( SELECT b.id,
            b.activity_message_id,
            b.user_id,
            b.user_name,
            b.apply_time,
            b.check_state,
            b.start_time,
            b.end_time,
            c.activity_name,
            c.activity_version,
            f.activity_type_code,
			      g.is_audit
           FROM ((activity_player_apply b
             JOIN activity_message f ON ((b.activity_message_id = f.id)))
						JOIN  activity_rule g ON b.activity_message_id=g.activity_message_id
             LEFT JOIN activity_message_i18n c ON ((b.activity_message_id = c.activity_message_id)))) e
     LEFT JOIN activity_player_preferential d ON (((e.id = d.activity_player_apply_id) AND (e.activity_message_id = d.activity_message_id))))
  ORDER BY e.apply_time DESC;

UPDATE sys_resource SET "privilege"='t' WHERE ("id"='48');