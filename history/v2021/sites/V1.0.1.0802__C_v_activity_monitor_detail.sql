-- auto gen by linsen 2018-05-07 17:43:05
-- 活动效果详情视图 by steffan
drop view if exists v_activity_monitor_detail;

CREATE OR REPLACE VIEW "v_activity_monitor_detail" AS
 SELECT apa.id,
    am.activity_type_code,
    apa.register_time,
    apa.start_time,
    apa.end_time,
    pr.recharge_amount,
    pr.transaction_no,
    pr.recharge_type,
    pr.check_time,
    apa.apply_time,
    apa.apply_transaction_no,
    pp.preferential_value,
    pp.preferential_data,
    apa.check_state
   FROM (((activity_player_apply apa
     LEFT JOIN activity_message am ON ((apa.activity_message_id = am.id)))
     LEFT JOIN player_recharge pr ON ((apa.player_recharge_id = pr.id)))
     LEFT JOIN activity_player_preferential pp ON ((pp.activity_player_apply_id = apa.id)));


COMMENT ON VIEW  "v_activity_monitor_detail" IS '活动效果详情视图 -- create by steffan';