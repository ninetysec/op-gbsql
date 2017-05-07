-- auto gen by cheery 2015-11-06 14:48:49
DROP VIEW IF EXISTS v_favorable_order;
select redo_sqls($$
    ALTER TABLE activity_player_apply ADD COLUMN player_recharge_id int4;
    ALTER TABLE player_favorable ADD COLUMN transaction_no varchar(32);
    ALTER TABLE player_favorable ADD COLUMN favorable_source varchar(32);
  $$);
COMMENT ON COLUMN activity_player_apply.player_recharge_id IS '存款id';
COMMENT ON COLUMN player_favorable.transaction_no IS '交易流水号';
COMMENT ON COLUMN player_favorable.favorable_source IS '优惠来源fund.favorable_source(存款优惠,活动优惠,手动优惠,返水优惠)';


CREATE  OR REPLACE VIEW v_favorable_order AS
  (SELECT t1.id,  t1.apply_time as create_time,
                  (case WHEN t2.preferential_form='percentage_handsel' THEN t2.preferential_value*t3.recharge_amount
                   WHEN t2.preferential_form='regular_handsel' THEN t2.preferential_value END) AS favorable,NULL AS transaction_no,
     NULL AS status,NULL AS favorable_source,t3.transaction_no recharge_transaction_no
   FROM activity_player_apply t1
     LEFT JOIN activity_way_relation t2 ON t1.activity_message_id = t2.activity_message_id
     LEFT JOIN player_recharge t3 ON t1.player_recharge_id = t3.id
   WHERE check_state='1' )
  union all
  (SELECT t1.id, t2.create_time,t1.favorable ,t1.transaction_no,t2.status,t1.favorable_source,t3.transaction_no recharge_transaction_no
   FROM player_favorable t1
     LEFT JOIN player_transaction t2 ON t2.id = t1.player_transaction_id
     LEFT JOIN player_recharge t3 ON t1.player_recharge_id = t3.id);

COMMENT ON VIEW v_favorable_order IS '查看所有优惠订单--cherry';
