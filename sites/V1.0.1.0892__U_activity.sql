-- auto gen by steffan 2018-06-27 17:00:35
--新站点活动大厅 add by steffan
--新增活动类型
INSERT INTO activity_type ( "code", "name", "introduce", "logo")
 select   'second_deposit', '次存送', '第二次存款达到一定金额可获得优惠', '/images/activity/events-img-03.jpg'
where not EXISTS (SELECT id FROM activity_type where code='second_deposit' and name='次存送' );

INSERT INTO activity_type ( "code", "name", "introduce", "logo")
 select   'third_deposit', '三存送', '第三次存款达到一定金额可获得优惠', '/images/activity/events-img-03.jpg'
where not EXISTS (SELECT id FROM activity_type where code='third_deposit' and name='三存送' );

INSERT INTO activity_type ( "code", "name", "introduce", "logo")
 select   'everyday_first_deposit', '每日首存', '每日第一次存款达到一定金额可获得优惠', '/images/activity/events-img-03.jpg'
where not EXISTS (SELECT id FROM activity_type where code='everyday_first_deposit' and name='每日首存' );

--打开活动大厅站点参数
update sys_param set param_value='true' ,default_value = 'true' where  module='setting' and  param_type='parameter_setting' and param_code='activity_hall_switch';
--关闭活动管理菜单
update sys_resource set status  = false where id = 401;
 -- 打开活动大厅菜单
update sys_resource set status  = true where id = 408;

