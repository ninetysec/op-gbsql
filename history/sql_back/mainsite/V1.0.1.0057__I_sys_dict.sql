-- auto gen by cheery 2015-11-02 10:50:20
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'company_deposit', '1', '资金类型:公司入款', NULL, 't'
  WHERE 'company_deposit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'online_deposit', '2', '资金类型:线上支付', NULL, 't'
  WHERE 'online_deposit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'artificial_deposit', '3', '资金类型:手动存款', NULL, 't'
  WHERE 'artificial_deposit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'artificial_withdraw', '4', '资金类型:手动取款', NULL, 't'
  WHERE 'artificial_withdraw' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'player_withdraw', '5', '资金类型:玩家取款', NULL, 't'
  WHERE 'player_withdraw' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'transfer_into', '6', '资金类型:转入', NULL, 't'
  WHERE 'transfer_into' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'transfer_out', '7', '资金类型:转出', NULL, 't'
  WHERE 'transfer_out' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'backwater', '8', '资金类型:返水', NULL, 't'
  WHERE 'backwater' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'rebate', '9', '资金类型:返佣', NULL, 't'
  WHERE 'rebate' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'recommend', '10', '资金类型:推荐', NULL, 't'
  WHERE 'recommend' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'fund_type');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'online', '1', '网银转账', NULL, 't'
  WHERE 'online' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT'common', 'transaction_way', 'atm_counter', '2', 'ATM自动柜员机', NULL, 't'
  WHERE 'atm_counter' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'counter', '3', '银行柜台', NULL, 't'
  WHERE 'counter' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'atm_money', '4', 'ATM现金入款', NULL, 't'
  WHERE 'atm_money' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'mobile_bank', '5', '手机银行', NULL, 't'
  WHERE 'mobile_bank' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'integrated_deposit', '6', '综合存款', NULL, 't'
  WHERE 'integrated_deposit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'artificial_favourable', '7', '存款优惠', NULL, 't'
  WHERE 'artificial_favourable' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'deposit_negative', '8', '负数余额归零', NULL, 't'
  WHERE 'deposit_negative' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'error_withdraw', '9', '取款误操作', NULL, 't'
  WHERE 'error_withdraw' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'deposit_other', '10', '其他存款', NULL, 't'
  WHERE 'deposit_other' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT  'common', 'transaction_way', 'single_reward', '11', '单次奖励', NULL, 't'
  WHERE 'single_reward' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'bonus_awards', '12', '红利奖励', NULL, 't'
  WHERE 'bonus_awards' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'first_deposit', '13', '首存送', NULL, 't'
  WHERE 'first_deposit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'regist_send', '14', '注册送', NULL, 't'
  WHERE 'regist_send' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'deposit_send', '15', '存就送', NULL, 't'
  WHERE 'deposit_send' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'relief_fund', '16', '救济金', NULL, 't'
  WHERE 'relief_fund' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'back_water', '17', '返水优惠', NULL, 't'
  WHERE 'back_water' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'profit_loss', '18', '盈亏返利', NULL, 't'
  WHERE 'profit_loss' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_way', 'effective_transaction', '19', '有效交易量', NULL, 't'
  WHERE 'effective_transaction' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_way');
