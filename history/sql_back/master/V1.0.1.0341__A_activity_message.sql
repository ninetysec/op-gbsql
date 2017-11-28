-- auto gen by cherry 2016-01-20 09:25:38
UPDATE sys_resource SET url = 'report/operate/operateIndex.html', remark = '统计报表-经营报表' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '经营报表' AND parent_id = 23 AND subsys_code = 'mcenterTopAgent');
UPDATE sys_resource SET url = 'report/operate/operateIndex.html', remark = '统计报表-经营报表' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '经营报表' AND parent_id = 33 AND subsys_code = 'mcenterAgent');

  select redo_sqls($$
       ALTER TABLE "activity_message" ADD COLUMN "settlement_time_start" timestamp;
      $$);

COMMENT ON COLUMN "activity_message"."settlement_time_start" IS '下次结算开始时间';