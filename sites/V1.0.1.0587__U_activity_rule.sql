-- auto gen by george 2017-11-03 17:11:06
UPDATE activity_rule SET condition_type = '1'
 WHERE activity_message_id IN (SELECT id FROM activity_message WHERE activity_type_code = 'money') AND condition_type IS null;
