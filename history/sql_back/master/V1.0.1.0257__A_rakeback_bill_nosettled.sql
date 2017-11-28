-- auto gen by cheery 2015-12-11 01:28:58
--修改返水未出账单表字段
ALTER TABLE rakeback_bill_nosettled DROP COLUMN IF EXISTS statistics_time ;

 select redo_sqls($$
     ALTER TABLE rakeback_bill_nosettled ADD COLUMN create_time timestamp(6);
$$);

COMMENT ON COLUMN rakeback_bill_nosettled.create_time IS '创建时间';

--修改返水api表字段
select redo_sqls($$
   ALTER TABLE rakeback_api_nosettled ADD COLUMN effective_transaction numeric(20,2) DEFAULT 0;
	ALTER TABLE rakeback_api_nosettled ADD COLUMN profit_loss numeric(20,2) DEFAULT 0;
ALTER TABLE rakeback_api_nosettled ADD COLUMN rakeback NUMERIC(20,2) DEFAULT 0;
$$);
COMMENT ON COLUMN rakeback_api_nosettled.effective_transaction IS '有效交易量';
COMMENT ON COLUMN rakeback_api_nosettled.profit_loss IS '总交易盈亏';
COMMENT ON COLUMN rakeback_api_nosettled.rakeback IS '返水';
ALTER TABLE rakeback_api_nosettled DROP COLUMN IF EXISTS rakeback_total ;

--修改未出账返佣账单字段
 select redo_sqls($$
ALTER TABLE rebate_bill_nosettled ADD COLUMN effective_transaction numeric(20,2) DEFAULT 0;
ALTER TABLE rebate_bill_nosettled ADD COLUMN profit_loss numeric(20,2) DEFAULT 0;
ALTER TABLE rebate_bill_nosettled ADD COLUMN refund_fee NUMERIC(20,2) DEFAULT 0;
ALTER TABLE rebate_bill_nosettled ADD COLUMN recommend numeric(20,2) DEFAULT 0;
ALTER TABLE rebate_bill_nosettled ADD COLUMN preferential_value numeric(20,2) DEFAULT 0;
ALTER TABLE rebate_bill_nosettled ADD COLUMN apportion NUMERIC(20,2) DEFAULT 0;
ALTER TABLE rebate_bill_nosettled ADD COLUMN rakeback NUMERIC(20,2) DEFAULT 0;
$$);

COMMENT ON COLUMN rebate_bill_nosettled.effective_transaction IS '有效交易量';
COMMENT ON COLUMN rebate_bill_nosettled.profit_loss IS '总交易盈亏';
COMMENT ON COLUMN rebate_bill_nosettled.refund_fee IS '返手续费';
COMMENT ON COLUMN rebate_bill_nosettled.recommend IS '推荐优惠';
COMMENT ON COLUMN rebate_bill_nosettled.preferential_value IS '优惠';
COMMENT ON COLUMN rebate_bill_nosettled.apportion IS '分摊费用';
COMMENT ON COLUMN rebate_bill_nosettled.rakeback IS '返水';

--修改未出账返佣玩家字段
 select redo_sqls($$
ALTER TABLE rebate_player_nosettled ADD COLUMN refund_fee numeric(20,2) DEFAULT 0;
ALTER TABLE rebate_player_nosettled ADD COLUMN recommend numeric(20,2) DEFAULT 0;
ALTER TABLE rebate_player_nosettled ADD COLUMN rakeback NUMERIC(20,2) DEFAULT 0;
ALTER TABLE rebate_player_nosettled ADD COLUMN apportion numeric(20,2) DEFAULT 0;
$$);

COMMENT ON COLUMN rebate_player_nosettled.refund_fee IS '返手续费';
COMMENT ON COLUMN rebate_player_nosettled.recommend IS '推荐优惠';
COMMENT ON COLUMN rebate_player_nosettled.rakeback IS '优惠';
COMMENT ON COLUMN rebate_player_nosettled.apportion IS '分摊费用';

--修改未出账返佣api表字段
 select redo_sqls($$
   ALTER TABLE rebate_api_nosettled ADD COLUMN effective_transaction numeric(20,2) DEFAULT 0;
	ALTER TABLE rebate_api_nosettled ADD COLUMN profit_loss numeric(20,2) DEFAULT 0;
$$);
COMMENT ON COLUMN rebate_api_nosettled.effective_transaction IS '有效交易量';
COMMENT ON COLUMN rebate_api_nosettled.profit_loss IS '总交易盈亏';

DROP VIEW IF EXISTS v_rebate_report ;
DROP VIEW IF EXISTS v_top_agent_ratio ;
DROP VIEW IF EXISTS v_agent_rebate ;


SELECT redo_sqls($$
  ALTER TABLE rebate_agent ADD COLUMN apportion NUMERIC(20,2);
$$);



ALTER TABLE rebate_agent DROP COLUMN IF EXISTS  deduct_expenses;
ALTER TABLE rebate_agent_nosettled DROP COLUMN IF EXISTS  deduct_expenses;
ALTER TABLE rebate_player_nosettled DROP COLUMN IF EXISTS  deduct_expenses;
ALTER TABLE rebate_player DROP COLUMN IF EXISTS  deduct_expenses;

CREATE OR REPLACE VIEW  v_rebate_report AS
 SELECT sra.id,
    sr.id AS rebate_bill_id,
    sra.agent_name,
    su.username,
    sra.effective_player,
    sra.effective_transaction,
    sra.profit_loss,
    sra.deposit_amount,
    sra.withdrawal_amount,
    sra.rakeback,
    sra.refund_fee,
    sra.preferential_value,
    sra.apportion,
    sra.rebate_total,
    sra.rebate_actual,
    sr.lssuing_state,
    sr.start_time,
    sr.end_time,
    sr.period
   FROM (((rebate_bill sr
     LEFT JOIN rebate_agent sra ON ((sr.id = sra.rebate_bill_id)))
     LEFT JOIN user_agent ua ON ((sra.agent_id = ua.id)))
     LEFT JOIN sys_user su ON ((ua.parent_id = su.id)))
  WHERE ((sra.id IS NOT NULL) AND (sr.end_time >= (now() - '90 days'::interval)));

CREATE OR REPLACE VIEW v_agent_rebate AS
 SELECT sb.id,
    su.username,
    srp.effective_transaction,
    srp.profit_loss,
    srp.deposit_amount,
    srp.withdrawal_amount,
    srp.rakeback,
    srp.preferential_value,
    srp.apportion,
    srp.rebate_total,
    srp.agent_id
   FROM ((rebate_player srp
     LEFT JOIN sys_user su ON ((srp.user_id = su.id)))
     LEFT JOIN rebate_bill sb ON ((srp.rebate_bill_id = sb.id)))
  WHERE ((su.user_type)::text = '24'::text);


