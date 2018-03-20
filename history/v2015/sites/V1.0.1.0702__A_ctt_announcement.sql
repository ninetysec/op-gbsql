-- auto gen by linsen 2018-03-09 16:21:52
-- 系统公告倒计时显示时间 by carl
select redo_sqls($$
    ALTER TABLE ctt_announcement ADD COLUMN countdown int4;
		COMMENT ON COLUMN "ctt_announcement"."countdown" IS '显示时间：秒';
  $$);
