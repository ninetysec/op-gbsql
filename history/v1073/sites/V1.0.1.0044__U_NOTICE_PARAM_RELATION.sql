-- auto gen by tom 2016-03-04 14:05:21
select redo_sqls($$
    ALTER TABLE "notice_param_relation" ALTER COLUMN "order" TYPE int4;
  $$);

  delete from notice_tmpl where event_type='CHANGE_PLAYER_DATA';