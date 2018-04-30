-- auto gen by linsen 2018-04-30 20:39:55
-- 实时概况表  by martin
CREATE TABLE IF NOT EXISTS realtime_profile
(
    id serial4 PRIMARY KEY NOT NULL,
    visitor_pc integer,
    visitor_h5 integer,
    active_pc integer,
    active_phone integer,
    active_ios integer,
    active_android integer,
    active_h5 integer,
    register_pc integer,
    register_phone integer,
    register_ios integer,
    register_android integer,
    register_h5 integer,
    deposit_pc numeric(20,2),
    deposit_phone numeric(20,2),
    deposit_ios numeric(20,2),
    deposit_android numeric(20,2),
    deposit_h5 numeric(20,2),
    effc_transaction_pc numeric(20,2),
    effc_transaction_phone numeric(20,2),
    effc_transaction_ios numeric(20,2),
    effc_transaction_android numeric(20,2),
    effc_transaction_h5 numeric(20,2),
    online_pc integer,
    online_phone integer,
    online_ios integer,
    online_android integer,
    online_h5 integer,
    realtime_profit_loss numeric(20,2) DEFAULT NULL::numeric,
    create_time timestamp without time zone
)
;


COMMENT ON TABLE realtime_profile IS '实时概况--Martin';

COMMENT ON COLUMN realtime_profile.id IS '主键';

COMMENT ON COLUMN realtime_profile.visitor_pc  IS '实时访客数-PC';

COMMENT ON COLUMN realtime_profile.visitor_h5  IS '实时访客数-H5';

COMMENT ON COLUMN realtime_profile.active_pc IS '实时活跃-PC';

COMMENT ON COLUMN realtime_profile.active_phone  IS '实时活跃-phone';

COMMENT ON COLUMN realtime_profile.active_ios IS '实时活跃-ios';

COMMENT ON COLUMN realtime_profile.active_android IS '实时活跃-android';

COMMENT ON COLUMN realtime_profile.active_h5 IS '实时活跃-H5';

COMMENT ON COLUMN realtime_profile.register_pc  IS '实时注册-PC';

COMMENT ON COLUMN realtime_profile.register_phone  IS '实时注册-phone';

COMMENT ON COLUMN realtime_profile.register_ios IS '实时注册-ios';

COMMENT ON COLUMN realtime_profile.register_android IS '实时注册-android';

COMMENT ON COLUMN realtime_profile.register_h5 IS '实时注册-H5';

COMMENT ON COLUMN realtime_profile.deposit_pc IS '实时存款-pc';

COMMENT ON COLUMN realtime_profile.deposit_phone IS '实时存款-phone';

COMMENT ON COLUMN realtime_profile.deposit_ios IS '实时存款-ios';

COMMENT ON COLUMN realtime_profile.deposit_android IS '实时存款-android';

COMMENT ON COLUMN realtime_profile.deposit_h5 IS '实时存款-h5';

COMMENT ON COLUMN realtime_profile.effc_transaction_pc IS '实时投注额-pc';

COMMENT ON COLUMN realtime_profile.effc_transaction_phone IS '实时投注额-phone';

COMMENT ON COLUMN realtime_profile.effc_transaction_ios IS '实时投注额-ios';

COMMENT ON COLUMN realtime_profile.effc_transaction_android IS '实时投注额-android';

COMMENT ON COLUMN realtime_profile.effc_transaction_h5 IS '实时投注额-h5';

COMMENT ON COLUMN realtime_profile.online_pc IS '实时在线-pc';

COMMENT ON COLUMN realtime_profile.online_phone IS '实时在线-phone';

COMMENT ON COLUMN realtime_profile.online_ios IS '实时在线-ios';

COMMENT ON COLUMN realtime_profile.online_android IS '实时在线-android';

COMMENT ON COLUMN realtime_profile.online_h5 IS '实时在线-h5';

COMMENT ON COLUMN realtime_profile.realtime_profit_loss IS '实时损益';

COMMENT ON COLUMN realtime_profile.create_time IS '数据收集时间';