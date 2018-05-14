-- auto gen by linsen 2018-04-10 11:13:28
-- 增加活动类型　add by steffan

INSERT INTO activity_type ( "code", "name", "introduce", "logo")
 select   'second_deposit', '次存送', '第二次存款达到一定金额可获得优惠', '/images/activity/events-img-03.jpg'
where not EXISTS (SELECT id FROM activity_type where code='second_deposit' and name='次存送' );

INSERT INTO activity_type ( "code", "name", "introduce", "logo")
 select   'third_deposit', '三存送', '第三次存款达到一定金额可获得优惠', '/images/activity/events-img-03.jpg'
where not EXISTS (SELECT id FROM activity_type where code='third_deposit' and name='三存送' );

INSERT INTO activity_type ( "code", "name", "introduce", "logo")
 select   'everyday_first_deposit', '每日首存', '每日第一次存款达到一定金额可获得优惠', '/images/activity/events-img-03.jpg'
where not EXISTS (SELECT id FROM activity_type where code='everyday_first_deposit' and name='每日首存' );