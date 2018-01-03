-- auto gen by jeff 2015-09-17 09:08:11

update sys_dict set dict_code = 'GMT+'||order_num where id in(
  SELECT "id" from sys_dict where dict_type = 'time_zone' and substr(dict_code, 0,5)= 'east'
);
update sys_dict set dict_code = 'GMT-'||order_num-12 where id in(
  SELECT "id" from sys_dict where dict_type = 'time_zone' and substr(dict_code, 0,5)= 'west'
);
update sys_dict set remark = dict_code ||'时区' where dict_type = 'time_zone'