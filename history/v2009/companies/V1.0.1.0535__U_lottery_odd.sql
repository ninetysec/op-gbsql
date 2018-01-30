-- auto gen by marz 2018-01-26 16:21:38
select redo_sqls($$
  alter TABLE lottery_odd add COLUMN play_code varchar(32) COLLATE "default";
$$);

UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'hundred' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'one' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'ten_thousand' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_digital' WHERE bet_code = 'thousand' and bet_num='9';





UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'hundred' and bet_num='大';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'hundred' and bet_num='小';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'one' and bet_num='大';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'one' and bet_num='小';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'ten' and bet_num='大';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'ten' and bet_num='小';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'ten_thousand' and bet_num='大';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'ten_thousand' and bet_num='小';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'thousand' and bet_num='大';
UPDATE lottery_odd SET  play_code='one_big_small' WHERE bet_code = 'thousand' and bet_num='小';




UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'hundred' and bet_num='单';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'hundred' and bet_num='双';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'one' and bet_num='单';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'one' and bet_num='双';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'ten' and bet_num='单';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'ten' and bet_num='双';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'ten_thousand' and bet_num='单';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'ten_thousand' and bet_num='双';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'thousand' and bet_num='单';
UPDATE lottery_odd SET  play_code='one_single_double' WHERE bet_code = 'thousand' and bet_num='双';




UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'hundred' and bet_num='质';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'hundred' and bet_num='合';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'one' and bet_num='质';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'one' and bet_num='合';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'ten' and bet_num='质';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'ten' and bet_num='合';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'ten_thousand' and bet_num='质';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'ten_thousand' and bet_num='合';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'thousand' and bet_num='质';
UPDATE lottery_odd SET  play_code='one_prime_combined' WHERE bet_code = 'thousand' and bet_num='合';




UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_after_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_all_five' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_first_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='one_combination' WHERE bet_code = 'one_in_three' and bet_num='9';



UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'hundred_one' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'hundred_ten' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'ten_one' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'ten_thousand_hundred' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'ten_thousand_one' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'ten_thousand_ten' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'ten_thousand_thousand' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'thousand_hundred' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'thousand_one' and bet_num='中2';
UPDATE lottery_odd SET  play_code='two_digital' WHERE bet_code = 'thousand_ten' and bet_num='中2';









UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'hundred_ten_one' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'ten_thousand_hundred_one' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'ten_thousand_hundred_ten' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'ten_thousand_ten_one' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'ten_thousand_thousand_hundred' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'ten_thousand_thousand_one' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'ten_thousand_thousand_ten' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'thousand_hundred_one' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'thousand_hundred_ten' and bet_num='中3';
UPDATE lottery_odd SET  play_code='three_digital' WHERE bet_code = 'thousand_ten_one' and bet_num='中3';









UPDATE lottery_odd SET  play_code='five_sum_big_small' WHERE bet_code = 'five_sum' and bet_num='总大';
UPDATE lottery_odd SET  play_code='five_sum_big_small' WHERE bet_code = 'five_sum' and bet_num='总小';
UPDATE lottery_odd SET  play_code='five_sum_single_double' WHERE bet_code = 'five_sum' and bet_num='总单';
UPDATE lottery_odd SET  play_code='five_sum_single_double' WHERE bet_code = 'five_sum' and bet_num='总双';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'hundred_one' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'hundred_one' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'hundred_one' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'hundred_ten' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'hundred_ten' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'hundred_ten' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_one' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_one' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_one' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_hundred' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_hundred' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_hundred' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_one' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_one' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_one' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_ten' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_ten' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_ten' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_thousand' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_thousand' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'ten_thousand_thousand' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_hundred' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_hundred' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_hundred' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_one' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_one' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_one' and bet_num='和';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_ten' and bet_num='龙';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_ten' and bet_num='虎';
UPDATE lottery_odd SET  play_code='dragon_tiger_tie' WHERE bet_code = 'thousand_ten' and bet_num='和';









UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_after_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_after_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_after_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_after_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_after_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_after_three' and bet_num='10';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_first_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_first_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_first_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_first_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_first_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_first_three' and bet_num='10';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_in_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_in_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_in_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_in_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_in_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='group_three' WHERE bet_code = 'group3_in_three' and bet_num='10';


UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_after_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_after_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_after_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_after_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_after_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_first_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_first_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_first_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_first_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_first_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_in_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_in_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_in_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_in_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='group_six' WHERE bet_code = 'group6_in_three' and bet_num='8';


UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_after_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_first_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='span' WHERE bet_code = 'span_in_three' and bet_num='9';


UPDATE lottery_odd SET  play_code='ssc_wuxing_zhixuan' WHERE bet_code = 'ssc_wuxing_zhixuan_ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_wuxing_zhixuan' WHERE bet_code = 'ssc_wuxing_zhixuan_fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sixing_zhixuan' WHERE bet_code = 'ssc_sixing_zhixuan_ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_sixing_zhixuan' WHERE bet_code = 'ssc_sixing_zhixuan_fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hsds' and bet_num='单式';
 UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hsfs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hshz' and bet_num='和值';
 UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hskd' and bet_num='跨度';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hszh' and bet_num='一星';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hszh' and bet_num='二星';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_hszh' and bet_num='三星';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qsds' and bet_num='单式';
 UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qsfs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qshz' and bet_num='和值';
 UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qskd' and bet_num='跨度';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qszh' and bet_num='一星';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qszh' and bet_num='二星';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zhixuan' WHERE bet_code = 'ssc_sanxing_zhixuan_qszh' and bet_num='三星';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hshhzx' and bet_num='组三';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hshhzx' and bet_num='组六';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hsz3ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hsz3fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hsz6ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hsz6fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hszxbd' and bet_num='组三';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hszxbd' and bet_num='组六';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hszxhz' and bet_num='组三';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_hszxhz' and bet_num='组六';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qshhzx' and bet_num='组三';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qshhzx' and bet_num='组六';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qsz3ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qsz3fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qsz6ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qsz6fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qszxbd' and bet_num='组三';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qszxbd' and bet_num='组六';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qszxhz' and bet_num='组三';
UPDATE lottery_odd SET  play_code='ssc_sanxing_zuxuan' WHERE bet_code = 'ssc_sanxing_zuxuan_qszxhz' and bet_num='组六';














UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_hshzws' and bet_num='和尾';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_hsts' and bet_num='对子';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_hsts' and bet_num='豹子';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_hsts' and bet_num='顺子';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_qshzws' and bet_num='和尾';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_qsts' and bet_num='对子';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_qsts' and bet_num='豹子';
UPDATE lottery_odd SET  play_code='ssc_sanxing_teshu' WHERE bet_code = 'ssc_sanxing_zuxuan_qsts' and bet_num='顺子';




