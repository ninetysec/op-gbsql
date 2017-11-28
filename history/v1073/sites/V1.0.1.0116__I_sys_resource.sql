-- auto gen by admin 2016-04-22 11:44:53
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege","status")

SELECT '460101', '修改银行卡', 'accountSettings/updateBankInfo.html', '修改银行卡', '4601', '', NULL, 'pcenter', 'account:setting_bank', '2', '', 't', 't','t'

WHERE '460101' NOT IN (SELECT id FROM sys_resource WHERE id='460101');


UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-06.jpg' WHERE ("code"='regist_send');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-05.jpg' WHERE ("code"='relief_fund');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-01.jpg' WHERE ("code"='back_water');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-07.jpg' WHERE ("code"='effective_transaction');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-02.jpg' WHERE ("code"='profit_loss');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-08.jpg' WHERE ("code"='content');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-04.jpg' WHERE ("code"='deposit_send');
UPDATE "activity_type" SET "logo"='mcenter/images/activity/events-img-03.jpg' WHERE ("code"='first_deposit');