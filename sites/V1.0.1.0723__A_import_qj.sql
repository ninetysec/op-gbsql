-- auto gen by linsen 2018-04-03 15:49:26
-- import_qj表添加字段 by carl
select redo_sqls($$
ALTER TABLE import_qj ADD COLUMN qq character varying(60);
ALTER TABLE import_qj ADD COLUMN wechat character varying(60);
ALTER TABLE import_qj ADD COLUMN crypqq character varying(255);
ALTER TABLE import_qj ADD COLUMN crypwechat character varying(255);
$$);
COMMENT ON COLUMN import_qj."qq" IS 'qq';
COMMENT ON COLUMN import_qj."wechat" IS '微信';
COMMENT ON COLUMN import_qj."crypqq" IS '加密qq';
COMMENT ON COLUMN import_qj."crypwechat" IS '加密微信';