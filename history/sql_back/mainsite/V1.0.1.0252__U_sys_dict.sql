-- auto gen by cherry 2016-01-27 11:36:09
UPDATE sys_dict SET dict_code='5' WHERE dict_type='privilage_pass_time' AND dict_code='five';
UPDATE sys_dict SET dict_code='10' WHERE dict_type='privilage_pass_time' AND dict_code='ten';
UPDATE sys_dict SET dict_code='20' WHERE dict_type='privilage_pass_time' AND dict_code='twenty';
UPDATE sys_dict SET dict_code='30' WHERE dict_type='privilage_pass_time' AND dict_code='thirty';
UPDATE sys_dict SET dict_code='60' WHERE dict_type='privilage_pass_time' AND dict_code='one_hour';
UPDATE sys_dict SET dict_code='120' WHERE dict_type='privilage_pass_time' AND dict_code='two_hour';

UPDATE sys_param SET default_value='5' WHERE param_type='privilage_pass_time' and param_code='setting.privilage.pass.time';

UPDATE sys_param SET default_value='musics/notice/facebook.mp3' WHERE param_code='notice' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/audit/hmdxls.mp3' WHERE param_code='audit' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/warm/xtjbs.mp3' WHERE param_code='warm' AND param_type='warming_tone_project';