-- auto gen by tony 2016-01-24 03:03:39
select redo_sqls($$
    ALTER TABLE svr_servers
      ALTER COLUMN "name" TYPE varchar(128) COLLATE "default";
  $$);

  select redo_sqls($$
    ALTER TABLE svr_servers
      ALTER COLUMN "description" TYPE varchar(512) COLLATE "default";
  $$);

  select redo_sqls($$
    ALTER TABLE svr_servers
      ALTER COLUMN "ip" TYPE varchar(32) COLLATE "default";
  $$);

  select redo_sqls($$
    ALTER TABLE svr_servers
      ALTER COLUMN "context_path" TYPE varchar(64) COLLATE "default";
  $$);

  select redo_sqls($$
    ALTER TABLE svr_servers
      ALTER COLUMN "war_name" TYPE varchar(256) COLLATE "default";
  $$);

  select redo_sqls($$
    ALTER TABLE svr_servers
      ADD COLUMN "subsys_code" varchar(32);
  $$);


COMMENT ON COLUMN "svr_servers"."subsys_code" IS '子系统编号1';