UPDATE lottery_odd SET  play_code='ssc_erxing_zhixuan' WHERE bet_code = 'ssc_erxing_zhixuan_qeds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_erxing_zhixuan' WHERE bet_code = 'ssc_erxing_zhixuan_qefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_erxing_zhixuan' WHERE bet_code = 'ssc_erxing_zhixuan_qehz' and bet_num='和值';
UPDATE lottery_odd SET  play_code='ssc_erxing_zhixuan' WHERE bet_code = 'ssc_erxing_zhixuan_qekd' and bet_num='跨度';




UPDATE lottery_odd SET  play_code='ssc_erxing_zuxuan' WHERE bet_code = 'ssc_erxing_zuxuan_qebd' and bet_num='1';
UPDATE lottery_odd SET  play_code='ssc_erxing_zuxuan' WHERE bet_code = 'ssc_erxing_zuxuan_qeds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='ssc_erxing_zuxuan' WHERE bet_code = 'ssc_erxing_zuxuan_qefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='ssc_erxing_zuxuan' WHERE bet_code = 'ssc_erxing_zuxuan_qehz' and bet_num='和值';


UPDATE lottery_odd SET  play_code='ssc_yixing' WHERE bet_code = 'ssc_yixing_dwd' and bet_num='定位胆';


UPDATE lottery_odd SET  play_code='ssc_budingwei_wuxing' WHERE bet_code = 'ssc_budingwei_wxem' and bet_num='2';
UPDATE lottery_odd SET  play_code='ssc_budingwei_wuxing' WHERE bet_code = 'ssc_budingwei_wxsm' and bet_num='3';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sixing' WHERE bet_code = 'ssc_budingwei_h4em' and bet_num='2';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sixing' WHERE bet_code = 'ssc_budingwei_h4ym' and bet_num='1';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sixing' WHERE bet_code = 'ssc_budingwei_q4em' and bet_num='2';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sixing' WHERE bet_code = 'ssc_budingwei_q4ym' and bet_num='1';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sanxing' WHERE bet_code = 'ssc_budingwei_h3em' and bet_num='2';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sanxing' WHERE bet_code = 'ssc_budingwei_h3ym' and bet_num='1';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sanxing' WHERE bet_code = 'ssc_budingwei_q3em' and bet_num='2';
UPDATE lottery_odd SET  play_code='ssc_budingwei_sanxing' WHERE bet_code = 'ssc_budingwei_q3ym' and bet_num='1';

UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'champion' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'eighth_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fifth_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'fourth_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'ninth_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'runner_up' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'seventh_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'sixth_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'tenth_place' and bet_num='10';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='00';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='01';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='02';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='03';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='04';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='05';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='06';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='07';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='08';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='09';
UPDATE lottery_odd SET  play_code='pk10_digital' WHERE bet_code = 'third_runner' and bet_num='10';










UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'champion' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'champion' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'eighth_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'eighth_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'fifth_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'fifth_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'fourth_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'fourth_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'ninth_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'ninth_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'runner_up' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'runner_up' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'seventh_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'seventh_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'sixth_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'sixth_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'tenth_place' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'tenth_place' and bet_num='小';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'third_runner' and bet_num='大';
UPDATE lottery_odd SET  play_code='pk10_big_small' WHERE bet_code = 'third_runner' and bet_num='小';









UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'champion' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'champion' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'eighth_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'eighth_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'fifth_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'fifth_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'fourth_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'fourth_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'ninth_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'ninth_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'runner_up' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'runner_up' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'seventh_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'seventh_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'sixth_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'sixth_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'tenth_place' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'tenth_place' and bet_num='双';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'third_runner' and bet_num='单';
UPDATE lottery_odd SET  play_code='pk10_single_double' WHERE bet_code = 'third_runner' and bet_num='双';









UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'champion' and bet_num='龙';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'champion' and bet_num='虎';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'fifth_place' and bet_num='龙';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'fifth_place' and bet_num='虎';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'fourth_place' and bet_num='龙';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'fourth_place' and bet_num='虎';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'runner_up' and bet_num='龙';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'runner_up' and bet_num='虎';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'third_runner' and bet_num='龙';
UPDATE lottery_odd SET  play_code='pk10_dragon_tiger' WHERE bet_code = 'third_runner' and bet_num='虎';




UPDATE lottery_odd SET  play_code='pk10_qe_zhixuan' WHERE bet_code = 'pk10_zhixuan_qeds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pk10_qe_zhixuan' WHERE bet_code = 'pk10_zhixuan_qefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pk10_qs_zhixuan' WHERE bet_code = 'pk10_zhixuan_qsds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pk10_qs_zhixuan' WHERE bet_code = 'pk10_zhixuan_qsfs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pk10_yixing' WHERE bet_code = 'pk10_yixing_dwd' and bet_num='定位胆';

UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='00';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='01';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='02';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='03';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='04';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='05';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='06';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='07';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='08';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='09';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='10';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='11';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='12';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='13';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='14';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='15';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='16';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='17';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='18';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='19';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='20';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='21';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='22';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='23';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='24';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='25';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='26';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='27';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='28';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='29';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='30';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='31';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='32';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='33';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='34';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='35';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='36';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='37';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='38';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='39';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='40';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='41';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='42';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='43';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='44';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='45';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='46';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='47';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='48';
UPDATE lottery_odd SET  play_code='special_digital' WHERE bet_code = 'special' and bet_num='49';
UPDATE lottery_odd SET  play_code='special_big_small' WHERE bet_code = 'special' and bet_num='大';
UPDATE lottery_odd SET  play_code='special_big_small' WHERE bet_code = 'special' and bet_num='小';
UPDATE lottery_odd SET  play_code='special_single_double' WHERE bet_code = 'special' and bet_num='单';
UPDATE lottery_odd SET  play_code='special_single_double' WHERE bet_code = 'special' and bet_num='双';
UPDATE lottery_odd SET  play_code='special_half' WHERE bet_code = 'special' and bet_num='大单';
UPDATE lottery_odd SET  play_code='special_half' WHERE bet_code = 'special' and bet_num='大双';
UPDATE lottery_odd SET  play_code='special_half' WHERE bet_code = 'special' and bet_num='小单';
UPDATE lottery_odd SET  play_code='special_half' WHERE bet_code = 'special' and bet_num='小双';
UPDATE lottery_odd SET  play_code='special_sum_big_small' WHERE bet_code = 'special' and bet_num='合大';
UPDATE lottery_odd SET  play_code='special_sum_big_small' WHERE bet_code = 'special' and bet_num='合小';
UPDATE lottery_odd SET  play_code='special_sum_single_double' WHERE bet_code = 'special' and bet_num='合单';
UPDATE lottery_odd SET  play_code='special_sum_single_double' WHERE bet_code = 'special' and bet_num='合双';





