# 数据库脚本整理规范
>@author Longer
>@date   150831

## 脚本目的
1. 实现数据库增量更新
2. 实现数据库更新有迹可循
2. 实现研发团队并行研发

## 脚本位置
每个数据库对应一个文件夹,列表如下:
1. boss
2. companies
3. sites
4. stat

## 脚本类别:
使用文件名前缀标识出脚本的类别,类别如下:
1. 创建(C)
2. 删除(D)
3. 修改结构(A)
4. 更新记录(U)
5. 插入(I)

## 脚本工具
### 工具目的
为了使开发人员在生成脚本文件时的版本号唯一,文件名格式如下:
V1.0.0.0002__A_SYS_USER.sql,其中
1. V1.0.0.0002  版本号
2. __           分隔符
3. A_SYS_USER   脚本说明
4. .sql         扩展名

## 使用方法:
1.使用idea terminal终端工具,快捷键: alt+f12

2.使用终端进入脚本目录:
```
  cd sql/boss
```
3.执行命令:
```
  ./genSqlFile.sh A_SYS_UESR
```

>其中: A_SYS_UESR 请自行填写

-------------------------------------
## 脚本整理规范：
1.默认可重复执行的SQL语句
```
 CREATE OR REPLACE/IF NOT EXISTS/IF EXISTS
```

2.默认不可重复执行
```
select redo_sqls($$
      语句1;
      语句2;
$$);
```


- 支持将所有语句都写在上述函数参数中
- 每条语句必须以半角分号结尾，语句本身内容不要带有半角分号!
- 每条sql必须以半角分号结束
- sql里不能有具体库名或者归属库 例如gb-boss，因为数据库名会变更。
- sql脚本给表字段设置默认值，不能有COLLATE "default"，flayway不能执行该语句。
- sql脚本表结构和表数据最好分离开来，要注意提交脚本先后顺序。


### 常见的语句的写法如下:

#### 表

1.创建表的语句, 创建表public.test, public可以不用写
```
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
```

2.删除表(慎用), 删除表test
```
 DROP TABLE IF EXISTS test;
```

3.修改表名
```
 ALTER TABLE IF EXISTS test rename to test1;
```

#### 视图

1.创建或更新视图，创建表test的视图
```
  CREATE OR REPLACE VIEW vw_test AS SELECT test.id, test.name FROM test;
  ALTER TABLE vw_test OWNER TO postgres;
```

2.删除视图
```
  DROP VIEW IF EXISTS vw_test;
```

#### 函数

1   创建或更新函数
```
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
```

2 删除函数
```
 DROP FUNCTION IF EXISTS fn_test(param text);
```

#### 序列

1.创建序列
```
    select redo_sqls($$
      CREATE SEQUENCE "seq_test"
         INCREMENT 1
         MINVALUE 1
         MAXVALUE 9223372036854775807
         START 10
         CACHE 10;
    $$);
```
2.删除序列
```
    DROP SEQUENCE IF EXISTS seq_test;
```

#### 字段

1.添加字段, 为test表添加字段name
```
  select redo_sqls($$
    ALTER TABLE test ADD COLUMN name character varying(255);
  $$);
```

2.删除字段，删除name字段：
```
 ALTER TABLE test DROP COLUMN IF EXISTS name;
```

#### 索引

1.增加索引，为表test的name列添加普通索引idx_test_name
```
  select redo_sqls($$
    CREATE INDEX idx_test_name ON test USING btree (name COLLATE pg_catalog."default");
  $$);
```

2.删除索引，删除名称为"idx_test_name"的索引
```
  DROP INDEX IF EXISTS idx_test_name;
```

#### 约束

1.增加约束，为表test添加主键约束pk_test
```
  select redo_sqls($$
    ALTER TABLE "public"."test" ADD CONSTRAINT "pk_test" PRIMARY KEY ("id");
  $$);
```

2.删除约束，删除主键约束pk_test，其他约束(惟一、外键等)的写法一样
```
 ALTER TABLE test DROP CONSTRAINT IF EXISTS pk_test;
```

#### 添加或修改注释

1.添加或修改表注释
```
 COMMENT ON TABLE public.test IS '测试表';
```

2.添加或修改字段注释
```
 COMMENT ON COLUMN test.name IS '姓名';
```

#### 语句

1.插入语句，插入一条id为2, name为foo的记录
```
 INSERT INTO test(id, name) SELECT 2, 'foo' WHERE 2 NOT IN(SELECT id FROM test WHERE id=2);
```

2.更新语句，更新id为2的记录的name字段为"foo"
```
 UPDATE test set name = 'foo' WHERE id = 2;
```

3.删除语句，删除id为2的记录
```
 DELETE FROM test WHERE id = 2;
```
