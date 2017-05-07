-- auto gen by cherry 2017-04-21 21:24:43
DELETE FROM lottery;

INSERT INTO "lottery" VALUES ('1', 'ssc', 'cqssc', 'normal', '1', '1');

INSERT INTO "lottery" VALUES ('2', 'pk10', 'bjpk10', 'normal', '2', '1');

INSERT INTO "lottery" VALUES ('4', 'lhc', 'hklhc', 'normal', '4', '1');

INSERT INTO "lottery" VALUES ('5', 'ssc', 'xjssc', 'normal', '5', '1');

INSERT INTO "lottery" VALUES ('6', 'ssc', 'tjssc', 'normal', '6', '1');

DELETE FROM lottery_betting;

INSERT INTO "lottery_betting" VALUES ('1', 'ssc', 'ten_thousand', '万位');

INSERT INTO "lottery_betting" VALUES ('2', 'ssc', 'thousand', '千位');

INSERT INTO "lottery_betting" VALUES ('3', 'ssc', 'hundreds', '百位');

INSERT INTO "lottery_betting" VALUES ('4', 'ssc', 'ten', '十位');

INSERT INTO "lottery_betting" VALUES ('5', 'ssc', 'one', '个位');

INSERT INTO "lottery_betting" VALUES ('6', 'ssc', 'one_all_five', '全五一字组合');

INSERT INTO "lottery_betting" VALUES ('7', 'ssc', 'one_first_three', '前三一字组合');

INSERT INTO "lottery_betting" VALUES ('8', 'ssc', 'one_in_three', '中三一字组合');

INSERT INTO "lottery_betting" VALUES ('9', 'ssc', 'one_after_three', '后三一字组合');

INSERT INTO "lottery_betting" VALUES ('10', 'ssc', 'five_sum', '总和');

INSERT INTO "lottery_betting" VALUES ('11', 'ssc', 'dragon_tiger_tie', '龙虎和');

INSERT INTO "lottery_betting" VALUES ('12', 'pk10', 'champion', '冠军');

INSERT INTO "lottery_betting" VALUES ('13', 'pk10', 'runner_up', '亚军');

INSERT INTO "lottery_betting" VALUES ('14', 'pk10', 'third_runner', '季军');

INSERT INTO "lottery_betting" VALUES ('15', 'pk10', 'fourth_place', '第四名');

INSERT INTO "lottery_betting" VALUES ('16', 'pk10', 'fifth_place', '第五名');

INSERT INTO "lottery_betting" VALUES ('17', 'pk10', 'sixth_place', '第六名');

INSERT INTO "lottery_betting" VALUES ('18', 'pk10', 'seventh_place', '第七名');

INSERT INTO "lottery_betting" VALUES ('19', 'pk10', 'eighth_place', '第八名');

INSERT INTO "lottery_betting" VALUES ('20', 'pk10', 'ninth_place', '第九名');

INSERT INTO "lottery_betting" VALUES ('21', 'pk10', 'tenth_place', '第十名');

INSERT INTO "lottery_betting" VALUES ('22', 'pk10', 'champion_up_sum', '冠亚军和');

INSERT INTO "lottery_betting" VALUES ('23', 'lhc', 'special', '特码');

INSERT INTO "lottery_betting" VALUES ('24', 'lhc', 'seven_sum', '总和');

INSERT INTO "lottery_betting" VALUES ('25', 'lhc', 'positive', '正码');

INSERT INTO "lottery_betting" VALUES ('26', 'lhc', 'positive_first', '正码一');

INSERT INTO "lottery_betting" VALUES ('27', 'lhc', 'positive_second', '正码二');

INSERT INTO "lottery_betting" VALUES ('28', 'lhc', 'positive_third', '正码三');

INSERT INTO "lottery_betting" VALUES ('29', 'lhc', 'positive_fourth', '正码四');

INSERT INTO "lottery_betting" VALUES ('30', 'lhc', 'positive_fifth', '正码五');

INSERT INTO "lottery_betting" VALUES ('31', 'lhc', 'positive_sixth', '正码六');

INSERT INTO "lottery_betting" VALUES ('32', 'cqssc', 'two_digital', '二字定位');

INSERT INTO "lottery_betting" VALUES ('33', 'cqssc', 'three_digital', '三字定位');

DELETE FROM lottery_play;
INSERT INTO "lottery_play" VALUES ('1', 'ssc', 'one_digital', '一字定位');

INSERT INTO "lottery_play" VALUES ('2', 'ssc', 'one_big_small', '一字大小');

INSERT INTO "lottery_play" VALUES ('3', 'ssc', 'one_single_double', '一字单双');

INSERT INTO "lottery_play" VALUES ('4', 'ssc', 'one_prime_combined', '一字质合');

INSERT INTO "lottery_play" VALUES ('5', 'ssc', 'one_combination', '一字组合');

INSERT INTO "lottery_play" VALUES ('6', 'ssc', 'two_digital', '二字定位');

INSERT INTO "lottery_play" VALUES ('7', 'ssc', 'two_combination', '二字组合');

INSERT INTO "lottery_play" VALUES ('8', 'ssc', 'two_sum_single_double', '二字和数单双');

INSERT INTO "lottery_play" VALUES ('9', 'ssc', 'three_digital', '三字定位');

INSERT INTO "lottery_play" VALUES ('10', 'ssc', 'five_sum_big_small', '五字和数大小');

INSERT INTO "lottery_play" VALUES ('11', 'ssc', 'five_sum_single_double', '五字和数单双');

INSERT INTO "lottery_play" VALUES ('12', 'ssc', 'dragon_tiger_tie', '龙虎和');

INSERT INTO "lottery_play" VALUES ('13', 'ssc', 'group_three', '组选三');