UPDATE lottery_odd SET  play_code='special_mantissa_big_small' WHERE bet_code = 'special' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='special_mantissa_big_small' WHERE bet_code = 'special' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='special_colour' WHERE bet_code = 'special' and bet_num='红波';
UPDATE lottery_odd SET  play_code='special_colour' WHERE bet_code = 'special' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='special_colour' WHERE bet_code = 'special' and bet_num='蓝波';



UPDATE lottery_odd SET  play_code='seven_sum_big_small' WHERE bet_code = 'seven_sum' and bet_num='总单';
UPDATE lottery_odd SET  play_code='seven_sum_big_small' WHERE bet_code = 'seven_sum' and bet_num='总双';
UPDATE lottery_odd SET  play_code='seven_sum_single_double' WHERE bet_code = 'seven_sum' and bet_num='总大';
UPDATE lottery_odd SET  play_code='seven_sum_single_double' WHERE bet_code = 'seven_sum' and bet_num='总小';



UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='00';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_digital' WHERE bet_code = 'positive' and bet_num='49';






UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_fifth' and bet_num='大';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_fifth' and bet_num='小';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_first' and bet_num='大';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_first' and bet_num='小';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_fourth' and bet_num='大';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_fourth' and bet_num='小';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_second' and bet_num='大';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_second' and bet_num='小';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_sixth' and bet_num='大';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_sixth' and bet_num='小';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_third' and bet_num='大';
UPDATE lottery_odd SET  play_code='positive_big_small' WHERE bet_code = 'positive_third' and bet_num='小';

UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fifth' and bet_num='49';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_first' and bet_num='49';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_fourth' and bet_num='49';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_second' and bet_num='49';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_sixth' and bet_num='49';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='01';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='02';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='03';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='04';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='05';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='06';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='07';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='08';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='09';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='10';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='11';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='12';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='13';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='14';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='15';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='16';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='17';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='18';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='19';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='20';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='21';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='22';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='23';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='24';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='25';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='26';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='27';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='28';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='29';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='30';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='31';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='32';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='33';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='34';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='35';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='36';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='37';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='38';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='39';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='40';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='41';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='42';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='43';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='44';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='45';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='46';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='47';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='48';
UPDATE lottery_odd SET  play_code='positive_special_digital' WHERE bet_code = 'positive_third' and bet_num='49';



UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_fifth' and bet_num='单';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_fifth' and bet_num='双';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_first' and bet_num='单';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_first' and bet_num='双';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_fourth' and bet_num='单';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_fourth' and bet_num='双';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_second' and bet_num='单';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_second' and bet_num='双';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_sixth' and bet_num='单';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_sixth' and bet_num='双';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_third' and bet_num='单';
UPDATE lottery_odd SET  play_code='positive_single_double' WHERE bet_code = 'positive_third' and bet_num='双';





UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_fifth' and bet_num='红波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_fifth' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_fifth' and bet_num='蓝波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_first' and bet_num='红波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_first' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_first' and bet_num='蓝波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_fourth' and bet_num='红波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_fourth' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_fourth' and bet_num='蓝波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_second' and bet_num='红波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_second' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_second' and bet_num='蓝波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_sixth' and bet_num='红波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_sixth' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_sixth' and bet_num='蓝波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_third' and bet_num='红波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_third' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='positive_colour' WHERE bet_code = 'positive_third' and bet_num='蓝波';





UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_fifth' and bet_num='合大';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_fifth' and bet_num='合小';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_first' and bet_num='合大';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_first' and bet_num='合小';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_fourth' and bet_num='合大';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_fourth' and bet_num='合小';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_second' and bet_num='合大';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_second' and bet_num='合小';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_sixth' and bet_num='合大';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_sixth' and bet_num='合小';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_third' and bet_num='合大';
UPDATE lottery_odd SET  play_code='positive_sum_big_small' WHERE bet_code = 'positive_third' and bet_num='合小';






UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_fifth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_fifth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_first' and bet_num='合单';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_first' and bet_num='合双';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_fourth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_fourth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_second' and bet_num='合单';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_second' and bet_num='合双';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_sixth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_sixth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_third' and bet_num='合单';
UPDATE lottery_odd SET  play_code='positive_sum_single_double' WHERE bet_code = 'positive_third' and bet_num='合双';






UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_fifth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_fifth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_first' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_first' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_fourth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_fourth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_second' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_second' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_sixth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_sixth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_third' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='positive_mantissa_big_small' WHERE bet_code = 'positive_third' and bet_num='尾小';





