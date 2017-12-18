-- auto gen by marz 2017-12-13 14:20:40
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '0尾', '2.1','2.1'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='0尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '1尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='1尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '2尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='2尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '3尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='3尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '4尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='4尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '5尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='5尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '6尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='6尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '7尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='7尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '8尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='8尾');
INSERT INTO lottery_odd (code, bet_code, bet_num, odd,odd_limit) SELECT 'hklhc', 'mantissa', '9尾', '1.8','1.8'where not EXISTS (SELECT id FROM lottery_odd where code='hklhc' and bet_code='mantissa' and bet_num='9尾');

select f_update_site_lottery_odd();

INSERT INTO lottery_quota (code, play_code, num_quota, bet_quota)  SELECT 'hklhc', 'mantissa', '50000', ' 5000'where not EXISTS(SELECT id FROM lottery_quota WHERE code='hklhc' and play_code='mantissa');

select f_update_site_lottery_quota();
