# 1. 添加数据
USE test01_office;

SELECT * FROM dept01;

# 方式1：一条一条添加数据
# ①（不推荐）
INSERT INTO dept01 
VALUES (1,'yujun','1998-06-03',15000); # 注意：一定要按照声明的字段的先后顺序添加

# ②
INSERT INTO dept01(id,hire_date,salary,`name`) 
VALUES (1,'1999-07-01',20000,'haiyan'); # 如果hire_date不赋值则为null

# ③
INSERT INTO dept01(id,hire_date,salary,`name`) 
VALUES
 (3,'2000-01-01',10000,'z'),
 (4,'2001-08-11',9000,'y');
 
# 方式2：将查询结果插入到表中,此时没有AS
# dept01表中要添加数据的字段的长度不能低于employees表中查询的字段的长度，
#     如果有的话就有添加失败的风险
INSERT INTO dept01(id,hire_date,salary,`name`) 
SELECT employee_id, hire_date, salary, last_name
FROM atguigudb.employees
WHERE department_id IN (70,60);


# 修改数据: UPDATE ... SET ... WHERE ...
# 可以实现批量修改数据
UPDATE dept01 
SET id = 2
WHERE `name` = 'haiyan';


# 3. 删除数据： DELETE FROM ... WHERE ...
DELETE FROM dept01 
WHERE id = 3
LIMIT 1;

# 联表删除
SELECT e,d 
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
WHERE last_name = '';

SELECT * FROM dept01;

# 4. MySQL8新特性：计算列
CREATE TABLE test01(
a INT,
b INT,
c INT GENERATED  ALWAYS AS (a + b) VIRTUAL
);

SHOW TABLES;

INSERT INTO test01(a,b)
VALUES (10,20);

SELECT * FROM test01;

UPDATE test01
SET a = 100;

SELECT * FROM test01;
