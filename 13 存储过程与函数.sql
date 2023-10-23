# 存储过程；将写好的SQL预先编译好存入缓存中，方便下次直接调用
# 但是阿里强制弃用
	CREATE DATABASE dbtest13;
	USE dbtest13;
	
	CREATE TABLE IF NOT EXISTS employees
	AS 
	SELECT * 
	FROM atguigudb.employees;
	
	CREATE TABLE IF NOT EXISTS departments
	AS 
	SELECT * 
	FROM atguigudb.departments;
	
	SELECT * FROM employees;
	SELECT * FROM departments;
	
	
	
	
	# 1. 创建存储过程
	
	# 类型1：无参数返回值
	# 举例1：创建存储过程select_all_data(),查看emps表的所有数据
	/*
	如果使用的是 Navicat 工具，那么在编写存储过程的时候，Navicat 会自动设置 DELIMITER 
	为其他符号，我们不需要再进行 DELIMITER 的操作
	*/
	DELIMITER $
	CREATE PROCEDURE select_all_data()
	BEGIN
				SELECT * FROM employees;
	END $
	DELIMITER ;
	
	# 存储过程的调用
	CALL select_all_data();
	
	/*
	创建存储过程show_max_salary()，用来查看emps表的最高薪资值		
	*/
	
	CREATE PROCEDURE show_max_salary()
	BEGIN
				SELECT MAX(salary) AS "max_salary"
				FROM employees; 
	END			
	
	CALL show_max_salary();
	
	
	# 类型2：带OUT
	/*
		创建存储过程show_min_salary()，查看"emps"表的最低薪资值，并将最低薪资
		通过OUT参数"ms"输出
	*/
		CREATE PROCEDURE show_min_salary(OUT ms DOUBLE)
		BEGIN
				SELECT MIN(salary) INTO ms 
				FROM employees;
		END
		
		# 调用
		CALL show_min_salary(@ms);
	
		# 查看
		SELECT @ms;
		
		
		#类型3：带IN
		/*
		
		创建存储过程show_someone_salary(),查看"emps"表的某个员工的薪资，
		并用IN参数empname输入员工姓名
		
		*/
		CREATE PROCEDURE show_someone_salary(IN empsome VARCHAR(20))
		BEGIN
				SELECT salary
				FROM employees
				WHERE last_name = empsome;
		END
		
		# 调用方式1
		CALL show_someone_salary('Abel');
	
		# 调用方式2
		SET @empname = 'Abel';
