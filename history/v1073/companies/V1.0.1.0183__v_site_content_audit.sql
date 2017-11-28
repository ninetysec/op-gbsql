-- auto gen by cherry 2016-09-20 15:01:38
drop view if EXISTS v_site_content_audit;

CREATE OR REPLACE VIEW "v_site_content_audit" AS

 SELECT site.id,

    site.site_id,

    site.logo_read_count,

    site.logo_remove_count,

    site.logo_total_count,

    site.document_read_count,

    site.document_remove_count,

    site.document_total_count,

    site.activity_read_count,

    site.activity_remove_count,

    site.activity_total_count,

    site.site_name,

    site.logo_path,

    site.site_classify_key,

    site.main_language,

    site.parent_id,

    site.master_id,

    su.username AS master_name,

    su.user_type

   FROM (( SELECT b.id,

            a.id AS site_id,

            b.logo_read_count,

            b.logo_remove_count,

            b.logo_total_count,

            b.document_read_count,

            b.document_remove_count,

            b.document_total_count,

            b.activity_read_count,

            b.activity_remove_count,

            b.activity_total_count,

            a.name AS site_name,

            a.logo_path,

            a.site_classify_key,

            a.main_language,

            a.parent_id,

            a.sys_user_id AS master_id

           FROM (sys_site a

             LEFT JOIN site_content_audit b ON ((a.id = b.site_id)))

          WHERE (a.id > 0)) site

     LEFT JOIN sys_user su ON ((site.master_id = su.id)));



COMMENT ON VIEW "v_site_content_audit" IS '内容审核视图--river';