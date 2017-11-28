-- auto gen by cherry 2016-08-30 20:04:34
update notice_tmpl set tmpl_type = 'auto',order_num=7 where group_code='2b801fbd304e11117393bdb9bf1d6c24';

update notice_tmpl set built_in = FALSE where group_code='33d8ef6eecf7455393c9aebd62d42113';

update notice_tmpl set built_in = TRUE where group_code='8d5b3045b72b47e3b89ec59b79ab09d6';

update notice_tmpl set order_num=8 where tmpl_type='auto' and event_type='PREFERENCE_AUDIT_SUCCESS';

update notice_tmpl set order_num=9 where tmpl_type='auto' and event_type='RETURN_RABBET_SUCCESS';

update notice_tmpl set order_num=10 where tmpl_type='auto' and event_type='RETURN_COMMISSION_SUCCESS';

update notice_tmpl set order_num=11 where tmpl_type='auto' and event_type='CHANGE_PLAYER_DATA';