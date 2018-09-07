-- auto gen by cherry 2018-07-04 21:04:20
select redo_sqls($$
   ALTER TABLE site_api ADD COLUMN own_icon BOOLEAN;
	ALTER TABLE site_game ADD COLUMN own_icon BOOLEAN;

$$);

COMMENT ON COLUMN site_api.own_icon is '图片是否个性化 t-是　空或f-否';

COMMENT ON COLUMN site_game.own_icon is '图片是否个性化 t-是　空或f-否';