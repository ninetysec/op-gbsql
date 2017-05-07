-- auto gen by admin 2016-12-16 14:23:40

  select redo_sqls($$
    ALTER TABLE live_order_result ADD COLUMN gameresult character varying(50);
  $$);

COMMENT ON COLUMN live_order_result.gameresult IS '游戏结果';