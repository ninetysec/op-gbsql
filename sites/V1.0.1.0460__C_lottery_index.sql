-- auto gen by cherry 2017-06-29 16:59:19
CREATE INDEX if NOT EXISTS fk_lottery_bet_order_expect ON lottery_bet_order USING btree (expect);
CREATE INDEX if NOT EXISTS fk_lottery_bet_order_bet_time ON lottery_bet_order USING btree (bet_time);
CREATE INDEX if NOT EXISTS fk_lottery_bet_order_status ON lottery_bet_order USING btree (status);
CREATE INDEX if NOT EXISTS fk_lottery_transaction_transaction_time ON lottery_transaction USING btree (transaction_time);
CREATE INDEX if NOT EXISTS fk_lottery_transaction_transaction_type ON lottery_transaction USING btree (transaction_type);

