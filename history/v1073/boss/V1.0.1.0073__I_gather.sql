-- auto gen by lenovo 2016-06-24 07:47:35
INSERT INTO "gather_category" ("id", "name", "status", "create_time") VALUES ('040', 'IM', '1', '2016-06-23 19:35:42');
INSERT INTO "gather_category" ("id", "name", "status", "create_time") VALUES ('020', 'KG', '1', '2016-06-23 19:35:44');
INSERT INTO "gather_category" ("id", "name", "status", "create_time") VALUES ('080', 'SLC', '1', '2016-06-23 19:35:42');
INSERT INTO "gather_category" ("id", "name", "status", "create_time") VALUES ('090', 'AG', '1', '2016-06-23 19:35:42');
INSERT INTO "gather_category" ("id", "name", "status", "create_time") VALUES ('100', 'HG', '1', '2016-06-23 19:35:42');



INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('020000', 'KG初始化', '020', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('020001', 'KG查询转账状态', '020', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('020002', 'KG保持会话', '020', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('040000', 'IM初始化', '040', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('040001', 'IM注单', '040', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('040002', 'IM会话保持', '040', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('080000', 'SLC初始化', '080', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('080001', 'SLC修改注单', '080', '1', NULL);
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") VALUES ('080002', 'SLC会话保持', '080', '1', NULL);



INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('1', 'dawoo001', '0318ACFI', 'KG用户', '01', '1', '2016-06-23 17:19:31', '020', 't');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('2', 'dawoo002', '3587EADI', 'KG用户', '01', '1', '2016-06-23 17:19:31', '020', 't');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('3', 'dawoo003', '8625CIFA', 'KG用户', '01', '1', '2016-06-23 17:19:31', '020', 't');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('4', 'IMABC001', 'P2AC0137', 'IM用户', '01', '1', '2016-06-23 19:26:49', '040', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('5', 'IMABC002', 'C2D30137', 'IM用户', '01', '1', '2016-06-23 19:26:49', '040', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('6', 'IMABC003', 'T28PC0137', 'IM用户', '01', '1', '2016-06-23 19:26:49', '040', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('7', 'IMABC004', 'P2AC0137', 'IM用户', '01', '1', '2016-06-23 19:26:49', '040', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('8', 'IMABC005', 'C2D30137', 'IM用户', '01', '1', '2016-06-23 19:26:49', '040', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('9', 'IMABC006', 'T28PC0137', 'IM用户', '01', '1', '2016-06-23 19:26:49', '040', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('10', 'SLC001', 'L30875SC', 'SLC用户', '01', '1', '2016-06-23 19:26:49', '080', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('11', 'SLC002', 'A208873C', 'SLC用户', '01', '1', '2016-06-23 19:26:49', '080', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('12', 'SLC003', 'L308CD57', 'SLC用户', '01', '1', '2016-06-23 19:26:49', '080', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('13', 'SLC004', 'L30875SC', 'SLC用户', '01', '1', '2016-06-23 19:26:49', '080', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('14', 'SLC005', 'A208873C', 'SLC用户', '01', '1', '2016-06-23 19:26:49', '080', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('15', 'SLC006', 'L308CD57', 'SLC用户', '01', '1', '2016-06-23 19:26:49', '080', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('16', 'HG001', 'H30875SC', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('17', 'HG002', 'H208873C', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('18', 'HG003', 'H308CD57', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('19', 'HG004', 'H30875SC', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('20', 'HG005', 'H208873C', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('21', 'HG006', 'H308CD57', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") VALUES ('22', 'HG007', 'H308CD57', 'HG用户', '01', '1', '2016-06-23 19:26:49', '100', 'f');


INSERT INTO "gather_schedule" ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") VALUES ('2', 'IM后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '040');
INSERT INTO "gather_schedule" ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") VALUES ('1', 'KG后台计划', 'daemon', NULL, NULL, '1', 'N', NULL, '2016-06-24 09:29:29', '2016-06-24 09:29:32', NULL, NULL, '2016', '020');
INSERT INTO "gather_schedule" ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") VALUES ('3', 'SLC后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '080');
INSERT INTO "gather_schedule" ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") VALUES ('4', 'HG后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '100');


INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('1', 'KG_INIT', 'KG初始化', '020', '020000', NULL, '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="url">www2.v88kgg.com/vendor/</var-def>
    <var-def name="html">
        <html-to-xml>
            <http method="get" url="${sys.fullUrl(url,&quot;login.php&quot;)}"/>
        </html-to-xml>
    </var-def>
    <validate name="code" type="image/png" wait-time="60000" expression="\d+">
        <http method="get" response-content-type="image/png"
              url="http://www2.v88kgg.com/vendor/file_manager/scripts/verify.php?0.10591737786307931">
        </http>
    </validate>
    <var-def name="login">
        <http method="post" url="${sys.fullUrl(url,&quot;file_manager/ajax/post/login.php&quot;)}">
            <http-param name="LoginName"><var name="userName"/></http-param>
            <http-param name="LoginPassword"><var name="password"/></http-param>
            <http-param name="VerifyCode">
                <var name="code"/>
            </http-param>
            <http-param name="LoginType">1</http-param>
            <http-param name="Language">sc</http-param>
            <http-param name="IPAddress">162.247.96.135</http-param>
        </http>
    </var-def>
    <!--
    <var-def name="mainpage">
        <http method="get" url="http://www2.v88kgg.com/vendor/#0|0"/>
    </var-def>
    -->
    <!--检查是否登入成功,进而向服务端报告 -->
    <notice envelope="login" reverse="true" message="${login}" url-decode="true">
        <regexp>
            <regexp-pattern>(VerifyCode)</regexp-pattern>
            <regexp-source>
                <var name="login"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'INIT');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('2', 'KG_CHECK', 'KG检查转账状态', '020', '020001', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="check">
        <html-to-xml>
            <http method="get"
                  url="http://www2.v88kgg.com/vendor/file_manager/ajax/report_fund.php">
                <http-param name="FundIntegrationId">
                    <var name="api_transId"/>
                </http-param>
            </http>
        </html-to-xml>
    </var-def>
    <var-def name="check_value">
        <![CDATA[阶段超时]]>
    </var-def>
    <!--检查session是否过期-->
    <session-exp init="true" value="${check_value}">
        <xpath expression="//body/text()">
            <var name="check"/>
        </xpath>
    </session-exp>
    <var-def name="parse">
        <xpath expression="//tr[@class=''rows'']/td[contains(text(),''${sys.getVar(&quot;api_transId&quot;)}'')]/text()">
            <var name="check"/>
        </xpath>
    </var-def>
    <!--返回的数据-->
    <var-def name="record">
        <script return="ch">
            <![CDATA[
            String pid=sys.getVar("api_transId").toList().get(0).toString();
            System.out.println("api_transId="+pid);
            Object object=sys.getVar("parse");
            System.out.println("Variable:"+object);
            if(object.toList().size()>0&&object.toList().get(0)!=null&&object.toList().get(0).toString().equals(pid))
            {
               ch="{\"status\":\"0\",\"id\":\""+pid+"\",\"desc\":\"转账成功!\"}";
            }else
            {
               ch="{\"status\":\"E024\",\"id\":\""+pid+"\",\"desc\":\"没有转账记录!\"}";
            }
            ]]>
        </script>
    </var-def>
    <result>
        <var name="record"/>
    </result>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('3', 'KG_RANDOM', 'KG会话保持', '020', '020002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="check">
        <html-to-xml>
            <http method="get"
                  url="http://www2.v88kgg.com/vendor/file_manager/ajax/report_fund.php">
                <http-param name="FundIntegrationId">
                    <var name="api_transId"/>
                </http-param>
            </http>
        </html-to-xml>
    </var-def>
    <var-def name="check_value">
        <![CDATA[阶段超时]]>
    </var-def>
    <!--检查session是否过期-->
    <session-exp init="true" value="${check_value}">
        <xpath expression="//body/text()">
            <var name="check"/>
        </xpath>
    </session-exp>
    <var-def name="parse">
        <xpath expression="//tr[@class=''rows'']/td[contains(text(),''${sys.getVar(&quot;api_transId&quot;)}'')]/text()">
            <var name="check"/>
        </xpath>
    </var-def>
    <!--返回的数据-->
    <var-def name="record">
        <script return="ch">
            <![CDATA[
            String pid=sys.getVar("api_transId").toList().get(0).toString();
            System.out.println("api_transId="+pid);
            Object object=sys.getVar("parse");
            System.out.println("Variable:"+object);
            if(object.toList().size()>0&&object.toList().get(0)!=null&&object.toList().get(0).toString().equals(pid))
            {
               ch="{\"status\":\"0\",\"id\":\""+pid+"\",\"desc\":\"转账成功!\"}";
            }else
            {
               ch="{\"status\":\"E024\",\"id\":\""+pid+"\",\"desc\":\"没有转账记录!\"}";
            }
            ]]>
        </script>
    </var-def>
    <result>
        <var name="record"/>
    </result>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'RANDOM');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('4', 'IM_INIT', 'IM初始化', '040', '040000', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

    <!--<var-def name="url">apps3.test.inplaymatrix.com</var-def>-->
    <!--<var-def name="code_url">http://apps3.test.inplaymatrix.com/backoffice/code.asp</var-def>-->
    <!--<var-def name="login_url">http://apps3.test.inplaymatrix.com/backoffice/adm_login_proc.asp</var-def>-->
    <!--<var-def name="redirect_url">http://apps3.test.inplaymatrix.com/backoffice/menu/redirect.asp?redirectUrl=http://apps3.test.inplaymatrix.com:81/BetEnquiry</var-def>-->
    <!--<var-def name="record_url">http://apps3.test.inplaymatrix.com:81/BetEnquiry</var-def>-->
    <!--<var-def name="history_url">http://apps3.test.inplaymatrix.com:81/BetEnquiry/BetLog</var-def>-->

    <var-def name="url">https://dawoo-sbbo.inplaymatrix.com</var-def>
    <var-def name="code_url">https://dawoo-sbbo.inplaymatrix.com/backoffice/code.asp</var-def>
    <var-def name="login_url">https://dawoo-sbbo.inplaymatrix.com/backoffice/adm_login_proc.asp</var-def>
    <var-def name="redirect_url">https://dawoo-sbbo.inplaymatrix.com/backoffice/menu/redirect.asp?redirectUrl=https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry</var-def>
    <var-def name="record_url">https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry</var-def>
    <var-def name="history_url">https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry/BetLog</var-def>

    <var-def name="html">
        <html-to-xml>
            <http method="get" url="${url}"/>
        </html-to-xml>
    </var-def>
    <validate name="code" type="image/bmp" wait-time="60000" expression="\d+">
        <http method="get" response-content-type="image/bmp" url="${code_url}">
        </http>
    </validate>
    <var-def name="login">
        <http method="post" url="${login_url}" content-type="application/x-www-form-urlencoded">
            <http-param name="txtUserID"><var name="userName"/> </http-param>
            <!--<http-param name="txtUserID">dawooadm</http-param>-->
            <http-param name="hidPassword"><var name="password"/></http-param>
            <http-param name="txtPassword"><var name="password"/></http-param>
            <http-param name="hidSelectedGrp"></http-param>
            <http-param name="txtCode"><var name="code"/></http-param>
        </http>
    </var-def>
    <!--通知登入信息-->
    <notice envelope="login" reverse="false" message="" url-decode="false">
        <regexp>
            <regexp-pattern>(menu_head)</regexp-pattern>
            <regexp-source>
                <html-to-xml>
                    <var name="login"/>
                </html-to-xml>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
    <!--转换请求-->
    <template>
        <http method="get" url="${redirect_url}" content-type="application/x-www-form-urlencoded"/>
    </template>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'INIT');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('5', 'IM_RECORD', 'IM有效交易量', '040', '040001', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

	<!--<var-def name="url">apps3.test.inplaymatrix.com</var-def>-->
	<!--<var-def name="code_url">http://apps3.test.inplaymatrix.com/backoffice/code.asp</var-def>-->
	<!--<var-def name="login_url">http://apps3.test.inplaymatrix.com/backoffice/adm_login_proc.asp</var-def>-->
	<!--<var-def name="redirect_url">http://apps3.test.inplaymatrix.com/backoffice/menu/redirect.asp?redirectUrl=http://apps3.test.inplaymatrix.com:81/BetEnquiry</var-def>-->
	<!--<var-def name="record_url">http://apps3.test.inplaymatrix.com:81/BetEnquiry</var-def>-->
	<!--<var-def name="history_url">http://apps3.test.inplaymatrix.com:81/BetEnquiry/BetLog</var-def>-->

	<var-def name="url">https://dawoo-sbbo.inplaymatrix.com</var-def>
	<var-def name="code_url">https://dawoo-sbbo.inplaymatrix.com/backoffice/code.asp</var-def>
	<var-def name="login_url">https://dawoo-sbbo.inplaymatrix.com/backoffice/adm_login_proc.asp</var-def>
	<var-def name="redirect_url">https://dawoo-sbbo.inplaymatrix.com/backoffice/menu/redirect.asp?redirectUrl=https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry</var-def>
	<var-def name="record_url">https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry</var-def>
	<var-def name="history_url">https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry/BetLog</var-def>

	<!--<var-def name="userName">dawooadm</var-def>
	<var-def name="password">asdf1234</var-def>
	<var-def name="html">
		<html-to-xml>
			<http method="get" url="${url}"/>
		</html-to-xml>
	</var-def>
	<validate name="code" type="image/bmp" wait-time="60000" expression="\d+">
		<http method="get" response-content-type="image/bmp" url="${code_url}">
		</http>
	</validate>
	<var-def name="login">
		<http method="post" url="${login_url}" content-type="application/x-www-form-urlencoded">
			<http-param name="txtUserID"><var name="userName"/> </http-param>
			<http-param name="hidPassword"><var name="password"/></http-param>
			<http-param name="txtPassword"><var name="password"/></http-param>
			<http-param name="hidSelectedGrp"></http-param>
			<http-param name="txtCode"><var name="code"/></http-param>
		</http>
	</var-def>
	<notice envelope="login" reverse="false" message="" url-decode="false">
		<regexp>
			<regexp-pattern>(menu_head)</regexp-pattern>
			<regexp-source>
				<html-to-xml>
					<var name="login"/>
				</html-to-xml>
			</regexp-source>
			<regexp-result>
				<template>${_1}</template>
			</regexp-result>
		</regexp>
	</notice>
	<template>
		<http method="get" url="${redirect_url}" content-type="application/x-www-form-urlencoded"/>
	</template>
	<var-def name="betNos">
		<template><![CDATA[16550059]]></template>
		<template><![CDATA[16551647]]></template>
	</var-def>-->
	<session-exp init="true" value="unauthorized">
		<xpath expression="//title/text()">
			<html-to-xml>
				<http method="get" url="${record_url}"></http>
			</html-to-xml>
		</xpath>
	</session-exp>

	<loop item="item_betno" index="i" filter="unique">
		<list><var name=''betNos''/></list>
		<body>
			<var-def name="html_detail">
				<html-to-xml>
					<http method="get" url="${record_url}" content-type="application/x-www-form-urlencoded">
						<http-param name="searchType">5</http-param>
						<http-param name="searchText"><var name="item_betno"></var></http-param>
						<http-param name="Currency"></http-param>
						<http-param name="HousePlayer"></http-param>
						<http-param name="IsFromReportView">False</http-param>
						<http-param name="LeagueCode"></http-param>
						<http-param name="IsFromOddsControlView">False</http-param>
						<http-param name="DateFrom"></http-param>
						<http-param name="DateTo"></http-param>
						<http-param name="IsCornerReport">false</http-param>
						<http-param name="BetType"></http-param>
						<http-param name="BetStatus">2</http-param>
						<http-param name="CompanyId"></http-param>
						<http-param name="Sport"></http-param>
						<http-param name="btnRefresh">Refresh</http-param>
						<http-param name="ReportLiveDbDate">2015-11-01</http-param>
						<http-param name="p"></http-param>
						<http-param name="ticketNo"></http-param>
						<http-param name="ticketMatchNo"></http-param>
						<http-param name="ticketStakeTypeId"></http-param>
						<http-param name="ticketCompanyId">1</http-param>
						<http-param name="cancelReasonTypeCode">BET_CAN</http-param>
						<http-param name="reasonCancel"></http-param>
					</http>
				</html-to-xml>
			</var-def>
			<var-def name="records">
				<xpath expression="//tbody[@id=''ReportContent'']/tr[contains(@style,''text-align'')]">
					<var name="html_detail"/>
				</xpath>
			</var-def>
			<!--
			循环注单记录
			-->
			<loop item="item_record" index="k" filter="unique">
				<list><var name=''records''/></list>
				<body>
					<var-def name="company_matchno_betno">
						<regexp>
							<!--showLog(119, 4042127, 16551198)-->
							<regexp-pattern>showLog\((\d+),\s+(\d+),\s+(\d+)\)</regexp-pattern>
							<regexp-source>
								<var name="item_record"/>
							</regexp-source>
							<regexp-result>
								<template>${_1},${_2},${_3}</template>
							</regexp-result>
						</regexp>
					</var-def>
					<script>
						<![CDATA[
                			System.out.println(sys.getVar("company_matchno_betno"));
                			Object object=sys.getVar("company_matchno_betno");
                			if(object!=null)
                			{
                				String value=object.toString();
                				System.out.println("value="+value);
                				String[] values=value.split(",");
                				System.out.println("value="+values.length);
              					sys.defineVariable("company",values[0],true);
              					sys.defineVariable("matchno",values[1],true);
              					sys.defineVariable("betno",values[2],true);
                			}
                		]]>
					</script>


					<var-def name="html_history">
						<html-to-xml>
							<http method="get" url="${history_url}" content-type="text/html">
								<http-param name="companyId"><var name="company"/></http-param>
								<http-param name="BetNo"><var name="betno"/></http-param>
								<http-param name="MatchNo"><var name="matchno"/></http-param>
							</http>
						</html-to-xml>
					</var-def>


					<var-def name="temp">
						<xpath expression="//td[2]/text()">
							<var name="item_record"/>
						</xpath>
					</var-def>
					<var-def name="account">
						<script return="c">
							<![CDATA[
					     	Object obj=sys.getVar("temp");
					     	if(obj!=null)
					     	{
					     		System.out.println(obj.toString());
					     		String a="";
					     		if(obj.toString().indexOf("_P1")>=0)
					     			a=obj.toString().substring(4,20);
					     		else
					     			a=obj.toString().substring(4,14);
					     		System.out.println("a="+a);
					     		c=a;
					     	}else
					     	{
					     		c="";
					     	}
					     	]]>
						</script>
					</var-def>
					<notice envelope="result">
						<xquery>
							<xq-param name="doc"><var name="html_history"></var></xq-param>
							<xq-param name="item"><var name="item_record"></var></xq-param>
							<xq-param name="betno" type="string"><var name="betno"/></xq-param>
							<xq-param name="matchno" type="string"><var name="matchno"/></xq-param>
							<xq-param name="company" type="string"><var name="company"/></xq-param>
							<xq-param name="account" type="string"><var name="account"/></xq-param>
							<xq-expression>
								<![CDATA[
									declare variable $doc as node()* external;
									declare variable $item as node()* external;
								    declare variable $betno as xs:string external;
								    declare variable $matchno as xs:string external;
								    declare variable $company as xs:string external;
								    declare variable $account as xs:string external;

									let $sellteddate := data($doc//tr[last()]/td[position()=1])
									let $betdate := data($doc//tr[position()=1]/td[position()=1])

									let $betamount := replace(data($item//td[7]/div/div[2]),''[^0-9|.]+'','''')
									let $betamount1 := replace(data($item//td[6]/div/div[2]),''[^0-9|.]+'','''')

									let $actualbetamount := replace(data($item//td[8]/div/div[2]),''[^0-9|.]+'','''')
									let $actualbetamount1 := replace(data($item//td[7]/div/div[2]),''[^0-9|.]+'','''')

									let $winloss := replace(data($item//td[11]/div/div[1]),''[^0-9|.]+'','''')
									let $winloss1 := replace(data($item//td[10]/div/div[1]),''[^0-9|.]+'','''')

									let $turnover := replace(data($item//td[12]),''[^0-9|.]+'','''')
									let $turnover1 := replace(data($item//td[11]),''[^0-9|.]+'','''')

									let $ip := data($item//td[13])
									let $ip1 := data($item//td[12])

									return <record
									matchno="{$matchno}"
									company="{$company}"
									betno="{$betno}"
									sellteddate="{$sellteddate}"
									account="{$account}"
									betdate="{$betdate}"
									betamount="{ if ($matchno=''0'') then $betamount1 else $betamount }"
									actualbetamount="{ if ($matchno=''0'') then $actualbetamount1 else $actualbetamount }"
									winloss="{ if ($matchno=''0'') then $winloss1 else $winloss }"
									turnover= "{ if ($matchno=''0'') then $turnover1 else $turnover }"
									ip="{ if ($matchno=''0'') then $ip1 else $ip }"/>
								]]>
							</xq-expression>
						</xquery>
					</notice>
				</body>
			</loop>
		</body>
	</loop>
</config>
', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('6', 'IM_RANDOM', 'IM会话保持', '040', '040002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <random-call>
        <http method="get" url="https://dawoo-sbbo.inplaymatrix.com:81/BetEnquiry">
        </http>
    </random-call>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'RANDOM');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('7', 'SLC_INIT', 'SLC初始化', '080', '080000', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="url">http://ag.12macau.com/</var-def>
    <var-def name="html">
        <html-to-xml>
            <http method="get" url="http://ag.12macau.com"/>
        </html-to-xml>
    </var-def>
    <validate name="code" type="image/png" wait-time="60000" expression="\d+">
        <http method="get" response-content-type="image/png" url="http://ag.12macau.com/Login/GetCaptcha?Sat%20Mar%2026%202016%2019:25:59%20GMT+0800%20(CST)">
        </http>
    </validate>
    <var-def name="login">
        <http method="post" url="http://ag.12macau.com/Login/Logins">
            <http-param name="userN"><var name="userName"/></http-param>
            <http-param name="password"><var name="password"/></http-param>
            <http-param name="captchaValue">
                <var name="code"/>
            </http-param>
            <http-param name="language">en-US</http-param>
        </http>
    </var-def>
    <notice envelope="login" reverse="false" message="${login}" url-decode="true">
        <regexp>
            <regexp-pattern>(\"IsSuccess\":true,)</regexp-pattern>
            <regexp-source>
                <var name="login"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'INIT');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('8', 'SLC_MODIFY', 'SLC取消注单', '080', '080001', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <function name="multipage">
        <return>
            <empty>
                <var-def name="content"></var-def>
            </empty>
            <while condition="${isempty.toString().length() !=0}" maxloops="${maxloops}" index="i">
                <empty>
                    <var-def name="num">
                        <script return="result">
                            <![CDATA[
			                          int index=sys.getVar("i").toInt();
		    	                      result=index-1;
	            		             ]]>
                        </script>
                    </var-def>
                    <var-def name="content">
                        <html-to-xml>
                            <http url="${pageUrl}" method="post">
                                <http-param name="fromDate"><var name="fromDate"/></http-param>
                                <http-param name="pageNo">
                                    <var name="num"/>
                                </http-param>
                                <http-param name="rowsPerPage">20</http-param>
                                <http-param name="toDate"><var name="toDate"/></http-param>
                                <http-param name="userN">ZVV12MC</http-param>
                            </http>
                        </html-to-xml>
                    </var-def>
                    <var-def name="isempty">
                        <xpath expression="//tbody[@id=''tbodyList'']/tr">
                            <var name="content"/>
                        </xpath>
                    </var-def>
                </empty>
                <template>
                    <var name="content"/>
                </template>
            </while>
        </return>
    </function>


    <var-def name="modify">
        <xpath expression="//tr[@data-values]">
            <html-to-xml>
                <call name="multipage">
                    <call-param name="pageUrl">
                        http://ag.12macau.com/Report/GetCancelledTrans
                    </call-param>
                    <call-param name="isempty">
                        ooo
                    </call-param>
                </call>
            </html-to-xml>
        </xpath>
    </var-def>

    <var-def name="records">
        <loop item="itemData" index="i" filter="unique">
            <list>
                <var name="modify"/>
            </list>
            <body>
                <xquery>
                    <xq-param name="record">
                        <var name="itemData"></var>
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
                declare variable $record as node() external;
                <record>
                {
                 let $index:=data($record//td[1])
                 let $Bet_ID:=data($record//td[2])
                 let $Bet_Date:=data($record//td[3])
                 let $Draw_No:=data($record//td[4])
                 let $Game_No:=data($record//td[5])
                 let $Table:=data($record//td[6])
                 let $Game_Type:=data($record//td[7])
                 let $Bet_Code:=data($record//td[8])
                 let $Member:=data($record//td[9])
                 let $Bet_Amount:=data($record//td[10])

                return <base index="{$index}" bet_Id="{$Bet_ID}" bet_Date="{$Bet_Date}" draw_No="{$Draw_No}" game_No="{$Game_No}"
                table="{$Table}" game_Type="{$Game_Type}" bet_Code="{$Bet_Code}" member="{$Member}" bet_Amount="{$Bet_Amount}" ></base>
                }
                </record>
                ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>
    <result>
        <var name="records"/>
    </result>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('9', 'SLC_RANDOM', 'SLC会话保持', '080', '080002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <random-call>
        <http method="get" url="http://ag.12macau.com/Report">
        </http>
    </random-call>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'RANDOM');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('10', 'HG_INIT', 'HG初始化', '100', '100000', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

    <var-def name="initParam">
        <script >
            <![CDATA[
                String result = "200|100||tthcw8sm15001669l2971469|4|zh-cn";
                String[] params = result.split("\\|");
                sys.defineVariable("param0",params[0],true);
                sys.defineVariable("param1",params[1],true);
                sys.defineVariable("param2",params[2],true);
                sys.defineVariable("uid",params[3],true);
                sys.defineVariable("mtype",params[4],true);
                sys.defineVariable("lang",params[5],true);
			]]>

        </script>
    </var-def>
    <notice envelope="login" reverse="false">
    </notice>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'INIT');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('11', 'HG_GG_TRANS', 'HG公告', '100', '100008', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">


    <var-def name ="html">
        <html-to-xml>
            <http method="get" url="http://localhost:8181/api/hg/old_jr_gg.jsp">

            </http>
        </html-to-xml>
    </var-def>

    <var-def name ="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("html");
            String result = content.toString();
            result = result.replaceAll("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">","");
            System.out.println(result);
            sys.defineVariable("content",result,true);
            ]]>
        </script>
    </var-def>

    <var-def name="records">
        <xpath expression="//table[@id=''box'']//table//tr">
            <var name="content"></var>
        </xpath>
    </var-def>

    <var-def name="data">
        <loop item="itemData" index="i" >
            <list>
                <var name="records"/>
            </list>

            <body>
                <xquery>
                    <xq-param name="record">
                        <var name="itemData"></var>
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
	                        declare variable $record as node() external;
	                        let $index := data($record//td[1])
	                        let $date := data($record//td[2])
	                        let $content := data($record//td[3])
					        return if ($record//td[1]="{NUM}")
					    	   	   then  <data></data>
							       else  <data index="{$index}" date="{$date}" content="{$content}"></data>
	                    ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>


    <result>
        <var name="data"/>
    </result>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('12', 'HG_GJ_TRANS', 'HG冠军', '100', '100009', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">


    <var-def name="reloadgame">
        <http method="get" url="http://localhost:8181/api/hg/old_zp_gj.jsp">
        </http>
    </var-def>

    <result>
        <var name="reloadgame"/>
    </result>

</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('13', 'HG_SG_TRANS', 'HG赛果', '100', '100010', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">



    <var-def name="matchResult">
        <http method="get" url="http://localhost:8181/api/hg/old_jr_sg.jsp">

        </http>
    </var-def>


    <var-def name ="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("matchResult");
            String result = content.toString();
            result = result.replaceAll("</table-->","");
            result = result.replaceAll("<!--table>","");
            sys.defineVariable("matchResult",result,true);
            ]]>
        </script>
    </var-def>

    <var-def name="records">
        <xpath expression="//table[@id=''box'']//tr//td[@class=''mem'']//table[@class=''game''][2]//tbody/tr">
            <html-to-xml >
                <var name="matchResult"/>
            </html-to-xml>
        </xpath>
    </var-def>

    <var-def name="data">
        <loop item="itemData" index="i" filter="0:4" append="true" ignore="b_hline">
            <list>
                <var name="records"/>
            </list>
            <body>
                <xquery>
                    <xq-param name="record">
                        <var-def name="addtable">
                            <script>
                                <![CDATA[
					            Object content = sys.getVar("itemData");
								String result = content.toString();
								StringBuffer stringBuffer = new StringBuffer();
								stringBuffer.append("<table>");
								stringBuffer.append(result);
								stringBuffer.append("</table>");
					            sys.defineVariable("demo",stringBuffer.toString(),true);

					            ]]>
                            </script>
                        </var-def>

                        <html-to-xml ><var name="demo"></var></html-to-xml>
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
                            declare variable $record as node() external;
                                <rsMatch>
                                {
                                 let $id:=  substring-after(substring-after(data($record//tbody/tr[@class=''b_cen'']/@id),''_''),''_'')
                                 let $halfA:=data($record//tbody/tr[3]//td[2]//span)
                                 let $halfB:=data($record//tbody/tr[3]//td[3]//span)
                                 let $allA:=data($record//tbody/tr[4]//td[2]//span)
                                 let $allB:=data($record//tbody/tr[4]//td[3]//span)
                                 return
                                        <rsItems>
                                             <rsItem gid="{$id}" itemType="HGM" host="{$halfA}" client="{$halfB}"></rsItem>
                                             <rsItem gid="{$id}" itemType="GM"  host="{$allA}" client="{$allB}"></rsItem>
                                        </rsItems>
                                }
                                </rsMatch>
                        ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>

    <result>
        <var name="data"/>
    </result>

    <!--let $teamA:=data($record//tbody/tr[1]//td[3]//table//tbody//tr[1]//td[@class=''team_c_ft'']//a)-->
    <!--let $teamB:=data($record//tbody/tr[1]//td[3]//table//tbody//tr[1]//td[@class=''team_h_ft''])-->
    <!--let $time:=data($record//tbody/tr[1]//td[1])-->
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('14', 'HG_SGGJ_TRANS', 'HG赛果冠军', '100', '100011', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

    <var-def name="matchResult">
        <http method="get" url="http://localhost:8181/api/hg/old_jr_sggj.jsp">

        </http>
    </var-def>

    <var-def name="records">
        <xpath expression="//body//table[@class=''game'']//tr">
            <html-to-xml>
                <var name="matchResult"/>
            </html-to-xml>
        </xpath>
    </var-def>

    <var-def name="data">
        <loop item="itemData" index="i">
            <list>
                <var name="records"/>
            </list>

            <body>
                <xquery>
                    <xq-param name="record">
                        <var name="itemData"></var>
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
			                 declare variable $record as node() external;
			                 let $time:=data($record//td[1])
			                 let $rule:=data($record//td[2])
			                 let $teams:=data($record//td[3])
			                 let $win:=data($record//td[4])
				     		 return
				     		 if ($record//td[1]="")
					    	   	   then  <data></data>
							       else  <data time="{$time}" rule="{$rule}" teams="{$teams}" win="{$win}" ></data>

            		    ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>


    <result>
        <var name="data"/>
    </result>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('15', 'HG_TSGJ_TRANS', 'HG特殊冠军', '100', '100012', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">


    <var-def name="matchResult">
        <http method="get" url="http://localhost:8181/api/hg/old_jr_sgtsgj.jsp">

        </http>
    </var-def>


    <var-def name="records">
        <xpath expression="//body//table[@class=''game'']//tr">
            <html-to-xml>
                <var name="matchResult"/>
            </html-to-xml>
        </xpath>
    </var-def>

    <var-def name="data">
        <loop item="itemData" index="i">
            <list>
                <var name="records"/>
            </list>

            <body>
                <xquery>
                    <xq-param name="record">
                        <var name="itemData"></var>
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
			                 declare variable $record as node() external;
			                 let $time:=data($record//td[1])
			                 let $rule:=data($record//td[2])
			                 let $firstWin:=data($record//td[3])
			                 let $lastWin:=data($record//td[4])
			                 let $anyWin:=data($record//td[4])
				     		 return
				     		 if ($record//td[1]="")
					    	   	  then  <data></data>
							       else  <data time="{$time}" rule="{$rule}" firstWin="{$firstWin}" lastWin="{$lastWin}" anyWin="{$anyWin}" ></data>

            		    ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>

    <result>
        <var name="data"/>
    </result>

</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('16', 'HG_XZLS_TRANS', 'HG选择联赛', '100', '100013', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">



    <var-def name="records">
        <xpath expression="//body//form//table[@class=''leg_game'']//td">
            <html-to-xml>
                <http method="get" url="http://localhost:8181/api/hg/old_xzls.jsp"></http>

            </html-to-xml>
        </xpath>
    </var-def>


    <var-def name="data">
        <loop item="itemData" index="i">
            <list>
                <var name="records"/>
            </list>

            <body>
                <xquery>
                    <xq-param name="record">
                        <var name="itemData"></var>
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
	                         declare variable $record as node() external;
	                         let $id := data($record//td[1]//div//input//@id)
	                         let $content := data($record//td[1]//div//input//@value)
					         return <match id="{$id}"  content="{$content}"></match>
	                    ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>





</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('17', 'HG_DATA_TRANS', 'HG数据', '100', '100014', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">


    <var-def name="type">
        <var name="rtype"/>
    </var-def>

    <script>
        <![CDATA[
            String result = sys.getVar("type").toString();
            if(result.equals("1")){
                String url ="www.baidu.com";
                sys.defineVariable("url",url,true);
            }else{
                String url ="http://localhost:8181/api/hg/old_jr_drdd.jsp";
                sys.defineVariable("url",url,true);
                }
			 ]]>
    </script>

    <var-def name="record">
        <http method="get" url="${url}">
        </http>
    </var-def>

    <var-def name="result">
        <regexp flag-multiline="true">
            <regexp-pattern>_=parent;(.*)function</regexp-pattern>
            <regexp-source>
                <var name="record"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </var-def>


    <result>
        <var name="result"/>
    </result>
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'BUSINESS');