UPDATE lottery_odd SET  play_code='lhc_half_colour_big_small' WHERE bet_code = 'lhc_half_colour' and bet_num='红大';
UPDATE lottery_odd SET  play_code='lhc_half_colour_big_small' WHERE bet_code = 'lhc_half_colour' and bet_num='红小';
UPDATE lottery_odd SET  play_code='lhc_half_colour_big_small' WHERE bet_code = 'lhc_half_colour' and bet_num='绿大';
UPDATE lottery_odd SET  play_code='lhc_half_colour_big_small' WHERE bet_code = 'lhc_half_colour' and bet_num='绿小';
UPDATE lottery_odd SET  play_code='lhc_half_colour_big_small' WHERE bet_code = 'lhc_half_colour' and bet_num='蓝大';
UPDATE lottery_odd SET  play_code='lhc_half_colour_big_small' WHERE bet_code = 'lhc_half_colour' and bet_num='蓝小';
UPDATE lottery_odd SET  play_code='lhc_half_colour_single_double' WHERE bet_code = 'lhc_half_colour' and bet_num='红单';
UPDATE lottery_odd SET  play_code='lhc_half_colour_single_double' WHERE bet_code = 'lhc_half_colour' and bet_num='红双';
UPDATE lottery_odd SET  play_code='lhc_half_colour_single_double' WHERE bet_code = 'lhc_half_colour' and bet_num='绿单';
UPDATE lottery_odd SET  play_code='lhc_half_colour_single_double' WHERE bet_code = 'lhc_half_colour' and bet_num='绿双';
UPDATE lottery_odd SET  play_code='lhc_half_colour_single_double' WHERE bet_code = 'lhc_half_colour' and bet_num='蓝单';
UPDATE lottery_odd SET  play_code='lhc_half_colour_single_double' WHERE bet_code = 'lhc_half_colour' and bet_num='蓝双';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='鼠';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='牛';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='虎';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='兔';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='龙';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='蛇';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='马';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='羊';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='猴';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='鸡';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='狗';
UPDATE lottery_odd SET  play_code='special_zodiac' WHERE bet_code = 'special' and bet_num='猪';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='鼠';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='牛';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='虎';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='兔';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='龙';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='蛇';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='马';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='羊';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='猴';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='鸡';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='狗';
UPDATE lottery_odd SET  play_code='lhc_one_zodiac' WHERE bet_code = 'lhc_one_zodiac' and bet_num='猪';
UPDATE lottery_odd SET  play_code='lhc_four_all_in' WHERE bet_code = 'lhc_four_all_in' and bet_num='4';
UPDATE lottery_odd SET  play_code='lhc_three_all_in' WHERE bet_code = 'lhc_three_all_in' and bet_num='3';
UPDATE lottery_odd SET  play_code='lhc_three_in_two' WHERE bet_code = 'lhc_three_in_two' and bet_num='中2';
UPDATE lottery_odd SET  play_code='lhc_three_in_two' WHERE bet_code = 'lhc_three_in_two' and bet_num='中3';
UPDATE lottery_odd SET  play_code='lhc_two_all_in' WHERE bet_code = 'lhc_two_all_in' and bet_num='2';
UPDATE lottery_odd SET  play_code='lhc_two_in_special' WHERE bet_code = 'lhc_two_in_special' and bet_num='中2';
UPDATE lottery_odd SET  play_code='lhc_two_in_special' WHERE bet_code = 'lhc_two_in_special' and bet_num='中特';



UPDATE lottery_odd SET  play_code='lhc_special_strand' WHERE bet_code = 'lhc_special_strand' and bet_num='2';
UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_eight_zodiac' and bet_num='8';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_eleven_zodiac' and bet_num='11';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_five_zodiac' and bet_num='5';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_four_zodiac' and bet_num='4';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_nine_zodiac' and bet_num='9';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_seven_zodiac' and bet_num='7';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_six_zodiac' and bet_num='6';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_ten_zodiac' and bet_num='10';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_three_zodiac' and bet_num='3';

UPDATE lottery_odd SET  play_code='lhc_sum_zodiac' WHERE bet_code = 'lhc_two_zodiac' and bet_num='2';











UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='鼠';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='牛';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='虎';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='兔';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='龙';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='蛇';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='马';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='羊';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='猴';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='鸡';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='狗';
UPDATE lottery_odd SET  play_code='lhc_two_zodiac_link' WHERE bet_code = 'lhc_two_zodiac_link' and bet_num='猪';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='鼠';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='牛';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='虎';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='兔';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='龙';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='蛇';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='马';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='羊';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='猴';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='鸡';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='狗';
UPDATE lottery_odd SET  play_code='lhc_three_zodiac_link' WHERE bet_code = 'lhc_three_zodiac_link' and bet_num='猪';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='鼠';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='牛';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='虎';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='兔';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='龙';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='蛇';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='马';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='羊';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='猴';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='鸡';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='狗';
UPDATE lottery_odd SET  play_code='lhc_four_zodiac_link' WHERE bet_code = 'lhc_four_zodiac_link' and bet_num='猪';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='鼠';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='牛';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='虎';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='兔';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='龙';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='蛇';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='马';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='羊';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='猴';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='鸡';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='狗';
UPDATE lottery_odd SET  play_code='lhc_five_zodiac_link' WHERE bet_code = 'lhc_five_zodiac_link' and bet_num='猪';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='0';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='1';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='2';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='3';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='4';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='5';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='6';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='7';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='8';
UPDATE lottery_odd SET  play_code='lhc_two_mantissa_link' WHERE bet_code = 'lhc_two_mantissa_link' and bet_num='9';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='0';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='1';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='2';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='3';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='4';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='5';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='6';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='7';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='8';
UPDATE lottery_odd SET  play_code='lhc_three_mantissa_link' WHERE bet_code = 'lhc_three_mantissa_link' and bet_num='9';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='0';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='1';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='2';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='3';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='4';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='5';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='6';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='7';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='8';
UPDATE lottery_odd SET  play_code='lhc_four_mantissa_link' WHERE bet_code = 'lhc_four_mantissa_link' and bet_num='9';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='0';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='1';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='2';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='3';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='4';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='5';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='6';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='7';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='8';
UPDATE lottery_odd SET  play_code='lhc_five_mantissa_link' WHERE bet_code = 'lhc_five_mantissa_link' and bet_num='9';




UPDATE lottery_odd SET  play_code='lhc_five_no_in' WHERE bet_code = 'lhc_five_no_in' and bet_num='5';
UPDATE lottery_odd SET  play_code='lhc_six_no_in' WHERE bet_code = 'lhc_six_no_in' and bet_num='6';
UPDATE lottery_odd SET  play_code='lhc_seven_no_in' WHERE bet_code = 'lhc_seven_no_in' and bet_num='7';
UPDATE lottery_odd SET  play_code='lhc_eight_no_in' WHERE bet_code = 'lhc_eight_no_in' and bet_num='8';
UPDATE lottery_odd SET  play_code='lhc_nine_no_in' WHERE bet_code = 'lhc_nine_no_in' and bet_num='9';
UPDATE lottery_odd SET  play_code='lhc_ten_no_in' WHERE bet_code = 'lhc_ten_no_in' and bet_num='10';
UPDATE lottery_odd SET  play_code='lhc_eleven_no_in' WHERE bet_code = 'lhc_eleven_no_in' and bet_num='11';
UPDATE lottery_odd SET  play_code='lhc_twelve_no_in' WHERE bet_code = 'lhc_twelve_no_in' and bet_num='12';

