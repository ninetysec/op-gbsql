-- auto gen by bruce 2016-04-23 22:23:06

--------------------------------------------activity_type-----------------------------------------------------------------
UPDATE "activity_type" SET "logo"='/images/activity/events-img-06.jpg' WHERE ("code"='regist_send');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-05.jpg' WHERE ("code"='relief_fund');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-01.jpg' WHERE ("code"='back_water');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-07.jpg' WHERE ("code"='effective_transaction');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-02.jpg' WHERE ("code"='profit_loss');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-08.jpg' WHERE ("code"='content');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-04.jpg' WHERE ("code"='deposit_send');
UPDATE "activity_type" SET "logo"='/images/activity/events-img-03.jpg' WHERE ("code"='first_deposit');

update sys_param set param_value='5', default_value='5' where param_type='privilage_pass_time' and param_code='setting.privilage.pass.time';