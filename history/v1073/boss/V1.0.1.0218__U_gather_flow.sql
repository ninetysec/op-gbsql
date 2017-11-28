-- auto gen by kobe 2016-11-08 17:09:24
UPDATE gather_flow SET flow='<?xml version="1.0" encoding="UTF-8"?>

<config charset="UTF-8">

	 <var-def name="userid">
	 	<xpath expression="//result[1]//crid/text()">
	 		<html-to-xml>
	       <json-to-xml>
					<http method="get" url="http://ag.adminserv88.com/lps/secure/network/80000483/downline">
						<http-param name="command">search</http-param>
						<http-param name="pageSize">10</http-param>
						<http-param name="page">1</http-param>
						<http-param name="search"><var name="account"/></http-param>
					</http>
				</json-to-xml>
			</html-to-xml>
     </xpath>
    </var-def>

	<var-def name="playcheckUrl">
	    <template>
	        ag.adminserv88.com/lps/secure/network/${userid}/playcheck/mgPlaycheck
	    </template>
	</var-def>

	<var-def name="type">live</var-def>

    <var-def name="playtoken">
      <http method="get" url="${playcheckUrl}">
			<http-param name="casinoType"></http-param>
			<http-param name="mgsGameId"><var name="gameId"/></http-param>
			<http-param name="isDevice">false</http-param>
		</http>
     	</var-def>

     	<var-def name="playUrl">
	  <script return="check">
	    <![CDATA[
	    String a1=sys.getJson("playtoken","message");
	    System.out.println("url="+a);
	    check=a1;
	    ]]>
	</script>
     </var-def>

     <var-def name="detail">
        	<http method="get" url="${playUrl}">
		</http>
     </var-def>

    <var-def name="ur">
        <regexp>
            <!--"transaction":"\u003ca href=\u0027/Playcheck/Home/GameDetail/48570831/34\u0027 class=-->
            <regexp-pattern>get\("(https:\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#]))",</regexp-pattern>
            <regexp-source>
                <var name="detail"/>
            </regexp-source>
            <regexp-result>
                <template>${_1}</template>
            </regexp-result>
        </regexp>
    </var-def>

     <var-def name="content">
	<html-to-xml>
		<http method="get" url="${ur}"/>
	</html-to-xml>
     </var-def>

	<var-def name="information">
		<xpath expression="//tbody/tr/td/table[1]/tbody/tr[2]/td[2]/text()">
			<var name="content"/>
		</xpath>
	</var-def>

	<var-def name="first">
		<script return="result">
		<![CDATA[
			String str=sys.getVar("information").toString();
			result=str.substring(0,1);
		]]>
		</script>
	</var-def>

	<var-def name="C">C</var-def>
	<var-def name="B">B</var-def>

	<var-def name="contents">
		<case>
			<if condition="${first.toString().trim().equals(C.toString())}">
				<xquery>
					<xq-param name="doc">
						<var name="content"/>
					</xq-param>
					<xq-expression>
						<![CDATA[
							declare variable $doc as node() external;
							let $tableInformation :=data($doc//tbody/tr/td/table[1]/tbody/tr[2]/td[2]/text())

							let $dealer1 :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[2]/text())
							let $dealer1img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[2]/img[1]/@src)
							let $dealer2img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[2]/img[2]/@src)
							let $dealer3img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[2]/img[3]/@src)
							let $dealer4img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[2]/img[4]/@src)
							let $dealer5img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[2]/img[5]/@src)
							let $player1 :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[3]/text())
							let $player1img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[3]/img[1]/@src)
							let $player2img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[3]/img[2]/@src)
							let $player3img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[3]/img[3]/@src)
							let $player4img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[3]/img[4]/@src)
							let $player5img :=data($doc//tbody/tr/td/table[1]/tbody/tr[7]/td[3]/img[5]/@src)

							let $pool1 :=data($doc//tbody/tr/td/table[3]/tbody/tr[2]/td[1]/text())
							let $bet1 :=data($doc//tbody/tr/td/table[3]/tbody/tr[2]/td[2]/text())
							let $profit1 :=data($doc//tbody/tr/td/table[3]/tbody/tr[2]/td[3]/text())
							let $profit11 :=data($doc//tbody/tr/td/table[3]/tbody/tr[2]/td[3]/font/text())

							let $pool2 :=data($doc//tbody/tr/td/table[3]/tbody/tr[3]/td[1]/text())
							let $bet2 :=data($doc//tbody/tr/td/table[3]/tbody/tr[3]/td[2]/text())
							let $profit2 :=data($doc//tbody/tr/td/table[3]/tbody/tr[3]/td[3]/text())
							let $profit21 :=data($doc//tbody/tr/td/table[3]/tbody/tr[3]/td[3]/font/text())


								return
									<Hodlem>
										<tableInformation>{$tableInformation}</tableInformation>
										<result>
											<dealer>
												<num>{$dealer1}</num>
												<img>{$dealer1img}</img>
											</dealer>
											<dealer>
												<num>{$dealer1}</num>
												<img>{$dealer2img}</img>
											</dealer>
											<dealer>
												<num>{$dealer1}</num>
												<img>{$dealer3img}</img>
											</dealer>
											<dealer>
												<num>{$dealer1}</num>
												<img>{$dealer4img}</img>
											</dealer>
											<dealer>
												<num>{$dealer1}</num>
												<img>{$dealer5img}</img>
											</dealer>

											<player>
												<num>{$player1}</num>
												<img>{$player2img}</img>
											</player>
											<player>
												<num>{$player1}</num>
												<img>{$player2img}</img>
											</player>
											<player>
												<num>{$player1}</num>
												<img>{$player3img}</img>
											</player>
											<player>
												<num>{$player1}</num>
												<img>{$player4img}</img>
											</player>
											<player>
												<num>{$player1}</num>
												<img>{$player5img}</img>
											</player>

										</result>
										<betType>
											<pool>{$pool1}</pool>
											<bet>{$bet1}</bet>
											<profit>{$profit1}{$profit11}</profit>
										</betType>
										<betType>
											<pool>{$pool2}</pool>
											<bet>{$bet2}</bet>
											<profit>{$profit2}{$profit21}</profit>
										</betType>
									</Hodlem>
						]]>
					</xq-expression>
				</xquery>
			</if>
			<else>
				<case>
					<if condition="${first.toString().trim().equals(B.toString())}">
						<xquery>
							<xq-param name="doc">
								<var name="content"/>
							</xq-param>
							<xq-expression>
								<![CDATA[
									declare variable $doc as node() external;

									let $tableInformation :=data($doc//tbody/tr/td/table[1]/tbody/tr[2]/td[2]/text())
									let $banker1 :=data($doc//tbody/tr/td/table[1]/tbody/tr[4]/td[2]/text())
									let $banker1img :=data($doc//tbody/tr/td/table[1]/tbody/tr[4]/td[2]/img/@src)
									let $player1 :=data($doc//tbody/tr/td/table[1]/tbody/tr[4]/td[3]/text())
									let $player1img :=data($doc//tbody/tr/td/table[1]/tbody/tr[4]/td[3]/img/@src)

									let $banker2 :=data($doc//tbody/tr/td/table[1]/tbody/tr[5]/td[2]/text())
									let $banker2img :=data($doc//tbody/tr/td/table[1]/tbody/tr[5]/td[2]/img/@src)
									let $player2 :=data($doc//tbody/tr/td/table[1]/tbody/tr[5]/td[3]/text())
									let $player2img :=data($doc//tbody/tr/td/table[1]/tbody/tr[5]/td[3]/img/@src)

									let $banker3 :=data($doc//tbody/tr/td/table[1]/tbody/tr[6]/td[2]/text())
									let $banker3img :=data($doc//tbody/tr/td/table[1]/tbody/tr[6]/td[2]/img/@src)
									let $player3 :=data($doc//tbody/tr/td/table[1]/tbody/tr[6]/td[3]/text())
									let $player3img :=data($doc//tbody/tr/td/table[1]/tbody/tr[6]/td[3]/img/@src)

									let $pool1 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[1]/text())
									let $bet1 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[2]/text())
									let $profit1 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[3]/text())
									let $profit11 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[3]/font/text())

									let $pool2 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[1]/text())
									let $bet2 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[2]/text())
									let $profit2 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[3]/text())
									let $profit21 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[3]/font/text())
										return
											<Baccarat>
												<tableInformation>{$tableInformation}</tableInformation>
												<result>
													<banker>
														<num>{$banker1}</num>
														<img>{$banker1img}</img>
													</banker>
													<player>
														<num>{$player1}</num>
														<img>{$player1img}</img>
													</player>
													<banker>
														<num>{$banker2}</num>
														<img>{$banker2img}</img>
													</banker>
													<player>
														<num>{$player2}</num>
														<img>{$player2img}</img>
														</player>
													<banker>
														<num>{$banker3}</num>
														<img>{$banker3img}</img>
														</banker>
													<player>
														<num>{$player3}</num>
														<img>{$player3img}</img>
													</player>
												</result>
												<betType>
													<pool>{$pool1}</pool>
													<bet>{$bet1}</bet>
													<profit>{$profit1}{$profit11}</profit>
												</betType>
												<betType>
													<pool>{$pool2}</pool>
													<bet>{$bet2}</bet>
													<profit>{$profit2}{$profit21}</profit>
												</betType>
											</Baccarat>
								]]>
							</xq-expression>
						</xquery>
					</if>
					<else>
						<xquery>
							<xq-param name="doc">
								<var name="content"/>
							</xq-param>
							<xq-expression>
								<![CDATA[
									declare variable $doc as node() external;
									let $number :=data($doc//tbody/tr/td/table[1]/tbody/tr[2]/td[2]/text())
									let $tableInformation :=data($doc//tbody/tr/td/table[1]/tbody/tr[3]/td[2]/text())
									let $pool1 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[1]/text())
									let $bet1 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[2]/text())
									let $profit1 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[3]/text())
									let $profit11 :=data($doc//tbody/tr/td/table[2]/tbody/tr[2]/td[3]/font/text())
									let $pool2 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[1]/text())
									let $bet2 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[2]/text())
									let $profit2 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[3]/text())
									let $profit21 :=data($doc//tbody/tr/td/table[2]/tbody/tr[3]/td[3]/font/text())
										return
											<Roulette>
												<result>{$number}</result>
												<tableInformation>{$tableInformation}</tableInformation>
												<betType>
													<pool>{$pool1}</pool>
													<bet>{$bet1}</bet>
													<profit>{$profit1}{$profit11}</profit>
												</betType>
												<betType>
													<pool>{$pool2}</pool>
													<bet>{$bet2}</bet>
													<profit>{$profit2}{$profit21}</profit>
												</betType>
											</Roulette>
								]]>
							</xq-expression>
						</xquery>
					</else>
				</case>
			</else>
		</case>
	</var-def>

	<var-def name="record">
		<xml-to-json>
			<var name="contents"/>
		</xml-to-json>
	</var-def>

	<result>
		 <var name="record"/>
	</result>

</config>' WHERE id=37;
