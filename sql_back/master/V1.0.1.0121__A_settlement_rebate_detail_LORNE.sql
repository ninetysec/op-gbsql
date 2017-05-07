-- auto gen by loong 2015-10-15 17:23:20
-- Table: settlement_rebate_detail

-- DROP TABLE settlement_rebate_detail;

CREATE TABLE IF NOT EXISTS settlement_rebate_detail
(
  id serial NOT NULL, -- 主键
  settlement_rebate_id integer, -- 返佣结算ID
  player_id integer, -- 玩家ID
  api_id integer, -- API表id
  game_type_parent character varying(32), -- 一级游戏分类:game.game_type_parent
  game_type character varying(32), -- 二级游戏类别:game.game_type
  rebate_total numeric(20,2), -- 返佣金额（未扣除分摊费用前的佣金）
  CONSTRAINT settlement_rebate_detail_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE settlement_rebate_detail
  OWNER TO postgres;
COMMENT ON TABLE settlement_rebate_detail
  IS '返佣明细表--lorne';
COMMENT ON COLUMN settlement_rebate_detail.id IS '主键';
COMMENT ON COLUMN settlement_rebate_detail.settlement_rebate_id IS '返佣结算ID';
COMMENT ON COLUMN settlement_rebate_detail.player_id IS '玩家ID';
COMMENT ON COLUMN settlement_rebate_detail.api_id IS 'API表id';
COMMENT ON COLUMN settlement_rebate_detail.game_type_parent IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN settlement_rebate_detail.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN settlement_rebate_detail.rebate_total IS '返佣金额（未扣除分摊费用前的佣金）';

