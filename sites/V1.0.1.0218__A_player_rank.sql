-- auto gen by cherry 2016-08-04 21:47:40
  select redo_sqls($$
      ALTER TABLE player_rank ADD COLUMN favorable_audit int4;
$$);

COMMENT ON COLUMN player_rank.favorable_audit IS '优惠稽核';

DROP VIEW IF EXISTS v_player_rank_statistics;
CREATE OR REPLACE VIEW v_player_rank_statistics AS
 SELECT pr.id,
    pr.rank_name,
    pr.rank_code,
    pr.risk_marker,
    pr.create_user,
    pr.create_time,
    pr.remark,
    pr.online_pay_min,
    pr.online_pay_max,
    pr.is_fee,
    pr.fee_time,
    pr.free_count,
    pr.max_fee,
    pr.fee_type,
    pr.fee_money,
    pr.is_return_fee,
    pr.reach_money,
    pr.max_return_fee,
    pr.return_time,
    pr.return_fee_count,
    pr.return_type,
    pr.return_money,
    pr.withdraw_time_limit,
    pr.withdraw_free_count,
    pr.withdraw_max_fee,
    pr.withdraw_fee_type,
    pr.withdraw_fee_num,
    pr.withdraw_check_status,
    pr.withdraw_check_time,
    pr.withdraw_excess_check_status,
    pr.withdraw_excess_check_num,
    pr.withdraw_excess_check_time,
    pr.withdraw_max_num,
    pr.withdraw_min_num,
    pr.withdraw_normal_audit,
    pr.withdraw_admin_cost,
    pr.withdraw_relax_credit,
    pr.withdraw_discount_audit,
    pr.is_withdraw_limit,
    pr.withdraw_count,
    pr.built_in,
    pr.status,
    pr.is_take_turns,
    pr.take_turns,
	  pr.favorable_audit,
    ( SELECT count(1) AS count
           FROM (user_player a
             JOIN sys_user b ON ((a.id = b.id)))
          WHERE (a.rank_id = pr.id)) AS player_num,
    ( SELECT count(1) AS count
           FROM pay_rank
          WHERE (pay_rank.player_rank_id = pr.id)) AS pay_account_num
   FROM player_rank pr
  WHERE ((pr.status)::text = '1'::text);