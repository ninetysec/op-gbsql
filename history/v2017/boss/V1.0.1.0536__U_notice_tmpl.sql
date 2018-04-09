-- auto gen by linsen 2018-03-28 20:00:25
-- 修改买分系统消息模板 by linsen
UPDATE notice_tmpl SET content='系统于${授信时间}免费赠送您买分额度${买分授信额度}，转账额度${转账授信额度}，请留意查收！'  WHERE tmpl_type='auto' AND event_type='GET_CREDIT_LINE' AND publish_method='siteMsg' AND group_code='1881951512019-iolqawaeara' AND locale='zh_CN';
UPDATE notice_tmpl SET content='系统于${授信时间}免费赠送您买分额度${买分授信额度}，转账额度${转账授信额度}，请留意查收！'  WHERE tmpl_type='auto' AND event_type='GET_CREDIT_LINE' AND publish_method='siteMsg' AND group_code='1881951512019-iolqawaeara' AND locale='zh_TW';
UPDATE notice_tmpl SET content='系统于${授信时间}免费赠送您买分额度${买分授信额度}，转账额度${转账授信额度}，请留意查收！'  WHERE tmpl_type='auto' AND event_type='GET_CREDIT_LINE' AND publish_method='siteMsg' AND group_code='1881951512019-iolqawaeara' AND locale='ja_JP';
UPDATE notice_tmpl SET content='系统于${授信时间}免费赠送您买分额度${买分授信额度}，转账额度${转账授信额度}，请留意查收！'  WHERE tmpl_type='auto' AND event_type='GET_CREDIT_LINE' AND publish_method='siteMsg' AND group_code='1881951512019-iolqawaeara' AND locale='en_US';

UPDATE notice_tmpl SET content='站点于${充值时间}通过系统自助充值，已成功提升买分额度${买分额度}，转账额度${转账额度},请留意查收！'  WHERE tmpl_type='auto' AND event_type='CREDIT_GET_QUOTA' AND publish_method='siteMsg' AND group_code='1881951512018-iolqawaeara' AND locale='zh_CN';
UPDATE notice_tmpl SET content='站点于${充值时间}通过系统自助充值，已成功提升买分额度${买分额度}，转账额度${转账额度},请留意查收！'  WHERE tmpl_type='auto' AND event_type='CREDIT_GET_QUOTA' AND publish_method='siteMsg' AND group_code='1881951512018-iolqawaeara' AND locale='zh_TW';
UPDATE notice_tmpl SET content='站点于${充值时间}通过系统自助充值，已成功提升买分额度${买分额度}，转账额度${转账额度},请留意查收！'  WHERE tmpl_type='auto' AND event_type='CREDIT_GET_QUOTA' AND publish_method='siteMsg' AND group_code='1881951512018-iolqawaeara' AND locale='ja_JP';
UPDATE notice_tmpl SET content='站点于${充值时间}通过系统自助充值，已成功提升买分额度${买分额度}，转账额度${转账额度},请留意查收！'  WHERE tmpl_type='auto' AND event_type='CREDIT_GET_QUOTA' AND publish_method='siteMsg' AND group_code='1881951512018-iolqawaeara' AND locale='en_US';
