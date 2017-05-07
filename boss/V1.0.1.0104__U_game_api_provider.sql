-- auto gen by jerry 2016-08-17 22:04:22
  select redo_sqls($$
  ALTER table game_api_provider add column default_timezone varchar(16);
  $$);
  COMMENT ON COLUMN "game_api_provider"."default_timezone" IS '默认时区';


UPDATE game_api_provider SET default_timezone='GMT+8' WHERE abbr_name in('SLC','PG','KG','GD','PT','OG','DS');


UPDATE game_api_provider SET default_timezone='GMT+0' WHERE abbr_name in('MG','HB');


UPDATE game_api_provider SET default_timezone='GMT-4' WHERE abbr_name in('NYX','SS','IM','AG','BB');






INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  SELECT '511', '注单异常查询', 'gameApi/exceptionTransfer/index.html', '注单异常查询', '5', NULL, '11', 'boss', 'maintenance:order', '1', NULL, 'f', 't', 't'
  WHERE  not EXISTS (SELECT id from sys_resource where id=511);





INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT'20', 'PT_INIT', 'PT初始化', '060', '060001', ' ', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
	<var-def name="url">dawoop.imptbo2.inplaymatrix.com</var-def>
    <var-def name="init">
        <http method="get" url="${url}">
        </http>
    </var-def>
    <var-def name="token">
        <xpath expression="//input[@name=''__RequestVerificationToken'']/@value">
            <var name="init"/>
        </xpath>
    </var-def>
    <var-def name="login">
        <http method="post" url="${sys.fullUrl(url,&quot;/Accounts/LogOn?ReturnUrl=%2F&quot;)}">
            <http-param name="MerchantCode">
                dawooprod
            </http-param>
            <http-param name="AccountId">
                <var name="userName"/>
            </http-param>
            <http-param name="Password">
                 <var name="password"/>
            </http-param>
            <http-param name="__RequestVerificationToken">
                <var name="token"></var>
            </http-param>
        </http>
    </var-def>
    <notice envelope="login" reverse="true" message="Login Fail">
        <regexp>
            <regexp-pattern>(AccountId)</regexp-pattern>
            <regexp-source>
                <var name="login"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:46:03', 'INIT'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='060001');

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT'21', 'PT_TRANS', 'PT帐务查询', '060', '060002', ' ', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
	<!--query searchList-->
    <var-def name="searchList">
        <html-to-xml>
            <http method="post" url="${sys.fullUrl(url,&quot;/Players/Search&quot;)}">
                <http-param name="SelectedMerchantId">93</http-param>
                <http-param name="SelectedCurrency">All</http-param>
                <http-param name="PlayerId"><var name="account"/></http-param>
                <http-param name="filter">Search</http-param>
            </http>
        </html-to-xml>
    </var-def>
    <var-def name="aList">
        <xpath expression="//a[contains(@href,''/PlayerDetails?PlayerId='')]">
            <var name="searchList"/>
        </xpath>
    </var-def>
    <var-def name="player">
        <script return="playerId">
            <![CDATA[
            String playerId = "";
            if(sys.getVar("aList")!=null){
            	String a=sys.getVar("aList").toString();
            	playerId = a.replace("/PlayerDetails?PlayerId=","").split("\"")[1];
            	System.out.println("playerId="+playerId);
            }
            ]]>
        </script>
    </var-def>
    <var-def name="check">
        <html-to-xml>
            <http method="get" url="${sys.fullUrl(url,&quot;/PlayerDetails/LoadPlayerTransactions&quot;)}">
                <http-param name="playerId">
                   <var name="player"/>
                </http-param>
                <http-param name="kioskDateType">last/10/timeperiod/now</http-param>
            </http>
        </html-to-xml>
    </var-def>
    <var-def name="check_value">
        <![CDATA[Submit]]>
    </var-def>
    <session-exp init="true" value="${check_value}">
        <xpath expression="//input[@type=''submit'']/@value">
            <var name="check"/>
        </xpath>
    </session-exp>
  <var-def name="parse">
        <xpath expression="//tbody/tr">
            <var name="check"/>
        </xpath>
    </var-def>
    <xml-to-json>
        <var name="parse"></var>
    </xml-to-json>
    <var-def name="records">
        <loop item="itemData" index="i" filter="unique">
            <list>
                <var name="parse"/>
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
                let $date:=data($record//td[1]/span/text())
                 let $type:=data($record//td[2]/span/text())
                 let $amount:=data($record//td[3]/span/text())
                 let $status:=data($record//td[4]/span/text())

                return <base date="{$date}" type="{$type}" amount="{$amount}" status="{$status}"></base>
                }
                </record>
                ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='060002');

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT'22', 'PT_RANDOM', 'PT会话保持', '060', '060003', ' ', ' <?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <random-call>
        <http method="get" url="dawoop.imptbo2.inplaymatrix.com/TransferLogs"/>
    </random-call>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:50', ' RANDOM'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='060003');

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT'23', 'AG_INIT', 'AG初始化', '090', '090001', ' ', '<?xml version="1.0" encoding="UTF-8"?>
<config>
	<var-def name="html">
        <html-to-xml>
            <http method="get" url="http://data.agingames.com/"/>
        </html-to-xml>
    </var-def>

     <validate name="code" type="image/png" wait-time="60000" expression="\d+">
        <http method="get" response-content-type="image/png"  url="http://data.agingames.com/images/captcha.jsp"/>
    </validate>

    <var-def name="login">
        <http method="post" url="http://data.agingames.com/dspcms/main/Login_process.htm">
            <http-param name="lang">zh_CN</http-param>
            <http-param name="loginname">bdyh48</http-param>
            <http-param name="password">Ve25GbtW</http-param>
            <http-param name="random"><var name="code"/></http-param>
        </http>
    </var-def>
    <var-def name="username">bdyh48</var-def>
    <notice envelope="login" reverse="false" message="登入失败">
        <regexp>
            <regexp-pattern>
            	<template>(${username})</template></regexp-pattern>
            <regexp-source>
                <var name="login"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:46:03', 'INIT'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='090001');

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT '24', 'AG_TRANS', 'AG额度转换', '090', '090002', ' ', '<?xml version="1.0" encoding="UTF-8"?>
<config>
<function name="multipage">
        <return>
            <empty>
                <var-def name="quit">false</var-def>
            </empty>
            <while condition="${quit.toString().length() !=4}" maxloops="20" index="i">
                <empty>
                    <var-def name="content">
                        <http url="${pageUrl}" method="post" content-type="text/xml">
                            <http-param name="xml">
                                <script return="result">
                                    <![CDATA[
                                    int index=sys.getVar("i").toInt();
                                    System.out.println("index:"+index);
                                    Object setNum=sys.getVar("setNum");
                                    System.out.println("Variable:"+setNum);
                                    int page= setNum.toInt();
                                    int start = (index-1)*page;
                                    System.out.println("start:"+start);
                                    Object FromTime=sys.getVar("FromTime");
                                    FromTime = FromTime.toString();
                                    System.out.println("FromTime:"+FromTime);
                                    Object ToTime=sys.getVar("ToTime");
                                    ToTime = ToTime.toString();
                                    System.out.println("ToTime:"+ToTime);
																		Object account=sys.getVar("account");
																		String MemberId=account.toString();
																	  Object transferType=sys.getVar("transferType");
									                  transferType=transferType.toString();
                                    result ="<message type=\"request\"><condition start=\""+start+"\" limit=\""+page+"\"   BillId=\"\"   FromTime=\""+FromTime+"\" ToTime=\""+ToTime+"\" Order=\"jointime\" By=\"DESC\"  GameCurrencyType=\"\" Num=\""+page+"\" Agent=\"\"   FZ=\"\" MemberId=\""+MemberId+"\" Remark=\"\"  Tradeno=\"\"     Credittranstype=\""+transferType+"\"  /></message>";
                                    ]]>
                                </script>
                            </http-param>
                        </http>
                    </var-def>
                    <var-def name="totalCount">
                        <xpath expression="//totalCount[1]/text()">
                            <var name="content"/>
                        </xpath>
                    </var-def>
                    <var-def name="quit">
                        <script return="condition">
                            <![CDATA[
                                        Object content=sys.getVar("content");
                                        System.out.println("content:"+content);
                                        Object totalCount=sys.getVar("totalCount");
                                        System.out.println("totalCount:"+totalCount);
                                        Object setNum=sys.getVar("setNum");
                                        System.out.println("setNum:"+setNum);
                                        int page= setNum.toInt();
                                        System.out.println("page:"+page);
                                        int count = totalCount.toInt();
                                        System.out.println("count:"+count);
                                        int total = count%page==0?count/page:count/page+1;;
                                        System.out.println("total:"+total);
                                        System.out.println("result:"+(total<index));
                                        if(total<index){
                                            condition= "true";
                                        }else{
                                            condition= "false";
                                        }
                                        ]]>
                        </script>
                    </var-def>
                </empty>
                <template>
                    <var name="content"/>
                </template>
            </while>
        </return>
    </function>
    <var-def name="record">
        <call name="multipage">
            <call-param name="pageUrl">
               http://data.agingames.com/dspcms/home/CreditRecord_queryCreditRecords.htm
            </call-param>
	    <call-param name="setNum">25</call-param>
        </call>
    </var-def>
	<session-exp init="true" value="Login_process.htm">
        <regexp>
            <regexp-pattern>(TotalRows)</regexp-pattern>
            <regexp-source>
                <var name="record"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>
    <var-def  name="records">
			<xml-to-json>
        <var name="record"/>
      </xml-to-json>
    </var-def>
    <result>
			<var name="records"/>
    </result>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='090002');

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT'25', 'AG_RANDOM', 'AG会话保持', '090', '090003', ' ', $$ <?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <random-call>
        <http method="get" url="http://data.agingames.com/dspcms/home/MemberDetail.htm"/>
    </random-call>
</config>$$, '201608101545', ' ', ' ', '1', '2016-08-10 15:47:50', ' RANDOM'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='090003');

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT '26', 'SLC_TRANS', 'SLC额度转换', '080', '080003', '', $$<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
	<function name="account">
		<return>
			<empty>
				<var-def name="quit">false</var-def>
			</empty>
			<while condition="${quit.toString().length() !=4}" maxloops="${maxloops}" index="i">
				<empty>
					 <var-def name="content">
					 	<var-def name="j">
					 		<script return="condition">
					 			<![CDATA[
					 			int index=sys.getVar("i").toInt();
					 				condition=index-1;
					 			]]>
					 		</script>
					 	</var-def>
						<http url="${pageUrl}" method="post">
							<http-param name="fromDate"><var name="fromDate"/></http-param>
							<http-param name="pageNo"><var name="j"/></http-param>
							<http-param name="rowsPerPage">20</http-param>
							<http-param name="excutedBy"></http-param>
							<http-param name="toDate"><var name="toDate"/></http-param>
							<http-param name="totalRows">0</http-param>
							<http-param name="transType"><var name="transType"/></http-param>
							<http-param name="userName"><var name="userName"/></http-param>
						</http>
						</var-def>
						<var-def name="totalCount">
							<xpath expression="//TotalRows/text()">
								<json-to-xml>
									<var-def name="aa">
									<xpath expression="//body/input/@data-values">
										<html-to-xml>
											<var name="content"/>
										</html-to-xml>
									</xpath>
									</var-def>
								</json-to-xml>
							</xpath>
						</var-def>
		        <var-def name="quit">
                        <script return="conditions">
                            <![CDATA[
 										 Object content=sys.getVar("content");
                                        System.out.println("content:"+content);
                                        Object totalCount=sys.getVar("totalCount");
                                        System.out.println("totalCount:"+totalCount);
                                        Object setNum=sys.getVar("setNum");
                                        System.out.println("setNum:"+setNum);
                                        int page= setNum.toInt();
                                        System.out.println("page:"+page);
                                        int count = totalCount.toInt();
                                        System.out.println("count:"+count);
                                        int total = count%page==0?count/page:count/page+1;;
                                        System.out.println("total:"+total);

                                       if(total<index){
                                            conditions= "true";
                                        }else{
                                            conditions= "false";
                                        }
                                        ]]>
                        </script>
                    </var-def>
				</empty>
				<template>
            <var name="content"/>
        </template>
			</while>
		</return>
	</function>
	<var-def name="record">
        <call name="account">
            <call-param name="pageUrl">
               http://ag.12macau.com/Report/GetDepositWithdrawal
            </call-param>
            <call-param name="setNum">20</call-param>
        </call>
    </var-def>
	<session-exp init="true" value="Login_process.htm">
        <regexp>
            <regexp-pattern>(TotalRows)</regexp-pattern>
            <regexp-source>
                <var name="record"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>
   <var-def name="records">
    	<xml-to-json>
	    	<xpath expression="//tbody/tr">
	    		<html-to-xml>
	    		<var name="record"/>
	    		</html-to-xml>
	    	</xpath>
    	</xml-to-json>
    </var-def>
    <result>
        <var name="records"/>
    </result>
