-- auto gen by longer 2015-11-05 13:32:41

drop view IF EXISTS v_sys_site_domain;
SELECT redo_sqls($$
    alter TABLE sys_domain drop column IF EXISTS is_resolve;
    alter TABLE sys_domain add column resolve_status CHARACTER VARYING(2) ;

$$);

COMMENT ON COLUMN sys_domain.resolve_status IS '域名绑定状态:1 绑定中,2 完成, 3 解绑中';

update sys_domain set resolve_status = '2';

CREATE OR REPLACE VIEW v_sys_site_domain AS
    SELECT dom.id,
        site.id AS site_id,
        site.name,
        site.timezone AS time_zone,
        site.main_language AS site_locale,
        site.code AS site_code,
        dom.id AS domain_id,
        dom.sys_user_id AS master_id,
        dom.domain,
        dom.is_default,
        dom.is_enable,
        dom.is_deleted,
        dom.sort,
        dom.subsys_code,
        usr.site_id AS center_id,
        dom.agent_id,
        dom.resolve_status,
        site.logo_path
    FROM sys_site site,
        sys_domain dom,
        sys_user usr
    WHERE dom.sys_user_id = usr.id AND usr.id = site.sys_user_id;

ALTER TABLE v_sys_site_domain
OWNER TO postgres;

COMMENT ON VIEW v_sys_site_domain IS '系统站点域名关联视图--Longer';


SELECT * FROM v_sys_site_domain WHERE
    --domain =? AND
    is_enable = TRUE AND resolve_status ='2' AND is_deleted =FALSE;