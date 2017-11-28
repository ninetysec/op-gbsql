-- auto gen by cheery 2015-12-07 12:36:05
SELECT redo_sqls($$
   ALTER TABLE sys_user ADD COLUMN freeze_title varchar(128);
   ALTER TABLE sys_user ADD COLUMN freeze_content TEXT;
$$);

COMMENT ON COLUMN sys_user.freeze_title IS '账号冻结标题';

COMMENT ON COLUMN sys_user.freeze_content IS '账号冻结内容';

--新增冻结时间字典
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
   SELECT 'common','freeze_time','-99',1,'冻结时间：永久',true
   WHERE 'forever' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'freeze_time');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
   SELECT 'common','freeze_time','3',2,'冻结时间：3小时',true
   WHERE '3' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'freeze_time');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
   SELECT 'common','freeze_time','6',3,'冻结时间：6小时',true
   WHERE '6' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'freeze_time');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
   SELECT 'common','freeze_time','12',4,'冻结时间：12小时',true
   WHERE '12' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'freeze_time');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
   SELECT 'common','freeze_time','24',5,'冻结时间：24小时',true
   WHERE '24' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'freeze_time');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
   SELECT 'common','freeze_time','72',6,'冻结时间：72小时',true
   WHERE '72' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'freeze_time');
