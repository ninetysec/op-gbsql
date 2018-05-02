-- auto gen by linsen 2018-04-13 16:38:12
-- 手机端背景颜色添加字典表 by linsen
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'default', '1', '默认', NULL, 't'
  WHERE 'default' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'black', '2', '黑色', NULL, 't'
  WHERE 'black' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'blue', '3', '蓝色', NULL, 't'
  WHERE 'blue' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'golden', '4', '金色', NULL, 't'
  WHERE 'golden' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'green', '5', '绿色', NULL, 't'
  WHERE 'green' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'pink', '6', '玫红', NULL, 't'
  WHERE 'pink' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'rainbow', '7', '彩虹', NULL, 't'
  WHERE 'rainbow' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'white', '8', '白色', NULL, 't'
  WHERE 'white' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'blue_black', '9', '蓝黑', NULL, 't'
  WHERE 'blue_black' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'orange_black', '10', '橘黑', NULL, 't'
  WHERE 'orange_black' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'red_black', '11', '红黑', NULL, 't'
  WHERE 'red_black' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'coffee_black', '12', '咖啡黑', NULL, 't'
  WHERE 'coffee_black' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'coffee_white', '13', '咖啡白', NULL, 't'
  WHERE 'coffee_white' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'green_white', '14', '绿白', NULL, 't'
  WHERE 'green_white' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'setting', 'mobile_background_color', 'orange_white', '15', '橙白', NULL, 't'
  WHERE 'orange_white' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'mobile_background_color');
