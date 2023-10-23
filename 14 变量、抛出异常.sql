# 1. 变量：系统变量(全局系统变量、会话系统变量) vs 用户自定义变量

	# 1.1查看系统变量
	# 查看全局系统变量
		SHOW GLOBAL VARIABLES;
		
	# 查看会话系统变量
		SHOW SESSION VARIABLES;
	
	# 默认查询的是会话系统变量		
		SHOW VARIABLES;
		
		
	# 查询部分系统变量
	SHOW GLOBAL VARIABLES LIKE 'admin_%';
	SHOW VARIABLES LIKE 'character_%';
	
	
	# 1.2 查看指定系统变量
	SELECT @@global.max_connections;  # 只能是全局的变量
	SELECT @@global.character_set_client; # 作用域既可以是全局也可以是会话
		SELECT @@session.max_connections; # 报错
	
	SELECT @@session.character_set_client; 
	SELECT @@session.pseudo_thread_id;
	SELECT @@global.pseudo_thread_id; # 报错
	
	SELECT @@character_set_client; # 先查询会话系统变量，再查询全局系统变量
	
	
	# 1.3 修改系统变量的值
		/*
		针对当前的数据库实例是有效的，一旦重启MySQL服务就失效了
		*/
		#方式1：
		SET @@global.max_connections = 161;
		
		#方式2：
		SET GLOBAL max_connections = 171;
		
		# 会话系统变量
		/*
		针对当前的会话是有效的，一旦重新建立会话就失效了
		*/
		SET @@session.character_set_cilent = 'gbk';
		SET SESSION character_set_cilent = 'gbk';
		
	
	
	# 1.4 用户变量
	
	/*
		① 用户变量：会话用户变量 vs 局部变量
		
		② 会话用户变量：使用"@"开头，作用域为当前会话
		
		③ 局部变量：只能使用在存储过程和存储函数中
	
	*/
	
	
	# 1.5 会话用户变量
	/*
	① 变量的声明和赋值：
		# 方式1 "=" 或 ":="
		SET @用户变量 = 值;
		SET @用户变量 := 值;
		
		
		# 方式2：":=" 或 INTO 关键字
		SELECT @用户变量 := 表达式 [FROM 等子句];
		SELECT 表达式 INTO @用户变量 [FROM 等子句];
	
	
	② 使用
	SELECT @变量名;
	*/

	CREATE DATABASE dbtest16;
	USE dbtest16;
	SELECT DATABASE();
	
	CREATE TABLE employees
	AS
	SELECT *
	FROM atguigudb.employees;
	
	CREATE TABLE departments
	AS
	SELECT *
	FROM atguigudb.departments;
 
  
	# 方式1
 	SET @a = 2;
	SET @b := 4;
	SET @c = @a + @b;
	SELECT @c;
	
	
	# 方式2
	SELECT @count := COUNT(*) FROM employees; #使用select必须使用 := 
	SELECT @count;
	 
	SELECT AVG(salary) INTO @avg_salary
	FROM employees;
	SELECT @avg_salary;
	
	
	# 1.7 局部变量
	/*
	1.局部变量的使用
		局部变量：①必须使用DECLARE声明
							②声明并使用在BEGIN ... END 中
							③ DECLARE的方式声明的局部变量必须声明在BEGIN中的首行的位置
	
	
	2.声明格式
	DECLARE 变量名  类型 [default 值];  # 如果没有DEFAULT子句，初始值为NULL
	
	3.赋值
	
	方式1:
	SET 变量名 = 值;
	SET 变量名 := 值;
	
	方式2：
	SELECT 字段名或表达式 INTO 变量名 FROM 表;
	
	4.使用
	SELECT 局部变量名;
	
	*/
	
	# 举例1：声明局部变量，并分别赋值为employees表中employee_id为102的last_name和salary
	CREATE PROCEDURE set_value() 
	BEGIN
	# 声明
	DECLARE salary DECIMAL(10,2);
	DECLARE lname VARCHAR(25);
	# 赋值
	SELECT last_name, e.salary INTO lname, salary 
	FROM employees e
	WHERE employee_id = 102;
	# 使用
	SELECT lname, salary;
	END

	
	CALL set_value();
	
	
	
	# 举例2：声明两个变量，求和并打印
	CREATE PROCEDURE sum_print()
	BEGIN
	# 声明
	DECLARE value1 INT DEFAULT 0;
	DECLARE value2 INT DEFAULT 0;
	DECLARE sum INT;
	# 赋值
	SET value1 = 10;
	SET value2 := 20;
	SET sum = value1 + value2;
	# 使用
	SELECT sum;
	END
	
	CALL sum_print();
	
	
	# 举例3：创建存储过程"different_salary"查询某员工和他领导的薪资差距，并用IN参数emp_id接收员工id,用
