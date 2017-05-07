-- auto gen by jerry 2016-09-25 17:13:23
UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>
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
    </config>' WHERE type_id='020003';





UPDATE gather_flow SET abbr_name='MG_TRANS', config_name='额度记录', flow ='<?xml version="1.0" encoding="UTF-8"?>
<config>
<var-def name="playerId"><var name="userId"/></var-def>
<var-def name="url">ag.adminserv88.com</var-def>
<var-def name="records">
   <http method="get" url="${sys.fullUrl(url,&quot;/lps/secure/report/audit/&quot;+playerId+&quot;/audit&quot;)}">

   </http>
   </var-def>


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









UPDATE gather_flow SET flow ='<?xml version="1.0" encoding="UTF-8"?>

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



INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '511', '转账异常对单', 'apiTransferCheck/exceptionTransfer/index.html', '转账异常对单', '5', NULL, '11', 'boss', 'maintenance:order', '1', NULL, 'f', 't', 't'
WHERE  not EXISTS (SELECT id from sys_resource where id=511);


UPDATE sys_resource SET url='apiTransferCheck/exceptionTransfer/index.html',remark='转账异常对单' WHERE id=511;