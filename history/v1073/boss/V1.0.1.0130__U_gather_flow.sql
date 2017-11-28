-- auto gen by jerry 2016-09-20 16:39:52
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '18', 'MG_INIT', 'MG初始化', '030', '030000', '', '<?xml version="1.0" encoding="UTF-8"?>

<config>
    <var-def name="url">ag.adminserv88.com</var-def>
    <var-def name="login" session="true">
        <http method="post" url="${sys.fullUrl(url,&quot;/lps/j_spring_security_check&quot;)}">
            <http-param name="j_username">
                <var name="userName"/>
            </http-param>
            <http-param name="j_password">
                <var name="password"/>
            </http-param>
        </http>
    </var-def>
</config>', '201606231713', '', '', '1', '2016-09-20 19:39:54', 'INIT'
  WHERE  not EXISTS (SELECT id from gather_flow where id=18);