-- 	或者 SET @empname := 'Abel';
		CALL show_someone_salary(@empname);
			
			
		# 类型4：带IN和OUT
		/*
		 创建存储过程show_someone_salary2(),查看emps表的某个员工的薪资，
		 并用IN参数empname输入员工姓名，用OUT参数empsalary输出员工薪资
		*/
		
		CREATE PROCEDURE show_someone_salary2(IN empname VARCHAR(20), OUT empsalary DECIMAL)
		BEGIN
				 SELECT salary INTO empsalary 
				 FROM employees
				 WHERE last_name = empname;
		 END
		 
		 CALL show_someone_salary2('Abel',@empsalary);
		 SELECT @empsalary;
		 
		 # 变量使用的时候用@符号
		 SET @empname = 'Abel';
		 CALL show_someone_salary2(@empname,@empsalary);
		 SELECT @empsalary;
		 
		 
		 # 类型5：带INOUT
		 /*
		 创建存储过程show_mgr_name()，查询某个员工领导的姓名，并用INOUT参数
		 "empname"输入员工姓名，输出领导的姓名
		 
		 */
		 
		 CREATE PROCEDURE show_mgr_name(INOUT empname VARCHAR(25))
		 BEGIN
					SELECT last_name INTO empname
					FROM employees
					WHERE employee_id = (
															SELECT manager_id
															FROM employees
															WHERE last_name = empname
														);
			END
			
			# 调用
			SET @empname = 'Abel';
			CALL show_mgr_name(@empname);
			SELECT @empname;
		
	
	
	
	
	# 2.存储函数的使用
	/*
	
	举例：创建存储函数，名称为email_by_name(),参数定义为空，
				该函数查询Abel的email，并返回数据类型为字符串型
	*/

	
	CREATE FUNCTION email_by_name()
	RETURNS VARCHAR(25)
					DETERMINISTIC
					CONTAINS SQL
					READS SQL DATA
	BEGIN
	RETURN
			(SELECT email 
			from employees
			WHERE last_name = 'Abel');
	END
	
	# 调用
	SELECT email_by_name();

	
	/*
	举例：创建存储函数，名称为email_by_id()，参数传入emp_id, 该函数查询emp_id的email并返回，数据类型为字符串型
	
	*/
		DESC employees;
		
		# 创建函数前执行如下语句
		SET GLOBAL log_bin_trust_function_creators = 1;
	
		CREATE FUNCTION email_by_id(emp_id INT)
		RETURNS VARCHAR(25)
		BEGIN
		RETURN
					(SELECT email 
					FROM employees
					WHERE employee_id = emp_id);
		END
					
		# 调用
		SELECT email_by_id(101);
		
		
		SET @emp_id = 101;
		SELECT email_by_id(@emp_id);
	
	
	/*
	
	举例： 创建存储函数count_by_id(),参数传入dept_id,该函数查询dept_id部门的员工人数
					并返回数据类型为整型
	*/
		CREATE FUNCTION count_by_id(dept_id INT)
		RETURNS INT
		BEGIN
		RETURN
					(
					SELECT COUNT(employee_id)
					FROM employees
					WHERE department_id = dept_id
					);
		END
		
		SELECT count_by_id(50);
					
	
	# 存储过程、存储函数的查看
		
		# 方式一
		SHOW CREATE FUNCTION count_by_id;
		SHOW CREATE PROCEDURE show_min_salary \G;
		
		# 方式二
		SHOW FUNCTION STATUS LIKE 'count_by_id';
		SHOW PROCEDURE STATUS LIKE 'show_min_salary';
		
		# 方式三
		SELECT * 
		FROM information_schema.ROUTINES
		WHERE ROUTINE_NAME = 'count_by_id'；
-- 		AND ROUTINE_TYPE = 'FUNCTION';   # 存储过程与存储函数同名时使用
		
		SELECT * 
		FROM information_schema.ROUTINES
		WHERE ROUTINE_NAME = 'show_min_salary';
