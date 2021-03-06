-- auto gen by linsen 2018-05-01 11:27:25
--优惠记录视图增加存款订单号 by steffan
drop view if exists  v_preferential_recode;
CREATE OR REPLACE VIEW "v_preferential_recode" AS
 SELECT apa.id,
    apa.user_id,
    apa.apply_time,
    apa.apply_transaction_no AS transaction_no,
    apa.check_state,
    ami.activity_name,
    ami.activity_version,
    app.preferential_audit,
    app.preferential_value,
    ami.activity_terminal_type,
    pr.transaction_no recharge_transaction_no
   FROM ((activity_player_apply apa
     LEFT JOIN activity_message_i18n ami ON ((ami.activity_message_id = apa.activity_message_id)))
     LEFT JOIN activity_player_preferential app ON ((app.activity_player_apply_id = apa.id)))
     left join player_recharge pr on ( apa.player_recharge_id = pr.id and apa.player_recharge_id is not null)
  WHERE ((apa.check_state)::text <> '0'::text)
UNION
 SELECT pf.id,
    pf.player_id AS user_id,
    pt.create_time AS apply_time,
    pt.transaction_no,
    pt.status AS check_state,
    ((pt.transaction_data)::json ->> 'activityName'::text) AS activity_name,
    NULL::character varying AS activity_version,
    pf.audit_favorable_multiple AS preferential_audit,
    pf.favorable AS preferential_value,
    NULL::character varying AS activity_terminal_type,
    ((pt.transaction_data)::json ->> 'rechargeTransactionNo'::text) AS  recharge_transaction_no
   FROM (player_favorable pf
     LEFT JOIN player_transaction pt ON ((pf.player_transaction_id = pt.id)))
  WHERE (((pt.transaction_way)::text = 'manual_favorable'::text) AND ((pt.fund_type)::text = 'artificial_deposit'::text));


COMMENT ON VIEW "v_preferential_recode" IS '优惠记录视图--modify by steffan';