-- auto gen by linsen 2018-04-30 20:29:37

-- 运营统计表 by martin

CREATE TABLE IF NOT EXISTS operation_summary
(
    id serial4 PRIMARY KEY NOT NULL,
    new_player_pc integer,
		new_player_phone integer,
		new_player_ios integer,
		new_player_android integer,
		new_player_h5 integer,
		new_player_deposit integer,
    deposit_amount numeric(20,2),
    deposit_player integer,
    withdrawal_amount numeric(20,2),
    withdrawal_player integer,
		refuse_withdrawal_amount numeric(20,2),
    effective_transaction_pc numeric(20,2),
		effective_transaction_phone numeric(20,2),
    transaction_profit_loss numeric(20,2),
    rakeback_player integer,
    rakeback_amount numeric(20,2),
		active_pc integer,
    active_phone integer,
    active_ios integer,
    active_android integer,
    active_h5 integer,
		login_num_pc integer,
    login_num_phone integer,
		install_ios integer,
    install_android integer,
		uninstall_ios integer,
    uninstall_android integer,
    static_date date NOT NULL,
		static_time timestamp(6) without time zone,
    static_time_end timestamp(6) without time zone
)
;


COMMENT ON TABLE operation_summary IS '运营统计表--Martin';

COMMENT ON COLUMN operation_summary.id IS '主键';

COMMENT ON COLUMN operation_summary.new_player_pc IS '当天新增玩家数-pc';

COMMENT ON COLUMN operation_summary.new_player_phone  IS '当天新增玩家数-phone';

COMMENT ON COLUMN operation_summary.new_player_ios  IS '当天新增玩家数-ios';

COMMENT ON COLUMN operation_summary.new_player_android IS '当天新增玩家数-android';

COMMENT ON COLUMN operation_summary.new_player_h5 IS '当天新增玩家数-h5';

COMMENT ON COLUMN operation_summary.new_player_deposit  IS '当天新增玩家的存款人数';

COMMENT ON COLUMN operation_summary.deposit_amount  IS '当天存款金额';

COMMENT ON COLUMN operation_summary.deposit_player IS '当天存款的玩家数';

COMMENT ON COLUMN operation_summary.withdrawal_amount IS '当天取款金额';

COMMENT ON COLUMN operation_summary.withdrawal_player IS '当天取款的玩家数';

COMMENT ON COLUMN operation_summary.refuse_withdrawal_amount IS '当天被拒取款金额';

COMMENT ON COLUMN operation_summary.effective_transaction_pc IS '当天有效交易量-pc';

COMMENT ON COLUMN operation_summary.effective_transaction_phone  IS '当天有效交易量-phone';

COMMENT ON COLUMN operation_summary.transaction_profit_loss IS '当天交易盈亏';

COMMENT ON COLUMN operation_summary.rakeback_player IS '当天返水人数';

COMMENT ON COLUMN operation_summary.rakeback_amount IS '当天返水总额';

COMMENT ON COLUMN operation_summary.active_pc IS '当日活跃用户-pc';

COMMENT ON COLUMN operation_summary.active_phone IS '当日活跃用户-phone';

COMMENT ON COLUMN operation_summary.active_ios IS '当日活跃用户-ios';

COMMENT ON COLUMN operation_summary.active_android IS '当日活跃用户-android';

COMMENT ON COLUMN operation_summary.active_h5  IS '当日活跃用户-h5';

COMMENT ON COLUMN operation_summary.login_num_pc IS '当日总登录次数-pc';

COMMENT ON COLUMN operation_summary.login_num_phone  IS '当日总登录次数-phone';

COMMENT ON COLUMN operation_summary.install_ios  IS '当日app安装量-ios';

COMMENT ON COLUMN operation_summary.install_android IS '当日app安装量-android';

COMMENT ON COLUMN operation_summary.uninstall_ios IS '当日app卸载量-ios';

COMMENT ON COLUMN operation_summary.uninstall_android IS '当日app卸载量-android';

COMMENT ON COLUMN operation_summary.static_date IS '统计日期';

COMMENT ON COLUMN operation_summary.static_time  IS '统计起始时间';

COMMENT ON COLUMN operation_summary.static_time_end IS '统计截止时间';