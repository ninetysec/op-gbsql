-- auto gen by bruce 2016-06-16 11:19:39
CREATE TABLE if not EXISTS site_api_type_relation_i18n
(
  id SERIAL4 NOT NULL,
  relation_id integer NOT NULL,
  name character varying(100),
  local character(5),
  CONSTRAINT site_api_type_relation_i18n_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE "site_api_type_relation_i18n" IS 'site_api_type_relation_i18n-- younger';

COMMENT ON COLUMN "site_api_type_relation_i18n"."id" IS '主键';

COMMENT ON COLUMN "site_api_type_relation_i18n"."relation_id" IS '关系ID';

COMMENT ON COLUMN "site_api_type_relation_i18n"."name" IS 'API名称';

COMMENT ON COLUMN "site_api_type_relation_i18n"."local" IS '语言代码';

update site_i18n set default_value="value" where "type"='service_terms' and site_id=0 and "key"='service';
update site_i18n set default_value="value" where "type"='service_terms_agent' and site_id=0 and "key"='service';