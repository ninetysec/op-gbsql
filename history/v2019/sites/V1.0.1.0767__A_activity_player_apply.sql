-- auto gen by linsen 2018-04-20 09:13:49
-- 防止并发申请hash和索引 by steffan
select redo_sqls($$
	alter table activity_player_apply add column "apply_hash" varchar(100) ;
	CREATE UNIQUE INDEX "idx_apply_hash" ON  "activity_player_apply" USING btree ("apply_hash");
$$);

COMMENT ON COLUMN "activity_player_apply"."apply_hash" IS '防并发hash:playerid+rechargeid+currentsecond/3';
