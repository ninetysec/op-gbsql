-- auto gen by admin 2016-10-23 14:28:49

INSERT INTO "gather_type" ("id", "name", "category_id", "status", "create_time") select  '030006', 'MG注单详情', '030', '1', NULL where '030006' not in (select id from gather_type where id='030006');

INSERT INTO "gather_schedule" ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id")
SELECT '5', 'MG后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '030' where '5' not in (select id from gather_schedule where id='5');


INSERT INTO "gather_flow" ("id", "abbr_name", "config_name", "category_id", "type_id", "remarks", "flow", "version", "ext_json", "init_param", "status", "create_time", "flow_type") select '37', 'MG_RECORD', 'MG_真人注单详情', '030', '030006', ' ', ' <?xml version="1.0" encoding="UTF-8"?>

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
        	<http method="get" url="${ur}"/>
     </var-def>
		<result>
			 <var name="content"/>
    </result>

</config>', '201609280936', ' ', ' ', '1', '2016-08-10 15:47:50', 'BUSINESS' where '37' not in  (select id from gather_flow where id='37');;
