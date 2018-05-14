-- auto gen by linsen 2018-04-11 15:35:58
-- 增加活动分类排序字段 by steffan

select redo_sqls($$
	alter table activity_message  add column "classify_order_num" int4;
$$);

COMMENT ON COLUMN "activity_message"."classify_order_num" IS '活动分类排序';
