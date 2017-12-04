-- auto gen by cherry 2017-07-31 12:04:34
delete  from game_api_provider where id in ('8','11','14');

delete From gather_category where id in ('080','110','140');
delete From gather_schedule where category_id in ('080','110','140');
delete From gather_flow where category_id in ('080','110','140');
delete From gather_type where category_id in ('080','110','140');
delete from gather_user where category_id in ('080','110','140');