# 1. 分支结构之 IF
	CREATE PROCEDURE test_if()
	BEGIN
			DECLARE age INT DEFAULT 45;
			
			IF age > 40
							THEN SELECT '中年人' AS title;
			ELSEIF age > 20
							THEN SELECT '青年人' AS title;
			ELSEIF age > 6
							THEN SELECT '少年人' AS title;
			ELSE	
						SELECT '儿童' AS title;
			END IF;
	END
							
	CALL test_if();
	
	DROP PROCEDURE test_if;
	
	
	# 声明存储过程"update_salary_by_eid1",定义IN参数emp_id,输入员工编号。
-- 		判断该员工工薪资如果低于8000元并且入职时间超过5年，就涨薪500元，否则就不变
	CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
	BEGIN
			DECLARE emp_sal DECIMAL(10,2);
			DECLARE emp_date DECIMAL(10,2);
			
			SELECT salary INTO emp_sal
			FROM employees 
			WHERE employee_id = emp_id;
			
			SELECT DATEDIFF(CURRENT_DATE,hire_date) / 365 INTO emp_date
			FROM employees
			WHERE employee_id = emp_id;
			
			IF emp_sal < 8000
					AND emp_date > 5
					THEN UPDATE employees 
							 SET salary = salary + 500
							 WHERE employee_id = emp_id;
			END IF;
	END


	CALL update_salary_by_eid1(104);
		

		SELECT salary,employee_id 
		FROM employees
		WHERE salary < 8000 AND DATEDIFF(CURRENT_DATE,hire_date) > 5;




# 2. 分支结构之 case
/*
类似于swith：
	CASE 表达式
	WHEN 值1 THEN 结果1或语句1(如果是语句需要加分号)
	WHEN 值2 THEN 结果2或语句2(如果是语句需要加分号)
	...
	ELSE 结果n或语句n(如果是语句需要加分号)
	END [CASE] (如果是放在begin end需要加上case，如果放在select后面不需要)
	
	
	类似于 if：
	CASE 
	WHEN 条件1 THEN 结果1或语句1(如果是语句需要加分号)
	WHEN 条件2 THEN 结果2或语句2(如果是语句需要加分号)
	...
	ELSE 结果n或语句n(如果是语句需要加分号)
	END [CASE] (如果是放在begin end需要加上case，如果放在select后面不需要)
	*/
	
		# 声明存储过程"update_salary_by_eid1",定义IN参数emp_id,输入员工编号。
-- 		判断该员工工薪资如果低于8000元并且入职时间超过5年，就涨薪500元，否则就不变

CREATE PROCEDURE update_salary_by_eid(IN emp_id INT)
BEGIN
		# 声明变量
		DECLARE emp_sal DOUBLE;
		DECLARE emp_date DOUBLE;
		
		# 为变量emp_sal 赋值
		SELECT salary INTO emp_sal
		FROM employees
		WHERE employee_id = emp_id;
		
		# 为变量emp_date赋值
		SELECT DATEDIFF(CURRENT_DATE,hire_date)/365 INTO emp_date
		FROM employees
		WHERE employee_id = emp_id;
	
		CASE WHEN emp_sal < 8000 AND emp_date>=5 THEN UPDATE employees
																									SET salary = salary + 500
																									WHERE employee_id = emp_id;
		END CASE;
END


		CALL update_salary_by_eid(104);
		

		SELECT salary,employee_id 
		FROM employees
		WHERE salary < 8000 AND DATEDIFF(CURRENT_DATE,hire_date) > 5;



# 3.循环结构之LOOP
		/* loop_label:LOOP
					循环执行的语句
			 END LOOP
		*/

		# 当市场环境变好时，公司为了奖励大家决定涨工资。声明存储过程"update_salary_loop()"，声明
		# OUT参数sum，输出循环次数。存储过程中实现循环给大家涨薪，薪资为原来的1.1倍。知道全公司的
		# 平均薪资达到12000结束。并统计循环次数
			CREATE PROCEDURE update_salary_loop(OUT sum INT)
			BEGIN	
					#	声明局部变量
					DECLARE loop_sum INT DEFAULT 0;	
					DECLARE avg_sal DOUBLE;
					
					loop_label:LOOP
												SET loop_sum = loop_sum + 1;
												# 查询平均工资
												SELECT AVG(salary) INTO avg_sal FROM employees;
												# 如果平均工资大于12000，结束循环
												IF avg_sal > 12000 
														THEN LEAVE loop_label;
												# 否则更新全体员工工资
												ELSE
														UPDATE employees SET salary = salary * 1.1;
												END IF;
				  END LOOP loop_label;
					
					SET sum = loop_sum;
			END
			

																				
		CALL update_salary_loop(@loop_sum);
		SELECT @loop_sum;
		
		SELECT AVG(salary) FROM employees;
	


