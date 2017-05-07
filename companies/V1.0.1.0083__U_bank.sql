-- auto gen by admin 2016-04-22 11:50:07
UPDATE bank SET is_use=FALSE WHERE  type='3' AND bank_name not in('ips_3','ips_7','baofoo','bbpay_old','reapal');