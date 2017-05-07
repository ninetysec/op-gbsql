-- auto gen by loong 2015-10-23 17:17:04

-- sys_user user_type 注释修改
COMMENT ON COLUMN "sys_user"."user_type" IS '用户类型：0运维，1运营，11运营子账号，2站长，21站长子账号，22总代，221总代子账号，23代理，231代理子账号，24玩家';


DROP VIEW IF EXISTS v_report_fund;
create or REPLACE view v_report_fund as
SELECT
	all_main.*,
	su.username,
(SELECT username from sys_user where id = (SELECT owner_id  from sys_user where id = su.owner_id))top_agent_name,
(SELECT username FROM sys_user where id = su.owner_id) agent_name,
(SELECT username FROM sys_user where id = all_main.operate_id) operate_name

 FROM (
	SELECT
			pt.id,
			pt.api_money,
			'backwater' as type,
			pt.remark remark,
			pt.failure_reason,
			pt.transaction_no,

			sbp.player_id player_id, --玩家id,
			sbp.operate_id operate_id, --操作人id,
			sbp.reason_title reason_title, --原因标题,
			sbp.reason_content reason_content, --原因内容,
			sbp.remark check_remark,--备注,
			sbp.settlement_state as sub_status, --状态,operation.settlement_state
			sbp.backwater_total backwater_total, --返水金额,
			sbp.backwater_actual backwater_actual, -- 实际返水,
			sbp.id transaction_id , --关联,
			sb.settlement_name describe, --描述,
			sb.start_time start_time, --返利开始时间,
			sb.end_time end_time, --返利结束时间,
			sbp.settlement_time create_time, --创建时间,
			NULL bank_order, --银行单号
			NULL sub_type,
			pt.completion_time,
			COALESCE(pt.transaction_money,sbp.backwater_total)money,
			pt.balance,
			case  when pt.status ISNULL THEN (CASE when sbp.settlement_state = 'reject_lssuing' THEN 'reject'
when sbp.settlement_state = 'pending_lssuing' THEN 'pending'
when sbp.settlement_state = 'lssuing' THEN 'lssuing' else sbp.settlement_state end) ELSE pt.status end ,
			null parent_type,
			sbp.id as source_id
		FROM
			settlement_backwater_player sbp
		LEFT JOIN settlement_backwater sb ON sb. ID = sbp.settlement_backwater_id
		LEFT JOIN (SELECT * from player_transaction where transaction_type ='backwater') pt on pt.source_id = sbp.id


		UNION
	-------------------------视图

	SELECT
		pt.id,
		pt.api_money,
		pt.transaction_type as type,
		pt.remark remark,
		pt.failure_reason,
		pt.transaction_no,
		--main.*,
		main.player_id, --玩家id,
		main.operate_id, --操作人id,
		main.reason_title,--原因标题
		main.reason_content,--原因内容
		main. remark check_remark,--备注
		main.sub_status,--状态 fund.recharge_status
		main.backwater_total ::numeric , --返水金额,
		main.backwater_actual::numeric , -- 实际返水,
		main.transaction_id, --关联,
		main.describe, --描述,
		main.start_time::timestamp , --返利开始时间,
		main.end_time::timestamp , --返利结束时间,
		main.create_time::timestamp , --创建时间,
		main.bank_order,
		main.sub_type,
		pt.completion_time,
		pt.transaction_money money,
		pt.balance,
		pt.status,
		main.parent_type,
		main.id as source_id
	from (
			-------公司存款和线上支付
			SELECT
				player_id player_id, --玩家id,
				check_user_id operate_id, --操作人id,
				NULL reason_title,--原因标题
				check_remark reason_content,--原因内容
				NULL  remark,--备注
				recharge_status sub_status,--状态 fund.recharge_status
				NULL backwater_total, --返水金额,
				NULL backwater_actual, -- 实际返水,
				player_transaction_id transaction_id, --关联,
				NULL describe, --描述,
				NULL start_time, --返利开始时间,
				NULL end_time, --返利结束时间,
				create_time create_time, --创建时间,
				bank_order bank_order,
				recharge_type sub_type,
				recharge_type_parent parent_type,
				id
			FROM
				player_recharge

			UNION

			---提现
			SELECT
				player_id, --玩家id,
				check_user_id, --操作人id,
				check_remark,--原因标题
				NULL ,--原因内容
				NULL,--备注
				withdraw_status,--状态
				NULL, --返水金额,
				NULL, -- 实际返水,
				player_transaction_id, --关联,
				NULL, --描述,
				NULL, --返利开始时间,
				NULL, --返利结束时间,
				create_time, --创建时间,
				NULL,--银行单号
				withdraw_type  sub_type,--类别
				withdraw_type_parent parent_type,
				id
			FROM
				player_withdraw --玩家充值含公司存款和线上支付
		UNION
			SELECT
				player_id player_id, --玩家id,
				check_user_id operate_id, --操作人id,
				NULL reason_title,--原因标题
				check_remark reason_content,--原因内容
				NULL  remark,--备注
				recharge_status sub_status,--状态 fund.recharge_status
				NULL backwater_total, --返水金额,
				NULL backwater_actual, -- 实际返水,
				pf.player_transaction_id transaction_id, --关联,
		(SELECT array_to_json(array_agg(row_to_json(aa))) from (select activity_name as name,activity_version as LOCAL from activity_message_i18n where activity_message_id =  pf.activity_message_id)aa)::TEXT, --描述,
				NULL start_time, --返利开始时间,
				NULL end_time, --返利结束时间,
				create_time create_time, --创建时间,
				bank_order bank_order,
				recharge_type sub_type,
				null parent_type,
				pf.id
			FROM
				player_favorable pf LEFT JOIN player_recharge pr on pf.player_recharge_id = pr.id --玩家充值含公司存款和线上支付
	)main LEFT JOIN player_transaction pt on main.transaction_id = pt.id
)as all_main LEFT JOIN sys_user su on all_main.player_id = su.id