-- auto gen by linsen 2018-07-19 10:31:54
-- vv_pay_account by laser
DROP VIEW IF EXISTS vv_pay_account;

CREATE OR REPLACE VIEW vv_pay_account AS
 SELECT pay_account.id,
    pay_account.pay_name,
    pay_account.account,
    pay_account.full_name,
    pay_account.pay_key,
    pay_account.status,
    pay_account.create_time,
    pay_account.create_user,
    pay_account.type,
    pay_account.account_type,
    pay_account.bank_code,
    pay_account.pay_url,
    pay_account.code,
    pay_account.deposit_count,
    pay_account.deposit_total,
    pay_account.deposit_default_count,
    pay_account.deposit_default_total,
    pay_account.effective_minutes,
    pay_account.single_deposit_min,
    pay_account.single_deposit_max,
    pay_account.frozen_time,
    md5(pay_account.channel_json) AS channel_json,
    pay_account.full_rank,
    pay_account.custom_bank_name,
    pay_account.open_acount_name,
    pay_account.qr_code_url,
    pay_account.remark,
    pay_account.terminal,
    pay_account.disable_amount,
    account_information,
    account_prompt
   FROM pay_account
;