-- auto gen by jerry 2016-09-28 11:36:19
UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>

<config>
    <var-def name="url">ag.adminserv88.com</var-def>
	<var-def name="login">
    	<http method="post" url="${sys.fullUrl(url,&quot;/lps/j_spring_security_check&quot;)}">
            <http-param name="j_username">
                <var name="userName"/>
            </http-param>
            <http-param name="j_password">
                <var name="password"/>
            </http-param>
        </http>
    </var-def>

    <notice envelope="login" reverse="true" message="fail" url-decode="true">
        <regexp>
            <regexp-pattern>(Secure Token)</regexp-pattern>
            <regexp-source>
                <var name="login"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </notice>
</config>' WHERE type_id='030000';
UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>
<config>
<var-def name="playerId"><var name="userId"/></var-def>
<var-def name="url">ag.adminserv88.com</var-def>
<var-def name="records">
   <http method="get" url="${sys.fullUrl(url,&quot;/lps/secure/report/audit/&quot;+playerId+&quot;/audit&quot;)}">

   </http>
   </var-def>

 <session-exp init="true">
        <regexp>
            <regexp-pattern>(Secure Token)</regexp-pattern>
            <regexp-source>
                <var name="records"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

   <var-def name="parse">
   		<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("records").toString();
	            if(j.contains("[]")){
	           		 ch="No record";
		        }else{
		            int a = j.indexOf("[");
		            ch = j.substring(a,j.length()-1);
		        }

	            ]]>
   </script>
   </var-def>

   <result>
		<var name="parse"/>
</result>
</config>' WHERE type_id='030004';
UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="search_url">https://dawoo-sbbo.inplaymatrix.com/misc/cashlog/member_cashflowtracker.asp</var-def>

    <var-def name="se">
		   <http method="get" url="https://dawoo-sbbo.inplaymatrix.com/backoffice/member/member_mainCash.asp"></http>
   </var-def>

     <session-exp init="true">
        <regexp>
            <regexp-pattern>(Page Expired)</regexp-pattern>
            <regexp-source>
                <var name="se"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

	<var-def name="searchResult">
    	<html-to-xml>
		    <http method="post" url="${search_url}" content-type="application/x-www-form-urlencoded">
		        <http-param name="hidSort">155</http-param>
		        <http-param name="hidSearch">1</http-param>
		        <http-param name="txtMemberCode"><var name="account"/></http-param>
		        <http-param name="optSort">155</http-param>
		        <http-param name="txtRefNo"></http-param>
		        <http-param name="txtFromDate"><var name="startTime"/></http-param>
		        <http-param name="txtToDate"><var name="endTime"/></http-param>
		    </http>
	    </html-to-xml>
    </var-def>

    <var-def name="filter">
    	<!--<xpath expression="//form/table[3]/*">-->
        <xpath expression="//form/table[3]//tr[@onmouseout]">
			<var name="searchResult"/>
        </xpath>
    </var-def>

    <var-def name="records">
    	<xml-to-json>
        <loop item="itemData" index="i" filter="unique">
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
			                 let $Log_ID:=data($record//td[1])
			                 let $Date:=data($record//td[2])
			                 let $Member_Code:=data($record//td[3])
			                 let $Type:=data($record//td[4])
			                 let $Ref_No:=data($record//td[5])
			                 let $Sport_Type:=data($record//td[6])
			                 let $Amount_Changed:=data($record//td[7])
			                 let $Previous_Balance:=data($record//td[8])
			                 let $Current_Balance:=data($record//td[9])

			                return <base Log_ID="{$Log_ID}" Date="{$Date}" Member_Code="{$Member_Code}" Type="{$Type}" Ref_No="{$Ref_No}"
			                Sport_Type="{$Sport_Type}" Amount_Changed="{$Amount_Changed}" Previous_Balance="{$Previous_Balance}" Current_Balance="{$Current_Balance}" ></base>
		                ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
        </xml-to-json>
    </var-def>


	 <var-def name="imResult">
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
	<var name="imResult"></var>
</result>

</config>' WHERE type_id='040003';


UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>

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


</config>' WHERE type_id='060001';





UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>
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



<var-def name="record">
<function name="multipage">
        <return>
            <empty>
                <var-def name="quit">false</var-def>
            </empty>
            <while condition="${quit.toString().length() != 4}" maxloops="${maxloops}" index="i">
            	<empty>
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
				                <http-param name="page"><var name="i"/></http-param>
	           				</http>
           				</html-to-xml>
		            </var-def>

				    <var-def name="filter">
				        <xpath expression="//div[@class=''section-content'']/table/tbody/tr[not(td/div)]">
           					 <var name="content"/>
      					  </xpath>
				    </var-def>
		            <var-def name="records">
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
				    </var-def>
                    <var-def name="quit">
                        <script return="condition">
                            <![CDATA[
	                            Object filter=sys.getVar("filter");
	                            System.out.println("content....:"+content);

	                            if(filter.toString().length()==0){
	                                condition= "true";
	                            }else{
	                                condition= "false";
	                            }
	                         ]]>
                        </script>
                    </var-def>
                </empty>
                <template>
                    <var name="records"/>
                </template>
            </while>
        </return>
    </function>
        <call name="multipage">
            <call-param name="startTime"><var name="startTime"/></call-param>
			<call-param name="endTime"><var name="endTime"/></call-param>
			<call-param name="transferType"><var name="transferType"/></call-param>
			<call-param name="account"><var name="account"/></call-param>
		</call>
</var-def>


        <var-def name="values">
	    <xml-to-json>
	        <var name="record"></var>
	    </xml-to-json>
    </var-def>

   <var-def name="ptResult">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("values").toString();
	         	int a = j.indexOf("[");
	         	if(a>-1){
	         		ch = j.substring(a,j.length()-1);
	         	}
	         	else if(j.equals("{}")){
	         		ch="No record";
	         	}
	         	else{
	         		int b = j.indexOf(":");
			        j = j.replace("{","[{").replace("}","}]");
			        ch = j.substring(b+2,j.length()-2);
	         	}

	            ]]>
	   </script>
   </var-def>

<result>
	<var name="ptResult"></var>
</result>

</config>' WHERE type_id='060002';