-- auto gen by cherry 2017-08-25 09:50:33
CREATE TABLE IF NOT EXISTS "lottery_lhc_zodiac" (
"id" SERIAL4  NOT NULL PRIMARY KEY,
"zodiac_name" varchar(32) ,
"zodiac_num" varchar(32),
"update_time" timestamp(6)
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_lhc_zodiac" IS '六合彩生肖表';

COMMENT ON COLUMN "lottery_lhc_zodiac"."id" IS '主键';

COMMENT ON COLUMN "lottery_lhc_zodiac"."zodiac_name" IS '生肖名称';

COMMENT ON COLUMN "lottery_lhc_zodiac"."zodiac_num" IS '生肖数字';

COMMENT ON COLUMN "lottery_lhc_zodiac"."update_time" IS '修改时间';

INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鸡', '1'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='1');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猴', '2'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='2');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '羊', '3'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='3');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '马', '4'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='4');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '蛇', '5'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='5');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '龙', '6'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='6');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '兔', '7'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='7');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '虎', '8'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='8');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '牛', '9'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='9');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鼠', '10'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='10');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猪', '11'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='11');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '狗', '12'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='12');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鸡', '13'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='13');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猴', '14'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='14');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '羊', '15'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='15');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '马', '16'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='16');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '蛇', '17'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='17');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '龙', '18'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='18');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '兔', '19'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='19');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '虎', '20'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='20');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '牛', '21'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='21');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鼠', '22'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='22');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猪', '23'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='23');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '狗', '24'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='24');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鸡', '25'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='25');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猴', '26'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='26');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '羊', '27'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='27');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '马', '28'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='28');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '蛇', '29'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='29');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '龙', '30'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='30');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '兔', '31'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='31');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '虎', '32'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='32');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '牛', '33'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='33');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鼠', '34'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='34');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猪', '35'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='35');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '狗', '36'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='36');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鸡', '37'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='37');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猴', '38'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='38');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '羊', '39'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='39');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '马', '40'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='40');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '蛇', '41'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='41');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '龙', '42'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='42');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '兔', '43'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='43');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '虎', '44'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='44');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '牛', '45'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='45');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鼠', '46'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='46');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '猪', '47'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='47');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '狗', '48'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='48');
INSERT INTO   lottery_lhc_zodiac  (zodiac_name ,  zodiac_num) 	select	 '鸡', '49'	WHERE	NOT EXISTS(SELECT zodiac_num FROM lottery_lhc_zodiac WHERE  zodiac_num='49');