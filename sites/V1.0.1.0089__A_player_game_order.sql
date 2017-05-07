-- auto gen by admin 2016-04-10 20:33:05
-- auto gen by admin 2016-04-06 22:03:09
 select redo_sqls($$
ALTER TABLE player_game_order ADD COLUMN  winning_amount numeric(20,2);
ALTER TABLE player_game_order ADD COLUMN winning_flag bool;
ALTER TABLE player_game_order_exception ADD COLUMN winning_amount numeric(20,2);
ALTER TABLE player_game_order_exception ADD COLUMN winning_flag bool;
ALTER TABLE player_game_order_exception ADD COLUMN winning_time timestamp(6);
ALTER TABLE player_game_order ADD COLUMN winning_time timestamp(6);
alter TABLE player_api add CONSTRAINT uc_player_api UNIQUE (player_id,api_id);
alter table player_api_account add CONSTRAINT us_player_api_account UNIQUE (user_id,api_id);
$$);


COMMENT on COLUMN player_game_order.winning_amount is '中奖金额';

COMMENT on COLUMN player_game_order.winning_flag is '中奖标识';

COMMENT on COLUMN player_game_order_exception.winning_amount is '中奖金额';

COMMENT on COLUMN player_game_order_exception.winning_flag is '中奖标识';

COMMENT on COLUMN player_game_order.winning_time is '中奖时间';

COMMENT on COLUMN player_game_order_exception.winning_time is '中奖时间';

DROP VIEW if EXISTS v_player_online;
ALTER TABLE player_game_log  ALTER COLUMN online_session_id type int8;

CREATE OR REPLACE VIEW "v_player_online" AS
 SELECT s.id,
    s.username,
    s.real_name,
    s.login_time,
    s.login_ip,
    s.login_ip_dict_code,
    s.last_active_time,
    s.use_line,
    s.last_login_time,
    s.last_login_ip,
    s.last_login_ip_dict_code,
    s.total_online_time,
    ( SELECT string_agg(((player_game_log.game_id)::character varying)::text, ','::text) AS string_agg
           FROM  player_game_log
          WHERE (player_game_log.online_session_id = o.id)) AS gameids
   FROM (( sys_on_line_session o
     JOIN  user_player u ON ((o.sys_user_id = u.id)))
     LEFT JOIN sys_user s ON ((s.id = u.id)));

COMMENT ON VIEW  "v_player_online" IS '在线玩家视图--susu';

--添加约束
 select redo_sqls($$
alter TABLE player_recharge add CONSTRAINT uc_player_recharge UNIQUE (player_id,transaction_no);
alter TABLE player_transaction add CONSTRAINT uc_player_transaction UNIQUE (player_id,transaction_no);
alter TABLE player_transfer add CONSTRAINT uc_player_transfer UNIQUE (user_id,transaction_no);
alter TABLE player_recommend_award add CONSTRAINT uc_player_recommend_award UNIQUE (user_id,transaction_no);
alter TABLE player_withdraw add CONSTRAINT uc_player_withdraw UNIQUE (player_id,transaction_no);
$$);