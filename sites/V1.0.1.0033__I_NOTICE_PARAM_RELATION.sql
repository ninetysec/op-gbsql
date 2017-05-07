-- auto gen by tom 2016-03-03 15:17:33
INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${user}','common',1 where '${user}' not in (select param_code from notice_param_relation where param_code='${user}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${sitename}','common',2 where '${sitename}' not in (select param_code from notice_param_relation where param_code='${sitename}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${website}','common',3 where '${website}' not in (select param_code from notice_param_relation where param_code='${website}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${customer}','common',4 where '${customer}' not in (select param_code from notice_param_relation where param_code='${customer}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${year}','common',5 where '${year}' not in (select param_code from notice_param_relation where param_code='${year}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${month}','common',6 where '${month}' not in (select param_code from notice_param_relation where param_code='${month}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${day}','common',7 where '${day}' not in (select param_code from notice_param_relation where param_code='${day}' and event_type='common');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${unfreezetime}','BALANCE_FREEZON',8 where '${unfreezetime}' not in (select param_code from notice_param_relation where param_code='${unfreezetime}' and event_type='BALANCE_FREEZON');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${unfreezetime}','PLAYER_ACCOUNT_FREEZON',9 where '${unfreezetime}' not in (select param_code from notice_param_relation where param_code='${unfreezetime}' and event_type='PLAYER_ACCOUNT_FREEZON');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${unfreezetime}','ACENTER_ACCOUNT_FREEZON',10 where '${unfreezetime}' not in (select param_code from notice_param_relation where param_code='${unfreezetime}' and event_type='ACENTER_ACCOUNT_FREEZON');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${unfreezetime}','TCENTER_ACCOUNT_FREEZON',11 where '${unfreezetime}' not in (select param_code from notice_param_relation where param_code='${unfreezetime}' and event_type='TCENTER_ACCOUNT_FREEZON');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${operatetime}','PLAYER_ACCOUNT_STOP',12 where '${operatetime}' not in (select param_code from notice_param_relation where param_code='${operatetime}' and event_type='PLAYER_ACCOUNT_STOP');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${operatetime}','ACENTER_ACCOUNT_STOP',13 where '${operatetime}' not in (select param_code from notice_param_relation where param_code='${operatetime}' and event_type='ACENTER_ACCOUNT_STOP');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${operatetime}','TCENTER_ACCOUNT_STOP',14 where '${operatetime}' not in (select param_code from notice_param_relation where param_code='${operatetime}' and event_type='TCENTER_ACCOUNT_STOP');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderlaunchtime}','DEPOSIT_AUDIT_FAIL',15 where '${orderlaunchtime}' not in (select param_code from notice_param_relation where param_code='${orderlaunchtime}' and event_type='DEPOSIT_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderlaunchtime}','PLAYER_WITHDRAWAL_AUDIT_FAIL',16 where '${orderlaunchtime}' not in (select param_code from notice_param_relation where param_code='${orderlaunchtime}' and event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderlaunchtime}','AGENT_WITHDRAWAL_AUDIT_FAIL',17 where '${orderlaunchtime}' not in (select param_code from notice_param_relation where param_code='${orderlaunchtime}' and event_type='AGENT_WITHDRAWAL_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderlaunchtime}','REFUSE_PLAYER_WITHDRAWAL',18 where '${orderlaunchtime}' not in (select param_code from notice_param_relation where param_code='${orderlaunchtime}' and event_type='REFUSE_PLAYER_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderlaunchtime}','REFUSE_AGENT_WITHDRAWAL',19 where '${orderlaunchtime}' not in (select param_code from notice_param_relation where param_code='${orderlaunchtime}' and event_type='REFUSE_AGENT_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderlaunchtime}','MANUAL_WITHDRAWAL',20 where '${orderlaunchtime}' not in (select param_code from notice_param_relation where param_code='${orderlaunchtime}' and event_type='MANUAL_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderamount}','DEPOSIT_AUDIT_FAIL',21 where '${orderamount}' not in (select param_code from notice_param_relation where param_code='${orderamount}' and event_type='DEPOSIT_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderamount}','PLAYER_WITHDRAWAL_AUDIT_FAIL',22 where '${orderamount}' not in (select param_code from notice_param_relation where param_code='${orderamount}' and event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderamount}','AGENT_WITHDRAWAL_AUDIT_FAIL',23 where '${orderamount}' not in (select param_code from notice_param_relation where param_code='${orderamount}' and event_type='AGENT_WITHDRAWAL_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderamount}','REFUSE_PLAYER_WITHDRAWAL',24 where '${orderamount}' not in (select param_code from notice_param_relation where param_code='${orderamount}' and event_type='REFUSE_PLAYER_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderamount}','REFUSE_AGENT_WITHDRAWAL',25 where '${orderamount}' not in (select param_code from notice_param_relation where param_code='${orderamount}' and event_type='REFUSE_AGENT_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${orderamount}','MANUAL_WITHDRAWAL',26 where '${orderamount}' not in (select param_code from notice_param_relation where param_code='${orderamount}' and event_type='MANUAL_WITHDRAWAL');


INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${ordernum}','DEPOSIT_AUDIT_FAIL',27 where '${ordernum}' not in (select param_code from notice_param_relation where param_code='${ordernum}' and event_type='DEPOSIT_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${ordernum}','PLAYER_WITHDRAWAL_AUDIT_FAIL',28 where '${ordernum}' not in (select param_code from notice_param_relation where param_code='${ordernum}' and event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${ordernum}','AGENT_WITHDRAWAL_AUDIT_FAIL',29 where '${ordernum}' not in (select param_code from notice_param_relation where param_code='${ordernum}' and event_type='AGENT_WITHDRAWAL_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${ordernum}','REFUSE_PLAYER_WITHDRAWAL',30 where '${ordernum}' not in (select param_code from notice_param_relation where param_code='${ordernum}' and event_type='REFUSE_PLAYER_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${ordernum}','REFUSE_AGENT_WITHDRAWAL',31 where '${ordernum}' not in (select param_code from notice_param_relation where param_code='${ordernum}' and event_type='REFUSE_AGENT_WITHDRAWAL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${saleapplytime}','SALE_AUDIT_FAIL',32 where '${saleapplytime}' not in (select param_code from notice_param_relation where param_code='${saleapplytime}' and event_type='SALE_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${saleactivityname}','SALE_AUDIT_FAIL',33 where '${saleactivityname}' not in (select param_code from notice_param_relation where param_code='${saleactivityname}' and event_type='SALE_AUDIT_FAIL');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${period}','REFUSE_RETURN_RABBET',34 where '${period}' not in (select param_code from notice_param_relation where param_code='${period}' and event_type='REFUSE_RETURN_RABBET');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${perioddetail}','REFUSE_RETURN_RABBET',35 where '${perioddetail}' not in (select param_code from notice_param_relation where param_code='${perioddetail}' and event_type='REFUSE_RETURN_RABBET');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${period}','REFUSE_RETURN_COMMISSION',34 where '${period}' not in (select param_code from notice_param_relation where param_code='${period}' and event_type='REFUSE_RETURN_COMMISSION');

INSERT INTO notice_param_relation  ("param_code","event_type","order")
select '${perioddetail}','REFUSE_RETURN_COMMISSION',35 where '${perioddetail}' not in (select param_code from notice_param_relation where param_code='${perioddetail}' and event_type='REFUSE_RETURN_COMMISSION');