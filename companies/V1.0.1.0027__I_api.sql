-- auto gen by cherry 2016-02-24 14:48:12

INSERT INTO api(ID,status,order_num,code)
SELECT 5,'normal',5,'A005' WHERE 5 not in (SELECT id from api);
INSERT INTO api(ID,status,order_num,code)
SELECT 6,'normal',6,'A006' WHERE 6 not in (SELECT id from api);
INSERT INTO api(ID,status,order_num,code)
SELECT 7,'normal',7,'A007' WHERE 7 not in (SELECT id from api);
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'PT','en_US',6,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 6 AND locale = 'en_US') =0;
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'PT','zh_CN',6,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 6 AND locale = 'en_US') =0;
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'PT','zh_TW',6,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 6 AND locale = 'en_US') =0;

INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'OG','en_US',7,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 7 AND locale = 'en_US') =0;
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'OG','zh_CN',7,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 7 AND locale = 'en_US') =0;
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'OG','zh_TW',7,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 7 AND locale = 'en_US') =0;

INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'GD','en_US',5,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 5 AND locale = 'en_US') =0;
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'GD','zh_CN',5,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 5 AND locale = 'en_US') =0;
INSERT INTO api_i18n(name,locale,api_id,logo1,logo2,cover,introduce_status,introduce_content)
SELECT 'GD','zh_TW',5,'','','','','' where (SELECT "count"(1) from api_i18n where api_id = 5 AND locale = 'en_US') =0;
