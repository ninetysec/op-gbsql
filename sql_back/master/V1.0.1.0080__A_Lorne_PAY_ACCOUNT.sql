-- auto gen by loong 2015-09-18 17:37:06
select redo_sqls($$
    DROP VIEW IF EXISTS v_pay_rank;
    DROP VIEW IF EXISTS v_pay_account;
    ALTER TABLE "pay_account" DROP COLUMN "single_deposit_min";
    ALTER TABLE "pay_account" DROP COLUMN "single_deposit_max";
    ALTER TABLE "pay_account" ADD COLUMN "single_deposit_min" int4;
    ALTER TABLE "pay_account" ADD COLUMN "single_deposit_max" int4;
    ALTER TABLE "user_player" ADD COLUMN "total_profit_loss" numeric(20,2) DEFAULT 0;
    ALTER TABLE "user_player" ADD COLUMN "total_trade_volume" numeric(20,2) DEFAULT 0;
    ALTER TABLE "user_player" ADD COLUMN "total_effective_volume" numeric(20,2) DEFAULT 0;
  $$);

COMMENT ON COLUMN "pay_account"."single_deposit_min" IS '单笔存款最小值';

COMMENT ON COLUMN "pay_account"."single_deposit_max" IS '单笔存款最大值';

COMMENT ON COLUMN "user_player"."total_profit_loss" IS '总盈亏';

COMMENT ON COLUMN "user_player"."total_trade_volume" IS '总交易量';

COMMENT ON COLUMN "user_player"."total_effective_volume" IS '总有效交易量';

-- View: v_pay_rank

-- DROP VIEW v_pay_rank;

CREATE OR REPLACE VIEW v_pay_rank AS
 SELECT a.id,
    a.player_rank_id,
    a.pay_account_id,
    a.create_time,
    a.create_user,
    b.pay_name,
    b.account,
    b.full_name,
    b.disable_amount,
    b.pay_key,
    b.status,
    b.create_time AS pay_create_time,
    b.create_user AS pay_create_user,
    b.type,
    b.account_type,
    b.bank_code,
    b.pay_url,
    b.code,
    b.deposit_count,
    b.deposit_total,
    b.deposit_default_count,
    b.deposit_default_total,
    b.single_deposit_min,
    b.single_deposit_max,
    b.effective_minutes,
    c.bank_icon,
    c.bank_district,
    c.type AS bank_type
   FROM pay_rank a
     LEFT JOIN pay_account b ON a.pay_account_id = b.id
     LEFT JOIN bank c ON b.bank_code::text = c.bank_name::text
  ORDER BY b.account_type, b.bank_code;

ALTER TABLE v_pay_rank
  OWNER TO postgres;
COMMENT ON VIEW v_pay_rank
  IS '玩家层级对应支付限制视图--lorne';


-- View: v_pay_account

-- DROP VIEW v_pay_account;

CREATE OR REPLACE VIEW v_pay_account AS
 SELECT pa.id,
    pa.pay_name,
    pa.account,
    pa.full_name,
    pa.disable_amount,
    pa.pay_key,
    pa.status,
    pa.create_time,
    pa.create_user,
    pa.type,
    pa.account_type,
    pa.bank_code,
    pa.pay_url,
    pa.code,
    pa.deposit_count,
    pa.deposit_total,
    pa.deposit_default_count,
    pa.deposit_default_total,
    pa.single_deposit_min,
    pa.single_deposit_max,
    pa.effective_minutes,
    ( SELECT count(1) AS count
           FROM ( SELECT r.pay_account_id
                   FROM pay_rank r
                     JOIN player_rank k ON r.player_rank_id = k.id) pr
          WHERE pr.pay_account_id = pa.id) AS pay_rank_num,
    ( SELECT count(1) AS recharge_num
           FROM player_recharge pr
          WHERE pr.pay_account_id = pa.id AND pr.recharge_status::text = '2'::text) AS recharge_num,
    ( SELECT sum(pr.recharge_amount) AS recharge_amount
           FROM player_recharge pr
          WHERE pr.pay_account_id = pa.id AND pr.recharge_status::text = '2'::text) AS recharge_amount,
    ( SELECT max(COALESCE(pr.create_time, to_date('1900-1-1'::text, 'yyyy-MM-dd'::text)::timestamp without time zone)) AS max
           FROM player_recharge pr
          WHERE pr.pay_account_id = pa.id AND pr.recharge_status::text = '2'::text) AS last_recharge
   FROM pay_account pa;

ALTER TABLE v_pay_account
  OWNER TO postgres;
COMMENT ON VIEW v_pay_account
  IS '收款账户--lorne';
