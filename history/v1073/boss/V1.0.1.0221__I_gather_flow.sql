-- auto gen by jerry 2016-11-12 15:50:40
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '7', 'SLC_INIT', 'SLC初始化', '080', '080000', '', '<?xml version="1.0" encoding="UTF-8"?>
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
            <http-param name="language">zh-Hans</http-param>
        </http>
    </var-def>
    <notice envelope="login" reverse="false" message="登录失败" url-decode="true">
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
</config>', '201606231713', '', '', '1', '2016-06-23 19:39:54', 'INIT'   WHERE NOT EXISTS (select id from gather_flow where id =7 );
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '8', 'SLC_MODIFY', 'SLC取消注单', '080', '080001', '', '<?xml version="1.0" encoding="UTF-8"?>
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
			                          int index=sys.getVar("i").toInt(   WHERE NOT EXISTS (select id from gather_flow where id = );
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

      <session-exp init="true">
        <regexp>
            <regexp-pattern>(goToWithUrlCurrent)</regexp-pattern>
            <regexp-source>
                <var name="content"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

							 

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
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS'   WHERE NOT EXISTS (select id from gather_flow where id = 8);
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '9', 'SLC_RANDOM', 'SLC会话保持', '080', '080002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
     <random-call>      
        <http method="get" url="http://ag.12macau.com/Report/Index"></http>
    </random-call>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'RANDOM'   WHERE NOT EXISTS (select id from gather_flow where id = 9);
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '26', 'SLC_TRANS', 'SLC额度转换', '080', '080003', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
   <var-def name="se">
        <http method="post" url="http://ag.12macau.com/Report/Index">
        </http>
    </var-def>
    
    <session-exp init="true" >
        <regexp>
            <regexp-pattern>(txtCaptcha)</regexp-pattern>
            <regexp-source>
                <var name="se"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>
   			<var-def name="filter">
   					<http url="http://ag.12macau.com/Report/GetDepositWithdrawal" method="post">
							<http-param name="fromDate"><var name="startTime"/></http-param>
							<http-param name="rowsPerPage">500</http-param>
							<http-param name="pageNo">0</http-param>
							<http-param name="excutedBy"></http-param>
							<http-param name="toDate"><var name="endTime"/></http-param>
							<http-param name="totalRows">0</http-param>
							<http-param name="transType"><var name="transferType"/></http-param>
							<http-param name="userName"><var name="account"/></http-param>
						</http>
			</var-def>			
						
						
	<var-def name="records">
	    <xpath expression="//tbody/tr">
	    	<html-to-xml>
	    		<var name="filter"/>
	    	</html-to-xml> 		
	    </xpath>
    </var-def>
						
	<var-def name="records">
		<xml-to-json>
				        <loop item="itemData" index="j" filter="unique">
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
							                
							                 let $date:=data($record//td[3]/text())
							                 
							                 let $transferType:=data($record//td[6]/text())
							                 
							                 let $amount:=data($record//td[7]/text())
							                 
							                 let $balance:=data($record//td[9]/text())
							                
							                let $transactionNo:=data($record//td[11]/text())
							    			
							                 return <base date="{$date}" transferType="{$transferType}" amount="{$amount}" balance="{$balance}" transactionNo="{$transactionNo}"></base>
						                ]]>
				                    </xq-expression>
				                </xquery>
				            </body>
				        </loop>
				        
				        </xml-to-json>
				    </var-def>   	
				    
				    
				    
	<var-def name="slcResult">
	   	<script return="ch">
	   	 <![CDATA[
  			Object obj=sys.getVar("records"   WHERE NOT EXISTS (select id from gather_flow where id = );
			if(obj!=null)
			{
			 String j=obj.toString(   WHERE NOT EXISTS (select id from gather_flow where id = );
			 int a = j.indexOf("["   WHERE NOT EXISTS (select id from gather_flow where id = );
			 if(a>-1){
			    ch = j.substring(a,j.length()-1   WHERE NOT EXISTS (select id from gather_flow where id = );
			 }
			 else if(j.equals("{}")){
			       ch="No record";
			 }
			 else{
			   int b = j.indexOf(":"   WHERE NOT EXISTS (select id from gather_flow where id = );
				   j = j.replace("{","[{").replace("}","}]"   WHERE NOT EXISTS (select id from gather_flow where id = );
				   ch = j.substring(b+2,j.length()-2   WHERE NOT EXISTS (select id from gather_flow where id = );
			}        	
		}
	            ]]>
	   </script>
   </var-def>
    
    
    <result>
        <var name="slcResult"/>       
    </result>		
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS'   WHERE NOT EXISTS (select id from gather_flow where id = 26);
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '28', 'SLC_CHECK', 'SLC检查转账状态', '080', '080004', '', '<?xml version="1.0" encoding="UTF-8"?>
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
					 			int index=sys.getVar("i").toInt(   WHERE NOT EXISTS (select id from gather_flow where id = );


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

 										 Object content=sys.getVar("content"   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        System.out.println("content:"+content   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        Object totalCount=sys.getVar("totalCount"   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        System.out.println("totalCount:"+totalCount   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        Object setNum=sys.getVar("setNum"   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        System.out.println("setNum:"+setNum   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        int page= setNum.toInt(   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        System.out.println("page:"+page   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        int count = totalCount.toInt(   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        System.out.println("count:"+count   WHERE NOT EXISTS (select id from gather_flow where id = );
                                        int total = count%page==0?count/page:count/page+1;;
                                        System.out.println("total:"+total   WHERE NOT EXISTS (select id from gather_flow where id = );

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




   <var-def name="records">
	    <xpath expression="//tbody/tr">
	    	<html-to-xml>
	    		<var name="record"/>
	    	</html-to-xml> 		
	    </xpath>
    </var-def>
    
    <function name="addTag">
	    <return> 
		    <loop item="item" index="i">
		    	<list>
		    		<var name="re"/>
		    	</list>
		    	<body>
		    		<var-def name="contents">
		    			<xquery>
		    				<xq-param name="doc">
		    					<var name="item"/>
		    				</xq-param>
		    				<xq-expression><![CDATA[
		    						declare variable $doc as node() external;
		    						let $hh :=data($doc//td[1])
		    						let $zdhh :=data($doc//td[2])
		    						let $zdrq :=data($doc//td[3])
		    						let $yhm :=data($doc//td[4])
		    						let $hb :=data($doc//td[5])
		    						let $lx :=data($doc//td[6])
		    						let $je1 :=data($doc//td[7])
		    						let $je2 :=data($doc//td[8])
		    						let $ye :=data($doc//td[9])
		    						let $zxy :=data($doc//td[10])
		    						let $zs :=data($doc//td[11])
		    							return
		    								<record>
		    									<hh>{$hh}</hh>
		    									<zdhh>{$zdhh}</zdhh>
		    									<zdrq>{$zdrq}</zdrq>
		    									<yhm>{$yhm}</yhm>
		    									<hb>{$hb}</hb>
		    									<lx>{$lx}</lx>
		    									<je1>{$je1}</je1>
		    									<je2>{$je2}</je2>
		    									<ye>{$ye}</ye>
		    									<zxy>{$zxy}</zxy>
		    									<zs>{$zs}</zs>
		    								</record>
		    				]]></xq-expression>
		    			</xquery>
		    		</var-def>	
		    	</body>
		    </loop>
	    </return> 
    </function>
    
    <var-def name="recordss">
    	<xml-to-json>
	    	<call name="addTag">
	    		<call-param name="re"><var name="records"/></call-param>
	    	</call>
    	</xml-to-json>
    </var-def>
    	<var-def name="apiTransId">
		<var name="transactionNo"/>
	</var-def>
    <result>
         <var-def name="mgResult">
        <script return="resultJson">
            <![CDATA[
            String j = sys.getVar("recordss").toString(   WHERE NOT EXISTS (select id from gather_flow where id = );
            String transId=sys.getVar("apiTransId").toString(   WHERE NOT EXISTS (select id from gather_flow where id = );
            if(j.contains(transId)){
            	resultJson = "转账成功！";
            }
            else{
            	resultJson = "转账失败！";
            }
            ]]>
        </script>
    </var-def>      
    </result>
</config>
', '201608261550', '', '', '1', '2016-08-26 17:16:26', 'BUSINESS'   WHERE NOT EXISTS (select id from gather_flow where id = 28);
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '161', 'EBET_INIT', 'EBET初始化', '160', '160001', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">

    <var-def name="login_url">http://dawoo.ebetoffice.com:8888/sadmin/login.html</var-def>
    
    <var-def name="login">
        <http method="post" url="${login_url}" content-type="application/x-www-form-urlencoded">
            <http-param name="username"><var name="userName"/></http-param>
            <http-param name="password"><var name="password"/></http-param>
            <http-param name="code"></http-param>
        </http>
    </var-def>

    <notice envelope="login" reverse="true" message="登录失败">
        <regexp>
            <regexp-pattern>(qrCodeModal)</regexp-pattern>
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
</config>', '201611092018', '', '', '1', '2016-11-09 20:18:40', 'INIT'   WHERE NOT EXISTS (select id from gather_flow where id = 161);
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '162', 'EBET_RANDOM', 'EBET会话保持', '160', '160002', ' ', ' <?xml version="1.0" encoding="UTF-8"?>

<config charset="UTF-8">
    <random-call>
        <http method="get" url="http://dawoo.ebetoffice.com:8888/sadmin/changepwd.html"/>
    </random-call>
</config>', '201608101545', ' ', ' ', '1', '2016-08-10 15:47:50', ' RANDOM'   WHERE NOT EXISTS (select id from gather_flow where id = 162);
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '163', 'EBET_TRANS', 'EBET额度记录', '160', '160003', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
 <var-def name="se">
        <http method="post" url="http://dawoo.ebetoffice.com:8888/sadmin/changepwd.html"></http>
    </var-def>

 	<session-exp init="true" >
        <regexp>
            <regexp-pattern>(qrCodeModal)</regexp-pattern>
            <regexp-source>
                <var name="se"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>


	<function name="multipage">
        <return>
            <empty>
                <var-def name="quit">false</var-def>
            </empty>
            <while condition="${quit.toString().length() != 4}" maxloops="${maxloops}" index="i">      	
            	<empty>
		            <var-def name="content">
		            	<html-to-xml>	          
						    <http method="get" url="${pageUrl}" content-type="application/x-www-form-urlencoded">
						    		<http-param name="userName"><var name="userName"/></http-param>
						       		<http-param name="sd"><var name="sd"/></http-param>
									<http-param name="ed"><var name="ed"/></http-param>
									<http-param name="channel">-2</http-param>
									<http-param name="tradeType"><var name="tradeType"/></http-param>
									<http-param name="pageSize"><var name="setNum"/></http-param>
									<http-param name="pageNow"><var name="i"/></http-param>
									<http-param name="ts">1473300396998</http-param>
						    </http>
		                </html-to-xml>
		            </var-def>
  
				    <var-def name="filter">
				        <xpath expression="//body/div[4]/div[3]/div[2]/div[2]/table//tbody/tr">
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
							                 let $userName:=data($record//td[2])
							                 let $channelId:=data($record//td[3])
							                 let $subChannelId:=data($record//td[4])
							                 let $transferType:=data($record//td[5])
							                 let $roundNo:=data($record//td[6])
							                 let $previousBalance:=data($record//td[7])
							                 let $amount:=data($record//td[8])
				                 			 let $currentBalance:=data($record//td[9])
				                             let $time:=data($record//td[10])
										
							                return <base ID="{$ID}" userName="{$userName}" channelId="{$channelId}" subChannelId="{$subChannelId}"
							                transferType="{$transferType}" roundNo="{$roundNo}" previousBalance="{$previousBalance}" amount="{$amount}" currentBalance="{$currentBalance}" 
							                time="{$time}"></base>
						                ]]>
				                    </xq-expression>
				                </xquery>
				            </body>
				        </loop>
				    </var-def>   				       
                    <var-def name="quit">
                        <script return="condition">
                            <![CDATA[
	                            Object filter=sys.getVar("filter"   WHERE NOT EXISTS (select id from gather_flow where id = );
	                            System.out.println("content....:"+content   WHERE NOT EXISTS (select id from gather_flow where id = );                       
	                            if(filter.toString().length() == 0){
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
            <call-param name="pageUrl">http://dawoo.ebetoffice.com:8888/sadmin/listusertransaction</call-param>
		    <call-param name="sd"><var name="startTime"/></call-param>
		    <call-param name="ed"><var name="endTime"/></call-param>
		    <call-param name="userName"><var name="account"/></call-param>
		    <call-param name="setNum">100</call-param>
		    <call-param name="tradeType"><var name="transferType"/></call-param>
        </call>
    </var-def>


    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("record"   WHERE NOT EXISTS (select id from gather_flow where id = );
            String result = content.toString(   WHERE NOT EXISTS (select id from gather_flow where id = );
            result = result.replaceAll("&#xA;      ",""   WHERE NOT EXISTS (select id from gather_flow where id = );  
            result = result.replaceAll("&#xA;   ",""   WHERE NOT EXISTS (select id from gather_flow where id = );  
            sys.defineVariable("record",result,true   WHERE NOT EXISTS (select id from gather_flow where id = );
            ]]>
        </script>
    </var-def>
    
    
    
           

        <var-def name="values">
	    <xml-to-json>
	        <var name="record"></var>
	    </xml-to-json>
    </var-def>
   
   <var-def name="result">
	   	<script return="ch">
	   	 <![CDATA[
	            String j = sys.getVar("values").toString(   WHERE NOT EXISTS (select id from gather_flow where id = );
	         	int a = j.indexOf("["   WHERE NOT EXISTS (select id from gather_flow where id = );
	         	if(a>-1){
	         		ch = j.substring(a,j.length()-1   WHERE NOT EXISTS (select id from gather_flow where id = );
	         	}
	         	else if(j.equals("{}")){
	         		ch="No record";
	         	}
	         	else{
	         		int b = j.indexOf(":"   WHERE NOT EXISTS (select id from gather_flow where id = );
			        j = j.replace("{","[{").replace("}","}]"   WHERE NOT EXISTS (select id from gather_flow where id = );
			        ch = j.substring(b+2,j.length()-2   WHERE NOT EXISTS (select id from gather_flow where id = );
	         	}
	            	
	            ]]>
	   </script>
   </var-def>
   
<result>
	<var name="result"></var>
</result>
    </config>', '201608272014', '', '', '1', '2016-08-27 20:15:26', 'BUSINESS'   WHERE NOT EXISTS (select id from gather_flow where id = 163);







UPDATE gather_flow SET "id"='7', "abbr_name"='SLC_INIT', "config_name"='SLC初始化', "category_id"='080', "type_id"='080000', "remarks"='', "flow"='<?xml version="1.0" encoding="UTF-8"?>
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
            <http-param name="language">zh-Hans</http-param>
        </http>
    </var-def>
    <notice envelope="login" reverse="false" message="登录失败" url-decode="true">
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
</config>', "version"='201606231713', "ext_json"='', "init_param"='', "status"='1', "create_time"='2016-06-23 19:39:54', "flow_type"='INIT' WHERE ("id"='7');
UPDATE gather_flow SET "id"='8', "abbr_name"='SLC_MODIFY', "config_name"='SLC取消注单', "category_id"='080', "type_id"='080001', "remarks"='', "flow"='<?xml version="1.0" encoding="UTF-8"?>
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

      <session-exp init="true">
        <regexp>
            <regexp-pattern>(goToWithUrlCurrent)</regexp-pattern>
            <regexp-source>
                <var name="content"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>

							 

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
</config>', "version"='201606231713', "ext_json"='', "init_param"='', "status"='1', "create_time"='2016-06-23 17:16:26', "flow_type"='BUSINESS' WHERE ("id"='8');
UPDATE gather_flow SET "id"='9', "abbr_name"='SLC_RANDOM', "config_name"='SLC会话保持', "category_id"='080', "type_id"='080002', "remarks"='', "flow"='<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
     <random-call>      
        <http method="get" url="http://ag.12macau.com/Report/Index"></http>
    </random-call>
</config>', "version"='201606231713', "ext_json"='', "init_param"='', "status"='1', "create_time"='2016-06-23 17:16:26', "flow_type"='RANDOM' WHERE ("id"='9');
UPDATE gather_flow SET "id"='26', "abbr_name"='SLC_TRANS', "config_name"='SLC额度转换', "category_id"='080', "type_id"='080003', "remarks"='', "flow"='<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
   <var-def name="se">
        <http method="post" url="http://ag.12macau.com/Report/Index">
        </http>
    </var-def>
    
    <session-exp init="true" >
        <regexp>
            <regexp-pattern>(txtCaptcha)</regexp-pattern>
            <regexp-source>
                <var name="se"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>
   			<var-def name="filter">
   					<http url="http://ag.12macau.com/Report/GetDepositWithdrawal" method="post">
							<http-param name="fromDate"><var name="startTime"/></http-param>
							<http-param name="rowsPerPage">500</http-param>
							<http-param name="pageNo">0</http-param>
							<http-param name="excutedBy"></http-param>
							<http-param name="toDate"><var name="endTime"/></http-param>
							<http-param name="totalRows">0</http-param>
							<http-param name="transType"><var name="transferType"/></http-param>
							<http-param name="userName"><var name="account"/></http-param>
						</http>
			</var-def>			
						
						
	<var-def name="records">
	    <xpath expression="//tbody/tr">
	    	<html-to-xml>
	    		<var name="filter"/>
	    	</html-to-xml> 		
	    </xpath>
    </var-def>
						
	<var-def name="records">
		<xml-to-json>
				        <loop item="itemData" index="j" filter="unique">
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
							                
							                 let $date:=data($record//td[3]/text())
							                 
							                 let $transferType:=data($record//td[6]/text())
							                 
							                 let $amount:=data($record//td[7]/text())
							                 
							                 let $balance:=data($record//td[9]/text())
							                
							                let $transactionNo:=data($record//td[11]/text())
							    			
							                 return <base date="{$date}" transferType="{$transferType}" amount="{$amount}" balance="{$balance}" transactionNo="{$transactionNo}"></base>
						                ]]>
				                    </xq-expression>
				                </xquery>
				            </body>
				        </loop>
				        
				        </xml-to-json>
				    </var-def>   	
				    
				    
				    
	<var-def name="slcResult">
	   	<script return="ch">
	   	 <![CDATA[
  			Object obj=sys.getVar("records");
			if(obj!=null)
			{
			 String j=obj.toString();
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
		}
	            ]]>
	   </script>
   </var-def>
    
    
    <result>
        <var name="slcResult"/>       
    </result>		
</config>', "version"='201606231713', "ext_json"='', "init_param"='', "status"='1', "create_time"='2016-06-23 17:16:26', "flow_type"='BUSINESS' WHERE ("id"='26');
UPDATE gather_flow SET "id"='28', "abbr_name"='SLC_CHECK', "config_name"='SLC检查转账状态', "category_id"='080', "type_id"='080004', "remarks"='', "flow"='<?xml version="1.0" encoding="UTF-8"?>
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




   <var-def name="records">
	    <xpath expression="//tbody/tr">
	    	<html-to-xml>
	    		<var name="record"/>
	    	</html-to-xml> 		
	    </xpath>
    </var-def>
    
    <function name="addTag">
	    <return> 
		    <loop item="item" index="i">
		    	<list>
		    		<var name="re"/>
		    	</list>
		    	<body>
		    		<var-def name="contents">
		    			<xquery>
		    				<xq-param name="doc">
		    					<var name="item"/>
		    				</xq-param>
		    				<xq-expression><![CDATA[
		    						declare variable $doc as node() external;
		    						let $hh :=data($doc//td[1])
		    						let $zdhh :=data($doc//td[2])
		    						let $zdrq :=data($doc//td[3])
		    						let $yhm :=data($doc//td[4])
		    						let $hb :=data($doc//td[5])
		    						let $lx :=data($doc//td[6])
		    						let $je1 :=data($doc//td[7])
		    						let $je2 :=data($doc//td[8])
		    						let $ye :=data($doc//td[9])
		    						let $zxy :=data($doc//td[10])
		    						let $zs :=data($doc//td[11])
		    							return
		    								<record>
		    									<hh>{$hh}</hh>
		    									<zdhh>{$zdhh}</zdhh>
		    									<zdrq>{$zdrq}</zdrq>
		    									<yhm>{$yhm}</yhm>
		    									<hb>{$hb}</hb>
		    									<lx>{$lx}</lx>
		    									<je1>{$je1}</je1>
		    									<je2>{$je2}</je2>
		    									<ye>{$ye}</ye>
		    									<zxy>{$zxy}</zxy>
		    									<zs>{$zs}</zs>
		    								</record>
		    				]]></xq-expression>
		    			</xquery>
		    		</var-def>	
		    	</body>
		    </loop>
	    </return> 
    </function>
    
    <var-def name="recordss">
    	<xml-to-json>
	    	<call name="addTag">
	    		<call-param name="re"><var name="records"/></call-param>
	    	</call>
    	</xml-to-json>
    </var-def>
    	<var-def name="apiTransId">
		<var name="transactionNo"/>
	</var-def>
    <result>
         <var-def name="mgResult">
        <script return="resultJson">
            <![CDATA[
            String j = sys.getVar("recordss").toString();
            String transId=sys.getVar("apiTransId").toString();
            if(j.contains(transId)){
            	resultJson = "转账成功！";
            }
            else{
            	resultJson = "转账失败！";
            }
            ]]>
        </script>
    </var-def>      
    </result>
</config>
', "version"='201608261550', "ext_json"='', "init_param"='', "status"='1', "create_time"='2016-08-26 17:16:26', "flow_type"='BUSINESS' WHERE ("id"='28');







INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '171', 'SA_INIT', 'SA初始化', '170', '170001', '', '<?xml version="1.0" encoding="UTF-8"?>

<config>
	<var-def name="login_url">http://bo.sa-gaming.net</var-def>
    <var-def name="vcid">
    	<html-to-xml>
    		<http method="get" url="${login_url}"></http>
    	</html-to-xml>
    </var-def>
     
    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("vcid");
            String result = content.toString();
            result = result.replaceAll(" PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"","");
            sys.defineVariable("vcid",result,true);  
            ]]>
        </script>
    </var-def>
    
    <var-def name="vcid">
        <xpath expression="//body/form/div[3]/div[3]/table/tbody/tr[4]/td[2]/table/tbody/tr/td[2]/div/div[1]/img/@src">
			<var name="vcid"/>
        </xpath>
    </var-def>
    
    <var-def name="vcid">
        <script return="splitResult[3]">
            <![CDATA[
            Object content = sys.getVar("vcid");
            String result = content.toString();
            String[] splitResult = new String[20];
            splitResult = result.split("="); 
            ]]>
        </script>
    </var-def>
   
    
    <var-def name="code_url">http://bo.sa-gaming.net/BotDetectCaptcha.ashx</var-def>
       
    <validate name="code" type="image/png" wait-time="30000" expression="\d+">
        <http method="get" response-content-type="image/png" url="${code_url}">
        	<http-param name="get">image</http-param>
        	<http-param name="c">c_login_loginuser_logincaptcha</http-param>
        	<http-param name="t"><var name="vcid"/></http-param>
        </http>
    </validate>
    
    <var-def name="login">
        <http method="post" url="${login_url}" content-type="application/x-www-form-urlencoded">
		<http-param name="__LASTFOCUS"></http-param>
		<http-param name="ToolkitScriptManager1_HiddenField">;;AjaxControlToolkit, Version=4.1.50508.0, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e:zh-CN:0c8c847b-b611-49a7-8e75-2196aa6e72fa:475a4ef5:effe2a26:3ac3e789</http-param>
		<http-param name="__EVENTTARGET"></http-param>
		<http-param name="__EVENTARGUMENT"></http-param>
		<http-param name="__VIEWSTATE">/wEPDwUKLTg3NTk0NjY3OA9kFgQCAQ9kFgQCAg9kFgJmDxYCHgRUZXh0BRRTQUdhbWluZ+euoeeQhuezu+e7n2QCBg9kFgICAQ8WAh4HVmlzaWJsZWhkAgMPFgIeBWNsYXNzBQxib2R5U0FHYW1pbmcWAgIBD2QWAgIDD2QWBmYPFgIfAgUGbm90aWNlZAIIDxYCHwFoZAILDxYCHwIFEWNvcHlyaWdodFNBR2FtaW5nZGRGgUTD4fSZgzP20ifsp/vst27OuA==</http-param>
		<http-param name="__VIEWSTATEGENERATOR">C2EE9ABB</http-param>
		<http-param name="__EVENTVALIDATION">/wEdAAW4t9R2ygX1Rh1hYqTfUi71HfOfr91+YI2XVhP1c/pGR96FYSfo5JULYVvfQ61/Uw5q8JdyELdkUhFX0svyStjM7DVGJTnjv5GsHJ/X19AaVpoYBtCTzpowQzzJ2M2ytVej3iEA</http-param>
		<http-param name="LoginUser$UserName"><var name="userName"/></http-param>
		<http-param name="LoginUser$Password"><var name="password"/></http-param>
		<http-param name="LoginUser$CaptchaCodeTextBox"><var name="code"/></http-param>
		<http-param name="LBD_VCID_c_login_loginuser_logincaptcha"><var name="vcid"/></http-param>
		<http-param name="LBD_BackWorkaround_c_login_loginuser_logincaptcha">1</http-param>
		<http-param name="LoginUser$LoginButton">登入</http-param>
        </http>
    </var-def>

    <notice envelope="login" reverse="false" message="登录失败">
        <regexp>
            <regexp-pattern>(Container.aspx)</regexp-pattern>
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
    
</config>', '20161112', '', '', '1', '2016-06-23 19:39:54', 'INIT'
WHERE NOT EXISTS (select id from gather_flow where id =171 );
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '172', 'SA_TRANS', 'SA额度转换', '170', '170002', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
   <var-def name="search_url">http://bo.sa-gaming.net/Operator/GetPointTransactionReport.aspx</var-def>
    <var-def name="getPointTransactionReport">
    	<html-to-xml>
    		<http method="get" url="${search_url}"/>
    	</html-to-xml>
    </var-def>
    
    <session-exp init="true" >
        <regexp>
            <regexp-pattern>(LoginUser_CaptchaLabel)</regexp-pattern>
            <regexp-source>
                <var name="getPointTransactionReport"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </session-exp>
    
    
    <var-def name="clean">
        <script>
            <![CDATA[
            Object content = sys.getVar("getPointTransactionReport");
            String result = content.toString();
            result = result.replaceAll(" PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"","");
            sys.defineVariable("getPointTransactionReport",result,true);
            ]]>
        </script>
    </var-def>
    
    <var-def name="viewState_2">
        <xpath expression="//body/form/div[1]/input[4]/@value">
			<var name="getPointTransactionReport"/>
        </xpath>
    </var-def>
    <var-def name="viewstateGenerator">
        <xpath expression="//body/form/div[2]/input[1]/@value">
			<var name="getPointTransactionReport"/>
        </xpath>
    </var-def>
     <var-def name="eventValidation">
        <xpath expression="//body/form/div[2]/input[2]/@value">
			<var name="getPointTransactionReport"/>
        </xpath>
    </var-def>

<!--first page-->
    <var-def name="content">
        	<html-to-xml>
        		<http method="post" url="${search_url}" content-type="application/x-www-form-urlencoded; charset=UTF-8">          
					<http-param name="ToolkitScriptManager1">ToolkitScriptManager1|btnSearch</http-param>
					<http-param name="ToolkitScriptManager1_HiddenField">;;AjaxControlToolkit, Version=4.1.50508.0, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e:zh-CN:0c8c847b-b611-49a7-8e75-2196aa6e72fa:475a4ef5:addc6819:5546a2b:d2e10b12:effe2a26:37e2e5c9:5a682656:c7029a2:e9e598a9</http-param>
					<http-param name="tbFromDate"><var name="tbFromDate"/></http-param>
					<http-param name="ddlFromHour">12</http-param>
					<http-param name="ddlFromMin">00</http-param>
					<http-param name="tbToDate"><var name="tbToDate"/></http-param>
					<http-param name="ddlToHour">11</http-param>
					<http-param name="ddlToMin">59</http-param>
					<http-param name="tbUsername"><var name="tbUsername"/></http-param>
					<http-param name="hidSelfCSUsername">dawoo</http-param>
					<http-param name="hidStartTime"><var name="hidStartTime"/></http-param>
					<http-param name="hidEndTime"><var name="hidEndTime"/></http-param>
					<http-param name="hidFilterUserType">1</http-param>
					<http-param name="hidUsername"><var name="tbUsername"/></http-param>
					<http-param name="hidSortType">11</http-param>
					<http-param name="hidForExport">False</http-param>
					<http-param name="__EVENTTARGET"></http-param>
					<http-param name="__EVENTARGUMENT"></http-param>
					<http-param name="__VIEWSTATE"><var name="viewState_2"/></http-param>
					<http-param name="__VIEWSTATEGENERATOR"><var name="viewstateGenerator"/></http-param>
					<http-param name="__EVENTVALIDATION"><var name="eventValidation"/></http-param>
					<http-param name="__ASYNCPOST">true</http-param>
					<http-param name="btnSearch">查询</http-param>
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
            
		    <var-def name="filter">
		        <xpath expression="//body/text()">
					<var name="content"/>
		        </xpath>
		    </var-def>   
		     <var-def name="viewState_2">
		        <script return="res">
		            <![CDATA[
		            Object obj = sys.getVar("filter");
		            String result = obj.toString();
		            String res = result.substring(result.indexOf("__VIEWSTATE|")+12, result.indexOf("|8|"));
		            ]]>
		        </script>
		    </var-def>

		    <var-def name="eventValidation">
		        <script return="res">
		            <![CDATA[
		            Object obj = sys.getVar("filter");
		            String result = obj.toString();
		            String res = result.substring(result.indexOf("__EVENTVALIDATION|")+18, result.indexOf("|19|asyncPostBackControlIDs"));
		            ]]>
		        </script>
		    </var-def>	
		    <var-def name="viewstateGenerator">
		        <script return="res">
		            <![CDATA[
		            Object obj = sys.getVar("filter");
		            String result = obj.toString();
		            String res = result.substring(result.indexOf("__VIEWSTATEGENERATOR|")+21, result.indexOf("|39"));
		            ]]>
		        </script>
		    </var-def>
		    <var-def name="filter_1">
		        <xpath expression="//body/table/tbody[1]/tr[@onmouseover]">
					<var name="content"/>
		        </xpath>
		    </var-def> 
		    					
            <var-def name="record_1">
		        <loop item="itemData" index="j" filter="unique">
		            <list>
		                <var name="filter_1"/>
		            </list>
		            <body>
		                <xquery>
		                    <xq-param name="record">
		                        <var name="itemData"></var>
		                    </xq-param>
		                    <xq-expression>
				                <![CDATA[
					                declare variable $record as node() external;
					               
					                 let $date:=data($record//td[1]/span)
					                 let $account:=data($record//td[2]/span)
					                 let $currencyName:=data($record//td[3]/span)
					                 let $outAmount:=data($record//td[4]/span)
					                 let $inAmount:=data($record//td[5]/span)
					                 let $startbalance:=data($record//td[6]/span)
					                 let $endbalance:=data($record//td[7]/span)
					                 let $remark:=data($record//td[8]/span)
		                 			 let $betTurn:=data($record//td[9]/span)
		                             let $orderId:=data($record//td[10]/span)
		
					                return <base date="{$date}" account="{$account}" currencyName="{$currencyName}" outAmount="{$outAmount}"
					                inAmount="{$inAmount}" startbalance="{$startbalance}" endbalance="{$endbalance}" remark="{$remark}" betTurn="{$betTurn}" 
					                orderId="{$orderId}"></base>
					                
				                ]]>
		                    </xq-expression>
		                </xquery>
		            </body>
		        </loop>
		    </var-def>
		    
			<var-def name="eventTarget">
			    <xpath expression="//body/table[2]/tbody/tr/td[2]/span/a[2]/@href">
			        <var name="content"/>
			    </xpath>
			</var-def>	 
			
		    <var-def name="eventTarget">
		        <script return="splitResult[1]">
		            <![CDATA[
		            Object obj = sys.getVar("eventTarget");
		            String result = obj.toString();
		            String[] splitResult = new String[20];
		            if(result.length() == 0){
		            	splitResult[1]="";
		            }else{
			            splitResult = result.split("''");   
		            }
		            ]]>
		        </script>
		    </var-def>	
		    			         
			<var-def name="totalCount">
			    <xpath expression="//body/table[2]/tbody/tr/td[3]/span/span[3]/text()">
			        <var name="content"/>
			    </xpath>
			</var-def>      
			<var-def name="quit">
				<script return="condition">
				    <![CDATA[
				        Object totalCount=sys.getVar("totalCount");
				        System.out.println("totalCount....:"+totalCount);
				        int count = totalCount.toInt();
				        if(count <= 100){
				            condition= "true";
				        }else{
				            condition= "false";
				        }
				     ]]>
				</script>      
			</var-def>
					
 	<function name="multipage">
        <return>
            <empty>
                <var-def name="quit"><var name="quit"/></var-def>
            </empty>
            <while condition="${quit.toString().length() != 4}" maxloops="${maxloops}" index="i">      	
            	<empty>
		            <var-def name="content">
		            	<html-to-xml>
		            		<http method="post" url="${pageUrl}" content-type="application/x-www-form-urlencoded; charset=UTF-8">          
								<http-param name="ToolkitScriptManager1"><template>UpdatePanel2|${eventTarget}</template></http-param>
								<http-param name="ToolkitScriptManager1_HiddenField">;;AjaxControlToolkit, Version=4.1.50508.0, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e:zh-CN:0c8c847b-b611-49a7-8e75-2196aa6e72fa:475a4ef5:addc6819:5546a2b:d2e10b12:effe2a26:37e2e5c9:5a682656:c7029a2:e9e598a9</http-param>
								<http-param name="tbFromDate"><var name="tbFromDate"/></http-param>
								<http-param name="ddlFromHour">12</http-param>
								<http-param name="ddlFromMin">00</http-param>
								<http-param name="tbToDate"><var name="tbToDate"/></http-param>
								<http-param name="ddlToHour">11</http-param>
								<http-param name="ddlToMin">59</http-param>
								<http-param name="tbUsername"><var name="tbUsername"/></http-param>
								<http-param name="hidSelfCSUsername">dawoo</http-param>
								<http-param name="hidStartTime"><var name="hidStartTime"/></http-param>
								<http-param name="hidEndTime"><var name="hidEndTime"/></http-param>
								<http-param name="hidFilterUserType">1</http-param>
								<http-param name="hidUsername"><var name="tbUsername"/></http-param>
								<http-param name="hidSortType">11</http-param>
								<http-param name="hidForExport">False</http-param>
								<http-param name="__EVENTTARGET"><var name="eventTarget"/></http-param>
								<http-param name="__EVENTARGUMENT"></http-param>
								<http-param name="__VIEWSTATE"><var name="viewState_2"/></http-param>
								<http-param name="__VIEWSTATEGENERATOR"><var name="viewstateGenerator"/></http-param>
								<http-param name="__EVENTVALIDATION"><var name="eventValidation"/></http-param>
								<http-param name="__ASYNCPOST">true</http-param>
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

				    <var-def name="filter">
				        <xpath expression="//body/text()">
							<var name="content"/>
				        </xpath>
				    </var-def>   
				     <var-def name="viewState_2">
				        <script return="res">
				            <![CDATA[
				            Object obj = sys.getVar("filter");
				            String result = obj.toString();
				            String res = result.substring(result.indexOf("__VIEWSTATE|")+12, result.indexOf("|8|"));
				            ]]>
				        </script>
				    </var-def>
 
				    <var-def name="eventValidation">
				        <script return="res">
				            <![CDATA[
				            Object obj = sys.getVar("filter");
				            String result = obj.toString();
				            String res = result.substring(result.indexOf("__EVENTVALIDATION|")+18, result.indexOf("|19|asyncPostBackControlIDs"));
				            ]]>
				        </script>
				    </var-def>	
				    <var-def name="viewstateGenerator">
				        <script return="res">
				            <![CDATA[
				            Object obj = sys.getVar("filter");
				            String result = obj.toString();
				            String res = result.substring(result.indexOf("__VIEWSTATEGENERATOR|")+21, result.indexOf("|39"));
				            ]]>
				        </script>
				    </var-def>
				    
					<var-def name="eventTarget">
					    <xpath expression="//body/table[2]/tbody/tr/td[2]/span/a[2]/@href">
					        <var name="content"/>
					    </xpath>
					</var-def>	
					 
				    <var-def name="eventTarget">
				        <script return="splitResult[1]">
				            <![CDATA[
				            Object obj = sys.getVar("eventTarget");
				            String result = obj.toString();
				            String[] splitResult = new String[20];
				            splitResult = result.split("''"); 
				            ]]>
				        </script>
				    </var-def>
				    			    
				    <var-def name="filter_2">
				        <xpath expression="//body/table/tbody[1]/tr[@onmouseover]">
							<var name="content"/>
				        </xpath>
				    </var-def>
				    
		            <var-def name="records">
				        <loop item="itemData" index="j" filter="unique">
				            <list>
				                <var name="filter_2"/>
				            </list>
				            <body>
				                <xquery>
				                    <xq-param name="record">
				                        <var name="itemData"></var>
				                    </xq-param>
				                    <xq-expression>
						                <![CDATA[
							                declare variable $record as node() external;
							               
							                 let $date:=data($record//td[1]/span)
							                 let $account:=data($record//td[2]/span)
							                 let $currencyName:=data($record//td[3]/span)
							                 let $outAmount:=data($record//td[4]/span)
							                 let $inAmount:=data($record//td[5]/span)
							                 let $startbalance:=data($record//td[6]/span)
							                 let $endbalance:=data($record//td[7]/span)
							                 let $remark:=data($record//td[8]/span)
				                 			 let $betTurn:=data($record//td[9]/span)
				                             let $orderId:=data($record//td[10]/span)
				
							                return <base date="{$date}" account="{$account}" currencyName="{$currencyName}" outAmount="{$outAmount}"
							                inAmount="{$inAmount}" startbalance="{$startbalance}" endbalance="{$endbalance}" remark="{$remark}" betTurn="{$betTurn}" 
							                orderId="{$orderId}"></base>
							                
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
	                            
	                            if((total-1)<= indexNum){
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

    <var-def name="record_2">
        <call name="multipage">
        	<call-param name="pageUrl"><var name="search_url"/></call-param>
          <call-param name="tbFromDate"><var name="tbFromDate"/></call-param>
          <call-param name="tbToDate"><var name="tbToDate"/></call-param>
		    <call-param name="hidStartTime"><var name="hidStartTime"/></call-param>
		    <call-param name="hidEndTime"><var name="hidEndTime"/></call-param>
		    <call-param name="tbUsername"><var name="tbUsername"/></call-param>
		    <call-param name="quit"><var name="quit"/></call-param>
		    <call-param name="setNum">100</call-param>
		    <call-param name="totalCount"><var name="totalCount"/></call-param>
		    <call-param name="viewState_2"><var name="viewState_2"/></call-param>
		    <call-param name="viewstateGenerator"><var name="viewstateGenerator"/></call-param>
		    <call-param name="eventValidation"><var name="eventValidation"/></call-param>
		    <call-param name="eventTarget"><var name="eventTarget"/></call-param>
        </call>
    </var-def>

    <var-def name="record">
    	<xml-to-json>
        <script return="result">
            <![CDATA[
            Object obj1 = sys.getVar("record_1");
            Object obj2 = sys.getVar("record_2");
            String res1 = obj1.toString();
            String res2 = obj2.toString();
            String result = res1 + res2;
            ]]>
        </script>
        </xml-to-json>
    </var-def>	    
  	<var-def name="saResult">
	   	<script return="ch">
	   	 <![CDATA[
  			Object obj=sys.getVar("record");
			if(obj!=null)
			{
			 String j=obj.toString();
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
		}
	            ]]>
	   </script>
   </var-def>
    
    
    <result>
        <var name="saResult"/>       
    </result>		
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'BUSINESS'
WHERE NOT EXISTS (select id from gather_flow where id =172 );
INSERT INTO gather_flow ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") SELECT '173', 'SA_RANDOM', 'SA会话保持', '170', '170003', '', '<?xml version="1.0" encoding="UTF-8"?>
<config charset="UTF-8">
     <random-call>      
        <http method="get" url="http://bo.sa-gaming.net/Operator/Default.aspx"></http>
    </random-call>
</config>', '201606231713', '', '', '1', '2016-06-23 17:16:26', 'RANDOM'
  WHERE NOT EXISTS (select id from gather_flow where id =173 );



INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '17', 'SA后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-09-06 20:24:22', '2016-09-06 20:24:22', NULL, NULL, '2016', '170' WHERE NOT EXISTS (select id from gather_schedule where id =17 );


INSERT INTO gather_user ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '161', 'ebet_gather01', 'fa8034h6', 'EBET用户', '01', '1', '2016-06-23 19:26:49', '160', 'f'  WHERE NOT EXISTS (select id from gather_user where id =161 );
INSERT INTO gather_user ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '171', 'gather01', 'fa8034h6', 'SA用户', '01', '1', '2016-06-23 19:26:49', '170', 'f' WHERE NOT EXISTS (select id from gather_user where id =171 );

DELETE FROM gather_type;
INSERT INTO gather_type (ID, NAME, category_id, status) SELECT
	type_id,
	config_name,
	category_id,
	1
FROM
	gather_flow;