-- 		AND ROUTINE_TYPE = 'PROCEDURE';


		# 存储过程、存储函数的修改
		ALTER FUNCTION count_by_id 
		SQL SECURITY INVOKER
		COMMIT '';
		
		# 存储过程、存储函数的删除
		DROP FUNCTION IF EXISTS count_by_id;
	
	
	# 存储过程练习题
	CREATE DATABASE test15_pro_func;
	USE test15_pro_func;
	
	CREATE TABLE admin(
	id INT PRIMARY KEY AUTO_INCREMENT,
	user_name VARCHAR(15) NOT NULL,
	pwd VARCHAR(25) NOT NULL
	);
	
	CREATE TABLE beauty(
	id INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(15) NOT NULL,
	phone VARCHAR(15) UNIQUE,
	birth DATE 
	);
	
	INSERT INTO beauty(name, phone, birth)
	VALUES('haiyan', '19509904018', '1999-07-01');
	
	# 1. 创建存储过程insert_user(),实现传入用户名和密码，出入到admin表中
		CREATE PROCEDURE insert_user(IN user_name VARCHAR(15), IN pwd VARCHAR(25))
		BEGIN
				INSERT INTO admin(user_name, pwd)
				VALUES
				(user_name, pwd);
		END
		
		CALL insert_user('yujun','123456');
		
		SELECT * FROM admin;
	
	# 2.创建存储过程get_phone(), 实现传入编号，返回姓名和电话
	CREATE PROCEDURE get_phone(IN id INT, OUT `name` VARCHAR(15), OUT phone VARCHAR(15))
	BEGIN
			 SELECT b.`name`,b.phone INTO `name`, phone
			 FROM beauty b
			 WHERE b.id = id;
	END
	
	SELECT * FROM beauty;
	
	CALL get_phone(2, @`name`, @phone);
	SELECT @`name`, @phone;
	
	
	# 3.创建存储过程date_diff(),实现传入两个生日，返回日期间隔大小
	CREATE PROCEDURE date_diff(IN birth1 DATE, IN birth2 DATE, OUT sub_date INT)
	BEGIN
			SELECT DATEDIFF(birth1,birth2) INTO sub_date;
	END
	
	
	CALL date_diff('1999-07-01', '1998-06-03', @sub_date);
	SELECT @sub_date;
	
	
	# 4.创建存储过程format_date(),实现传入一个日期，格式化成xx年xx月xx日并返回
	CREATE PROCEDURE format_date(IN `date` DATE, OUT to_date VARCHAR(30))
	BEGIN
			SELECT DATE_FORMAT(`date`,'%Y年%m月%d日') INTO to_date;
	END
	
	
	CALL format_date ('1999-07-01', @to_date);
	SELECT @to_date;
	
	# 5.创建存储过程beauty_limit(),根据传入的起始索引和条目数，查询beauty表的记录
	CREATE PROCEDURE beauty_limit(IN start_index INT, IN size INT)
	BEGIN 	
			SELECT *
			from beauty
			LIMIT start_index, size;
	END
	
	CALL beauty_limit(1,1);
	
	
	# 6.创建带INOUT模式参数的存储过程，传入a和b两个值，最终a和b都翻倍并返回
	CREATE PROCEDURE double_out(INOUT a INT, INOUT b INT)
	BEGIN 
				SELECT a * 2, b * 2 INTO a,b; 
	END
	
	SET @a = 2;
	SET @b = 4;
	CALL double_out(@a, @b);
	SELECT @a, @b;


	# 7.删除题目5的存储过程
	DROP PROCEDURE IF EXISTS beauty_limit;
	
	
	# 8.查看题目6中存储过程的信息
	SHOW CREATE PROCEDURE double_out;
	SHOW PROCEDURE STATUS LIKE 'double_out';
	
	SELECT *
	FROM information_schema.ROUTINES
	WHERE ROUTINE_NAME = 'double_out';
	
	
	
	# 存储函数的练习
	USE test15_pro_func;
	
	CREATE TABLE employees
	AS 
	SELECT * FROM atguigudb.employees;
	
	CREATE TABLE departments
	AS
	SELECT * FROM atguigudb.departments;
	
	# 1.创建函数get_count(), 返回公司的员工个数
	CREATE FUNCTION get_count()
	RETURNS INT
	BEGIN

	RETURN
				(
				SELECT COUNT(employee_id)
				FROM employees
				);
	END
	
	SELECT get_count();
	
	# 2.创建函数ename_salary(),根据员工姓名，返回它的工资
	CREATE FUNCTION ename_salary(`name` VARCHAR(25)) 
	RETURNS DECIMAL(10,2)
	BEGIN
	RETURN
				(
					SELECT salary
					FROM employees
					WHERE last_name = name
				);
	END
	
	SET @name = 'Abel';
	SELECT ename_salary(@name);
	
	SELECT * FROM departments;
	# 3.创建函数dept_sal(),根据部门名，返回该部门的平均工资
	CREATE FUNCTION dept_sal(dept_name VARCHAR(30)) 
	RETURNS DECIMAL(10,2)
	BEGIN
	RETURN
				(
				SELECT AVG(salary)
				FROM employees 
				GROUP BY department_id 
				HAVING department_id = (
																SELECT department_id 
																FROM departments 
																WHERE department_name = dept_name
															)	
				);
	END
	
	SET @dept_name = 'Marketing';
	SELECT dept_sal(@dept_name);
	
	
	CREATE FUNCTION dept_sal1(dept_name VARCHAR(30)) 
	RETURNS DECIMAL(10,2)
	BEGIN
	RETURN
				(
				SELECT AVG(e.salary)
				FROM employees e JOIN (
														SELECT department_id 
														FROM departments 
														WHERE department_name = dept_name
															)	sub 
				ON e.department_id = sub.department_id 
				GROUP BY e.department_id
				);
	END
	
		SET @dept_name = 'Marketing';
		SELECT dept_sal1(@dept_name);
	
	
	# 4. 创建函数add_float()，实现传入两个float，返回二者之和
	CREATE FUNCTION add_float(a FLOAT, b FLOAT)
	RETURNS FLOAT
	BEGIN
	RETURN
				(
				SELECT a + b
				);
	END
	
	SELECT add_float(2.5,3.8);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
			
	
	
	
	
	