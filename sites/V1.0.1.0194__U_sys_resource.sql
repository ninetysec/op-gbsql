-- auto gen by admin 2016-07-12 21:41:07
UPDATE sys_resource SET url = 'fund/deposit/company/list.html' WHERE "name" = '公司入款审核' AND parent_id = 3;
UPDATE sys_resource SET url = 'fund/deposit/online/list.html' WHERE "name" = '线上支付记录' AND parent_id = 3;

UPDATE user_task_reminder SET task_url = 'fund/deposit/company/list.html' WHERE dict_code = 'recharge' AND task_url = '/fund/companyDespoit/list.html?search.rechargeStatus=1';