-- auto gen by cherry 2017-08-25 19:03:57
select redo_sqls($$
   CREATE SEQUENCE if not EXISTS "currency_exchange_rate_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 2
 CACHE 1;

ALTER TABLE currency_exchange_rate ADD CONSTRAINT "u_currency_exchange_rate" UNIQUE (ifrom_currency, ito_currency); ;

ALTER TABLE currency_exchange_rate ALTER COLUMN  id  SET DEFAULT nextval('currency_exchange_rate_id_seq'::regclass);

  $$);
