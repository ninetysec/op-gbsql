-- auto gen by jerry 2016-09-18 20:18:12

INSERT INTO gather_flow ("abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT  'KG_TRANS', 'KG额度记录', '020', '020003', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
<var-def name="check">
        <html-to-xml>
            <http method="get"
                  url="http://www2.v88kgg.com/vendor/file_manager/ajax/report_fund.php">
                <http-param name="PlayerId">
                    <var name="account"/>
                </http-param>
                <http-param name="SortOrder">
                    desc
                </http-param>
                <http-param name="SortColumn">
                    _pf.CreateTime
                </http-param>
                <http-param name="StartTime">
                    <var name="startTime"/>
                </http-param>
                <http-param name="EndTime">
                    <var name="endTime"/>
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
    </config>', '201609182027', '', '', '1', '2016-09-17 20:28:26', 'BUSINESS'
    WHERE  not EXISTS (SELECT id from gather_flow where type_id='020003');
UPDATE gather_flow SET abbr_name='KG_TRANS', config_name='KG额度记录', flow='<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
<var-def name="check">
        <html-to-xml>
            <http method="get"
                  url="http://www2.v88kgg.com/vendor/file_manager/ajax/report_fund.php">
                <http-param name="PlayerId">
                    <var name="account"/>
                </http-param>
                <http-param name="SortOrder">
                    desc
                </http-param>
                <http-param name="SortColumn">
                    _pf.CreateTime
                </http-param>
                <http-param name="StartTime">
                    <var name="startTime"/>
                </http-param>
                <http-param name="EndTime">
                    <var name="endTime"/>
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
    </config>' WHERE type_id='020003';










INSERT INTO gather_flow ( "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
SELECT 'MG_TRANS', '额度记录', '030', '030004', '', '<?xml version="1.0" encoding="UTF-8"?>

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
            String agentId = sys.getVar("agent").toString();
              agentId = agentId.replace("#/","")
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
                String j= sys.getVar("json").toString();
                int a = j.indexOf("ProtoBucket:");
                String playerId = j.substring(a+12,a+20)
            ]]>
        </script>
    </var-def>
   <var-def name="records">
   <http method="get" url="${sys.fullUrl(url,&quot;/lps/secure/report/audit/&quot;+player+&quot;/audit&quot;)}">

   </http>
   </var-def>


   <var-def name="parse">
   		<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("records").toString();
	         	int a = j.indexOf("[");
	            ch = j.substring(a,j.length()-1)
	            ]]>
   </script>
   </var-def>

   <result>
		<var name="parse"/>
</result>
</config>', '201608271727', '', '', '1', '2016-08-27 17:27:54', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='030004');
UPDATE gather_flow SET abbr_name='MG_TRANS', config_name='额度记录', flow ='<?xml version="1.0" encoding="UTF-8"?>

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
            String agentId = sys.getVar("agent").toString();
              agentId = agentId.replace("#/","")
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
                String j= sys.getVar("json").toString();
                int a = j.indexOf("ProtoBucket:");
                String playerId = j.substring(a+12,a+20)
            ]]>
        </script>
    </var-def>
   <var-def name="records">
   <http method="get" url="${sys.fullUrl(url,&quot;/lps/secure/report/audit/&quot;+player+&quot;/audit&quot;)}">

   </http>
   </var-def>


   <var-def name="parse">
   		<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("records").toString();
	         	int a = j.indexOf("[");
	            ch = j.substring(a,j.length()-1)
	            ]]>
   </script>
   </var-def>

   <result>
		<var name="parse"/>
</result>
</config>' WHERE type_id='030004';