</config>
$$, '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='080003');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT '27', 'MG_RECORDS', '玩家额度记录', '030', '030002', '', $$<?xml version="1.0" encoding="UTF-8"?>
<config>
    <var-def name="agent">
        <xpath expression="//a[@class=''brand'']/@href">
            <html-to-xml>
                <http method="get" url="ag.adminserv88.com"/>
            </html-to-xml>
        </xpath>
    </var-def>
    <var-def name="agentNumber">
        <script return="agentId">
            <![CDATA[
            String
            agentId = sys.getVar("agent").toString();
            agentId = agentId.replace("#/", "")
            ]]>
        </script>
    </var-def>
    <random-call>
        <http method="get" url="${url}"/>
    </random-call>
    <var-def name="json">
        <http method="get" url="${sys.fullUrl(url,&quot;/lps/secure/network/&quot;+agentNumber+&quot;/downline&quot;)}">
            <http-param name="search">
                <var name="account"/>
            </http-param>
        </http>
    </var-def>
    <var-def name="player">
        <script return="playerId">
            <![CDATA[
            String
            j = sys.getVar("json").toString();
            int a = j.indexOf("ProtoBucket:");
            String playerId = j.substring(a + 12, a + 20)
            ]]>
        </script>
    </var-def>
    <var-def name="records">
        <http method="get" url="${sys.fullUrl(url,&quot;/lps/secure/report/audit/&quot;+player+&quot;/audit&quot;)}"/>
    </var-def>
    <result>
        <var name="records"/>
    </result>
</config>$$, '201608202042', '', '', '1', '2016-08-20 19:39:54', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='030002');


UPDATE gather_flow SET "flow"=$$<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
<var-def name="userName">dayans</var-def>
	<var-def name="password">Fa8034H6</var-def>
    <var-def name="url">http://ag.12macau.com/</var-def>
    <var-def name="html">
        <html-to-xml>
            <http method="get" url="http://ag.12macau.com"/>
        </html-to-xml>
    </var-def>
    <validate name="code" type="image/png" wait-time="60000" expression="\d+">
        <http method="get" response-content-type="image/png" url="http://ag.12macau.com/Login/GetCaptcha">
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
</config>$$ WHERE type_id='080000';
