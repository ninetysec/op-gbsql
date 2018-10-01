-- auto gen by steffan 2018-09-28 16:11:29
 select redo_sqls($$
    alter table player_rank add column "is_deposit_company_all" BOOLEAN;
    alter table player_rank add column "deposit_company_bank" varchar(256);
    alter table player_rank add column "is_deposit_online_all" BOOLEAN;
    alter table player_rank add column "deposit_online_bank"  varchar(256);
  $$);
  COMMENT ON COLUMN player_rank.is_deposit_company_all IS '是否收取或者返还所有公司入款渠道';
  COMMENT ON COLUMN player_rank.deposit_company_bank IS '公司入款收取或者返还渠道:银行固定为bank_pay,第三方:第三方的bank_name';
  COMMENT ON COLUMN player_rank.is_deposit_online_all IS '是否收取或者返还所有线上支付入款渠道';
  COMMENT ON COLUMN player_rank.deposit_online_bank IS '线上支付收取或者返还渠道:银行固定为bank_pay,第三方:第三方的bank_name';