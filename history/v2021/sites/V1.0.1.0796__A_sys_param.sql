-- auto gen by linsen 2018-05-04 11:40:40
--更新活动大厅开关_只在boss查看 by steffan
update sys_param set operate='0' where  module='setting' and  param_type='parameter_setting' and param_code='activity_hall_switch';