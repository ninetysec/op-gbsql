-- auto gen by george 2018-01-14 17:59:58
select redo_sqls($$
	ALTER TABLE game ADD COLUMN game_score numeric(20,1);
	ALTER TABLE game ADD COLUMN game_score_number int4;
	ALTER TABLE game ADD COLUMN game_collect_number int4;
	ALTER TABLE game ADD COLUMN game_view int4;
	ALTER TABLE game ADD COLUMN game_line int4;
	ALTER TABLE game ADD COLUMN game_rtp numeric(20,2);
	ALTER TABLE game ADD COLUMN game_3d bool;
$$);
COMMENT ON COLUMN "game"."game_view" IS '游戏点击量';
COMMENT ON COLUMN "game"."game_line" IS '游戏线';
COMMENT ON COLUMN "game"."game_rtp" IS 'API传输的RTP值';
COMMENT ON COLUMN "game"."game_score" IS '游戏平均评分';
COMMENT ON COLUMN "game"."game_score_number" IS '游戏评分个数';
COMMENT ON COLUMN "game"."game_collect_number" IS '游戏收藏个数';
COMMENT ON COLUMN "game"."game_3d" IS '游戏3D效果：true 是';

update game set game_view = COALESCE(game_view,0);
update game set game_line = COALESCE(game_line,0);
update game set game_collect_number = COALESCE(game_collect_number,0);
update game set game_score = COALESCE(game_score,0);
update game set game_rtp = COALESCE(game_rtp,0);