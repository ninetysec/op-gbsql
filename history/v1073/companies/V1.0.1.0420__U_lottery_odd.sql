-- auto gen by cherry 2017-09-07 21:33:08
UPDATE lottery_odd set odd = 2.1,odd_limit=2.2
where(code='xyft' and bet_code='champion_up_sum' and bet_num in('和双','和大'));

UPDATE site_lottery_odd set odd = 2.1,odd_limit=2.2
where(code='xyft' and bet_code='champion_up_sum' and bet_num in('和双','和大'));

UPDATE lottery_odd set odd = 1.78,odd_limit=1.78
where(code='xyft' and bet_code='champion_up_sum' and bet_num in('和单','和小'));

UPDATE site_lottery_odd set odd = 1.78,odd_limit=1.78
where(code='xyft' and bet_code='champion_up_sum' and bet_num in('和单','和小'));

update lottery_odd set odd_limit = 100
where code='hklhc' and bet_code='special' and bet_num in('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49');

update site_lottery_odd set odd_limit = 100
where code='hklhc' and bet_code='special' and bet_num in('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49');
