-- auto gen by linsen 2018-04-09 11:54:37

-- app_domain_error表取代collect_app_error表 by kobe
DROP TABLE IF EXISTS collect_app_error;

-- 只需要stat库里的site_online_account,boss库这张表是建错库了 by kobe
DROP TABLE IF EXISTS site_online_account;