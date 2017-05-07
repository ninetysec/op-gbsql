-- auto gen by Alvin 2016-08-14 07:58:41
alter table game_api_log add COLUMN check_trans BOOLEAN DEFAULT 'f';
COMMENT ON COLUMN game_api_log.check_trans IS '是否检查交易';

alter table game_api_log add COLUMN checkup BOOLEAN DEFAULT 'f';
COMMENT ON COLUMN game_api_log.checkup IS '补单';