UPDATE lottery_odd SET  play_code='points_big_small' WHERE bet_code = 'points' and bet_num='大';
UPDATE lottery_odd SET  play_code='points_big_small' WHERE bet_code = 'points' and bet_num='小';
UPDATE lottery_odd SET  play_code='points_single_double' WHERE bet_code = 'points' and bet_num='单';
UPDATE lottery_odd SET  play_code='points_single_double' WHERE bet_code = 'points' and bet_num='双';
UPDATE lottery_odd SET  play_code='points_417' WHERE bet_code = 'points' and bet_num='4';
UPDATE lottery_odd SET  play_code='points_417' WHERE bet_code = 'points' and bet_num='17';
UPDATE lottery_odd SET  play_code='points_516' WHERE bet_code = 'points' and bet_num='5';
UPDATE lottery_odd SET  play_code='points_516' WHERE bet_code = 'points' and bet_num='16';
UPDATE lottery_odd SET  play_code='points_615' WHERE bet_code = 'points' and bet_num='6';
UPDATE lottery_odd SET  play_code='points_615' WHERE bet_code = 'points' and bet_num='15';
UPDATE lottery_odd SET  play_code='points_714' WHERE bet_code = 'points' and bet_num='7';
UPDATE lottery_odd SET  play_code='points_714' WHERE bet_code = 'points' and bet_num='14';
UPDATE lottery_odd SET  play_code='points_813' WHERE bet_code = 'points' and bet_num='8';
UPDATE lottery_odd SET  play_code='points_813' WHERE bet_code = 'points' and bet_num='13';
UPDATE lottery_odd SET  play_code='points_912' WHERE bet_code = 'points' and bet_num='9';
UPDATE lottery_odd SET  play_code='points_912' WHERE bet_code = 'points' and bet_num='12';
UPDATE lottery_odd SET  play_code='points_1011' WHERE bet_code = 'points' and bet_num='10';
UPDATE lottery_odd SET  play_code='points_1011' WHERE bet_code = 'points' and bet_num='11';








UPDATE lottery_odd SET  play_code='armed_forces' WHERE bet_code = 'armed_forces' and bet_num='1';
UPDATE lottery_odd SET  play_code='armed_forces' WHERE bet_code = 'armed_forces' and bet_num='2';
UPDATE lottery_odd SET  play_code='armed_forces' WHERE bet_code = 'armed_forces' and bet_num='3';
UPDATE lottery_odd SET  play_code='armed_forces' WHERE bet_code = 'armed_forces' and bet_num='4';
UPDATE lottery_odd SET  play_code='armed_forces' WHERE bet_code = 'armed_forces' and bet_num='5';
UPDATE lottery_odd SET  play_code='armed_forces' WHERE bet_code = 'armed_forces' and bet_num='6';

UPDATE lottery_odd SET  play_code='dice' WHERE bet_code = 'dice_full_dice' and bet_num='111';
UPDATE lottery_odd SET  play_code='dice' WHERE bet_code = 'dice_full_dice' and bet_num='222';
UPDATE lottery_odd SET  play_code='dice' WHERE bet_code = 'dice_full_dice' and bet_num='333';
UPDATE lottery_odd SET  play_code='dice' WHERE bet_code = 'dice_full_dice' and bet_num='444';
UPDATE lottery_odd SET  play_code='dice' WHERE bet_code = 'dice_full_dice' and bet_num='555';
UPDATE lottery_odd SET  play_code='dice' WHERE bet_code = 'dice_full_dice' and bet_num='666';

UPDATE lottery_odd SET  play_code='full_dice' WHERE bet_code = 'dice_full_dice' and bet_num='全骰';

UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='12';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='13';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='14';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='15';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='16';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='23';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='24';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='25';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='26';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='34';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='35';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='36';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='45';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='46';
UPDATE lottery_odd SET  play_code='long_card' WHERE bet_code = 'long_card' and bet_num='56';

UPDATE lottery_odd SET  play_code='short_card' WHERE bet_code = 'short_card' and bet_num='11';
UPDATE lottery_odd SET  play_code='short_card' WHERE bet_code = 'short_card' and bet_num='22';
UPDATE lottery_odd SET  play_code='short_card' WHERE bet_code = 'short_card' and bet_num='33';
UPDATE lottery_odd SET  play_code='short_card' WHERE bet_code = 'short_card' and bet_num='44';
UPDATE lottery_odd SET  play_code='short_card' WHERE bet_code = 'short_card' and bet_num='55';
UPDATE lottery_odd SET  play_code='short_card' WHERE bet_code = 'short_card' and bet_num='66';





UPDATE lottery_odd SET  play_code='k3_same_num' WHERE bet_code = 'k3_danxuan_ertong' and bet_num='单选';
UPDATE lottery_odd SET  play_code='k3_same_num' WHERE bet_code = 'k3_danxuan_santong' and bet_num='单选';
UPDATE lottery_odd SET  play_code='k3_same_num' WHERE bet_code = 'k3_fuxuan_ertong' and bet_num='复选';
UPDATE lottery_odd SET  play_code='k3_same_num' WHERE bet_code = 'k3_tongxuan_santong' and bet_num='通选';
UPDATE lottery_odd SET  play_code='k3_diff_num' WHERE bet_code = 'k3_erbutong' and bet_num='二不同';
UPDATE lottery_odd SET  play_code='k3_diff_num' WHERE bet_code = 'k3_sanbutong' and bet_num='三不同';
UPDATE lottery_odd SET  play_code='k3_three_straight' WHERE bet_code = 'k3_tongxuan_sanlian' and bet_num='通选';

UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_eighth' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fifth' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_first' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_fourth' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_second' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_seventh' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_sixth' and bet_num='20';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='00';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='01';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='02';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='03';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='04';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='05';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='06';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='07';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='08';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='09';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='10';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='11';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='12';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='13';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='14';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='15';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='16';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='17';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='18';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='19';
UPDATE lottery_odd SET  play_code='sfc_digital' WHERE bet_code = 'sfc_third' and bet_num='20';


UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_eighth' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_eighth' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_fifth' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_fifth' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_first' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_first' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_fourth' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_fourth' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_second' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_second' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_seventh' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_seventh' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_sixth' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_sixth' and bet_num='小';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_third' and bet_num='大';
UPDATE lottery_odd SET  play_code='sfc_big_small' WHERE bet_code = 'sfc_third' and bet_num='小';



UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_eighth' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_eighth' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_fifth' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_fifth' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_first' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_first' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_fourth' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_fourth' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_second' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_second' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_seventh' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_seventh' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_sixth' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_sixth' and bet_num='双';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_third' and bet_num='单';
UPDATE lottery_odd SET  play_code='sfc_single_double' WHERE bet_code = 'sfc_third' and bet_num='双';






UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_eighth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_eighth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_fifth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_fifth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_first' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_first' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_fourth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_fourth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_second' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_second' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_seventh' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_seventh' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_sixth' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_sixth' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_third' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='sfc_mantissa_big_small' WHERE bet_code = 'sfc_third' and bet_num='尾小';


UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_eighth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_eighth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_fifth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_fifth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_first' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_first' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_fourth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_fourth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_second' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_second' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_seventh' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_seventh' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_sixth' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_sixth' and bet_num='合双';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_third' and bet_num='合单';
UPDATE lottery_odd SET  play_code='sfc_sum_single_double' WHERE bet_code = 'sfc_third' and bet_num='合双';







































UPDATE lottery_odd SET  play_code='sfc_sum8_big_small' WHERE bet_code = 'sfc_sum8' and bet_num='总大';
UPDATE lottery_odd SET  play_code='sfc_sum8_big_small' WHERE bet_code = 'sfc_sum8' and bet_num='总小';
UPDATE lottery_odd SET  play_code='sfc_sum8_single_double' WHERE bet_code = 'sfc_sum8' and bet_num='总单';
UPDATE lottery_odd SET  play_code='sfc_sum8_single_double' WHERE bet_code = 'sfc_sum8' and bet_num='总双';
UPDATE lottery_odd SET  play_code='sfc_sum8_mantissa_big_small' WHERE bet_code = 'sfc_sum8' and bet_num='总尾大';
UPDATE lottery_odd SET  play_code='sfc_sum8_mantissa_big_small' WHERE bet_code = 'sfc_sum8' and bet_num='总尾小';



UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_12' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_13' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_14' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_15' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_16' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_17' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_18' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_23' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_24' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_25' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_26' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_27' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_28' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_34' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_35' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_36' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_37' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_38' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_45' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_46' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_47' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_48' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_56' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_57' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_58' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_67' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_68' and bet_num='龙';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_78' and bet_num='龙';

UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_12' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_13' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_14' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_15' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_16' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_17' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_18' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_23' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_24' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_25' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_26' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_27' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_28' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_34' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_35' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_36' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_37' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_38' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_45' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_46' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_47' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_48' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_56' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_57' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_58' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_67' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_68' and bet_num='虎';
UPDATE lottery_odd SET  play_code='sfc_dragon_tiger' WHERE bet_code = 'sfc_dragon_tiger_78' and bet_num='虎';






























UPDATE lottery_odd SET  play_code='keno_selection_one' WHERE bet_code = 'keno_selection' and bet_num='选一';
UPDATE lottery_odd SET  play_code='keno_selection_two' WHERE bet_code = 'keno_selection' and bet_num='选二';
UPDATE lottery_odd SET  play_code='keno_selection_three' WHERE bet_code = 'keno_selection' and bet_num='选三-中2';
UPDATE lottery_odd SET  play_code='keno_selection_three' WHERE bet_code = 'keno_selection' and bet_num='选三-中3';
UPDATE lottery_odd SET  play_code='keno_selection_four' WHERE bet_code = 'keno_selection' and bet_num='选四-中2';
UPDATE lottery_odd SET  play_code='keno_selection_four' WHERE bet_code = 'keno_selection' and bet_num='选四-中3';
UPDATE lottery_odd SET  play_code='keno_selection_four' WHERE bet_code = 'keno_selection' and bet_num='选四-中4';
UPDATE lottery_odd SET  play_code='keno_selection_five' WHERE bet_code = 'keno_selection' and bet_num='选五-中3';
UPDATE lottery_odd SET  play_code='keno_selection_five' WHERE bet_code = 'keno_selection' and bet_num='选五-中4';
UPDATE lottery_odd SET  play_code='keno_selection_five' WHERE bet_code = 'keno_selection' and bet_num='选五-中5';



UPDATE lottery_odd SET  play_code='keno_sum20_big_small' WHERE bet_code = 'keno_sum20' and bet_num='大';
UPDATE lottery_odd SET  play_code='keno_sum20_big_small' WHERE bet_code = 'keno_sum20' and bet_num='小';
UPDATE lottery_odd SET  play_code='keno_sum20_big_small' WHERE bet_code = 'keno_sum20' and bet_num='810';
UPDATE lottery_odd SET  play_code='keno_sum20_single_double' WHERE bet_code = 'keno_sum20' and bet_num='单';
UPDATE lottery_odd SET  play_code='keno_sum20_single_double' WHERE bet_code = 'keno_sum20' and bet_num='双';
UPDATE lottery_odd SET  play_code='keno_sum20_elements' WHERE bet_code = 'keno_sum20' and bet_num='金';
UPDATE lottery_odd SET  play_code='keno_sum20_elements' WHERE bet_code = 'keno_sum20' and bet_num='木';
UPDATE lottery_odd SET  play_code='keno_sum20_elements' WHERE bet_code = 'keno_sum20' and bet_num='水';
UPDATE lottery_odd SET  play_code='keno_sum20_elements' WHERE bet_code = 'keno_sum20' and bet_num='火';
UPDATE lottery_odd SET  play_code='keno_sum20_elements' WHERE bet_code = 'keno_sum20' and bet_num='土';
UPDATE lottery_odd SET  play_code='keno_up_down' WHERE bet_code = 'keno_number' and bet_num='上';
UPDATE lottery_odd SET  play_code='keno_up_down' WHERE bet_code = 'keno_number' and bet_num='中';
UPDATE lottery_odd SET  play_code='keno_up_down' WHERE bet_code = 'keno_number' and bet_num='下';
UPDATE lottery_odd SET  play_code='keno_odd_even' WHERE bet_code = 'keno_number' and bet_num='奇';
UPDATE lottery_odd SET  play_code='keno_odd_even' WHERE bet_code = 'keno_number' and bet_num='偶';
UPDATE lottery_odd SET  play_code='keno_odd_even' WHERE bet_code = 'keno_number' and bet_num='和';






