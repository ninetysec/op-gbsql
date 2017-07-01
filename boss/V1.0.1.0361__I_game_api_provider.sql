-- auto gen by cherry 2017-07-01 10:19:10
UPDATE  "game_api_provider" SET "id"='23', "abbr_name"='opussport', "full_name"=NULL, "api_url"='http://3rd.game.api.com/opussport-api/', "remarks"='测试环境:http://testopussporttoken.ampinplayopt0matrix.com/api/', "jar_url"='file:/data/impl-jars/api/api-opussport.jar', "api_class"='so.wwb.gamebox.service.gameapi.impl.OpusSportGameApi', "jar_version"='20170602120611', "ext_json"='{"operator_id":"4C936EDA-6C77-4A46-B55F-D97AFA63B338","site_code":"DAP","secret_key":"862B05FA0F62","valsecret_key":"B6C571320B3D","product_code":"sb2","search-minute":"10","loginUrl":"https://opus.ampinplayopt0matrix.com/api/opus/login.html","domain":"ampinplayopt0matrix.com","gameUrl":"http://opussport.ampinplayopt0matrix.com","validateTokenExpire":60,"membertype":"CASH","min_transfer":"0","max_transfer":"100000","modify-minute":"10"}', "default_timezone"='+0', "support_agent"='f' WHERE ("id"='23');

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT    '2309', 'HTTP', '', 'fetchModifiedRecord', 'POST', 'OPUS-SPORT拉取未结算注单数据', 'org.soul.model.gameapi.param.FetchModifiedRecordParam', 'org.soul.model.gameapi.result.FetchModifiedRecordResult', 'FORM', 'XML', '23', ''  WHERE 2309 NOT IN(SELECT id FROM game_api_interface WHERE id=2309);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT   '23034', 'fromDate', 'startTime', 't', NULL, NULL, '', '', '2309', '', 'OPUS-SPORT-查询开始时间', '', ''  WHERE 23034 NOT IN(SELECT id FROM game_api_interface_request WHERE id=23034);

INSERT INTO "gather_category" ("id", "name", "status", "create_time") SELECT   '230', 'OPUS-SPORT', '1', '2017-06-19 14:05:54'  WHERE '230' NOT IN(SELECT id FROM gather_category WHERE id='230');

INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT   '232', 'OPUSSPORT_RANDOM', 'OPUS-SPORT会话保持', '230', '230002', ' ', ' <?xml version="1.0" encoding="UTF-8"?>

	<config charset="UTF-8">
	    <random-call>
		<http method="get" url="http://adminopussport.ampinplayopt0matrix.com/Pages/Customer/CustomerList.aspx"/>
	    </random-call>
	</config>', '201608101542', ' ', ' ', '1', '2016-08-10 15:47:50', 'RANDOM' WHERE 232 NOT IN(SELECT id FROM gather_flow WHERE id=232);
INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT   '233', 'OPUSSPORT_RECORD', 'OPUS-SPORT未结算注单', '230', '230003', ' ', '<?xml version="1.0" encoding="utf-8"?>
<config>
 <var-def name="betrecordurl" overwrite="overwrite_existing">http://adminopussport.ampinplayopt0matrix.com/Pages/trading/BetEnquiry.aspx</var-def>
    <function name="multipage">
        <return>
            <empty>
                <var-def name="loginrecord">
                    <http method="get" url="${recordurl}"></http>
                </var-def>
                <var-def name="recordparamhtml">
                    <html-to-xml>
                        <regexp flag-multiline="yes">
                            <regexp-pattern>
                                <![CDATA[(<input.*id="__EVENTVALIDATION".*?/>)]]>
			    </regexp-pattern>
                            <regexp-source>
                                <var name="loginrecord" />
                            </regexp-source>
                            <regexp-result>
                                <template>${_1}</template>
                            </regexp-result>
                        </regexp>
                    </html-to-xml>
                </var-def>
                <var-def name="__EVENTTARGET">
                    <xpath expression="//*[@id=''__EVENTTARGET'']/@value">
                        <var name="recordparamhtml" />
                    </xpath>
                </var-def>
                <var-def name="__EVENTARGUMENT">
                    <xpath expression="//*[@id=''__EVENTARGUMENT'']/@value">
                        <var name="recordparamhtml" />
                    </xpath>
                </var-def>
                <var-def name="__LASTFOCUS">
                    <xpath expression="//*[@id=''__LASTFOCUS'']/@value">
                        <var name="recordparamhtml" />
                    </xpath>
                </var-def>
                <var-def name="__VIEWSTATE">
                    <xpath expression="//*[@id=''__VIEWSTATE'']/@value">
                        <var name="recordparamhtml" />
                    </xpath>
                </var-def>
                <var-def name="__VIEWSTATEGENERATOR">
                    <xpath expression="//*[@id=''__VIEWSTATEGENERATOR'']/@value">
                        <var name="recordparamhtml" />
                    </xpath>
                </var-def>
                <var-def name="__EVENTVALIDATION">
                    <xpath expression="//*[@id=''__EVENTVALIDATION'']/@value">
                        <var name="recordparamhtml" />
                    </xpath>
                </var-def>
            </empty>
            <var-def name="getrecordhtml">
                <http method="post" url="http://adminopussport.ampinplayopt0matrix.com/Pages/trading/BetEnquiry.aspx">
                    <http-param name="ctl00$mainScriptManager">ctl00$MainContent$upMain|ctl00$MainContent$btnSubmit</http-param>
                    <http-param name="ctl00$MainContent$txtFromBetDate">
                        <var name="FromBetDate" />
                    </http-param>
                    <http-param name="ctl00$MainContent$txtFromBetDateHour">
                        <var name="FromBetDateHour" />
                    </http-param>
                    <http-param name="ctl00$MainContent$txtFromBetDateMinute">
                        <var name="FromBetDateMinute" />
                    </http-param>
                    <http-param name="ctl00$MainContent$txtToBetDate">
                        <var name="ToBetDate" />
                    </http-param>
                    <http-param name="ctl00$MainContent$txtToBetDateHour">
                        <var name="ToBetDateHour" />
                    </http-param>
                    <http-param name="ctl00$MainContent$txtToBetDateMinute">
                        <var name="ToBetDateMinute" />
                    </http-param>
                    <http-param name="ctl00$MainContent$ddlGameType">-99</http-param>
                    <http-param name="ctl00$MainContent$ddlPlatform" />
                    <http-param name="ctl00$MainContent$txtFromBetID" />
                    <http-param name="ctl00$MainContent$txtToBetID" />
                    <http-param name="ctl00$MainContent$ddlBetStatus">OUTSTANDING</http-param>
                    <http-param name="ctl00$MainContent$txtMatchID" />
                    <http-param name="ctl00$MainContent$ddlBranch" />
                    <http-param name="ctl00$MainContent$txtUsername" />
                    <http-param name="ctl00$MainContent$txtStampUser" />
                    <http-param name="ctl00$MainContent$ucPaging01$ddlCurPage">
                        <var name="recordnum" />
                    </http-param>
                    <http-param name="ctl00$MainContent$ucPaging01$ddlPageSize">50</http-param>
                    <http-param name="__EVENTTARGET">
                        <var name="__EVENTTARGET" />
                    </http-param>
                    <http-param name="__EVENTARGUMENT">
                        <var name="__EVENTARGUMENT" />
                    </http-param>
                    <http-param name="__LASTFOCUS">
                        <var name="__LASTFOCUS" />
                    </http-param>
                    <http-param name="__VIEWSTATE">
                        <var name="__VIEWSTATE" />
                    </http-param>
                    <http-param name="__VIEWSTATEGENERATOR">
                        <var name="__VIEWSTATEGENERATOR" />
                    </http-param>
                    <http-param name="__EVENTVALIDATION">
                        <var name="__EVENTVALIDATION" />
                    </http-param>
                    <http-param name="__ASYNCPOST">true</http-param>
                    <http-param name="ctl00$MainContent$btnSubmit">Submit</http-param>
                </http>
            </var-def>
        </return>
    </function>
    <var-def name="getrecord">
        <call name="multipage">
            <call-param name="recordnum">1</call-param>
            <call-param name="recordurl">
                <var name="betrecordurl" />
            </call-param>
        </call>
    </var-def>
    <!--获取所需参数数据-->
    <var-def name="trrecords">
        <xpath expression="//*[@id=''MainContent_gvMain'']/tbody/tr[@class!=''header'']">
            <html-to-xml>
                <var name="getrecord" />
            </html-to-xml>
        </xpath>
    </var-def>
    <var-def name="totalnums">
        <xpath expression="//*[@id=''MainContent_ucPaging01_ddlCurPage'']/option[last()]/@value">
            <html-to-xml>
                <var name="getrecord" />
            </html-to-xml>
        </xpath>
    </var-def>
    <var-def name="getlastbrdata">
        <regexp flag-multiline="yes">
            <regexp-pattern>
                <![CDATA[(hiddenField.*)]]>