# 4.循环结构之WHILE
	/*
		while_label:WHILE 循环条件 DO
							循环体
		END WHILE(while_label);
	
		*/
		
		/*
		凡是循环结构，一定具备4个要素：
				1. 初始化条件
				2. 循环条件
				3. 循环体
				4. 迭代条件
		*/

		# 声明存储过程"update_salary_while()"，声明OUT参数num，输出循环次数
		# 存储过程中实现循环给大家降薪，薪资降为原来的90%，知道全公司的平均薪资
		# 达到5000结束，并统计循环次数
		
		CREATE PROCEDURE update_salary_while(OUT num INT)
		BEGIN
					# 声明局部变量
					DECLARE avg_sal DOUBLE;
					DECLARE loop_sum INT DEFAULT 0;
				  # 给局部变量赋值 
					SELECT AVG(salary) INTO avg_sal FROM employees;
					
					while_label: WHILE avg_sal > 5000 DO
														SET loop_sum = loop_sum + 1;
														UPDATE employees SET salary = salary * 0.9;
														SELECT AVG(salary) INTO avg_sal FROM employees;
					END WHILE while_label;
					
					SET num = loop_sum; 			
		END

		CALL update_salary_while(@result);
		SELECT @result;
SELECT AVG(salary) FROM employees;
	

# 5. 循环结构之REPEAT:相当于do...while...
		/*
			repeat_label:REPEAT
							循环体的语句
			UNTIL 结束循环的条件表达式
			END REPEAT [repeat_label]
		
		*/
		
		CREATE PROCEDURE test_repeat()
		BEGIN
				DECLARE num INT DEFAULT 0;
		
				REPEAT
							SET num = num + 1;
					
				UNTIL num >= 10 
				END REPEAT;

		END 


# 6.LEAVE：相当于break
	# 使用该关键字需要给循环加上标签


# 7.ITERATE：相当于continue
	# 使用该关键字需要给循环加上标签


# 8.游标的使用:
/*
逐条读取结果集中的数据。
但是在使用游标的过程中，会对数据进行加锁，这样在业务并发量大的时候，
不仅会影响业务之间的效率，还会消耗系统资源
*/


/*
	使用步骤：
		① 声明游标: DECLARE 游标名称 CURSOR FOR 执行语句;
		② 打开游标: OPEN 游标名称;
		③ 使用游标: FETCH 名称 INTO 变量;
		④ 关闭游标: CLOSE 游标名称;

*/



# MySQL8.0的新特性---全局变量的持久化
		
		# PERSIST 
		SET PERSIST log_bin_trust_function_creators = 1;
		

# 练习：
	#无参返回
	# 1. 创建函数get_count(),返回公司的员工个数
	CREATE FUNCTION get_count()
	RETURNS INT
	BEGIN
			 RETURN
				(
					SELECT COUNT(*)
					FROM employees	
				);
	END
	
	SELECT get_count();

	# 有参返回
	# 2. 创建函数name_salary(),根据员工姓名，返回他的工资
	CREATE FUNCTION name_salary(emp_name VARCHAR(25))
	RETURNS DOUBLE
	BEGIN
			
			SET @sal = 0;
			
			SELECT salary INTO @sal 
			FROM employees
			WHERE last_name = emp_name;
			
			RETURN @sal;
	
	END
	
	SELECT name_salary('Abel') AS "salary";
	SELECT @sal AS "salary";

	# 3. 创建函数dept_sal()，根据部门名返回该部门的平均工资
	CREATE FUNCTION dept_sal(dept_name VARCHAR(30))
	RETURNS DOUBLE
	BEGIN
				DECLARE avg_sal DOUBLE;
		
				SELECT AVG(e.salary) INTO avg_sal
				FROM employees e JOIN departments d
				ON e.department_id = d.department_id 
				WHERE d.department_name = dept_name;
				
				RETURN avg_sal;		
	END
	
	SELECT dept_sal('Administration');
	
	
	# 4. 创建函数add_float()，实现传入两个float，返回二者之和
	CREATE FUNCTION add_float(value1 FLOAT, value2 FLOAT)
	RETURNS FLOAT
	BEGIN
				DECLARE sum FLOAT;
				
				SELECT value1 + value2 INTO sum;
				
				RETURN sum;
	END

	SELECT add_float(2.8,3.6);


