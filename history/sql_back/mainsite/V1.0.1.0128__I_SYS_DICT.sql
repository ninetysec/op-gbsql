-- auto gen by tom 2015-11-30 11:50:33
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','site_status','4',4,'未建库',true
WHERE '4' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'site_status');

comment on column "sys_site"."status" IS '状态,1:正常，2:停用，3:维护中, 4:未建库';