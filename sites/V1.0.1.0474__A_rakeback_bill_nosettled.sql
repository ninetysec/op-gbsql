-- auto gen by cherry 2017-07-15 18:27:44
SELECT redo_sqls($$
  ALTER TABLE rakeback_bill_nosettled ADD COLUMN player_count int4;
$$);

COMMENT ON COLUMN rakeback_bill_nosettled.player_count IS '返水玩家数';

SELECT redo_sqls($$
ALTER TABLE rakeback_player ADD COLUMN rakeback_paid NUMERIC(20, 2) DEFAULT 0 NOT NULL;
ALTER TABLE rakeback_player ADD COLUMN rakeback_pending NUMERIC(20, 2) DEFAULT 0 NOT NULL;
$$);

COMMENT ON COLUMN rakeback_player.rakeback_paid IS '已付返水';
COMMENT ON COLUMN rakeback_player.rakeback_pending IS '未付返水';

ALTER TABLE rakeback_player
  ALTER COLUMN rakeback_bill_id SET NOT NULL,
  ALTER COLUMN rakeback_total SET DEFAULT 0,
  ALTER COLUMN rakeback_total SET NOT NULL,
  ALTER COLUMN rakeback_actual SET DEFAULT 0,
  ALTER COLUMN rakeback_actual SET NOT NULL;

SELECT redo_sqls($$
  ALTER TABLE rakeback_bill ADD COLUMN rakeback_paid NUMERIC(20, 2) DEFAULT 0 NOT NULL;
  ALTER TABLE rakeback_bill ADD COLUMN rakeback_pending NUMERIC(20, 2) DEFAULT 0 NOT NULL;
$$);

COMMENT ON COLUMN rakeback_bill.rakeback_paid IS '已付返水';
COMMENT ON COLUMN rakeback_bill.rakeback_pending IS '未付返水';

ALTER TABLE rakeback_bill
  ALTER COLUMN rakeback_total SET DEFAULT 0,
  ALTER COLUMN rakeback_total SET NOT NULL,
  ALTER COLUMN rakeback_actual SET DEFAULT 0,
  ALTER COLUMN rakeback_actual SET NOT NULL;

SELECT redo_sqls($$
ALTER TABLE rakeback_player ADD CONSTRAINT rakeback_player_rp_uc UNIQUE(rakeback_bill_id, player_id);
ALTER TABLE rakeback_bill ADD CONSTRAINT rakeback_bill_ct_uc UNIQUE(create_time);
$$);

