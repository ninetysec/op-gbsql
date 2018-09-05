-- auto gen by linsen 2018-07-30 17:14:43
--支付配置增加约束 by mical
SELECT redo_sqls($$
	ALTER TABLE pay_api_provider ADD CONSTRAINT "pay_api_provider_channel_code" UNIQUE ("channel_code");
$$);