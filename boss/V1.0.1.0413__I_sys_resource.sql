-- auto gen by cherry 2017-09-21 09:13:53
  INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)         SELECT 70405,'手动修改开奖结果记录', 'lotteryResult/updateLotteryResult.html', '手动修改开奖结果记录', '704', '', '5', 'boss', 'lottery:opencode_update', '2', '', 'f', 't', 't'
 WHERE NOT EXISTS (SELECT id FROM sys_resource  WHERE  id=70405) ;