-- auto gen by cherry 2016-11-12 10:49:12
CREATE TABLE IF NOT EXISTS player_game_tip_order(

	id SERIAL4 NOT NULL PRIMARY KEY,

	player_id int4,

	sands_name varchar(64),

	api_id int4,

	game_id int4,

	game_type varchar(32),

	api_type_id int4,

	tip_amount numeric(20,2) NOT NULL,

	bill_no varchar(64) not NULL,

	bet_id varchar(64),

	tip_time timestamp(6),

	terminal varchar(8) COLLATE "default",

	additional_result text,

	create_time timestamp(6),

	status varchar(16),

	account varchar(32) NOT NULL,

	update_time TIMESTAMP(6),

	anchor VARCHAR(64),

	CONSTRAINT "u_player_game_tip_order" UNIQUE ("api_id", "bill_no")

);



COMMENT ON TABLE player_game_tip_order is '玩家小费打赏记录';

COMMENT ON COLUMN player_game_tip_order.id IS '主键';

COMMENT ON COLUMN player_game_tip_order.player_id is '玩家id';

COMMENT ON COLUMN player_game_tip_order.sands_name is '打赏荷官的姓名';

COMMENT ON COLUMN player_game_tip_order.api_id is 'api';

COMMENT ON COLUMN player_game_tip_order.game_id is '游戏id';

COMMENT ON COLUMN player_game_tip_order.game_type is '游戏类型';

COMMENT ON COLUMN player_game_tip_order.api_type_id is 'api游戏类型';

COMMENT ON COLUMN player_game_tip_order.tip_amount is '小费金额';

COMMENT ON COLUMN player_game_tip_order.bill_no is '小费id';

COMMENT ON COLUMN player_game_tip_order.bet_id is '打赏注单号';

COMMENT ON COLUMN player_game_tip_order.tip_time is '小费时间';

COMMENT ON COLUMN player_game_tip_order.terminal is '小费终端：1-PC，2-MOBILE';

COMMENT ON COLUMN player_game_tip_order.additional_result is '附加结果';

COMMENT ON COLUMN player_game_tip_order.create_time is '入库时间';

COMMENT ON COLUMN player_game_tip_order.status is '状态：settle-已打赏，cancel-取消';

COMMENT ON COLUMN player_game_tip_order.account is '游戏账号';

COMMENT ON COLUMN player_game_tip_order.update_time is '更新时间';

COMMENT ON COLUMN player_game_tip_order.anchor is '主播名字';

CREATE OR REPLACE VIEW v_player_game_tip_order AS

SELECT t1.* ,t2.username

FROM player_game_tip_order t1

LEFT JOIN sys_user t2 ON t1.player_id=t2."id"

ORDER BY t1.tip_time DESC;

COMMENT ON VIEW v_player_game_tip_order is '小费视图'

