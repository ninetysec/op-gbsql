-- auto gen by cherry 2016-01-21 20:31:29
 select redo_sqls($$
    CREATE SEQUENCE "player_game_order_exception_id_seq"
       INCREMENT 1
       MINVALUE 1
       MAXVALUE 9223372036854775807
       START 1
       CACHE 10;

       ALTER TABLE player_game_order_exception ADD CONSTRAINT "player_game_order_exception_pkey" PRIMARY KEY ("id");

        ALTER TABLE player_game_order_exception ALTER COLUMN  id  SET DEFAULT nextval('player_game_order_exception_id_seq'::regclass);
  $$);