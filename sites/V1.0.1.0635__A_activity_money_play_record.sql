-- auto gen by george 2017-12-18 17:38:12

--红包抽奖记录添加时间 add by younger
select redo_sqls($$
   ALTER TABLE activity_money_play_record ADD COLUMN operate_date date;
   ALTER TABLE activity_money_play_record ADD COLUMN start_time timestamp(6);
   ALTER TABLE activity_money_play_record ADD COLUMN end_time timestamp(6);
$$);

COMMENT ON COLUMN activity_money_play_record.start_time IS '时段开始时间';
COMMENT ON COLUMN activity_money_play_record.end_time IS '时段结束时间';
COMMENT ON COLUMN activity_money_play_record.operate_date IS '操作日期';