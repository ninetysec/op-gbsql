-- auto gen by mark 2015-12-18 16:34:24

CREATE OR REPLACE VIEW "v_sys_site_user" AS
SELECT
site."id",
site."name" AS site_name,
usr."id" AS sys_user_id,
usr.username,
usr.subsys_code,
usr.site_id AS center_id,
site.parent_id AS site_parent_id,
site.main_language AS site_locale
FROM sys_site site,
    sys_user usr
WHERE (site.sys_user_id = usr.id)
;

select redo_sqls($$
ALTER TABLE "notice_send"
ADD COLUMN "actual_receiver" varchar(64);

COMMENT ON COLUMN "notice_send"."actual_receiver" IS '实际接收者：目前仅支持邮件发送方式，存储的是实际邮箱地址。';
$$);

