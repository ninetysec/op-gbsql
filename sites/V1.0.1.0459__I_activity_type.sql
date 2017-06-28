-- auto gen by cherry 2017-06-28 20:58:08
--开启红包活动
INSERT INTO "activity_type" ("code", "name", "introduce", "logo")
SELECT 'money', '红包', '通过抢红包，玩家有一定机率获取优惠', '/images/activity/events-img-10.jpg'
where not EXISTS (SELECT code FROM activity_type where code='money');