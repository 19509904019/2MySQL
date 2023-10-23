# 1. 常用的聚合函数
# AVG() / SUM():只适用于数值类型的字段
# MAX() / MIN()：适用于数值类型、字符串类型、日期时间类型的字段
# 方差、标准差、中位数
SELECT AVG(salary)
FROM employees;

SELECT SUM(salary)
FROM employees;

SELECT MAX(salary)
FROM employees;

SELECT MIN(salary)
FROM employees;

# COUNT()：
# ① 作用:计算指定字段在查询结构中出现的个数(不包含NULL值)
#	② 公式：AVG = SUM / COUNT 
# ③ 聚合函数除了COUNT(*),都自动跳过NULL值

/*
	计算表中有多少条记录：
		COUNT(*)
		COUNT(1)
		COUNT(具体字段)：计算指定字段出现的个数时，是不计算NULL值的
		
	三者效率那个更高?
		> 如果使用的是MyISAM存储引擎，则三者效率相同，都是O(1)
		> 如果使用的是InnoDB存储引擎，则三者效率：COUNT(*) = COUNT(1) > COUNT(具体字段)
		>
	
*/
SELECT COUNT(salary), COUNT(manager_id), COUNT(*)
FROM employees;

SELECT AVG(IFNULL(commission_pct,0)), SUM(commission_pct) / COUNT(IFNULL(commission_pct, 0)), SUM(commission_pct) / COUNT(*)
FROM employees;


# 2. GROUP BY 的使用
# 查询各个部门的平均工资、最高工资
SELECT department_id, AVG(salary), MAX(salary)
FROM employees
GROUP BY department_id;

# 查询各个department_id,job_id的平均工资
SELECT department_id, job_id, SUM(salary) / COUNT(IFNULL(salary,1)) AS "avg_salary"
FROM employees 
GROUP BY department_id, job_id
ORDER BY department_id;

# 结论1：SELECT中出现的非组函数的字段必须声明在GROUP BY中，而GROUP BY中的字段可以
# 不出现在SELECT中

# 结论2：GROUP BY 声明在FROM后面、WHERE后面，ORDER BY前面，LIMIT前面

# 结论3：MySQL 中GROUP BY 中使用WITH ROLLUP 
SELECT department_id, job_id, SUM(salary) / COUNT(IFNULL(salary,1)) AS "avg_salary"
FROM employees 
GROUP BY department_id;

SELECT department_id, job_id, AVG(salary)
FROM employees 
GROUP BY department_id,job_id WITH ROLLUP;


# 说明：当使用 WITH ROLLUP时，不能同时使用ORDER BY子句进行结果排序
SELECT department_id, job_id, AVG(salary)
FROM employees 
GROUP BY department_id,job_id WITH ROLLUP
ORDER BY department_id;

# 3. HAVING的使用
# 查询各个部门中最高工资比10000高的部门信息
SELECT department_id, MAX(salary)
FROM employees
WHERE salary > 10000
GROUP BY department_id;

# 结论1：如果过滤条件中使用了聚合函数，则必须使用HAVING来替换WHERE。否则报错
# 开发中 HAVING 通常都是跟 GROUP BY 一起出现的
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000;

# 查询部门id为10，20，30，40这4个部门中最高工资比10000高的部门信息
/*
此语句报错，不能确定最大工资属于哪个部门的department_id，如果此时10，20的最大工资相同，则无法输出
*/
SELECT department_id, MAX(salary)
FROM employees 
WHERE department_id IN (10,20,30,40); 

# 正确输出语句
# 方式1：
SELECT department_id, MAX(salary)
FROM employees 
WHERE department_id IN (10,20,30,40)
GROUP BY department_id
HAVING MAX(salary) > 10000;

# 方式2：
SELECT department_id, MAX(salary)
FROM employees 
GROUP BY department_id
HAVING department_id IN (10,20,30,40) AND MAX(salary) > 10000;

# 结论：当过滤条件中有聚合函数时，则此过滤条件必须声明在HAVING中
#	当过滤条件中没有聚合函数时，则此过滤条件既可以声明在WHERE和HAVING中，建议使用WHERE
　
/*
　WHERE　和　HAVING 的对比
		1. 从适用范围上来说，HAVING的适用范围更广
		2. 如果过滤条件中没有聚合函数，WHERE的执行效率要高于HAVING
*/


# 4. SQL底层执行原理
	# 4.1 SELECT 语句的完整结构
	/*
	
	# sql92语法： 
	SELECT ..., ..., ...(存在聚合函数)
	FROM ..., ..., ...
	WHERE 多表的连接条件 AND 不包含聚合函数的过滤条件
	GROUP BY ..., ...
	HAVING 包含聚合函数的过滤条件
	ORDER BY ..., ....
	LIMIT ..., ...
	
	
	# sql99语法： 
	SELECT ..., ..., ...(存在聚合函数)
	FROM ... (LEFT,RIGHT) JOIN ...
	ON ...  多表的连接条件 
	WHERE 不包含聚合函数的过滤条件
	GROUP BY ..., ...
	HAVING 包含聚合函数的过滤条件
	ORDER BY ..., ....
	LIMIT ..., ...
	*/

# 4.2 SQL语句的执行过程
/*

FROM：从指定的表或视图中选择数据。
WHERE：根据指定的条件对数据进行筛选。
GROUP BY：将数据按照指定的列进行分组。
HAVING：对分组后的数据进行进一步筛选。
SELECT：选择要显示的列或计算的表达式。
ORDER BY：按照指定的列对结果集进行排序。
LIMIT/OFFSET：限制返回的行数和起始位置。

*/


# 练习1：WHERE子句可否使用组函数进行过滤？
	# 不可以
	
	
# 练习2：查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary) AS "max_salary", MIN(salary) AS "min_saalry", SUM(salary) / COUNT(employee_id) AS "avg_salary", SUM(salary) AS "sum_salary"
FROM employees;


# 练习3：查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT job_id, MAX(salary) AS "max_salary", MIN(salary) AS "min_salary", AVG(salary) AS "avg_salary", SUM(salary) AS "sum_salary"
FROM employees
GROUP BY job_id;


# 练习4：选择具有各个job_id的员工人数
SELECT job_id, COUNT(employee_id) AS "peopleNo"
FROM employees
GROUP BY job_id;


# 练习5：查询员工最高工资和最低工资的差距
SELECT MAX(salary)  - MIN(salary) AS "DIFFERENCE"
FROM employees;


#练习6：查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不
#计算在内
SELECT manager_id, MIN(salary) AS "min_salary"
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

# 子查询:查询最低工资是谁
SELECT e.last_name, e.manager_id, e.salary
FROM employees e
JOIN (
  SELECT manager_id, MIN(salary) AS min_salary
  FROM employees
  WHERE manager_id IS NOT NULL
  GROUP BY manager_id
  HAVING MIN(salary) >= 6000
) sub ON e.manager_id = sub.manager_id AND e.salary = sub.min_salary;


# 练习7：查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
SELECT d.department_name, d.location_id, COUNT(e.employee_id) AS "peopleNo", AVG(e.salary) AS "avg_salary"
FROM employees e RIGHT JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name, d.location_id
ORDER BY avg_salary DESC;






















