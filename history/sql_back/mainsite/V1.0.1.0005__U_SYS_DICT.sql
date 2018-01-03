-- auto gen by sh 2015-09-06
--字典表 - 添加时区
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT * FROM(
  SELECT
     'common',
     'time_zone',
     "replace"(dict_code,'{n}', CASE when row_number() over() >12 then 'west_'||row_number() over() -12||'' else 'east_'||row_number() over() ||''end ) dict_code,
     row_number() over(),
     "replace"(remark,'{z}', CASE when row_number() over() >12 then '西'||row_number() over() -12 || '区' else '东'||row_number() over() || '区' end ) remark,
     true
  FROM (
    SELECT  '{n}_districts' dict_code ,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
    UNION all
    SELECT  '{n}_districts' dict_code,'时区- {z}' remark
  )aa
)aa
WHERE aa.dict_code NOT IN (SELECT dict_code FROM sys_dict where module = 'common' AND dict_type = 'time_zone')
---East ten districts
--East ten area
--West
