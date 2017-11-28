-- auto gen by Administrator 2017-02-11 15:11:15
select redo_sqls($$
ALTER TABLE player_game_order
    ADD COLUMN username character varying(32);
$$);
select redo_sqls($$
ALTER TABLE player_game_order
    ADD COLUMN agentid integer;
$$);
select redo_sqls($$
ALTER TABLE player_game_order
    ADD COLUMN agentusername character varying(32);
$$);
select redo_sqls($$
ALTER TABLE player_game_order
    ADD COLUMN topagentusername character varying(32);
$$);
select redo_sqls($$
ALTER TABLE player_game_order
    ADD COLUMN topagentid integer;
$$);
