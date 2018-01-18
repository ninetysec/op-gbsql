-- auto gen by cherry 2018-01-16 19:52:53

update player_transaction set
fund_type=(SELECT recharge_type FROM player_recharge WHERE recharge_type_parent='online_deposit' and player_transaction.transaction_no=player_recharge.transaction_no),transaction_way=(SELECT recharge_type FROM player_recharge WHERE recharge_type_parent='online_deposit' and player_transaction.transaction_no=player_recharge.transaction_no)
WHERE fund_type='' and transaction_way='' and transaction_type='deposit'
AND transaction_no in(SELECT transaction_no FROM player_recharge WHERE recharge_type_parent='online_deposit');

