-- auto gen by kobe 2016-09-21 21:00:02

INSERT INTO game_api_provider ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone")
SELECT '17', 'SA', '', 'http://api.eval.sa-gaming.net/api/api.aspx', '测试环境', 'file:/data/impl-jars/api/api-sa.jar', 'so.wwb.gamebox.service.gameapi.impl.SaGameApi', '20160921070935', '{"Key":"3F8C6D14FD6F401CBBE8ECDD27FEE8E8","des":"g9G16nTs","md5":"GgaIMaiNNtg","isDebug":"true","validateTokenExpire":60}', '+8'
WHERE  NOT EXISTS(SELECT id FROM game_api_provider WHERE id=17);



