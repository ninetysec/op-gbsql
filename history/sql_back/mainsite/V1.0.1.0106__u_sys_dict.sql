-- auto gen by tom 2015-11-24 17:30:05
update sys_dict set dict_code='GMT'||substr(dict_code, 4,1)||lpad(substr(dict_code, 5) ,2 ,'0')||':00'  where dict_type='time_zone';