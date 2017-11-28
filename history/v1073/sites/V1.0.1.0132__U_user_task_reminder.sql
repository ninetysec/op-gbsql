-- auto gen by admin 2016-04-29 20:50:54
UPDATE user_task_reminder SET task_url ='/vPayAccount/list.html?search.type=1' where parent_code='pay';

UPDATE user_task_reminder set task_url='/payAccount/warningSettings/1.html' WHERE parent_code='profit';

select redo_sqls($$
        ALTER TABLE player_game_order ADD COLUMN bet_time timestamp(6);
				ALTER TABLE player_game_order_exception ADD COLUMN bet_time timestamp(6);
        ALTER TABLE player_game_order_exception ADD COLUMN  action_id_json text;
$$);

COMMENT on COLUMN player_game_order.bet_time is '投注时间';
COMMENT ON COLUMN player_game_order.create_time is '入库时间';

COMMENT on COLUMN player_game_order_exception.bet_time is '投注时间';
COMMENT ON COLUMN player_game_order_exception.create_time is '入库时间';
COMMENT ON COLUMN player_game_order_exception.action_id_json is 'action_id_json，格式为action_id:profitAmount';