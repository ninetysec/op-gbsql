-- auto gen by loong 2015-10-29 09:21:19

select redo_sqls($$
        ALTER TABLE "station_bill" ADD COLUMN "top_agent_id" int4;
        ALTER TABLE "station_bill" ADD PRIMARY KEY ("id");
$$);

COMMENT ON COLUMN "station_bill"."top_agent_id" IS '总代ID';


