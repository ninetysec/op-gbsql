-- auto gen by cherry 2017-06-10 14:18:36
INSERT INTO "activity_type" ("code", "name", "introduce", "logo") SELECT 'money', '红包', '通过抢红包，玩家有一定机率获取优惠', '/images/activity/events-img-10.jpg'
    where not EXISTS (SELECT code FROM activity_type where code='money');

   ALTER TABLE if EXISTS activity_money_open_period RENAME TO activity_open_period;
			ALTER SEQUENCE if EXISTS activity_money_open_period_id_seq RENAME TO activity_open_period_id_seq;

