# 1.创建和管理数据库 
	/*
		1.1 如何创建数据库
		方式1：
		CREATE DATABASE test(数据库名); # 创建的此数据库使用的是默认字符集
		
		方式2：显示指明要创建的数据库的字符集
		CREATE DATABASE 数据库名 CHARACTER SET '字符集';
		
		方式3：
		CREATE DATABASE IF NOT EXISTS '数据库名' CHARACTER SET '字符集';
	
	*/
	
	
	/*
	
	1.2 管理数据库
		 ①查看当前连接中的数据库都有哪些
			SHOW DATABASES;
			
			②切换数据库
			USE 数据库名;
			
			③查看当前数据库中保存的数据表
			SHOW TABLES;
			
			④查看当前使用的数据库
			SELECT DATABASE() FROM DUAL;
		
			⑤查看指定数据库下保存的数据表
			SHOW TABLES FROM 数据库名;
	
	*/

	/*
	
	1.3 修改数据库
		①更改数据库字符集
		ALTER DATABASE 数据库名 CHARACTER SET '字符集';
		
	*/
	
	/*
	
	1.4 删除数据库
		方式1：
		DROP DATABASE 数据库名;
		
		方式2：
		DROP DATABASE IF EXISTS 数据库名;
	
	*/
	
	
	
	# 2. 如何创建表
	/*
	方式1： 
		CREATE TABLE IF NOT EXISTS 表名(
			id INT;
			emo_name VARCHAR(10);
			hire_data DATE
		);
	
	
	方式2：基于现有的表,同时导入数据
	CREATE TABLE 表名
	AS
	SELECT employee_id, last_name, salary 
	FROM employees;
	
	说明1：查询语句中字段的别名，可以作为新创建的表的字段的别名
	说明2：此时的查询语句可以结构比较丰富，使用前面章节讲过的各种SELECT
	*/
	
	# 练习1：创建一个表employees_copy，实现对employees表的复制，包括表数据
	CREATE TABLE IF NOT EXISTS employees_copy
	AS
	SELECT *
	FROM employees;
	DROP TABLE employees_copy;
	
 # 练习2：创建一个表employees_copy，实现对employees表的复制，不包括表数据
	CREATE TABLE IF NOT EXISTS employees_copy
	AS
	SELECT *
	FROM employees
	LIMIT 0;
	
	
	
	# 3. 修改表 ---> ALTER TABLE
	/*
	
		3.1 添加一个字段
		ALTER TABLE 表名
		ADD 字段名 类型;  # 默认放在表尾
	
	
		ALTER TABLE 表名
		ADD 字段名 类型 FIRST;  # 放在第一位
		
		ALTER TABLE 表名
		ADD 字段名 类型 AFTER 字段名;  # 在某个字段之后
		
		
		3.2 修改一个字段；数据类型、长度、默认值
		ALTER TABLE 表名
		MODIFY 字段名 更改后类型;
		
		ALTER TABLE employees
		MODIFY first_name VARCHAR(25);
		
		ALTER TABLE employees
		MODIFY first_name VARCHAR(25) DEFAULT 'aaa'; # 添加默认值
		
		# 3.3 重命名一个字段
		
		ALTER TABLE 表名
		CHANGE 旧字段名 新字段名 类型;
		
		# 3.4 删除一个字段
		ALTER TABLE 表名
		DROP COLUMN 字段名;
		
	*/
	ALTER TABLE employees_copy
	DROP favorate;
	
	DESC employees;
	
	ALTER TABLE employees
		MODIFY first_name;
	
	
	
	# 4. 重命名表
	/*
		方式1：
			RENAME TABLE 原表名
			TO 新表名
			
		方式2：
		 ALTER TABLE 表名
		 RENAME TO 新表名;
	
	*/
	
	
	# 5. 删除表
	/*
	
	不光将表结构删除，同时表中的数据也删除掉，释放表空间
	DELETE TABLE IF EXISTS 表名; 
	
	*/
	
	# 6. 清空表
	
	/*
		表示清空表中的所有数据，但是表结构保留
		TRUNCATE TABLE 表名;
	
	*/
	
	
	# 7. DCL 中 COMMIT 和 ROLLBACK
	/*
	    开启事务 start transaction / begin
		COMMIT：提交数据。一旦执行，则数据就被永久的保存在了数据库中，意味着数据不可以回滚
		ROLLBACK：回滚数据。一旦执行，则可以实现回滚数据，回滚到最近一次COMMIT之后
	
	*/
	
	
	# 8. 对比 TRUNCATE TABLE 和 DELETE FROM 
	/*
		相同点：都可以实现对表中所有数据的删除，同时保留表结构
		不同点：
					TRUNCATE TABLE：表数据全部删除，同时数据不支持回滚
					DELETE FROM:表数据可以全部删除（不带WHERE），同时数据是可以支持回滚的
	*/
	
	
	# 9.DDL 和 DML 的说明
	/*
			DDL：对表执行操作
			DML：对表的内容执行操作
			
			① DDL的操作一旦执行，就不可以回滚。SET autocommit = FALSE对其失效
			② DML的操作默认情况，一旦执行不可以回滚。
				但是如果在执行DML之前，执行了 SET autocommit = FALSE,则执行的DML可以回滚
		
	*/
COMMIT;

SELECT * FROM employees_copy;
	
SET autocommit = FALSE;

DELETE FROM employees_copy;	

ROLLBACK;	
	
TRUNCATE TABLE employees_copy;


	
	# 10. DDL的原子化
	
	
	CREATE DATABASE IF NOT EXISTS test01_office CHARACTER SET 'utf8';
	
	USE test01_office;
	
	CREATE TABLE dept01(
	id INT(7),
	`name` VARCHAR(25)
	);
	
	
	CREATE TABLE dept02 
	AS 
	SELECT * 
	FROM atguigudb.departments;
	
	

	
	
	
	