UPDATE lottery_odd SET  play_code='xy28_sum3_big_small' WHERE bet_code = 'xy28_sum3' and bet_num='大';
UPDATE lottery_odd SET  play_code='xy28_sum3_big_small' WHERE bet_code = 'xy28_sum3' and bet_num='小';
UPDATE lottery_odd SET  play_code='xy28_sum3_single_double' WHERE bet_code = 'xy28_sum3' and bet_num='单';
UPDATE lottery_odd SET  play_code='xy28_sum3_single_double' WHERE bet_code = 'xy28_sum3' and bet_num='双';
UPDATE lottery_odd SET  play_code='xy28_sum3_half' WHERE bet_code = 'xy28_sum3' and bet_num='大单';
UPDATE lottery_odd SET  play_code='xy28_sum3_half' WHERE bet_code = 'xy28_sum3' and bet_num='小单';
UPDATE lottery_odd SET  play_code='xy28_sum3_half' WHERE bet_code = 'xy28_sum3' and bet_num='大双';
UPDATE lottery_odd SET  play_code='xy28_sum3_half' WHERE bet_code = 'xy28_sum3' and bet_num='小双';
UPDATE lottery_odd SET  play_code='xy28_sum3_extreme' WHERE bet_code = 'xy28_sum3' and bet_num='极大';
UPDATE lottery_odd SET  play_code='xy28_sum3_extreme' WHERE bet_code = 'xy28_sum3' and bet_num='极小';
UPDATE lottery_odd SET  play_code='xy28_sum3_colour' WHERE bet_code = 'xy28_sum3' and bet_num='红波';
UPDATE lottery_odd SET  play_code='xy28_sum3_colour' WHERE bet_code = 'xy28_sum3' and bet_num='绿波';
UPDATE lottery_odd SET  play_code='xy28_sum3_colour' WHERE bet_code = 'xy28_sum3' and bet_num='蓝波';
UPDATE lottery_odd SET  play_code='xy28_three_same' WHERE bet_code = 'xy28_sum3' and bet_num='豹子';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital_three' WHERE bet_code = 'xy28_sum3' and bet_num='特码包三';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='0';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='1';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='2';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='3';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='4';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='5';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='6';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='7';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='8';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='9';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='10';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='11';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='12';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='13';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='14';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='15';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='16';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='17';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='18';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='19';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='20';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='21';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='22';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='23';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='24';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='25';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='26';
UPDATE lottery_odd SET  play_code='xy28_sum3_digital' WHERE bet_code = 'xy28_sum3' and bet_num='27';








UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_hundred' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_one' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_one_digital' WHERE bet_code = 'pl3_ten' and bet_num='9';

UPDATE lottery_odd SET  play_code='pl3_one_big_small' WHERE bet_code = 'pl3_hundred' and bet_num='大';
UPDATE lottery_odd SET  play_code='pl3_one_big_small' WHERE bet_code = 'pl3_hundred' and bet_num='小';
UPDATE lottery_odd SET  play_code='pl3_one_single_double' WHERE bet_code = 'pl3_hundred' and bet_num='单';
UPDATE lottery_odd SET  play_code='pl3_one_single_double' WHERE bet_code = 'pl3_hundred' and bet_num='双';
UPDATE lottery_odd SET  play_code='pl3_one_prime_combined' WHERE bet_code = 'pl3_hundred' and bet_num='质';
UPDATE lottery_odd SET  play_code='pl3_one_prime_combined' WHERE bet_code = 'pl3_hundred' and bet_num='合';











UPDATE lottery_odd SET  play_code='pl3_two_digital' WHERE bet_code = 'pl3_hundred_one' and bet_num='中2';
UPDATE lottery_odd SET  play_code='pl3_two_digital' WHERE bet_code = 'pl3_hundred_ten' and bet_num='中2';
UPDATE lottery_odd SET  play_code='pl3_two_digital' WHERE bet_code = 'pl3_ten_one' and bet_num='中2';



UPDATE lottery_odd SET  play_code='pl3_three_digital' WHERE bet_code = 'pl3_hundred_ten_one' and bet_num='中3';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_one_combination' WHERE bet_code = 'pl3_all_three' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_two_combination' WHERE bet_code = 'pl3_two_different' and bet_num='二不同';
UPDATE lottery_odd SET  play_code='pl3_two_combination' WHERE bet_code = 'pl3_two_same' and bet_num='二同';
UPDATE lottery_odd SET  play_code='pl3_three_combination' WHERE bet_code = 'pl3_three_group3' and bet_num='组三';
UPDATE lottery_odd SET  play_code='pl3_three_combination' WHERE bet_code = 'pl3_three_group6' and bet_num='组六';
UPDATE lottery_odd SET  play_code='pl3_three_combination' WHERE bet_code = 'pl3_three_same' and bet_num='三同';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='10';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='11';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='12';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='13';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='14';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='15';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='16';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='17';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='18';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='10';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='11';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='12';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='13';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='14';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='15';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='16';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='17';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='18';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='10';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='11';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='12';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='13';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='14';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='15';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='16';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='17';
UPDATE lottery_odd SET  play_code='pl3_sum2_digital' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='18';

UPDATE lottery_odd SET  play_code='pl3_sum2_single_double' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='单';
UPDATE lottery_odd SET  play_code='pl3_sum2_single_double' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='双';
UPDATE lottery_odd SET  play_code='pl3_sum2_single_double' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='单';
UPDATE lottery_odd SET  play_code='pl3_sum2_single_double' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='双';
UPDATE lottery_odd SET  play_code='pl3_sum2_single_double' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='单';
UPDATE lottery_odd SET  play_code='pl3_sum2_single_double' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='双';

UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_big_small' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_big_small' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_big_small' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_big_small' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_big_small' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_big_small' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='尾小';

UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_prime_combined' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='尾质';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_prime_combined' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='尾合';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_prime_combined' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='尾质';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_prime_combined' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='尾合';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_prime_combined' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='尾质';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa_prime_combined' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='尾合';


UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='0尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='1尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='2尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='3尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='4尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='5尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='6尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='7尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='8尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_one_sum' and bet_num='9尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='0尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='1尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='2尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='3尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='4尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='5尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='6尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='7尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='8尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_hundred_ten_sum' and bet_num='9尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='0尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='1尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='2尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='3尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='4尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='5尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='6尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='7尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='8尾';
UPDATE lottery_odd SET  play_code='pl3_sum2_mantissa' WHERE bet_code = 'pl3_ten_one_sum' and bet_num='9尾';














UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='0尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='1尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='2尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='3尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='4尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='5尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='6尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='7尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='8尾';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='9尾';

UPDATE lottery_odd SET  play_code='pl3_sum3_big_small' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='大';
UPDATE lottery_odd SET  play_code='pl3_sum3_big_small' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='小';
UPDATE lottery_odd SET  play_code='pl3_sum3_single_double' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='单';
UPDATE lottery_odd SET  play_code='pl3_sum3_single_double' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='双';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa_big_small' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='尾大';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa_big_small' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='尾小';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa_prime_combined' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='尾质';
UPDATE lottery_odd SET  play_code='pl3_sum3_mantissa_prime_combined' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='尾合';

UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='10';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='11';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='12';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='13';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='14';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='15';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='16';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='17';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='18';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='19';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='20';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='21';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='22';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='23';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='24';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='25';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='26';
UPDATE lottery_odd SET  play_code='pl3_sum3_digital' WHERE bet_code = 'pl3_hundred_ten_one_sum' and bet_num='27';