/*

流程控制练习

*/

# 1. 创建函数test_if_case()，实现传入成绩，如果成绩>90，返回A；如果>80,返回B
#			如果成绩>60，返回C；否则返回D(使用if结构和case结构实现)

	CREATE FUNCTION test_if_case(score DOUBLE)
	RETURNS CHAR(1)
	BEGIN
		 IF score > 90 THEN RETURN 'A';
		 ELSEIF score > 80 THEN RETURN 'B';
		 ELSEIF score > 60 THEN RETURN 'C';
		 ELSE RETURN 'D';
		 END IF;
			
	END
	
	SELECT test_if_case(95);
	SELECT test_if_case(85);
	SELECT test_if_case(70);
	SELECT test_if_case(50);
	
	
	# 2. 创建存储过程test_if_pro()传入工资值，如果工资<3000,则删除工资为此值的员工
	#     如果3000<= 工资值 <= 5000, 则修改此工资值的员工薪资涨1000，否则涨工资500
	
	CREATE PROCEDURE test_if_pro(IN emp_sal DOUBLE)
	BEGIN
			IF emp_sal < 3000
							THEN DELETE FROM employees WHERE salary = emp_sal;
			ELSEIF emp_sal <= 5000
							THEN UPDATE employees SET salary = salary + 1000 WHERE salary = emp_sal;
			ELSE UPDATE employees SET salary = salary + 500 WHERE salary = emp_sal;
			END IF;
	END
	
	CALL test_if_pro(6794.75);
	CALL test_if_pro(3623.88);

	
	# 3.创建存储过程insert_data(),传入参数为 IN 的 INT 类型变量 insert_count，实现向admin
	#			表中批量插入insert_count条记录
	CREATE TABLE admin 
	(
		id INT PRIMARY KEY AUTO_INCREMENT,
		user_name VARCHAR(25) NOT NULL,
		user_pwd VARCHAR(35) NOT NULL
	);
	
	
	CREATE PROCEDURE insert_data(IN insert_count INT)
	BEGIN 
			DECLARE count INT DEFAULT 0;
			WHILE insert_count > 0 DO
						SET count = count + 1; 
						INSERT INTO admin(user_name, user_pwd)
										 VALUES(CONCAT('yujun-', count), TRUNCATE(RAND() * 1000000,0));
						SET insert_count = insert_count - 1;
			END WHILE;
	END
	
	CALL insert_data(5);
	
	SELECT * FROM admin;
	
	
	
	# 游标的使用
		/*
			创建存储过程update_salary()，参数1为IN的INT型变量dept_id,表示部门id;
			参数2为IN的INT型变量change_sal_count,表示要调整薪资的员工个数。查询
			指定id部门的员工信息，按照salary升序排列，根据hire_date的情况，调整
			前change_sal_count个员工的薪资
		*/
			CREATE PROCEDURE update_salary(IN dept_id INT, IN change_sal_count INT)
			BEGIN
					# 声明局部变量
					DECLARE emp_date INT;
					DECLARE emp_id INT;

					# 创建游标
					DECLARE emp_cursor CURSOR FOR 
					SELECT YEAR(hire_date),employee_id 
					FROM employees
					WHERE department_id = dept_id
					ORDER BY salary ASC
					LIMIT 0, change_sal_count;
					
					# 打开游标
					OPEN emp_cursor;
					
					WHILE change_sal_count > 0 DO
								# 使用游标
								FETCH emp_cursor INTO emp_date,emp_id;
								
								# 调整薪资
								IF emp_date > 2001 THEN
														UPDATE employees SET salary = salary * 1.05 WHERE employee_id = emp_id;
								ELSEIF emp_date > 1998 THEN
									          UPDATE employees SET salary = salary * 1.10 WHERE employee_id = emp_id;
								ELSEIF emp_date >= 1995 THEN
									          UPDATE employees SET salary = salary * 1.15 WHERE employee_id = emp_id;
								ELSE UPDATE employees SET salary = salary * 1.20 WHERE employee_id = emp_id;
								END IF;
								
								# 结束条件
								SET change_sal_count = change_sal_count - 1;
					END WHILE;
					
					# 关闭游标
					CLOSE emp_cursor;
			END
			
			
			CALL update_salary(50,45);
			
			SELECT *
			FROM employees
			WHERE department_id = 50
			ORDER BY salary ASC;


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

