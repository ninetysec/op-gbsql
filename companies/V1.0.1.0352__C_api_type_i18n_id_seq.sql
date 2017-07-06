-- auto gen by cherry 2017-07-06 11:58:57
CREATE SEQUENCE IF NOT EXISTS "api_type_i18n_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1
 OWNED BY "api_type_i18n"."id";
SELECT setval('api_type_i18n_id_seq', 12);
ALTER TABLE api_type_i18n ALTER COLUMN id SET DEFAULT nextval('api_type_i18n_id_seq'::regclass);