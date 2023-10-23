/*

	1.为什么使用试图？
		一方面可以帮我们使用表的一部分而不是所有的表，另一方面也可以针对不同的用户
		制定不同的查询视图
		
		简单来讲就是每个人看到的同一张表的不同部分
		
		
	2. 视图的理解
		① 视图可以看作是一个虚拟表，本身是不存储数据的。视图的本质就可以看作是存储起来
			的SELECT语句
			
		② 视图中SELECT语句中涉及到的表，称为基表
		
		③ 针对视图做DML操作，会影响到对应的基表中的数据，反之亦然
		
		③ 视图本身的删除，不会导致基表中数据的删除
			
		
		⑤ 视图的应用场景： 针对小型项目，不推荐使用视图；针对大型项目，可以考虑使用视图

*/
		USE test01_office;
		
		CREATE TABLE IF NOT EXISTS emps 
		AS 
		SELECT *
		FROM atguigudb.employees;

		CREATE TABLE IF NOT EXISTS depts
		AS 
		SELECT *
		FROM atguigudb.departments;

		SELECT * FROM emps;
		
		SELECT * FROM depts;
		
		DESC emps;
		
		DESC depts;
		
	# 3.针对于单表
		
		# 3.1 确定视图中字段名的方式1：
-- 						查询语句中字段名或别名作为视图的字段名
		CREATE VIEW vu_emp1 
		AS
		SELECT employee_id, last_name, salary 
		FROM emps;
		
		SELECT * FROM vu_emp1;

		CREATE VIEW vu_emp2 
		AS
		SELECT employee_id emp_id, last_name, salary
		FROM emps
		WHERE salary > 5000;
		
		SELECT * FROM vu_emp2;
		
		
		# 3.2 确定视图中字段名的方式2：创建视图时指定字段别名，顺序是一一对应的
		CREATE VIEW vu_emp3(emp_id, `name`,monthly_sal)
		AS
		SELECT employee_id, last_name, salary 
		FROM emps;
		
		SELECT * FROM vu_emp3;

	# 4.针对多表 JOIN ... ON ...
	CREATE VIEW vu_emp_dept(emp_id, name, dept_name)
	AS
	SELECT e.employee_id, e.last_name, d.department_name
	FROM atguigudb.employees e JOIN atguigudb.departments d
	ON e.department_id = d.department_id;
	
	SELECT * FROM vu_emp_dept;


		# 4.1 利用视图对数据进行格式化
		CREATE VIEW vu_emp_dept1 
		AS
		SELECT CONCAT(e.last_name, '(', d.department_name,')') emp_info
		FROM emps e JOIN depts d 
		ON e.department_id = d.department_id;
		
		SELECT * FROM vu_emp_dept1;
	
		# 4.2 利用视图创建新的视图 


	# 5. 查看视图
		# 语法1：查看数据库的表对象、视图对象
		SHOW TABLES;
		
		# 语法2：查看视图结构
		DESC vu_emp1;
		
		# 语法3：查看视图的属性信息
		SHOW TABLE STATUS LIKE 'vu_emp1';
		
		# 语法4：查看视图的详细定义信息
		SHOW CREATE VIEW vu_emp1;


	# 6.更新视图中的数据 
	 
	 #6.1 更新视图的数据，会导致基表中数据的修改
		UPDATE vu_emp1 
		SET salary = 10000
		WHERE employee_id = 101;
		
		SELECT * FROM vu_emp1;
		SELECT * FROM emps;
		
		# 同理更新表中的数据，也会导致视图中的数据的修改
		UPDATE emps 
		SET salary = 15000
		WHERE employee_id = 101;

		SELECT employee_id, salary
		FROM emps;
		
		SELECT * 
		FROM vu_emp1;
		
		# 删除视图中的数据，也会导致表中的数据删除
		DELETE FROM vu_emp1 
		WHERE employee_id = 101;
		
		SELECT * 
		FROM vu_emp1;

	  SELECT employee_id, salary
		FROM emps; 


		# 6.2 不能更新视图中的数据
		
		/*
				创建视图的字段如果是基表中多个数据所计算得到的，比如说每个部门的
		平均工资，此时就不能进行更新操作，即增删改等
		*/
		
		
	# 7. 修改视图
		DESC vu_emp1;
		
		# 方式1
		# CREATE OR REPLACE VIEW 
		CREATE OR REPLACE VIEW vu_emp1 
		AS
		SELECT employee_id, last_name, salary, email 
		FROM emps 
		WHERE salary > 5000;
		
		# 方式2
		ALTER VIEW vu_emp1 
		AS 
		SELECT employee_id, last_name, salary, email,hire_date
		FROM emps;
		
		
	# 8. 删除视图
	DROP VIEW vu_emp3;
	
	
	# 9. 总结
	
	/*
		① 操作简单
		
		② 减少数据冗余
		
		③ 数据安全
	
	*/
