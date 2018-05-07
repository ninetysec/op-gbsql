-- auto gen by linsen 2018-05-07 09:02:31
--增加活动优惠详情字段 by steffan

select redo_sqls($$
	alter table  activity_player_preferential add column preferential_data  text;
$$);

COMMENT ON COLUMN  "activity_player_preferential"."preferential_data" IS '优惠详情';

