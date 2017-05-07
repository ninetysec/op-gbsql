-- auto gen by cherry 2016-09-12 14:22:54
 select redo_sqls($$
	ALTER TABLE operation_profile ADD COLUMN deposit_new_player numeric(20,2);
	ALTER TABLE operation_profile ADD COLUMN expenditure numeric(20,2);
	ALTER TABLE operation_profile ADD COLUMN rakeback_player int4;
	ALTER TABLE operation_profile ADD COLUMN rakeback_amount NUMERIC(20,2);
	ALTER TABLE operation_profile ADD COLUMN favorable_player int4;
	ALTER TABLE operation_profile ADD COLUMN favorable_amount NUMERIC(20,2);
	ALTER TABLE operation_profile ADD COLUMN recommend_player int4;
	ALTER TABLE operation_profile ADD COLUMN recommend_amount NUMERIC(20,2);
	ALTER TABLE operation_profile ADD COLUMN recommend_player int4;
	ALTER TABLE operation_profile ADD COLUMN recommend_amount NUMERIC(20,2);
	ALTER TABLE operation_profile ADD COLUMN refund_player int4;
	ALTER TABLE operation_profile ADD COLUMN refund_amount NUMERIC(20,2);
	ALTER TABLE operation_profile ADD COLUMN rebate_player int4;
	ALTER TABLE operation_profile ADD COLUMN rebate_amount NUMERIC(20,2);
	ALTER TABLE operation_profile ADD COLUMN single_amount NUMERIC(20,2);
$$);

COMMENT ON COLUMN operation_profile.deposit_new_player IS '当天新增玩家存款额';
COMMENT ON COLUMN operation_profile.expenditure IS '当天所有支出(包含返水、人工返水、优惠、人工优惠、推荐、返手续费、返佣)';
COMMENT ON COLUMN operation_profile.rakeback_player IS '当天返水人数';
COMMENT ON COLUMN operation_profile.rakeback_amount IS '当天返水总额';
COMMENT ON COLUMN operation_profile.favorable_player IS '当天优惠人数';
COMMENT ON COLUMN operation_profile.favorable_amount IS '当天优惠总额';
COMMENT ON COLUMN operation_profile.recommend_player IS '当天推荐人数';
COMMENT ON COLUMN operation_profile.recommend_amount IS '当天推荐总额';
COMMENT ON COLUMN operation_profile.recommend_player IS '当天推荐人数';
COMMENT ON COLUMN operation_profile.recommend_amount IS '当天推荐总额';
COMMENT ON COLUMN operation_profile.refund_player IS '当天反手续费人数';
COMMENT ON COLUMN operation_profile.refund_amount IS '当天反手续费总额';
COMMENT ON COLUMN operation_profile.rebate_player IS '当天返佣人数';
COMMENT ON COLUMN operation_profile.rebate_amount IS '当天返佣总额';
COMMENT ON COLUMN operation_profile.single_amount IS '当天交易单量';