-- auto gen by admin 2016-03-30 15:26:13
update sys_param SET param_value=NULL  WHERE module='content' AND param_type='depositAccountWarning' AND param_code='deposit.reset.days.next.time' and param_value='0';

update sys_param SET param_value=NULL  WHERE module='content' AND param_type='payAccountWarning' AND param_code='deposit.reset.days.next.time' AND param_value='0';
