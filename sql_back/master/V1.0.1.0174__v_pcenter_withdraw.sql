-- auto gen by cheery 2015-11-05 08:33:06

CREATE OR REPLACE VIEW "v_pcenter_withdraw" AS
  SELECT p.id,
    p.wallet_balance,
    sys.permission_pwd,
    b.bankcard_master_name,
    b.bankcard_number,
    b.is_default,
    b.bank_name,
    r.withdraw_time_limit,
    r.withdraw_free_count,
    r.withdraw_max_fee,
    r.withdraw_fee_type,
    r.withdraw_fee_num,
    r.withdraw_check_status,
    r.withdraw_check_time,
    r.withdraw_excess_check_status,
    r.withdraw_excess_check_num,
    r.withdraw_excess_check_time,
    r.withdraw_max_num,
    r.withdraw_min_num,
    r.withdraw_count,
    r.is_withdraw_limit,
    r.status
  FROM user_player p
    LEFT JOIN sys_user sys ON sys.id = p.id
    LEFT JOIN user_bankcard b ON b.user_id = p.id
    LEFT JOIN player_rank r ON r.id = p.rank_id
  WHERE b.is_default = true;

ALTER TABLE "v_pcenter_withdraw" OWNER TO "postgres";
COMMENT ON VIEW v_pcenter_withdraw IS '玩家中心-取款视图';