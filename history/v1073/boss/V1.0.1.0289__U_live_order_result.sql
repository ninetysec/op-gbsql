-- auto gen by bruce 2017-01-28 10:49:58
select redo_sqls($$
    ALTER TABLE live_order_result
      ALTER COLUMN "shootcode" TYPE varchar(20);
    ALTER TABLE live_order_result
      ALTER COLUMN "banker_point" TYPE varchar(20);
    ALTER TABLE live_order_result
      ALTER COLUMN "player_point" TYPE varchar(20);
$$);