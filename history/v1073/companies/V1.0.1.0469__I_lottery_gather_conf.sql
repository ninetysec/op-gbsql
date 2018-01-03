-- auto gen by marz 2017-11-12 21:56:03
INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai','湖北快3彩票网','hbk3','k3','http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=hubk3&format=json','GET','JSON','JSON','','collection','t'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'hbk3' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '安徽快三彩票网', 'ahk3', 'k3', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=ahk3&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'ahk3' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '广西快三彩票网', 'gxk3', 'k3', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=gxk3&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'gxk3' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '江苏快三彩票网', 'jsk3', 'k3', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=jsk3&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'jsk3' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '重庆幸运农场彩票网', 'cqxync', 'sfc', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=cqklsf&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'cqxync' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '广东快乐十分彩票网', 'gdkl10', 'sfc', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=gdklsf&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'gdkl10' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '重庆时时彩彩票网', 'cqssc', 'ssc', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=cqssc&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'cqssc' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '天津时时彩彩票网', 'tjssc', 'ssc', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=tjssc&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'tjssc' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '新疆时时彩彩票网', 'xjssc', 'ssc', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=xjssc&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'xjssc' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '北京快乐8彩票网', 'bjkl8', 'keno', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=bjkl8&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'bjkl8' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '北京pk10彩票网', 'bjpk10', 'pk10', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=bjpk10&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'bjpk10' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '幸运飞艇彩票网', 'xyft', 'pk10', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=mlaft&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'xyft' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '福彩3d彩票网', 'fc3d', 'pl3', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=fc3d&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'fc3d' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '排列3彩票网', 'tcpl3', 'pl3', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=pl3&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'tcpl3' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '六合彩彩票网', 'hklhc', 'lhc', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=hk6&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'hklhc' AND conf_type = 'collection');

INSERT INTO lottery_gather_conf (abbr_name,name,code,type,url,method,request_content_type,response_content_type,json_param,conf_type,check_next)
SELECT 'opencai', '幸运28彩票网', 'xy28', 'xy28', 'http://3rd.game.api.com/open-ltapi/daily.do?token=8a5ec8717ed0efe6&code=bjkl8&format=json', 'GET', 'JSON', 'JSON', '', 'collection', 't'
WHERE NOT EXISTS (SELECT ID FROM lottery_gather_conf WHERE code = 'xy28' AND conf_type = 'collection');