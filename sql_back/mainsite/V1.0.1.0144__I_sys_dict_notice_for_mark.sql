-- auto gen by longer 2015-12-10 18:41:50
DELETE FROM sys_dict WHERE MODULE = 'notice' AND dict_type='notice_send_status';

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','00',1,'等待发送',true
  WHERE '00' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','01',2,'取消发送',true
  WHERE '01' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','11',3,'已发送给消息队列',true
  WHERE '11' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','22',4,'最终发送失败',true
  WHERE '22' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','31',5,'已从消息队列消费',true
  WHERE '31' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','32',6,'发送完成，但是部分用户发送失败',true
  WHERE '32' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'notice','notice_send_status','33',7,'发送成功',true
  WHERE '33' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');