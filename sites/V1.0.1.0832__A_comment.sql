-- auto gen by steffan 2018-05-24 11:05:00  add by steffan
COMMENT ON COLUMN  "sys_user"."terminal" IS '登录终端：1-PC，2-MOBILE,8-h5,12-android,16-ios';
COMMENT ON COLUMN  "player_transaction"."origin" IS '交易订单来源：1-PC,2-MOBILE,8-h5,12-android,16-ios (旧的pc,mobile改成1,2)';
COMMENT ON COLUMN  "player_game_order"."terminal" IS '注单终端:1-PC 2-MOBILE,8-h5,12-android,16-ios';