-- auto gen by marz 2017-12-21 19:57:49
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '3', '42','42'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='3');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '4', '42','42'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='4');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '5', '20','20'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='5');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '6', '20','20'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='6');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '7', '13','13'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='7');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '8', '13','13'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='8');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '9', '9','9'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='9');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '10', '9','9'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='10');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '12', '9','9'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='12');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '13', '9','9'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='13');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '14', '13','13'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='14');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '15', '13','13'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='15');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '16', '20','20'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='16');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '17', '20','20'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='17');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '18', '42','42'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='18');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'bjpk10', 'champion_up_sum', '19', '42','42'where not EXISTS (SELECT id FROM lottery_odd where code='bjpk10' and bet_code='champion_up_sum' and bet_num='19');


select f_update_site_lottery_odd();