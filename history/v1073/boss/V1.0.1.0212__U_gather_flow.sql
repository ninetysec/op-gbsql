-- auto gen by jerry 2016-11-05 09:56:12
UPDATE gather_flow set flow='<?xml version="1.0" encoding="UTF-8"?>

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
                                    result ="<message type=\"request\"><condition start=\"0\" limit=\"1000\"   BillId=\"\"   FromTime=\""+FromTime+"\" ToTime=\""+ToTime+"\" Order=\"jointime\" By=\"DESC\"  GameCurrencyType=\"\" Num=\"1000\" Agent=\"\"   FZ=\"\" MemberId=\""+MemberId+"\" Remark=\"\"  Tradeno=\"\"     Credittranstype=\""+transferType+"\"  /></message>";


                                    ]]>
                                </script>
                            </http-param>
                        </http>
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
</config>' where id=24;



UPDATE gather_flow SET flow='<?xml version="1.0" encoding="UTF-8"?>
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
    </config>' where type_id='020003';



 INSERT INTO gather_flow ( "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT 'PG_INIT', 'PG初始化', '110', '110001', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
			<var-def name="login_url">http://pgadmin.perfectgame.cc/System/login.aspx</var-def>
        <var-def name="viewState_1">
    	<html-to-xml>
    		<http method="get" url="http://pgadmin.perfectgame.cc/System/login.aspx"/>
    	</html-to-xml>
    </var-def>

    <var-def name="viewState_1">
        <xpath expression="//body/form/div[1]/input[1]/@value">
			<var name="viewState_1"/>
        </xpath>
    </var-def>

    <var-def name="login">
        <http method="post" url="${login_url}" content-type="application/x-www-form-urlencoded">
        	<http-param name="__VIEWSTATE"><var name="viewState_1"/></http-param>
        	<http-param name="__VIEWSTATEGENERATOR">75191122</http-param>
            <http-param name="txtAdminName"><var name="userName"/></http-param>
            <http-param name="txtAdminPass"><var name="password"/></http-param>
            <http-param name="btnSubmit">登 陆</http-param>
        </http>
    </var-def>

<notice envelope="login" reverse="false"  message="登录失败">
        <regexp>
            <regexp-pattern>(statisticalReports1.aspx)</regexp-pattern>
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
</config>', '201609061713', '', '', '1', '2016-09-06 19:39:54', 'INIT'

WHERE NOT EXISTS(SELECT id from gather_flow where type_id='110001');




UPDATE gather_flow set flow='<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

 <var-def name="search_url">http://pgadmin.perfectgame.cc/System/statistics/UserMoneyChangeList.aspx</var-def>
     <var-def name="viewState_2">
    	<html-to-xml>
    		<http method="get" url="${search_url}"/>
    	</html-to-xml>
    </var-def>
     <session-exp init="true">
        <regexp>
            <regexp-pattern>(return  CheckValidate())</regexp-pattern>
            <regexp-source>
                <var name="viewState_2"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>
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
						<call-param name="setNum">1000</call-param>
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
</config>' where type_id='110002';