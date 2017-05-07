-- auto gen by admin 2016-07-11 15:36:30

--删除 代理返佣成功  站点开关　邮箱绑定验证码（固定文案）　手动存款成功　玩家返水成功  优惠申请成功  修改站务账单通知  　重置登陆密码成功（固定文案）
DELETE
FROM
	notice_tmpl
WHERE
	event_type IN (
		'AGENT_RAKEBACK_SUCCESS',
		'SWITCH',
		'BIND_EMAIL_VERIFICATION_CODE',
		'MANUAL_DEPOSIT_SUCCESS',
		'PLAYER_REBATE_SUCCESS',
		'PREFERENTIAL_APPLY_SUCCESS',
		'MODIFY_STATION_BILL',
		'FIND_PASSWORD_VERIFICATION_CODE'
	);



--删除子账号相关权限
DELETE from sys_resource WHERE "id"  in ('70301','70303','250101','250103','350101','350103','70304','350104','250104');


  select redo_sqls($$
			ALTER TABLE player_recharge ADD COLUMN check_username VARCHAR(20) NULL;
$$);

COMMENT ON COLUMN player_recharge.check_username IS '审核人账号';

UPDATE sys_resource SET url = 'fund/company/list.html' WHERE url = 'fund/companyDespoit/list.html?search.rechargeStatus=1' AND parent_id = 3;
UPDATE sys_resource SET url = 'fund/online/list.html' WHERE url = 'fund/rechargeOnline/list.html' AND parent_id = 3;

DROP VIEW IF EXISTS v_player_deposit;
CREATE OR REPLACE VIEW "v_player_deposit" AS
  SELECT pr.id,
  su.id AS player_id,
  su.username,
  up.rank_id,
  ra.rank_name,
  ra.risk_marker,
  pr.create_time,
  pr.recharge_type,
  pr.is_first_recharge,
  pr.payer_bank,
  pr.payer_bankcard,
  pr.bank_order,
  pr.recharge_address,
  pr.pay_account_id,
  pa.bank_code,
  pa.full_name,
  pr.counter_fee,
  su.default_currency,
  pr.recharge_amount,
  pr.recharge_total_amount,
  pr.check_status,
  CASE
  WHEN (((pr.recharge_status)::text = '4'::text) AND ((pr.create_time + ((pa.effective_minutes || ' minute'::text))::interval) <= now())) THEN '7'::character varying
  ELSE pr.recharge_status
  END AS recharge_status,
  pr.check_user_id,
  pr.check_username,
  pr.check_time,
  pr.payer_name,
  pr.transaction_no,
  pa.custom_bank_name,
  pa.account,
  pr.recharge_type_parent,
  pr.check_remark,
  pr.failure_title,
  pa.status AS pay_account_status,
  pa.deposit_count,
  up.recharge_count
FROM player_recharge pr
        LEFT JOIN sys_user su ON pr.player_id = su.id
        LEFT JOIN user_player up ON pr.player_id = up.id
        LEFT JOIN player_rank ra ON up.rank_id = ra.id
        LEFT JOIN pay_account pa ON pr.pay_account_id = pa.id
ORDER BY pr.create_time DESC NULLS LAST;