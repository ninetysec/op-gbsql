-- auto gen by jerry 2016-09-24 11:52:37
-- auto gen by jerry 2016-09-24 09:59:22
-- auto gen by jerry 2016-08-28 19:26:42

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
        <http method="get" url="ag.adminserv88.com"/>
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
				    String playerId="";
			        int a = j.indexOf("totalPage");
			        String x = j.substring(a+11,a+12);
			        if(x.equals("1")){
			            int b = j.indexOf("ProtoBucket:");
			            playerId = j.substring(b+12,b+20);
			        }
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
	            if(j.contains("is not found")){
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


UPDATE gather_flow SET  abbr_name='PT_TRANS', config_name='PT帐务查询',  flow = '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
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
				        <xpath expression="//div[@class=''''section-content'''']/table/tbody/tr[not(td/div)]">
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

<result>0
	<var name="ptResult"></var>
</result>

</config>' where type_id='060002';