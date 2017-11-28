-- auto gen by cherry 2017-06-08 15:11:30
ALTER SEQUENCE api_type_relation_id_seq OWNED BY "api_type_relation"."id";

	CREATE SEQUENCE if not EXISTS "api_type_relation_i18n_id_seq"
	 INCREMENT 1
	 MINVALUE 1
	 MAXVALUE 9223372036854775807
	 START 100
	 CACHE 1
	 OWNED BY "api_type_relation_i18n"."id";

	 ALTER TABLE api_type_relation ALTER COLUMN id set DEFAULT nextval('api_type_relation_id_seq'::regclass);
ALTER TABLE api_type_relation_i18n ALTER COLUMN id set DEFAULT nextval('api_type_relation_i18n_id_seq'::regclass);
