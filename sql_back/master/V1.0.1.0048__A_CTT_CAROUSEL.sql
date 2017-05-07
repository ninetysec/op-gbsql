-- auto gen by sh 2015-09-01 15:47:14
--删除广告表中的间隔时间字段
--有视图依赖,不能在测试库(Longer注)
--ALTER TABLE ctt_carousel DROP COLUMN IF EXISTS interval;

--将间隔时间添加到系统参数表

INSERT INTO sys_param (MODULE,param_type,param_code,param_value,DEFAULT_value,order_num,remark,active)
  SELECT 'content','carouselIntervalTime','carousel_type_login','5','5',1,'登录-广告轮播,间隔时间 param_code 是字典(module = content,dict_type = carousel_type)',true
  where 'carousel_type_login' not in (SELECT param_code from sys_param where module = 'content' and param_type = 'carouselIntervalTime');

INSERT INTO sys_param (MODULE,param_type,param_code,param_value,DEFAULT_value,order_num,remark,active)
  SELECT 'content','carouselIntervalTime','carousel_type_register','5','5',2,'注册-广告轮播,间隔时间 param_code 是字典(module = content,dict_type = carousel_type)',true
  where 'carousel_type_register' not in (SELECT param_code from sys_param where module = 'content' and param_type = 'carouselIntervalTime');


--广告表添加类别字段
select redo_sqls($$
ALTER TABLE ctt_carousel ADD COLUMN TYPE character varying(100);
$$);
COMMENT ON COLUMN "ctt_carousel"."type" IS '广告类别  字典(module = content,dict_type = carousel_type)';

