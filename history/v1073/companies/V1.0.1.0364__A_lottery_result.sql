-- auto gen by cherry 2017-07-17 14:47:51
 select redo_sqls($$    ALTER TABLE "lottery_result" ADD CONSTRAINT "lottery_result_combination_code_expect" UNIQUE ("code, expect");
    COMMENT ON CONSTRAINT "lottery_result_combination_code_expect" ON "lottery_result" IS '唯一性';
  $$);