-- auto gen by root 2016-10-08 19:50:07
ALTER TABLE monitor_vo
   ALTER COLUMN err_message TYPE text;
COMMENT ON COLUMN "gb-boss".monitor_vo.err_message IS '错误信息细';