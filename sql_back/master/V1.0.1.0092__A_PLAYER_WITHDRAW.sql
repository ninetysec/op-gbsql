-- auto gen by cheery 2015-09-21 06:43:23
--删除玩家取款视图
DROP VIEW IF EXISTS v_player_withdraw;

ALTER TABLE player_withdraw DROP COLUMN IF EXISTS reason_id;

ALTER TABLE player_withdraw DROP COLUMN IF EXISTS artificial_reason_id;

--新增原因标题字段
select redo_sqls($$
	 ALTER TABLE player_withdraw rename lock_person to lock_person_id ;

   ALTER TABLE player_withdraw ADD COLUMN reason_title varchar(128);

   ALTER TABLE player_withdraw ADD COLUMN artificial_reason_title varchar(128);

 $$);

COMMENT ON COLUMN player_withdraw.reason_title IS '原因标题';

COMMENT ON COLUMN player_withdraw.artificial_reason_title IS '人工申请原因标题';

--创建视图
CREATE OR REPLACE VIEW v_player_withdraw AS
SELECT
t1.*,
	t4.withdraw_count AS success_count,
	(
		date_part(
			'epoch' :: TEXT,
			(
				(t1.check_closing_time) :: TIMESTAMP WITH TIME ZONE - now()
			)
		) / (60) :: DOUBLE PRECISION
	) AS closing_time,
	P .remark,
	t2.username,
	t3.username AS check_user_name,
	t4.rank_id,
	t4.nation,
	t4.province,
	t4.real_name,
	t2.create_time AS register_time,
	t2.status,
	t5.rank_name,
	t6.username AS agent_name,
	t9.username AS general_agent_name,
	t10.username AS lock_person_name
FROM
	(
		(
			(
				(
					(
						(
							(
								(
									player_withdraw t1
									LEFT JOIN player_transaction P ON (
										(
											t1.player_transaction_id = P . ID
										)
									)
								)
								LEFT JOIN sys_user t2 ON ((t1.player_id = t2. ID))
							)
							LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3. ID))
						)
						LEFT JOIN user_player t4 ON ((t4. ID = t1.player_id))
					)
					LEFT JOIN player_rank t5 ON ((t5. ID = t4.rank_id))
				)
				LEFT JOIN sys_user t6 ON ((t6. ID = t4.user_agent_id))
			)
			LEFT JOIN sys_user t10 ON ((t10. ID = t1.lock_person_id))
		)
		LEFT JOIN (
			SELECT
				t7. ID,
				t8.username
			FROM
				(
					user_agent t7
					LEFT JOIN sys_user t8 ON ((t8. ID = t7.parent_id))
				)
		) t9 ON ((t9. ID = t4.user_agent_id))
	);