</regexp-pattern>
            <regexp-source>
                <var name="getrecord" />
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </var-def>
    <!--判断是否登陆过期-->

    <!--获取所有行数据-->
    <var-def name="getalltrrecords">
        <while condition="${getlastbrdata.toString().length() !=0}" maxloops="${totalnums}" index="i">
            <empty>
                <var-def name="num">
                    <script return="result">
                        <![CDATA[
                    Object content = sys.getVar("getlastbrdata");
                    String dataparame = content.toString();

                    String[] splits = dataparame.split("hiddenField");

                String ss1 = splits[1].replace("|", "@").split("@")[2];
                String ss2 = splits[2].replace("|", "@").split("@")[2];
                String ss3 = splits[3].replace("|", "@").split("@")[2];
                String ss4 = splits[4].replace("|", "@").split("@")[2];
                String ss5 = splits[5].replace("|", "@").split("@")[2];
                String ss6 = splits[6].replace("|", "@").split("@")[2];
                sys.defineVariable("__EVENTTARGET",ss1,true);
                sys.defineVariable("__EVENTARGUMENT",ss2,true);
                sys.defineVariable("__LASTFOCUS",ss3,true);
                sys.defineVariable("__VIEWSTATE",ss4,true);
                sys.defineVariable("__VIEWSTATEGENERATOR",ss5,true);
                sys.defineVariable("__EVENTVALIDATION",ss6,true);
                int index=sys.getVar("i").toInt();
                result=index;
                                                     ]]>
