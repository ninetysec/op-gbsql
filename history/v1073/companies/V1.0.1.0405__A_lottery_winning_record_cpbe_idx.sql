-- auto gen by cherry 2017-08-28 19:41:27
CREATE INDEX IF NOT EXISTS lottery_winning_record_cpbe_idx ON lottery_winning_record USING btree (code, play_code, bet_code, expect);
CREATE INDEX IF NOT EXISTS lottery_winning_record_expect_idx ON lottery_winning_record USING btree (expect);