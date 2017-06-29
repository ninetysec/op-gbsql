-- auto gen by cherry 2017-06-29 16:51:16
CREATE INDEX IF NOT EXISTS fk_lottery_handicap_close_time ON lottery_handicap USING btree (close_time);
 CREATE INDEX IF NOT EXISTS fk_lottery_handicap_expect ON lottery_handicap USING btree (expect);
 CREATE INDEX IF NOT EXISTS fk_lottery_handicap_code ON lottery_handicap USING btree (code);
 CREATE INDEX IF NOT EXISTS fk_lottery_handicap_lhc_close_time ON lottery_handicap_lhc USING btree (close_time);
  CREATE INDEX IF NOT EXISTS fk_lottery_handicap_lhc_expect ON lottery_handicap_lhc USING btree (expect);
  CREATE INDEX IF NOT EXISTS fk_lottery_handicap_lhc_code ON lottery_handicap_lhc USING btree (code);
 CREATE INDEX IF NOT EXISTS fk_lottery_result_code ON lottery_result USING btree (code);
	CREATE INDEX IF NOT EXISTS fk_lottery_result_expect ON lottery_result USING btree (expect);
   CREATE INDEX IF NOT EXISTS fk_lottery_result_open_time ON lottery_result USING btree (open_time);