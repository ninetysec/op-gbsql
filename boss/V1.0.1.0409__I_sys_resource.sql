-- auto gen by cherry 2017-09-05 17:42:46
INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
SELECT 70601,'彩票开奖异常日志手动派彩', 'lotteryResult/delete.html', '彩票开奖异常日志手动派彩', '706', '', '1', 'boss', 'lottery:hand_payout', '2', '', 'f', 't', 't'
 WHERE NOT EXISTS (SELECT id FROM sys_resource  WHERE  id='70601') ;

  INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)         SELECT 70404,'手动删除开奖结果记录', 'lotteryResult/delete.html', '手动删除开奖结果记录', '704', '', '4', 'boss', 'lottery:opencode_delete', '2', '', 'f', 't', 't'  WHERE NOT EXISTS (SELECT id FROM sys_resource  WHERE  id=70404) ;