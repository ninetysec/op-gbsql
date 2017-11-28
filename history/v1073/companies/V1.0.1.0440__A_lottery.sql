-- auto gen by marz 2017-10-09 19:36:54
 select redo_sqls($$
ALTER TABLE lottery ADD genre int4 DEFAULT 3;
$$);
COMMENT ON COLUMN "lottery"."genre" IS '类型(1.全部2.官方玩法3.双面玩法)';