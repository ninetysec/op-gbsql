-- auto gen by cherry 2017-06-29 09:59:11
DELETE FROM lottery_result WHERE id IN (SELECT t2.id FROM lottery_result t1, lottery_result t2
                 WHERE t1.code = t2.code
                         AND t1.expect = t2.expect
                         AND t1.id < t2.id
);

CREATE UNIQUE INDEX IF NOT EXISTS  idx_lottery_result_combination ON lottery_result(code, expect);