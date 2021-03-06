@author Longer
@date   150831
------------------------------------
数据库脚本存放位置,  每个文件夹对应一个数据库

脚本目的:
    >>与测试对接方便

脚本内容:
    >>所有对数据库的操作:创建(C)\删除(D)\修改结构(A)\更新记录(U)\插入(I) 表|视图|字段|注释|记录


-------------------------------------
工具目的:
    >>为了使开发人员在生成脚本文件时的版本号唯一

执行方法:
    >>使用idea terminal终端工具
        快捷键: alt+f12

    >>使用终端进入脚本目录:
        cd sql/boss

    >>执行命令
        ./genSqlFile.sh                 --->生成    V1.0.0.0001__.sql
            或
        ./genSqlFile.sh A_SYS_UESR    --->生成    V1.0.0.0002__A_SYS_USER.sql

    注:genSqlFile.sh命令行可以带一个参数,如上例中的"DDL_SYS_UESR"

-------------------------------------
脚本整理规范：
-- 说明：
  -- sql语句本身支持重复执行的(带有CREATE OR REPLACE/IF NOT EXISTS/IF EXISTS)，可以直接写；否则写法如下：
     /*
     select redo_sqls($$
        语句1;
        语句2;
      $$);
      */
      -- 支持将所有语句都写在上述函数参数中
      -- 每条语句必须以半角分号结尾，语句本身内容不要带有半角分号!

-- 一些常见的语句的写法如下，没在下面列出的请事先跟Kevice确认：

-- 创建表的语句, 创建表public.test, public可以不用写
/**
  CREATE TABLE IF NOT EXISTS public.test
    (
      id integer NOT NULL,
      name character varying(255) NOT NULL
    )
    WITH (
      OIDS=FALSE
    );
    ALTER TABLE test
      OWNER TO postgres;
*/

-- 删除表(慎用), 删除表test
-- DROP TABLE IF EXISTS test;

-- 修改表名
-- ALTER TABLE IF EXISTS test rename to test1;

-- 创建或更新视图，创建表test的视图
/*
  CREATE OR REPLACE VIEW vw_test AS SELECT test.id, test.name FROM test;
  ALTER TABLE vw_test OWNER TO postgres;
*/

-- 删除视图
-- DROP VIEW IF EXISTS vw_test;

-- 创建或更新函数,
/**
  CREATE OR REPLACE FUNCTION fn_test(param text)
    RETURNS void AS
  $BODY$
  begin

  end
  $BODY$
    LANGUAGE plpgsql VOLATILE
    COST 100;
  ALTER FUNCTION fn_test(text)
    OWNER TO postgres;
 */

-- 删除函数，
-- DROP FUNCTION IF EXISTS fn_test(param text);

-- 创建序列，
/**
  select redo_sqls($$
    CREATE SEQUENCE "seq_test"
       INCREMENT 1
       MINVALUE 1
       MAXVALUE 9223372036854775807
       START 10
       CACHE 10;
  $$);
 */

-- 删除序列
-- DROP SEQUENCE IF EXISTS seq_test;


-- 添加字段, 为test表添加字段name
/**
  select redo_sqls($$
    ALTER TABLE test ADD COLUMN name character varying(255);
  $$);
*/

-- 删除字段，删除name字段
-- ALTER TABLE test DROP COLUMN IF EXISTS name;

-- 增加索引，为表test的name列添加普通索引idx_test_name
/*
  select redo_sqls($$
    CREATE INDEX idx_test_name ON test USING btree (name COLLATE pg_catalog."default");
  $$);
 */

-- 删除索引，删除名称为"idx_test_name"的索引
-- DROP INDEX IF EXISTS idx_test_name;

-- 增加约束，为表test添加主键约束pk_test
/*
  select redo_sqls($$
    ALTER TABLE "public"."test" ADD CONSTRAINT "pk_test" PRIMARY KEY ("id");
  $$);
 */

-- 删除约束，删除主键约束pk_test，其他约束(惟一、外键等)的写法一样
-- ALTER TABLE test DROP CONSTRAINT IF EXISTS pk_test;


-- 添加或修改表注释
-- COMMENT ON TABLE public.test IS '测试表';

-- 添加或修改字段注释
-- COMMENT ON COLUMN test.name IS '姓名';


--  插入语句，插入一条id为2, name为kevice的记录
-- INSERT INTO test(id, name) SELECT 2, 'kevice' WHERE 2 NOT IN(SELECT id FROM test WHERE id=2);

-- 更新语句，更新id为2的记录的name字段为"KEVICE"
-- UPDATE test set name = 'KEVICE' WHERE id = 2;

-- 删除语句，删除id为2的记录
-- DELETE FROM test WHERE id = 2;
