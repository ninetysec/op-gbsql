-- auto gen by mark 2015-11-18 09:38:12
select redo_sqls($$
CREATE SEQUENCE notice_unreceived_id_seq INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
$$);
ALTER TABLE notice_unreceived ALTER COLUMN id SET DEFAULT nextval('notice_unreceived_id_seq'::regclass);