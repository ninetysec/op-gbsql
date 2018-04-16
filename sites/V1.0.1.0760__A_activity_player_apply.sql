-- auto gen by linsen 2018-04-16 21:53:35

-- 活动玩家申请表增加申请交易号字段 by steffan
select redo_sqls($$
	alter table activity_player_apply add column "apply_transaction_no" varchar(32)  ;
$$);
COMMENT ON COLUMN  "activity_player_apply"."apply_transaction_no" IS '申请优惠交易号: 生成优惠时,作为优惠数据的player_transaction表的交易号';