UPDATE lottery_odd SET  play_code='pl3_group_three' WHERE bet_code = 'pl3_group3' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_group_three' WHERE bet_code = 'pl3_group3' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_group_three' WHERE bet_code = 'pl3_group3' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_group_three' WHERE bet_code = 'pl3_group3' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_group_three' WHERE bet_code = 'pl3_group3' and bet_num='9';
UPDATE lottery_odd SET  play_code='pl3_group_three' WHERE bet_code = 'pl3_group3' and bet_num='10';
UPDATE lottery_odd SET  play_code='pl3_group_six' WHERE bet_code = 'pl3_group6' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_group_six' WHERE bet_code = 'pl3_group6' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_group_six' WHERE bet_code = 'pl3_group6' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_group_six' WHERE bet_code = 'pl3_group6' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_group_six' WHERE bet_code = 'pl3_group6' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='0';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='1';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='2';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='3';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='4';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='5';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='6';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='7';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='8';
UPDATE lottery_odd SET  play_code='pl3_span' WHERE bet_code = 'pl3_span' and bet_num='9';



UPDATE lottery_odd SET  play_code='pl3_sanxing_zhixuan' WHERE bet_code = 'pl3_sanxing_zhixuan_ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zhixuan' WHERE bet_code = 'pl3_sanxing_zhixuan_fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zhixuan' WHERE bet_code = 'pl3_sanxing_zhixuan_hz' and bet_num='和值';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_hhzx' and bet_num='组三';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_hhzx' and bet_num='组六';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_z3ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_z3fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_z6ds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_z6fs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_zxhz' and bet_num='组三';
UPDATE lottery_odd SET  play_code='pl3_sanxing_zuxuan' WHERE bet_code = 'pl3_sanxing_zuxuan_zxhz' and bet_num='组六';






UPDATE lottery_odd SET  play_code='pl3_erxing_zhixuan' WHERE bet_code = 'pl3_erxing_zhixuan_heds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zhixuan' WHERE bet_code = 'pl3_erxing_zhixuan_hefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zhixuan' WHERE bet_code = 'pl3_erxing_zhixuan_qeds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zhixuan' WHERE bet_code = 'pl3_erxing_zhixuan_qefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zuxuan' WHERE bet_code = 'pl3_erxing_zuxuan_heds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zuxuan' WHERE bet_code = 'pl3_erxing_zuxuan_hefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zuxuan' WHERE bet_code = 'pl3_erxing_zuxuan_qeds' and bet_num='单式';
UPDATE lottery_odd SET  play_code='pl3_erxing_zuxuan' WHERE bet_code = 'pl3_erxing_zuxuan_qefs' and bet_num='复式';
UPDATE lottery_odd SET  play_code='pl3_yixing' WHERE bet_code = 'pl3_yixing_dwd' and bet_num='定位胆';
UPDATE lottery_odd SET  play_code='pl3_budingwei_sanxing' WHERE bet_code = 'pl3_budingwei_sxym' and bet_num='1';


UPDATE lottery_odd SET  play_code='champion_up_alone_11' WHERE bet_code = 'champion_up_sum' and bet_num='11';
UPDATE lottery_odd SET  play_code='champion_up_alone_34' WHERE bet_code = 'champion_up_sum' and bet_num='3';
UPDATE lottery_odd SET  play_code='champion_up_alone_34' WHERE bet_code = 'champion_up_sum' and bet_num='4';
UPDATE lottery_odd SET  play_code='champion_up_alone_34' WHERE bet_code = 'champion_up_sum' and bet_num='18';
UPDATE lottery_odd SET  play_code='champion_up_alone_34' WHERE bet_code = 'champion_up_sum' and bet_num='19';
UPDATE lottery_odd SET  play_code='champion_up_alone_56' WHERE bet_code = 'champion_up_sum' and bet_num='5';
UPDATE lottery_odd SET  play_code='champion_up_alone_56' WHERE bet_code = 'champion_up_sum' and bet_num='6';
UPDATE lottery_odd SET  play_code='champion_up_alone_56' WHERE bet_code = 'champion_up_sum' and bet_num='16';
UPDATE lottery_odd SET  play_code='champion_up_alone_56' WHERE bet_code = 'champion_up_sum' and bet_num='17';
UPDATE lottery_odd SET  play_code='champion_up_alone_78' WHERE bet_code = 'champion_up_sum' and bet_num='7';
UPDATE lottery_odd SET  play_code='champion_up_alone_78' WHERE bet_code = 'champion_up_sum' and bet_num='8';
UPDATE lottery_odd SET  play_code='champion_up_alone_78' WHERE bet_code = 'champion_up_sum' and bet_num='14';
UPDATE lottery_odd SET  play_code='champion_up_alone_78' WHERE bet_code = 'champion_up_sum' and bet_num='15';
UPDATE lottery_odd SET  play_code='champion_up_alone_910' WHERE bet_code = 'champion_up_sum' and bet_num='9';
UPDATE lottery_odd SET  play_code='champion_up_alone_910' WHERE bet_code = 'champion_up_sum' and bet_num='10';
UPDATE lottery_odd SET  play_code='champion_up_alone_910' WHERE bet_code = 'champion_up_sum' and bet_num='12';
UPDATE lottery_odd SET  play_code='champion_up_alone_910' WHERE bet_code = 'champion_up_sum' and bet_num='13';
UPDATE lottery_odd SET  play_code='champion_up_big_small' WHERE bet_code = 'champion_up_sum' and bet_num='和大';
UPDATE lottery_odd SET  play_code='champion_up_big_small' WHERE bet_code = 'champion_up_sum' and bet_num='和小';
UPDATE lottery_odd SET  play_code='champion_up_single_double' WHERE bet_code = 'champion_up_sum' and bet_num='和单';
UPDATE lottery_odd SET  play_code='champion_up_single_double' WHERE bet_code = 'champion_up_sum' and bet_num='和双';
UPDATE lottery_odd SET  play_code='champion_up_half' WHERE bet_code = 'champion_up_sum' and bet_num='大单';
UPDATE lottery_odd SET  play_code='champion_up_half' WHERE bet_code = 'champion_up_sum' and bet_num='小单';
UPDATE lottery_odd SET  play_code='champion_up_half' WHERE bet_code = 'champion_up_sum' and bet_num='大双';
UPDATE lottery_odd SET  play_code='champion_up_half' WHERE bet_code = 'champion_up_sum' and bet_num='小双';


UPDATE lottery_odd SET  play_code='pk10_qy_zhixuan' WHERE bet_code = 'pk10_zhixuan_qyfs' and bet_num='复式';