INSERT INTO gather_flow ( "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
 SELECT  'IM_TRANS', 'IM额度记录', '040', '040003', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="search_url">https://dawoo-sbbo.inplaymatrix.com/misc/cashlog/member_cashflowtracker.asp</var-def>
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

</config>', '201608281519', '', '', '1', '2016-08-28 15:19:26', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='040003');
UPDATE gather_flow SET abbr_name='IM_TRANS', config_name='IM额度记录', flow = '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
    <var-def name="search_url">https://dawoo-sbbo.inplaymatrix.com/misc/cashlog/member_cashflowtracker.asp</var-def>
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

</config>' where type_id='040003';


INSERT INTO gather_flow ( "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
 SELECT 'PT_TRANS', 'PT帐务查询', '060', '060002', ' ', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
	<!--query searchList-->
    <var-def name="searchList">
        <html-to-xml>
            <http method="post" url="${sys.fullUrl(url,&quot;/Players/Search&quot;)}">
                <http-param name="SelectedMerchantId">93</http-param>
                <http-param name="SelectedCurrency">All</http-param>
                <http-param name="PlayerId"><var name="account"/></http-param>
				<http-param name="CreatedDateFrom"><var name="startTime"/></http-param>
				<http-param name="PlayeCreatedDateTorId"><var name="endTime"/></http-param>
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
            if(sys.getVar("aList").toString().length()>0){
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

                let $date:=data($record//td[1]/span/text())
                 let $type:=data($record//td[2]/span/text())
                 let $amount:=data($record//td[3]/span/text())
                 let $status:=data($record//td[4]/span/text())

                return <base date="{$date}" type="{$type}" amount="{$amount}" status="{$status}"></base>

                ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>

    <var-def name="values">
	    <xml-to-json>
	        <var name="records"></var>
	    </xml-to-json>
    </var-def>

   <var-def name="ptResult">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("values").toString();
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
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='060002');

UPDATE gather_flow SET  abbr_name='PT_TRANS', config_name='PT帐务查询',  flow = '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
	<!--query searchList-->
    <var-def name="searchList">
        <html-to-xml>
            <http method="post" url="${sys.fullUrl(url,&quot;/Players/Search&quot;)}">
                <http-param name="SelectedMerchantId">93</http-param>
                <http-param name="SelectedCurrency">All</http-param>
                <http-param name="PlayerId"><var name="account"/></http-param>
				<http-param name="CreatedDateFrom"><var name="startTime"/></http-param>
				<http-param name="PlayeCreatedDateTorId"><var name="endTime"/></http-param>
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
            if(sys.getVar("aList").toString().length()>0){
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

                let $date:=data($record//td[1]/span/text())
                 let $type:=data($record//td[2]/span/text())
                 let $amount:=data($record//td[3]/span/text())
                 let $status:=data($record//td[4]/span/text())

                return <base date="{$date}" type="{$type}" amount="{$amount}" status="{$status}"></base>

                ]]>
                    </xq-expression>
                </xquery>
            </body>
        </loop>
    </var-def>

    <var-def name="values">
	    <xml-to-json>
	        <var name="records"></var>
	    </xml-to-json>
    </var-def>

   <var-def name="ptResult">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("values").toString();
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
</config>' where type_id='060002';


INSERT INTO gather_flow ( "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
 SELECT 'AG_TRANS', 'AG额度转换', '090', '090002', ' ', '<?xml version="1.0" encoding="UTF-8"?>

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
                                        if(total<=index){
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
            <call-param name="account"><var name="account"/></call-param>
						<call-param name="FromTime"><var name="startTime"/></call-param>
						<call-param name="ToTime"><var name="endTime"/></call-param>
						<call-param name="transferType"><var name="transferType"/></call-param>
						<call-param name="setNum">25</call-param>
        </call>
    </var-def>

   <var-def  name="records">
			<xml-to-json>
           <xpath expression="//record">
           		<html-to-xml>
           			<var name="record"/>
           		</html-to-xml>
        	</xpath>
      </xml-to-json>
	</var-def>

		<session-exp init="true" value="Login_process.htm">
        <regexp>
            <regexp-pattern>(totalCount)</regexp-pattern>
            <regexp-source>
                <var name="record"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

		<var-def name="agResult">
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
	<var name="agResult"></var>
</result>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:08', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='090002');

UPDATE gather_flow SET abbr_name='AG_TRANS', config_name='AG额度转换', flow = '<?xml version="1.0" encoding="UTF-8"?>

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
                                        if(total<=index){
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
            <call-param name="account"><var name="account"/></call-param>
						<call-param name="FromTime"><var name="startTime"/></call-param>
						<call-param name="ToTime"><var name="endTime"/></call-param>
						<call-param name="transferType"><var name="transferType"/></call-param>
						<call-param name="setNum">25</call-param>
        </call>
    </var-def>

   <var-def  name="records">
			<xml-to-json>
           <xpath expression="//record">
           		<html-to-xml>
           			<var name="record"/>
           		</html-to-xml>
        	</xpath>
      </xml-to-json>
	</var-def>

		<session-exp init="true" value="Login_process.htm">
        <regexp>
            <regexp-pattern>(totalCount)</regexp-pattern>
            <regexp-source>
                <var name="record"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

		<var-def name="agResult">
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
	<var name="agResult"></var>
</result>
</config>' WHERE type_id='090002';












INSERT INTO gather_flow ( "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type")
 SELECT 'PG_TRANS', 'PG额度转换存款', '110', '110002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

    <var-def name="search_url">http://pgadmin.perfectgame.cc/System/statistics/UserMoneyChangeList.aspx</var-def>
     <var-def name="viewState_2">
    	<html-to-xml>
    		<http method="get" url="${search_url}"/>
    	</html-to-xml>
    </var-def>

    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("viewState_2");
            String result = content.toString();
            result = result.replaceAll(" PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"","");
            sys.defineVariable("viewState_2",result,true);
            ]]>
        </script>
    </var-def>

    <var-def name="viewState_2">
        <xpath expression="//body/form/div[1]/input[4]/@value">
			<var name="viewState_2"/>
        </xpath>
    </var-def>

	<function name="multipage">
        <return>
            <empty>
                <var-def name="quit">false</var-def>
            </empty>
            <while condition="${quit.toString().length() != 4}" maxloops="${maxloops}" index="i">
            	<empty>
		            <var-def name="content">
		            	<html-to-xml>
			                <http method="post" url="${pageUrl}" content-type="application/x-www-form-urlencoded">
						        <http-param name="__EVENTTARGET">AspNetPager1</http-param>
						        <http-param name="__EVENTARGUMENT"><var name="i"/></http-param>
						        <http-param name="__LASTFOCUS"></http-param>
						        <http-param name="__VIEWSTATE"><var name="viewState_2"/></http-param>
						        <http-param name="__VIEWSTATEGENERATOR">E4B34840</http-param>
						        <http-param name="txtOrderNum"></http-param>
						        <http-param name="txtUserID"><var name="txtUserID"/></http-param>
						        <http-param name="txtAgent"></http-param>
						        <http-param name="txtStartDate"><var name="txtStartDate"/></http-param>
						        <http-param name="txtEndDate"><var name="txtEndDate"/></http-param>
						        <http-param name="txtChangeMoney1"></http-param>
						        <http-param name="txtChangeMoney2"></http-param>
		        				<http-param name="rdoExplains"><var name="rdoExplains"/></http-param>
						        <http-param name="txtPageSize"><var name="setNum"/></http-param>
						        <http-param name="AspNetPager1_input">1</http-param>
			                </http>
		                </html-to-xml>
		            </var-def>

				    <var-def name="content">
				        <script return="result">
				            <![CDATA[
				            Object content = sys.getVar("content");
				            String result = content.toString();
				            result = result.replaceAll(" PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"","");
				            sys.defineVariable("content",result,true);
				            ]]>
				        </script>
				    </var-def>
                    <var-def name="totalCount">
                        <xpath expression="//body/form/table[2]/tbody/tr/td[1]/span[1]/text()">
                            <var name="content"/>
                        </xpath>
                    </var-def>
					<var-def name="viewState_2">
				        <xpath expression="//body/form/div[1]/input[4]/@value">
							<var name="content"/>
				        </xpath>
				    </var-def>
					<var-def name="filter">
						<xpath expression="//body//form//table[1]//tbody[1]//tr[@onmouseout]">
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

							                 let $ID:=data($record//td[1])
							                 let $orderNum:=data($record//td[2])
							                 let $userId:=data($record//td[3])
							                 let $userName:=data($record//td[4]/a)
							                 let $allAgent:=data($record//td[5])
							                 let $summary:=data($record//td[6])
							                 let $Amount_Changed:=data($record//td[7])
							                 let $Previous_Balance:=data($record//td[8])
							                 let $Current_Balance:=data($record//td[9])
				                 			 let $transTime:=data($record//td[10])
				                             let $remark:=data($record//td[11])

							                return <base ID="{$ID}" orderNum="{$orderNum}" userId="{$userId}" userName="{$userName}" allAgent="{$allAgent}"
							                summary="{$summary}" Amount_Changed="{$Amount_Changed}" Previous_Balance="{$Previous_Balance}" Current_Balance="{$Current_Balance}" transTime="{$transTime}" remark="{$remark}" ></base>

						                ]]>
				                    </xq-expression>
				                </xquery>
				            </body>
				        </loop>
				    </var-def>
                    <var-def name="quit">
                        <script return="condition">
                            <![CDATA[
	                            Object content=sys.getVar("content");
	                            System.out.println("content....:"+content);
	                            Object totalCount=sys.getVar("totalCount");
	                            System.out.println("totalCount....:"+totalCount);
	                            Object setNum=sys.getVar("setNum");
	                            System.out.println("setNum....:"+setNum);
	                            int page= setNum.toInt();
	                            System.out.println("page....:"+page);
	                            int count = totalCount.toInt();
	                            System.out.println("count....:"+count);
	                            int total = count%page==0?count/page:count/page+1;;
	                            System.out.println("total:"+total);
	                            Object index=sys.getVar("i");
	                            int indexNum = index.toInt();
	                            System.out.println("result:"+(total< indexNum)+"  indexNum="+indexNum);

	                            if(total<= indexNum){
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

    <var-def name="record">
        <call name="multipage">
            <call-param name="pageUrl"><var name="search_url"/></call-param>
		    <call-param name="txtStartDate"><var name="startTime"/></call-param>
		    <call-param name="txtEndDate"><var name="endTime"/></call-param>
		    <call-param name="txtUserID"><var name="account"/></call-param>
		    <call-param name="setNum">100</call-param>
		    <call-param name="rdoExplains"><var name="transferType"/></call-param>
		    <call-param name="viewState_2"><var name="viewState_2"/></call-param>
        </call>
    </var-def>

    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("record");
            String result = content.toString();
            result = result.replaceAll("&#xA;      ","");
            result = result.replaceAll("&#xA;   ","");
            sys.defineVariable("record",result,true);
            ]]>
        </script>
    </var-def>


           <var-def name="values">
	    <xml-to-json>
	        <var name="record"></var>
	    </xml-to-json>
    </var-def>

   <var-def name="record">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("values").toString();
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
    	<var name="record"/>
	</result>
</config>', '201609061713', '', '', '1', '2016-09-06 19:39:54', 'BUSINESS'
WHERE  not EXISTS (SELECT id from gather_flow where type_id='110002');

UPDATE gather_flow SET abbr_name='PG_TRANS', config_name='PG额度转换', flow = '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

    <var-def name="search_url">http://pgadmin.perfectgame.cc/System/statistics/UserMoneyChangeList.aspx</var-def>
     <var-def name="viewState_2">
    	<html-to-xml>
    		<http method="get" url="${search_url}"/>
    	</html-to-xml>
    </var-def>

    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("viewState_2");
            String result = content.toString();
            result = result.replaceAll(" PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"","");
            sys.defineVariable("viewState_2",result,true);
            ]]>
        </script>
    </var-def>

    <var-def name="viewState_2">
        <xpath expression="//body/form/div[1]/input[4]/@value">
			<var name="viewState_2"/>
        </xpath>
    </var-def>

	<function name="multipage">
        <return>
            <empty>
                <var-def name="quit">false</var-def>
            </empty>
            <while condition="${quit.toString().length() != 4}" maxloops="${maxloops}" index="i">
            	<empty>
		            <var-def name="content">
		            	<html-to-xml>
			                <http method="post" url="${pageUrl}" content-type="application/x-www-form-urlencoded">
						        <http-param name="__EVENTTARGET">AspNetPager1</http-param>
						        <http-param name="__EVENTARGUMENT"><var name="i"/></http-param>
						        <http-param name="__LASTFOCUS"></http-param>
						        <http-param name="__VIEWSTATE"><var name="viewState_2"/></http-param>
						        <http-param name="__VIEWSTATEGENERATOR">E4B34840</http-param>
						        <http-param name="txtOrderNum"></http-param>
						        <http-param name="txtUserID"><var name="txtUserID"/></http-param>
						        <http-param name="txtAgent"></http-param>
						        <http-param name="txtStartDate"><var name="txtStartDate"/></http-param>
						        <http-param name="txtEndDate"><var name="txtEndDate"/></http-param>
						        <http-param name="txtChangeMoney1"></http-param>
						        <http-param name="txtChangeMoney2"></http-param>
		        				<http-param name="rdoExplains"><var name="rdoExplains"/></http-param>
						        <http-param name="txtPageSize"><var name="setNum"/></http-param>
						        <http-param name="AspNetPager1_input">1</http-param>
			                </http>
		                </html-to-xml>
		            </var-def>

				    <var-def name="content">
				        <script return="result">
				            <![CDATA[
				            Object content = sys.getVar("content");
				            String result = content.toString();
				            result = result.replaceAll(" PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"","");
				            sys.defineVariable("content",result,true);
				            ]]>
				        </script>
				    </var-def>
                    <var-def name="totalCount">
                        <xpath expression="//body/form/table[2]/tbody/tr/td[1]/span[1]/text()">
                            <var name="content"/>
                        </xpath>
                    </var-def>
					<var-def name="viewState_2">
				        <xpath expression="//body/form/div[1]/input[4]/@value">
							<var name="content"/>
				        </xpath>
				    </var-def>
					<var-def name="filter">
						<xpath expression="//body//form//table[1]//tbody[1]//tr[@onmouseout]">
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

							                 let $ID:=data($record//td[1])
							                 let $orderNum:=data($record//td[2])
							                 let $userId:=data($record//td[3])
							                 let $userName:=data($record//td[4]/a)
							                 let $allAgent:=data($record//td[5])
							                 let $summary:=data($record//td[6])
							                 let $Amount_Changed:=data($record//td[7])
							                 let $Previous_Balance:=data($record//td[8])
							                 let $Current_Balance:=data($record//td[9])
				                 			 let $transTime:=data($record//td[10])
				                             let $remark:=data($record//td[11])

							                return <base ID="{$ID}" orderNum="{$orderNum}" userId="{$userId}" userName="{$userName}" allAgent="{$allAgent}"
							                summary="{$summary}" Amount_Changed="{$Amount_Changed}" Previous_Balance="{$Previous_Balance}" Current_Balance="{$Current_Balance}" transTime="{$transTime}" remark="{$remark}" ></base>

						                ]]>
				                    </xq-expression>
				                </xquery>
				            </body>
				        </loop>
				    </var-def>
                    <var-def name="quit">
                        <script return="condition">
                            <![CDATA[
	                            Object content=sys.getVar("content");
	                            System.out.println("content....:"+content);
	                            Object totalCount=sys.getVar("totalCount");
	                            System.out.println("totalCount....:"+totalCount);
	                            Object setNum=sys.getVar("setNum");
	                            System.out.println("setNum....:"+setNum);
	                            int page= setNum.toInt();
	                            System.out.println("page....:"+page);
	                            int count = totalCount.toInt();
	                            System.out.println("count....:"+count);
	                            int total = count%page==0?count/page:count/page+1;;
	                            System.out.println("total:"+total);
	                            Object index=sys.getVar("i");
	                            int indexNum = index.toInt();
	                            System.out.println("result:"+(total< indexNum)+"  indexNum="+indexNum);

	                            if(total<= indexNum){
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

    <var-def name="record">
        <call name="multipage">
            <call-param name="pageUrl"><var name="search_url"/></call-param>
		    <call-param name="txtStartDate"><var name="startTime"/></call-param>
		    <call-param name="txtEndDate"><var name="endTime"/></call-param>
		    <call-param name="txtUserID"><var name="account"/></call-param>
		    <call-param name="setNum">100</call-param>
		    <call-param name="rdoExplains"><var name="transferType"/></call-param>
		    <call-param name="viewState_2"><var name="viewState_2"/></call-param>
        </call>
    </var-def>

    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("record");
            String result = content.toString();
            result = result.replaceAll("&#xA;      ","");
            result = result.replaceAll("&#xA;   ","");
            sys.defineVariable("record",result,true);
            ]]>
        </script>
    </var-def>


           <var-def name="values">
	    <xml-to-json>
	        <var name="record"></var>
	    </xml-to-json>
    </var-def>

   <var-def name="record">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("values").toString();
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
    	<var name="record"/>
	</result>
</config>' WHERE type_id='110002';









INSERT INTO gather_user ("id","username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT 28 , 'marking', 'Acfep134', 'MG用户', '01', '1', '2016-06-23 19:26:49', '030', 't'
WHERE  not EXISTS (SELECT id from gather_user where username='marking' AND category_id= '030');



INSERT INTO gather_user ("id","username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT 29 , 'dw_brave', 'fa8034h6', 'PG用户', '01', '1', '2016-06-23 19:26:49', '110', 'f'
WHERE  not EXISTS (SELECT id from gather_user where username='dw_brave' AND category_id= '110');






INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '511', '转账异常对单', 'apiTransferCheck/exceptionTransfer/index.html', '转账异常对单', '5', NULL, '11', 'boss', 'maintenance:order', '1', NULL, 'f', 't', 't'
WHERE  not EXISTS (SELECT id from sys_resource where id=511);


UPDATE sys_resource SET url='apiTransferCheck/exceptionTransfer/index.html',remark='转账异常对单' WHERE id=511;