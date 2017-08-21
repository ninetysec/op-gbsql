-- auto gen by cherry 2017-08-21 16:20:10
CREATE OR REPLACE VIEW "v_preferential_recode" AS
 SELECT apa.id,
    apa.user_id,
    apa.apply_time,
    apa.check_state,
    ami.activity_name,
    ami.activity_version,
    app.preferential_audit,
    app.preferential_value
   FROM activity_player_apply apa
     LEFT JOIN activity_message_i18n ami ON ami.activity_message_id = apa.activity_message_id
     LEFT JOIN activity_player_preferential app ON app.activity_player_apply_id = apa.id
		WHERE apa.check_state!='0'
UNION
 SELECT pf.id,
    pf.player_id AS user_id,
    pt.create_time AS apply_time,
    pt.status AS check_state,
    ((pt.transaction_data)::json ->> 'activityName'::text) AS activity_name,
    NULL::character varying AS activity_version,
    pf.audit_favorable_multiple AS preferential_audit,
    pf.favorable AS preferential_value
   FROM (player_favorable pf
     LEFT JOIN player_transaction pt ON ((pf.player_transaction_id = pt.id)))
  WHERE (((pt.transaction_way)::text = 'manual_favorable'::text) AND ((pt.fund_type)::text = 'artificial_deposit'::text));


COMMENT ON VIEW "v_preferential_recode" IS '优惠记录视图';