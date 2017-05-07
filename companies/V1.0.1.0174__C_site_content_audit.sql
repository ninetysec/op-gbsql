-- auto gen by cherry 2016-09-12 14:36:23
CREATE TABLE  IF NOT EXISTS site_content_audit
(

   id serial4 NOT NULL,

   site_id int4,

   logo_read_count int4,

   logo_remove_count int4,

   logo_total_count int4,

   document_read_count int4,

   document_remove_count int4,

   document_total_count int4,

   activity_read_count int4,

   activity_remove_count int4,

   activity_total_count int4,

   CONSTRAINT "site_content_audit_pkey" PRIMARY KEY ("id")

);

COMMENT ON COLUMN site_content_audit.id IS '主键';

COMMENT ON COLUMN site_content_audit.site_id IS '站点ID';

COMMENT ON COLUMN site_content_audit.logo_read_count IS 'LOGO已读数';

COMMENT ON COLUMN site_content_audit.logo_remove_count IS 'LOGO下架数';

COMMENT ON COLUMN site_content_audit.logo_total_count IS 'LOGO总数';

COMMENT ON COLUMN site_content_audit.document_read_count IS '文案已读数';

COMMENT ON COLUMN site_content_audit.document_remove_count IS '文案下架数';

COMMENT ON COLUMN site_content_audit.document_total_count IS '文案总数';

COMMENT ON COLUMN site_content_audit.activity_read_count IS '活动已读数';

COMMENT ON COLUMN site_content_audit.activity_remove_count IS '活动下架数';

COMMENT ON COLUMN site_content_audit.activity_total_count IS '活动总数';

COMMENT ON TABLE site_content_audit  IS '站点内容审核记录';


drop view if exists v_site_content_audit;

CREATE OR REPLACE VIEW "v_site_content_audit" AS

 SELECT a.id,

    a.site_id,

    a.logo_read_count,

    a.logo_remove_count,

    a.logo_total_count,

    a.document_read_count,

    a.document_remove_count,

    a.document_total_count,

    a.activity_read_count,

    a.activity_remove_count,

    a.activity_total_count,

    b.name AS site_name,

    c.username AS master_name,

    b.logo_path,

    b.site_classify_key,

    b.main_language,

    c.user_type,

    c.id AS master_id,

    b.parent_id

   FROM site_content_audit a,

    sys_site b,

    sys_user c

  WHERE ((a.site_id = b.id) AND (b.sys_user_id = c.id));

COMMENT ON VIEW "v_site_content_audit" IS '内容审核视图--river';

update sys_resource set url='vSiteContentAudit/list.html' where id=201;