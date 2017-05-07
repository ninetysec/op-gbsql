-- auto gen by cheery 2015-10-14 09:04:39

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','notice_send_status','00',1,'等待发送',true
WHERE '00' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','notice_send_status','11',2,'已发送给消息队列',true
WHERE '11' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','notice_send_status','12',3,'已从消息队列消费',true
WHERE '12' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','notice_send_status','22',4,'最终发送失败',true
WHERE '22' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','notice_send_status','33',5,'发送成功',true
WHERE '33' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'notice_send_status');
