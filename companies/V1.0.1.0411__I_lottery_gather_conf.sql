-- auto gen by cherry 2017-09-05 10:26:25
--companies
INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'opencai', 'opencai开彩网', 'xyft', 'pk10', 'http://3rd.game.api.com/open-ltapi/newly.do?token=8a5ec8717ed0efe6&code=mlaft&rows=1&format=json&extend=true', 'GET', 'JSON', 'JSON', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'xyft');


INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'opencai', 'opencai开彩网', 'cqxync', 'sfc', 'http://3rd.game.api.com/open-ltapi/newly.do?token=8a5ec8717ed0efe6&code=cqklsf&rows=1&format=json&extend=true', 'GET', 'JSON', 'JSON', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'cqxync');


INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'opencai', 'opencai开彩网', 'gdkl10', 'sfc', 'http://3rd.game.api.com/open-ltapi/newly.do?token=8a5ec8717ed0efe6&code=gdklsf&rows=1&format=json&extend=true', 'GET', 'JSON', 'JSON', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'gdkl10');

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'opencai', 'opencai开彩网', 'bjkl8', 'keno', 'http://3rd.game.api.com/open-ltapi/newly.do?token=8a5ec8717ed0efe6&code=bjkl8&rows=1&format=json&extend=true', 'GET', 'JSON', 'JSON', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'bjkl8');

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'opencai', 'opencai开彩网', 'fc3d', 'keno', 'http://3rd.game.api.com/open-ltapi/newly.do?token=8a5ec8717ed0efe6&code=fc3d&rows=1&format=json&extend=true', 'GET', 'JSON', 'JSON', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'fc3d');

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'opencai', 'opencai开彩网', 'tcpl3', 'keno', 'http://3rd.game.api.com/open-ltapi/newly.do?token=8a5ec8717ed0efe6&code=pl3&rows=1&format=json&extend=true', 'GET', 'JSON', 'JSON', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'tcpl3');


INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'ffc', '平台分分彩', 'ffssc', 'ssc', '', '', '', '', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'ffssc');

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'ffc', '平台二分彩', 'efssc', 'ssc', '', '', '', '', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'efssc');

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'ffc', '平台三分彩', 'sfssc', 'ssc', '', '', '', '', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'sfssc');

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param")
select  'ffc', '平台五分彩', 'wfssc', 'ssc', '', '', '', '', ''
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'wfssc');

  select redo_sqls($$
  ALTER table lottery_gather_conf add column check_next bool;
  COMMENT ON COLUMN lottery_gather_conf.check_next IS '是否检验下一期开奖时间';
  $$);

UPDATE lottery_gather_conf set check_next ='true' where abbr_name='opencai';

  select redo_sqls($$
alter table lottery_gather_conf add column conf_type  varchar(20);
  COMMENT ON COLUMN lottery_gather_conf.conf_type IS '接口配置类型，gather采集，valid验证';
  $$);


UPDATE lottery_gather_conf set conf_type ='gather';

UPDATE lottery_gather_conf set check_next ='false' where abbr_name='ffc';

UPDATE lottery_gather_conf set check_next ='false' where abbr_name='kai';


INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param", "check_next", "conf_type")
select  'lbw', '600w彩票网', 'ALL', 'ALL', 'http://3rd.game.api.com/lbw-ltapi/ssc/getAllSscOpenTime2.json', 'GET', 'JSON', 'JSON', '', 't', 'valid'
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'ALL');

 select redo_sqls($$
alter table lottery_winning_record add column open_code varchar(128);
  COMMENT ON COLUMN lottery_winning_record.open_code IS '开奖号码';
  $$);

 select redo_sqls($$
alter table lottery_payout_record add column payout_hash  varchar(50);
  COMMENT ON COLUMN lottery_gather_conf.conf_type IS '开奖hash，避免同时开奖';
  $$);

 select redo_sqls($$
    ALTER TABLE "lottery_payout_record" ADD CONSTRAINT "unique_payout_hash" UNIQUE ("payout_hash")
  $$);