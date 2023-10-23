# 关于属性： CHARACTER SET name 

# 创建数据库时指明字符集
CREATE DATABASE IF NOT EXISTS test12 CHARACTER SET 'utf8';


# 创建表时指明字符集
CREATE TABLE temp(
	id INT
) CHARACTER SET 'utf8';


# 创建表指明表中的字段时，可以指定字段的字符集
CREATE TABLE temp1(
	id INT,
	`name` VARCHAR(6) CHARACTER SET 'gbk'
);


CREATE TABLE test_int(

f1 INT,
f2 INT(5),
f3 INT(5) ZEROFILL  # 显示宽度为5，当insert的值不足5位时，用0填充
)


# DATETIME：('2023-10-18 22:47:36') 


# TIMESTAMP类型： 1970-01-01 00：00：01 ---->  2038-01-19 03:14:07 


# 在实际开发中尽量使用DATETIME

# 获取时间戳
SELECT UNIX_TIMESTAMP();



# ENUM类型
CREATE TABLE test_enum(
season ENUM('春','夏','秋','冬','unknow')
)


INSERT INTO test_enum
VALUES ('春');

SELECT * FROM test_enum;

INSERT INTO test_enum 
VALUES (2),('3');  # 用索引值也可以添加


# SET 类型
CREATE TABLE test_set(
s SET ('A','B','C')
)

SELECT * FROM test_set;
# 可以添加多个元素
INSERT INTO test_set (s) VALUES ('A'), ('A,B');

# 插入重复的SET类型成员时，MySQL会自动删除重复的成员
INSERT INTO test_set (s) VALUES ('A,B,A,B,C');

# 向SET中插入SET成员中不存在的值时，MySQL会抛出错误 




# JSON 类型
CREATE TABLE IF NOT EXISTS test_json(
js JSON
);

INSERT INTO test_json 
VALUES ('{"name":"yj","age":18,"address":{"province":"jiangsu","city":"nanjing"}}');

SELECT * FROM test_json;

SELECT js -> '$.name' AS `name`, js -> '$.age' AS age, js -> '$.address.province' AS province, js -> '$.address.city' AS city
FROM test_json; 
