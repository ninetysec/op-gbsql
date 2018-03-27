-- auto gen by george 2018-01-28 10:01:32
SELECT redo_sqls($$

ALTER TABLE api ADD COLUMN timezone VARCHAR(16);

COMMENT ON COLUMN api.timezone IS 'api对账时区';

$$);