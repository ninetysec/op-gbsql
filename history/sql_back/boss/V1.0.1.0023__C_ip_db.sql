-- auto gen by longer 2015-12-08 10:47:54

drop TABLE if EXISTS ip_db;
drop TABLE if EXISTS ip_db_amend;
CREATE TABLE ip_db (
  id SERIAL8 PRIMARY KEY NOT NULL ,
  ip_start BIGINT NOT NULL UNIQUE, -- ip段起
  ip_end BIGINT NOT NULL, -- ip段止
  addr_type CHARACTER VARYING(2) NOT NULL, -- IP类型: 1:ipv4 2:ipv6
  land CHARACTER VARYING(100) NOT NULL, -- 大洲
  country CHARACTER VARYING(2) NOT NULL, -- 国家代码(2位)
  stateprov CHARACTER VARYING(80) NOT NULL, -- 州|省
  city CHARACTER VARYING(80) NOT NULL, -- 城市
  code CHARACTER VARYING(6) NOT NULL, -- 邮编
  latitude DOUBLE PRECISION NOT NULL, -- 纬度
  longitude DOUBLE PRECISION NOT NULL, -- 经度
  timezone_offset DOUBLE PRECISION NOT NULL, -- 时区偏移
  timezone_name CHARACTER VARYING(64) NOT NULL, -- 时区类型
  isp_name CHARACTER VARYING(128) NOT NULL, -- isp名称
  connection_type CHARACTER VARYING(20), -- 连接类型:dialup','isdn','cable','dsl','fttx','wireless
  organization_name CHARACTER VARYING(128) NOT NULL, -- 组织名称
  create_time TIMESTAMP WITHOUT TIME ZONE, -- 创建时间
  update_time TIMESTAMP WITHOUT TIME ZONE -- 更新时间
);
COMMENT ON TABLE ip_db IS 'IP数据库--Longer';
COMMENT ON COLUMN ip_db.id IS '主键';
COMMENT ON COLUMN ip_db.ip_start IS 'ip段起';
COMMENT ON COLUMN ip_db.ip_end IS 'ip段止';
COMMENT ON COLUMN ip_db.addr_type IS 'IP类型: 1:ipv4 2:ipv6';
COMMENT ON COLUMN ip_db.land IS '大洲';
COMMENT ON COLUMN ip_db.country IS '国家代码(2位)';
COMMENT ON COLUMN ip_db.stateprov IS '州|省';
COMMENT ON COLUMN ip_db.city IS '城市';
COMMENT ON COLUMN ip_db.code IS '邮编';
COMMENT ON COLUMN ip_db.latitude IS '纬度';
COMMENT ON COLUMN ip_db.longitude IS '经度';
COMMENT ON COLUMN ip_db.timezone_offset IS '时区偏移';
COMMENT ON COLUMN ip_db.timezone_name IS '时区类型';
COMMENT ON COLUMN ip_db.isp_name IS 'isp名称';
COMMENT ON COLUMN ip_db.connection_type IS '连接类型:dialup'',''isdn'',''cable'',''dsl'',''fttx'',''wireless';
COMMENT ON COLUMN ip_db.organization_name IS '组织名称';
COMMENT ON COLUMN ip_db.create_time IS '创建时间';
COMMENT ON COLUMN ip_db.update_time IS '更新时间';


CREATE TABLE ip_db_amend (
  id SERIAL8 PRIMARY KEY NOT NULL ,
  ip BIGINT UNIQUE NOT NULL, -- ip
  addr_type CHARACTER VARYING(2) NOT NULL, -- IP类型: 1:ipv4 2:ipv6
  land CHARACTER VARYING(100) NOT NULL, -- 大洲
  country CHARACTER VARYING(2) NOT NULL, -- 国家代码(2位)
  stateprov CHARACTER VARYING(80) NOT NULL, -- 州|省
  city CHARACTER VARYING(80) NOT NULL, -- 城市
  code CHARACTER VARYING(6) NOT NULL, -- 邮编
  latitude DOUBLE PRECISION NOT NULL, -- 纬度
  longitude DOUBLE PRECISION NOT NULL, -- 经度
  timezone_offset DOUBLE PRECISION NOT NULL, -- 时区偏移
  timezone_name CHARACTER VARYING(64) NOT NULL, -- 时区类型
  isp_name CHARACTER VARYING(128) NOT NULL, -- isp名称
  connection_type CHARACTER VARYING(20), -- 连接类型:dialup','isdn','cable','dsl','fttx','wireless
  organization_name CHARACTER VARYING(128) NOT NULL, -- 组织名称
  site_id INTEGER, -- 站点ID
  create_user INTEGER,
  create_time TIMESTAMP WITHOUT TIME ZONE, -- 创建时间
  update_user INTEGER,
  update_time TIMESTAMP WITHOUT TIME ZONE -- 更新时间
);
COMMENT ON TABLE ip_db_amend IS 'IP数据库-修正库--Longer';
COMMENT ON COLUMN ip_db_amend.id IS '主键';
COMMENT ON COLUMN ip_db_amend.ip IS 'ip';
COMMENT ON COLUMN ip_db_amend.addr_type IS 'IP类型: 1:ipv4 2:ipv6';
COMMENT ON COLUMN ip_db_amend.land IS '大洲';
COMMENT ON COLUMN ip_db_amend.country IS '国家代码(2位)';
COMMENT ON COLUMN ip_db_amend.stateprov IS '州|省';
COMMENT ON COLUMN ip_db_amend.city IS '城市';
COMMENT ON COLUMN ip_db_amend.code IS '邮编';
COMMENT ON COLUMN ip_db_amend.latitude IS '纬度';
COMMENT ON COLUMN ip_db_amend.longitude IS '经度';
COMMENT ON COLUMN ip_db_amend.timezone_offset IS '时区偏移';
COMMENT ON COLUMN ip_db_amend.timezone_name IS '时区类型';
COMMENT ON COLUMN ip_db_amend.isp_name IS 'isp名称';
COMMENT ON COLUMN ip_db_amend.connection_type IS '连接类型:dialup'',''isdn'',''cable'',''dsl'',''fttx'',''wireless';
COMMENT ON COLUMN ip_db_amend.organization_name IS '组织名称';
COMMENT ON COLUMN ip_db_amend.site_id IS '站点ID';
COMMENT ON COLUMN ip_db_amend.create_user IS '创建用户';
COMMENT ON COLUMN ip_db_amend.create_time IS '创建时间';
COMMENT ON COLUMN ip_db_amend.update_user IS '更新用户';
COMMENT ON COLUMN ip_db_amend.update_time IS '更新时间';