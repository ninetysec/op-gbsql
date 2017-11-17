-- auto gen by george 2017-11-17 15:44:25
CREATE OR REPLACE VIEW "v_credit_record" AS
 SELECT p.id,
    p.site_id,
    p.transaction_no,
    p.pay_amount,
    p.pay_scale,
    p.credict_account_id,
    p.pay_url,
    p.pay_user_name,
    p.ip,
    p.ip_dict_code,
    p.check_user,
    p.check_name,
    p.create_time,
    p.status,
    p.pay_type,
    p.bank_name,
    p.pay_user_id,
    p.quota,
    p.currency,
    p.external_order_no,
    p.background_added,
    p.path,
    p.remark,
    m.pay_name
   FROM (credit_record p
     LEFT JOIN credit_account m ON ((p.credict_account_id = m.id)));

COMMENT ON VIEW "v_credit_record" IS '充值记录查询视图--Leo';