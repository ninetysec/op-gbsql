-- auto gen by marz 2017-11-02 14:57:34
INSERT INTO sys_param(module,param_type,param_code,param_value,default_value,order_num,remark,parent_code, active,site_id )
select 'setting', 'lottery', 'maintain', 'false', 'false', NULL, 'LT全站维护', NULL, 't', NULL  where (select count(1) from sys_param where  module='setting' and param_type='lottery' and param_code='maintain')<1;
