-- auto gen by cherry 2017-03-29 16:28:49
alter table agent_rebate alter column fee_amount TYPE NUMERIC(20,3);

alter table agent_rebate alter column fee_amount_history TYPE NUMERIC(20,3);