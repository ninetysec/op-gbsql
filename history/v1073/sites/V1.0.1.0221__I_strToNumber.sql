-- auto gen by Alvin 2016-08-09 02:54:27
drop function if exists strToNumber(VARCHAR);
CREATE OR REPLACE FUNCTION strToNumber(account VARCHAR)
  RETURNS BIGINT AS $BODY$
DECLARE
	c int:=0;
  len int:=0;
  ac text;
  lop text:='';
BEGIN
  if account is null THEN
		return 0;
  end if;
	len=length(account);
  FOR i in 1..len
  LOOP
    if len>11 and (i=1 or (i>=8 and i<=11)) THEN
     CONTINUE;
    end if;
		ac=substr(account,i,1);
    lop=lop||((ascii(ac)-48)::text);
    --raise info '%,%',ac,((ascii(ac)-48)::text);
  END LOOP;
  --raise info '%',lop;
  if lop='' THEN
		lop='0';
   end if;
	return lop::BIGINT;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