INSERT INTO "lottery_play" VALUES ('14', 'ssc', 'group_six', '组选六');

INSERT INTO "lottery_play" VALUES ('15', 'pk10', 'pk10_digital', '定位');

INSERT INTO "lottery_play" VALUES ('16', 'pk10', 'pk10_big_small', '大小');

INSERT INTO "lottery_play" VALUES ('17', 'pk10', 'pk10_single_double', '单双');

INSERT INTO "lottery_play" VALUES ('18', 'pk10', 'pk10_dragon_tiger', '龙虎');

INSERT INTO "lottery_play" VALUES ('19', 'pk10', 'champion_up_34', '冠亚军和[3,4,18,19]');

INSERT INTO "lottery_play" VALUES ('20', 'pk10', 'champion_up_56', '冠亚军和[5,6,16,17]');

INSERT INTO "lottery_play" VALUES ('21', 'pk10', 'champion_up_78', '冠亚军和[7,8,14,15]');

INSERT INTO "lottery_play" VALUES ('22', 'pk10', 'champion_up_910', '冠亚军和[9,10,12,13]');

INSERT INTO "lottery_play" VALUES ('23', 'pk10', 'champion_up_alone_11', '独立冠亚军和[11]');

INSERT INTO "lottery_play" VALUES ('24', 'pk10', 'champion_up_alone_34', '独立冠亚军和[3,4,18,19]');

INSERT INTO "lottery_play" VALUES ('25', 'pk10', 'champion_up_alone_56', '独立冠亚军和[5,6,16,17]');

INSERT INTO "lottery_play" VALUES ('26', 'pk10', 'champion_up_alone_78', '独立冠亚军和[7,8,14,15]');

INSERT INTO "lottery_play" VALUES ('27', 'pk10', 'champion_up_alone_910', '独立冠亚军和[9,10,12,13]');

INSERT INTO "lottery_play" VALUES ('28', 'pk10', 'champion_up_big_small', '冠亚军和大小');

INSERT INTO "lottery_play" VALUES ('29', 'pk10', 'champion_up_single_double', '冠亚军和单双');

INSERT INTO "lottery_play" VALUES ('30', 'lhc', 'special_digital', '特码');

INSERT INTO "lottery_play" VALUES ('31', 'lhc', 'special_big_small', '特码大小');

INSERT INTO "lottery_play" VALUES ('32', 'lhc', 'special_single_double', '特码单双');

INSERT INTO "lottery_play" VALUES ('33', 'lhc', 'special_half', '特码半特');

INSERT INTO "lottery_play" VALUES ('34', 'lhc', 'special_sum_big_small', '特码合数大小');

INSERT INTO "lottery_play" VALUES ('35', 'lhc', 'special_sum_single_double', '特码合数单双');

INSERT INTO "lottery_play" VALUES ('36', 'lhc', 'special_mantissa_big_small', '特码尾数大小');

INSERT INTO "lottery_play" VALUES ('37', 'lhc', 'special_mantissa', '特码尾数');

INSERT INTO "lottery_play" VALUES ('38', 'lhc', 'special_colour', '特码色波');

INSERT INTO "lottery_play" VALUES ('39', 'lhc', 'special_zodiac', '特肖');

INSERT INTO "lottery_play" VALUES ('40', 'lhc', 'seven_sum_big_small', '总和大小');

INSERT INTO "lottery_play" VALUES ('41', 'lhc', 'seven_sum_single_double', '总和单双');

INSERT INTO "lottery_play" VALUES ('42', 'lhc', 'positive_digital', '正码');

INSERT INTO "lottery_play" VALUES ('43', 'lhc', 'positive_special_digital', '正码特');

INSERT INTO "lottery_play" VALUES ('44', 'lhc', 'positive_big_small', '正码1-6大小');

INSERT INTO "lottery_play" VALUES ('45', 'lhc', 'positive_single_double', '正码1-6单双');

INSERT INTO "lottery_play" VALUES ('46', 'lhc', 'positive_colour', '正码1-6色波');

INSERT INTO "lottery_play" VALUES ('47', 'lhc', 'positive_sum_big_small', '正码1-6合数大小');

INSERT INTO "lottery_play" VALUES ('48', 'lhc', 'positive_sum_single_double', '正码1-6合数单双');

INSERT INTO "lottery_play" VALUES ('49', 'lhc', 'positive_mantissa_big_small', '正码1-6尾数大小');

delete from lottery_gather_conf;

INSERT INTO "lottery_gather_conf" VALUES ('4', 'kai', '168开彩网', 'cqssc', 'ssc', 'http://3rd.game.api.com/kai-ltapi/CQShiCai/getBaseCQShiCai.do?issue=20170413079&lotCode=10002', 'GET', 'JSON', 'JSON', '');
INSERT INTO "lottery_gather_conf" VALUES ('5', 'kai', '168开彩网', 'bjpk10', 'pk10', 'http://3rd.game.api.com/kai-ltapi/pks/getLotteryPksInfo.do?issue=613354&lotCode=10001', 'GET', 'JSON', 'JSON', NULL);
INSERT INTO "lottery_gather_conf" VALUES ('2', 'kai', '168开彩网', 'tjssc', 'ssc', 'http://3rd.game.api.com/kai-ltapi/CQShiCai/getBaseCQShiCai.do?issue=20170427006&lotCode=10003', 'GET', 'JSON', 'JSON', NULL);
INSERT INTO "lottery_gather_conf" VALUES ('7', 'kai', '168开彩网', 'xjssc', 'ssc', 'http://3rd.game.api.com/kai-ltapi/CQShiCai/getBaseCQShiCai.do?issue=&lotCode=10004', 'GET', 'JSON', 'JSON', '');

