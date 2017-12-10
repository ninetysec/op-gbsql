-- auto gen by george 2017-12-10 21:55:50
 update player_transaction set origin='PC' where origin='1' and transaction_type='withdrawals';
 update player_transaction set origin='MOBILE' where origin='2' and transaction_type='withdrawals';