</script>
                </var-def>
            </empty>
            <var-def name="content">
                <xpath expression="//*[@id=''MainContent_gvMain'']/tbody/tr[@class!=''header'']">
                    <html-to-xml>
                        <var-def name="getrecord" overwrite="overwrite_existing">
                            <http method="post" url="${betrecordurl}">
                                <http-param name="ctl00$mainScriptManager">ctl00$MainContent$upMain|ctl00$MainContent$ucPaging01$ddlCurPage</http-param>
                                <http-param name="ctl00$MainContent$txtFromBetDate">
                                    <var name="FromBetDate" />
                                </http-param>
                                <http-param name="ctl00$MainContent$txtFromBetDateHour">
                                    <var name="FromBetDateHour" />
                                </http-param>
                                <http-param name="ctl00$MainContent$txtFromBetDateMinute">
                                    <var name="FromBetDateMinute" />
                                </http-param>
                                <http-param name="ctl00$MainContent$txtToBetDate">
                                    <var name="ToBetDate" />
                                </http-param>
                                <http-param name="ctl00$MainContent$txtToBetDateHour">
                                    <var name="ToBetDateHour" />
                                </http-param>
                                <http-param name="ctl00$MainContent$txtToBetDateMinute">
                                    <var name="ToBetDateMinute" />
                                </http-param>
                                <http-param name="ctl00$MainContent$ddlGameType">-99</http-param>
                                <http-param name="ctl00$MainContent$ddlBetStatus">OUTSTANDING</http-param>
                                <http-param name="ctl00$MainContent$ucPaging01$ddlCurPage">
                                    <var name="num" />
                                </http-param>
                                <http-param name="ctl00$MainContent$ucPaging01$ddlPageSize">50</http-param>
                                <http-param name="__EVENTTARGET">
                                    <var name="__EVENTTARGET" />
                                </http-param>
                                <http-param name="__EVENTARGUMENT">
                                    <var name="__EVENTARGUMENT" />
                                </http-param>
                                <http-param name="__LASTFOCUS">
                                    <var name="__LASTFOCUS" />
                                </http-param>
                                <http-param name="__VIEWSTATE">
                                    <var name="__VIEWSTATE" />
                                </http-param>
                                <http-param name="__VIEWSTATEGENERATOR">
                                    <var name="__VIEWSTATEGENERATOR" />
                                </http-param>
                                <http-param name="__EVENTVALIDATION">
                                    <var name="__EVENTVALIDATION" />
                                </http-param>
                                <http-param name="__ASYNCPOST">true</http-param>
                            </http>
                        </var-def>
                    </html-to-xml>
                </xpath>
            </var-def>
            <!--判断是否登陆过期-->
            <session-exp init="true" value="pageRedirect">
                <html-to-xml>
                    <var name="getrecord" />
                </html-to-xml>
            </session-exp>
        </while>
    </var-def>
    <var-def name="records">
        <loop item="itemData" index="i" filter="unique">
            <list>
                <var name="getalltrrecords" />
            </list>
            <body>
                <xquery>
                    <xq-param name="record">
                        <var name="itemData" />
                    </xq-param>
                    <xq-expression>
                        <![CDATA[
                        declare variable $record as node() external;
                        <record>
                        {
                        let $index:=data($record//td[1])
                        let $member_id:=data($record//td[2]/span/text())
                        let $trans_id:=data($record//td[3]/text())
                        let $transaction_time:=data($record//td[4]/text())
                        let $stake:=data($record//td[11]/text())
												let $sport_type:=data($record//td[7]/text()[1])
                        return  <base index="{$index}" member_id="{$member_id}" trans_id="{$trans_id}" transaction_time="{$transaction_time}" stake="{$stake}" sport_type="{$sport_type}" ></base>
                        }
                        </record>
                        ]]>
</xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>
    <result>
        <var name="records" />
    </result>
</config>', '2016086615', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS' WHERE 233 NOT IN(SELECT id FROM gather_flow WHERE id=233);

INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT   '231', 'OPUSSPORT_INIT', 'OPUS-SPORT初始化', '230', '230001', '', '<?xml version="1.0" encoding="utf-8"?>
<config>
 <var-def name="sporturl">http://adminopussport.ampinplayopt0matrix.com/</var-def>
    <var-def name="loginhtml">
        <html-to-xml>
            <http method="get" url="${sporturl}" />
        </html-to-xml>
    </var-def>
    <var-def name="imagehtml">
        <html-to-xml>
            <regexp flag-multiline="yes">
                <regexp-pattern>
                    <![CDATA[(<img.*id="imgCaptcha" class="captcha_image.*?/>)]]>
</regexp-pattern>
                <regexp-source>
                    <var name="loginhtml" />
                </regexp-source>
                <regexp-result>
                    <template>${_1}</template>
                </regexp-result>
            </regexp>
        </html-to-xml>
    </var-def>
    <var-def name="image">
        <xpath expression="//*[@id=''imgCaptcha'']/@src">
            <var name="imagehtml" />
        </xpath>
    </var-def>
    <validate name="code" type="image/png" wait-time="60000" expression="\d+">
        <http method="get" response-content-type="image/png" url="${sporturl}/Credential/${image}" />
    </validate>
    <var-def name="inputlist">
        <html-to-xml>
            <regexp flag-multiline="yes">
                <regexp-pattern>
                    <![CDATA[(<input.*id="__EVENTVALIDATION".*?/>)]]>
</regexp-pattern>
                <regexp-source>
                    <var name="loginhtml" />
                </regexp-source>
                <regexp-result>
                    <template>${_1}</template>
                </regexp-result>
            </regexp>
        </html-to-xml>
    </var-def>
    <var-def name="EVENTTARGET">
        <xpath expression="//*[@id=''EVENTTARGET'']/@value">
            <var name="inputlist" />
        </xpath>
    </var-def>
    <var-def name="EVENTARGUMENT">
        <xpath expression="//*[@id=''__EVENTARGUMENT'']/@value">
            <var name="inputlist" />
        </xpath>
    </var-def>
    <var-def name="LASTFOCUS">
        <xpath expression="//*[@id=''__LASTFOCUS'']/@value">
            <var name="inputlist" />
        </xpath>
    </var-def>
    <var-def name="VIEWSTATE">
        <xpath expression="//*[@id=''__VIEWSTATE'']/@value">
            <var name="inputlist" />
        </xpath>
    </var-def>
    <var-def name="EVENTVALIDATION">
        <xpath expression="//*[@id=''__EVENTVALIDATION'']/@value">
            <var name="inputlist" />
        </xpath>
    </var-def>
    <var-def name="VIEWSTATEGENERATOR">
        <xpath expression="//*[@id=''__VIEWSTATEGENERATOR'']/@value">
            <var name="inputlist" />
        </xpath>
    </var-def>
    <!--获取登陆的url-->
    <var-def name="logins">
        <var-def name="loginform">
            <xpath expression="//*[@id=''Form1'']/@action">
                <html-to-xml>
                    <regexp flag-multiline="yes">
                        <regexp-pattern>
                            <![CDATA[(<div.*id="content" .*?/>)]]>
</regexp-pattern>
                        <regexp-source>
                            <var name="loginhtml" />
                        </regexp-source>
                        <regexp-result>
                            <template>${_1}</template>
                        </regexp-result>
                    </regexp>
                </html-to-xml>
            </xpath>
        </var-def>
        <var-def name="loginurl">
            <script return="result">
                <![CDATA[
                    Object content = sys.getVar("loginform");
                    String lurl = content.toString().replace("./", "");
                    String url = sys.getVar("sporturl").toString();


                            result=sys.fullUrl(sys.fullUrl(url,"Credential/"),lurl);
                         ]]>
</script>
        </var-def>
        <http method="post" url="${loginurl}">
            <http-param name="rdlLang">en-US</http-param>
            <http-param name="btnLogin">Sign In</http-param>
            <http-param name="txtUsername">
                <var name="userName"/>
            </http-param>
            <http-param name="txtPassword">
                 <var name="password"/>
            </http-param>
            <http-param name="txtAccessCode">
                <var name="code" />
            </http-param>
            <http-param name="__EVENTTARGET">
                <var name="EVENTTARGET" />
            </http-param>
            <http-param name="__EVENTARGUMENT">
                <var name="EVENTARGUMENT" />
            </http-param>
            <http-param name="__LASTFOCUS">
                <var name="LASTFOCUS" />
            </http-param>
            <http-param name="__VIEWSTATE">
                <var name="VIEWSTATE" />
            </http-param>
            <http-param name="__VIEWSTATEGENERATOR">
                <var name="VIEWSTATEGENERATOR" />
            </http-param>
            <http-param name="__EVENTVALIDATION">
                <var name="EVENTVALIDATION" />
            </http-param>
        </http>
    </var-def>
    <notice envelope="login" reverse="false" message="登入失败">
        <regexp>
            <regexp-pattern>
                <template>("lnkLogout")</template>
            </regexp-pattern>
            <regexp-source>
                <var name="logins" />
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
</config>', '201611092013', '', '', '1', '2016-11-09 20:18:40', 'INIT' WHERE 231 NOT IN(SELECT id FROM gather_flow WHERE id=231);


INSERT INTO "gather_schedule" ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT   '18', 'OPUS-SPORT后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-09-06 20:24:22', '2016-09-06 20:24:22', NULL, NULL, '2016', '230'  WHERE 18 NOT IN(SELECT id FROM gather_schedule WHERE id=18);


INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") SELECT   '230001', 'OPUS-SPORT初始化', '230', '1', NULL  WHERE '230001' NOT IN(SELECT id FROM gather_type WHERE id='230001');
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") SELECT   '230002', 'OPUS-SPORT会话保持', '230', '1', NULL  WHERE '230002' NOT IN(SELECT id FROM gather_type WHERE id='230002');
INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") SELECT   '230003', 'OPUS-SPORT未结算注单查询', '230', '1', NULL  WHERE '230003' NOT IN(SELECT id FROM gather_type WHERE id='230003');


INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '181', 'gatheruser01', 'password123', 'OPUS-SPORT用户', '01', '1', '2017-06-19 14:21:39', '230', 'f' WHERE 181 NOT IN(SELECT id FROM gather_user WHERE id=181);
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '182', 'gatheruser02', 'password123', 'OPUS-SPORT用户', '01', '1', '2017-06-19 14:21:39', '230', 'f' WHERE 182 NOT IN(SELECT id FROM gather_user WHERE id=182);
INSERT INTO "gather_user" ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '183', 'gatheruser03', 'password123', 'OPUS-SPORT用户', '01', '1', '2017-06-19 14:21:39', '230', 'f' WHERE 183 NOT IN(SELECT id FROM gather_user WHERE id=183);


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT   'apiId-23-OPUSSPORT-未结算注单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2017-05-24 02:13:48.132917', NULL, 'api-23-M', 'f', 'f', '23', 'java.lang.Integer', 'B', 'scheduler4Api' WHERE NOT EXISTS(SELECT id  FROM  task_schedule where  job_code='api-23-M')
