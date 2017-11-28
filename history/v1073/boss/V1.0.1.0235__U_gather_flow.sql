-- auto gen by jerry 2016-11-26 09:38:51
DELETE FROM gather_flow where category_id='020';
DELETE FROM gather_flow where category_id='060';
DELETE FROM gather_flow where category_id='090';

INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('202', 'KG_CHECK', 'KG检查转账状态', '020', '020001', '', '<?xml version="1.0" encoding="UTF-8"?>
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
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('201', 'KG_INIT', 'KG初始化', '020', '020000', NULL, '<?xml version="1.0" encoding="UTF-8"?>
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
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('203', 'KG_TRANS', 'KG额度记录', '020', '020003', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
<var-def name="check">
        <html-to-xml>
            <http method="get"
                  url="http://www2.v88kgg.com/vendor/file_manager/ajax/report_fund.php">
                 <http-param name="PlayerId">
                    <var name="account"/>
                </http-param>
                <http-param name="CashFlowType">
                    1
                </http-param>
                <http-param name="StartTime">
                    <var name="startTime"/>
                </http-param>
                <http-param name="EndTime">
                    <var name="endTime"/>
                </http-param>
                <http-param name="SortColumn">
                    _pf.CreateTime
                </http-param>
                 <http-param name="SortOrder">
                    desc
                </http-param>
            </http>
        </html-to-xml>
    </var-def>




    <var-def name="parse">
        <xpath expression="//tr[@class=''rows'']">
            <var name="check"/>
        </xpath>
    </var-def>
    <var-def name="records">
    	<xml-to-json>
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

                let $amount:=data($record//td[3]/text())
                 let $oldAmount:=data($record//td[4]/text())
                 let $date:=data($record//td[9]/text())

                return <base amount="{$amount}" oldAmount="{$oldAmount}" date="{$date}"></base>

                ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
        	</xml-to-json>
    </var-def>




    <var-def name="kgResult">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("records").toString();
	         	int a = j.indexOf("[");
	         	if(a!=-1){
	         		ch = j.substring(a,j.length()-1);
	         	}
	         	else{
	         		ch="No record";
	         	}
	            ]]>
	   </script>
   </var-def>

<result>
	<var name="kgResult"></var>
</result>
    </config>', '201608272014', '', '', '1', '2016-08-27 20:15:26', 'BUSINESS');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('204', 'KG_RANDOM', 'KG会话保持', '020', '020002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <random-call>
        <http method="get" url="http://www2.v88kgg.com/vendor/file_manager/ajax/system_info.php?Count=10&TargetGroup=2&_=1480124210542">
        </http>
    </random-call>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'RANDOM');













INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('601', 'PT_INIT', 'PT初始化', '060', '060001', ' ', '<?xml version="1.0" encoding="UTF-8"?>

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


</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:46:03', 'INIT');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('602', 'PT_RANDOM', 'PT会话保持', '060', '060003', ' ', ' <?xml version="1.0" encoding="UTF-8"?>

<config charset="UTF-8">
    <random-call>
        <http method="get" url="dawoop.imptbo2.inplaymatrix.com/TransferLogs"/>
    </random-call>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:50', 'RANDOM');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('603', 'PT_TRANS', 'PT帐务查询', '060', '060002', ' ', '<?xml version="1.0" encoding="UTF-8"?>
      <config charset="UTF-8">                                                                                                                                                       
                                                                                                                                                                                     
<var-def name="se">
		   <http method="get" url="http://dawoop.imptbo2.inplaymatrix.com/TransferLogs"></http>
   </var-def>


 <session-exp init="true">
        <regexp>
            <regexp-pattern>(MerchantCode)</regexp-pattern>
            <regexp-source>
                <var name="se"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

<var-def name="content">
	<html-to-xml>
	   <http method="post" url="http://dawoop.imptbo2.inplaymatrix.com/TransferLogs/Search">
		<http-param name="TransferDateFrom"><var name="startTime"/></http-param>
		<http-param name="TransferDateTo"><var name="endTime"/></http-param>
		<http-param name="SelectedMerchantId">93</http-param>
		<http-param name="SelectedCurrency">All</http-param>
		<http-param name="SelectedStatus">All</http-param>
		<http-param name="SelectedTransferType"><var name="transferType"/></http-param>
		<http-param name="PlayerId"><var name="account"/></http-param>
		<http-param name="SelectedProduct">All</http-param>
		<http-param name="filter">Search</http-param>
	  </http>
    </html-to-xml>	            	
</var-def>
<script>
	   	 <![CDATA[
	             System.out.println("content:"+sys.getVar("content"));
	            ]]>
	   </script>

					<var-def name="filter">
				        <xpath expression="//div[@class=''section-content'']/table/tbody/tr[not(td/div)]">
           					 <var name="content"/>
      					  </xpath>
				    </var-def>
    		            <var-def name="records">
    		            	<xml-to-json>
				        <loop item="itemData" index="j" filter="unique">
				            <list>
				                <var name="filter"/>
				            </list>
				            <body>
				                <xquery>
				                    <xq-param name="record">
				                        <var name="itemData"></var>
				                    </xq-param>
				                    <xq-expression>
						                <![CDATA[
							                declare variable $record as node() external;
							                
							                 let $date:=data($record//td[4]/span/text())
							                 let $transactionNo:=data($record//td[7]/span/text())
							                 let $transId:=data($record//td[8]/span/text())
							                 let $transferType:=data($record//td[10]/span/text())
							                 let $amount:=data($record//td[11]/span/text())
							                 let $status:=data($record//td[12]/span/text())
							    			
							                 return <base date="{$date}" transactionNo="{$transactionNo}" transId="{$transId}" transferType="{$transferType}" amount="{$amount}" status="{$status}"></base>
						                ]]>
				                    </xq-expression>
				                </xquery>
				            </body>
				        </loop>
				        </xml-to-json>
				    </var-def>  
  
  
  
  
  
   <var-def name="ptResult">
	   	<script return="ch">
	   	 <![CDATA[
	             ch = sys.getVar("records").toString();
	         	 int a = ch.indexOf("[");
	            	if(a>-1){
	         		ch = ch.substring(a,ch.length()-1);
	         	}
	         	else if(ch.equals("{}")){
	         		ch="No record";
	         	}
	         	else{
	         		int b = ch.indexOf(":");
			        ch = ch.replace("{","[{").replace("}","}]");
			        ch = ch.substring(b+2,ch.length()-2);
	         	}
	            ]]>
	   </script>
   </var-def>
   
<result>
	<var name="ptResult"></var>
</result>                                                                                                                                                              
      </config>
', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS');
















INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('901', 'AG_CHECK', 'AG检查转账', '090', '090004', ' ', '<?xml version="1.0" encoding="UTF-8"?>

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
    <var-def name="apiTransId">
		<var name="apiTransactionId"/>
	</var-def>
   
         <var-def name="agResult">
        <script return="ch">
            <![CDATA[
            String j = sys.getVar("records").toString();
            String transId=sys.getVar("apiTransId").toString();
            if(j.contains(transId)){
            	ch = "转账成功！";
            }
            else{
            	ch = "转账失败！";
            }
            ]]>
        </script>
    </var-def>      
		<result>
			<var name="agResult"/>
    </result>
</config>', '201608270933', ' ', ' ', '1', '2016-08-27 09:33:08', 'BUSINESS');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('902', 'AG_RANDOM', 'AG会话保持', '090', '090003', ' ', ' <?xml version="1.0" encoding="UTF-8"?>

<config charset="UTF-8">
    <random-call>
        <http method="get" url="http://data.agingames.com/dspcms/home/MemberDetail.htm"/>
    </random-call>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:50', ' RANDOM');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('903', 'AG_INIT', 'AG初始化', '090', '090001', ' ', '<?xml version="1.0" encoding="UTF-8"?>
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
            <http-param name="loginname"><var name="userName"/></http-param>
            <http-param name="password"><var name="password"/></http-param>
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
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:46:03', 'INIT');
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") VALUES ('904', 'AG_TRANS', 'AG额度转换', '090', '090002', ' ', '<?xml version="1.0" encoding="UTF-8"?>

<config>

<var-def name="pageUrl">http://data.agingames.com/dspcms/home/CreditRecord_queryCreditRecords.htm</var-def>
			<var-def name="account"><var name="account"/></var-def>
    		<var-def name="FromTime"><var name="startTime"/></var-def>
			<var-def name="ToTime"><var name="endTime"/></var-def>
			<var-def name="transferType"><var name="transferType"/></var-def>



    <var-def name="record">
    				<http url="${pageUrl}" method="post" content-type="text/xml">
                            <http-param name="xml">
                                <script return="result">
                                    <![CDATA[
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
                                    result ="<message type=\"request\"><condition start=\"0\" limit=\"1000\" MemberId=\""+account+"\" Remark=\"\" BillId=\"\" Tradeno=\"\" FromTime=\""+FromTime+"\" ToTime=\""+ToTime+"\" Order=\"jointime\" By=\"DESC\" Credittranstype=\""+transferType+"\" GameCurrencyType=\"\" Num=\"1000\" Agent=\"\" FZ=\"\"/></message>\n";
                                    ]]>
                                </script>
                            </http-param>
                        </http>
      </var-def>
      
      
    
    
    
    
    
    <session-exp init="true">
        <regexp>
            <regexp-pattern>(doSubmit)</regexp-pattern>
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
           <xpath expression="//record">
           		<html-to-xml>
           			<var name="record"/>
           		</html-to-xml>
          		
        	</xpath>
        </xml-to-json>
	</var-def>
   <var-def name="ptResult">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("records").toString();
	         	int a = j.indexOf("[");
	            if(a!=-1){
	         		ch = j.substring(a,j.length()-1);
	         	}
	         	else{
	         		ch="No record";
	         	}
	            ]]>
	   </script>
   </var-def>
   
<result>
	<var name="ptResult"></var>
</result>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS');