-- 		  		OUT参数dif_salary输出薪资差距结果
	CREATE PROCEDURE different_salary(IN emp_id INT, OUT dif_salary DECIMAL(10,2) )
	BEGIN
			DECLARE mgr_sal DECIMAL(10,2) DEFAULT 0.0;
			DECLARE emp_sal DECIMAL(10,2) DEFAULT 0.0;
			
			SELECT salary INTO mgr_sal 
			FROM employees 
			WHERE employee_id = (
														SELECT manager_id
														FROM employees
														WHERE employee_id = emp_id
														);
													
			SELECT salary INTO emp_sal
			FROM employees
			WHERE employee_id = emp_id;
			
			SELECT mgr_sal - emp_sal;
	END
	
	SET @emp_id = 103;
	CALL different_salary(@emp_id, @dif_salary);
	SELECT @dif_salary;
	
	
	# 二、定义条件和处理程序
		# 1. 定义条件
			#格式： DECLARE 错误名称 CONDITION FOR 错误码 (或错误条件)
			
			# 举例1：定义"Field_Not_Be_NULL"错误名称与MySQL中违反非空约束的错误类型是
-- 			         "ERROR 1048 (23000)" 对应
			
			# 方式1：使用MySQL_error_code 
			DECLARE Field_Not_Be_NULL CONDITION FOR 1048;
			
			# 方式2：使用sqlstate_value
			DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';
	
	
			# 举例2：定义"ERROR 1148(42000)" 错误，名称为command_not_allowed
			DECLARE command_not_allowed CONTINUE FOR 1148;
			
			DECLARE command_not_allowed CONDITION FOR VALUE '42000';
			
			
	# 2. 定义处理程序
		# 格式： DECLARE 处理方式 HANDLER FOR 错误类型 处理语句
		CREATE PROCEDURE UpdateDataNoCondition()
					BEGIN 
							 # 声明处理程序
							 #处理方式1：
							 DECLARE CONTINUE HANDLER FOR 1048 SET @prc_value = -1; # 遇到异常继续
							 #处理方式2：
-- 							 DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @prc_value = -1;
						   SET @x = 1;
							 UPDATE employees SET email = NULL WHERE last_name = 'Abel';
							 SET @x = 2;
							 UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
							 SET @x = 3;
				  END
					
				# 调用存储过程
				CALL UpdateDataNoCondition();
					
				SELECT @x, @prc_value;
	

					CREATE PROCEDURE UpdateDataNoCondition()
					BEGIN 
							 # 声明处理程序
							 #处理方式1：
							 DECLARE error CONDITION FOR 1048;
							 DECLARE EXIT HANDLER FOR error SET @prc_value = -1;  # 遇到异常退出
							 #处理方式2：
-- 							 DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @prc_value = -1;
						   SET @x = 1;
							 UPDATE employees SET email = NULL WHERE last_name = 'Abel';
							 SET @x = 2;
							 UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
							 SET @x = 3;
				  END
					
				# 调用存储过程
				CALL UpdateDataNoCondition();
					
				SELECT @x, @prc_value;
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	