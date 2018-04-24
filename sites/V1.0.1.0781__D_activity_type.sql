-- auto gen by linsen 2018-04-24 12:16:29
-- 删除活动大厅新增活动类型_站点不需要活动大厅才执行 by steffan

delete from activity_type where code='second_deposit' and name='次存送';
delete from activity_type where code='third_deposit' and name='三存送';
delete from activity_type where code='everyday_first_deposit' and name='每日首存';
