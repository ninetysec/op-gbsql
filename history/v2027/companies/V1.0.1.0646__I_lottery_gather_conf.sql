-- auto gen by marz 2018-07-15 19:05:54
INSERT INTO lottery_gather_conf (abbr_name, name, code, type, url, method, request_content_type, response_content_type, json_param,"conf_type", "check_next")
SELECT 'opencai', '北京pk10彩票网', 'bjpk10', 'bjpk10', 'http://3rd.game.api.com/openlt-api/daily.do?token=tdeca2b81a7345ccbk&code=bjpk10&format=json', 'GET', 'JSON', 'JSON', '','open_code_valid','f'
where not EXISTS (SELECT id FROM lottery_gather_conf where abbr_name='opencai' and code ='bjpk10' and conf_type='open_code_valid');
