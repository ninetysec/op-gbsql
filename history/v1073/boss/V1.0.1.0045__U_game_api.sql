--修改slc 修改注单的脚本
update  game_api_provider set ext_json ='{"consumerId":"34","consumerPassword":"842452","prefix":"LZV","loginurl":"http://slc.slcpicdance.info/Main/ValidateTicket/?ticket={0}&lang={1}","xmlns":"http://lucky-89.com/webservices","setNum":"100","search-minute":"10","modify-minute":"60"}' where id=8;
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('633', 'fromDate', 'startTime', 't', NULL, NULL, '', '', '185', '', 'SLC-查询开始时间', '', '');
update game_api_interface_request set api_field_name ='toDate' where id=627;

--修改bb的请求方式

update game_api_interface set http_method ='POST' where provider_id=10;
update game_api_interface set request_content_type ='FORM' where provider_id=10;

