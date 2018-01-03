-- auto gen by marz 2017-11-07 12:01:06
UPDATE sys_resource SET  "name"='调盘', "remark"='调盘' WHERE "id"='70405';
UPDATE sys_resource SET  "name"='撤单', "remark"='撤单' WHERE "id"='71001';
UPDATE sys_resource SET  "name"='撤销', "remark"='撤销' WHERE "id"='71002';
UPDATE sys_resource set url='lotterySysTool/heavy.html',permission='lottery:lottery_heavy' WHERE id=71005;
UPDATE sys_resource set url='lotterySysTool/payout.html',permission='lottery:lottery_payout' WHERE id=71004;
UPDATE sys_resource SET URL = 'lotterySysTool/collectOpenCode.html' ,  permission ='lottery:collect_opencode' WHERE  id = 71003