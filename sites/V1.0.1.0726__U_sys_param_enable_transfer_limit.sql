-- auto gen by water 2018-04-05 09:22:59
update sys_param set param_value = false,default_value = FALSE
WHERE module='setting' AND param_type='credit' AND param_code='enable_transfer_limit';