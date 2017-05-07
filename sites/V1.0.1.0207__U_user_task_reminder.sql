-- auto gen by cherry 2016-07-22 15:15:18
update user_task_reminder set task_url='/operation/announcementMessage/advisoryList.html' where dict_code='playerConsultation';

update sys_param set param_value='gray',default_value='gray' where param_type='captcha' and param_code='style' and "module"='setting';