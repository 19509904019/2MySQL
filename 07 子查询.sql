# 1.谁的工资比Abel高？
SELECT e.last_name, e.salary
FROM employees e 
JOIN(SELECT salary 
		 FROM employees 
		 WHERE last_name = 'Abel'
) sub ON e.salary > sub.salary;


# 2. 称谓的规范:外查询、内查询
/*
	> 子查询在主查询之前一次执行完成
	> 子查询的结果被主查询使用
	> 注意事项
			> 子查询要包含在括号内
			> 将子查询放在比较条件的右侧
			> 单行操作符对应单行子查询，多行操作符对应多行子查询

*/

# 3. 子查询的分类
/*
	角度1：从内查询返回的结果的条目数
				 单行子查询 vs 多行子查询
				 
	角度2：内查询是否被执行多次
				 相关子查询 vs 不相关子查询
		比如：相关子查询的需求：查询工资大于本部门平均工资的员工信息
					不相关子查询的需求：查询工资大于本公司平均工资的员工信息
*/

# 4. 单行子查询
	/*
		4.1 单行操作符：> < = >= <= <>
	*/
	# 查询工资大于149号员工工资的员工信息
	SELECT last_name, salary
	FROM employees 
	WHERE salary > (
									SELECT salary
									FROM employees
									WHERE employee_id = 149
								);
								
	# 返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
SELECT
	last_name,
	job_id,
	salary 
FROM
	employees 
WHERE
	job_id = ( SELECT job_id FROM employees WHERE employee_id = 141 ) 
	AND salary > ( SELECT salary FROM employees WHERE employee_id = 143 );
				
	# 返回公司工资最少的员工的last_name,job_id和salary
SELECT
	last_name,
	job_id,
	salary 
FROM
	employees 
WHERE
	salary = ( SELECT MIN( salary ) FROM employees );
	
	# 查询与141号或147号员工的manager_id和department_id相同的其他员工的employee_id,manager_id,department_id
SELECT
	employee_id,
	manager_id,
	department_id 
FROM
	employees 
WHERE
	manager_id IN ( SELECT manager_id FROM employees WHERE employee_id IN ( 147, 141 ) ) 
	AND department_id IN ( SELECT department_id FROM employees WHERE employee_id IN ( 147, 141 ) ) 
	AND employee_id <> 141 
	AND employee_id <> 147;
	
	# 查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT
	department_id,
	MIN( salary ) AS "min_salary" 
FROM
	employees 
GROUP BY
	department_id 
HAVING
	min_salary > ( SELECT MIN( salary ) FROM employees WHERE department_id = 50 ) 
ORDER BY
	min_salary ASC 
	LIMIT 1;
		
	DESC departments;
	# 显示员工的employee_id,last_name和location
	# 其中，若员工department_id与location_id为1800的department_id相同，则location为'Canada',其余则为'USA'
SELECT
	employee_id,
	last_name,
CASE
		
		WHEN department_id = ( SELECT department_id FROM departments WHERE location_id = 1800) THEN
		'Canada' ELSE 'USA' 
	END "location" 
FROM
	employees;
	
	
SELECT employee_id, last_name, IF(( SELECT department_id FROM departments WHERE location_id = 1800 ),
	'Canada',
	'USA' 
) AS "location" 
FROM
	employees;
	
	
	/*
	
	4.2 子查询中的空值问题
	
	*/
	
	
# 5. 多行子查询

# 5.1
/*
	IN：任意一个 比最小的还要小
	ANY：某一个  比最大的小就行
	ALL：所有
	SOME：与ANY相同
	ANY 和 ALL 可以用< > = 等符号进行运算

*/
	
	# 查询平均工资最低的部门id
	# 方式1：不严谨
	SELECT department_id, AVG(salary) AS "avg_salary"
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id
	ORDER BY avg_salary ASC
	LIMIT 1;
	
	# 方式2：
	# MySQL的聚合函数不能嵌套使用，需要添加相应的别名
	/*
		① 先查询每个部门的平均工资
		② 此时得到临时表，对这个表取最小值即为最低工资，注意要对临时表起一个别名，否则报错
		③ 再对得到的最小薪资查询部门id
	
	*/
SELECT
	department_id,AVG( salary )
FROM
	employees 
GROUP BY
	department_id 
HAVING
	AVG( salary ) = ( SELECT MIN( avg_sal ) 
										FROM( 
												SELECT AVG( salary ) AS "avg_sal" 
												FROM employees 
												GROUP BY department_id
												) t_dept_avg_sal 
										);
	
	# 方式3：
	# <= ALL：即取最小值
	SELECT department_id,AVG(salary) AS "avg_salary"
	FROM employees
	GROUP BY department_id
	HAVING avg_salary <= ALL (	SELECT AVG(salary)
															FROM employees
															GROUP BY department_id
															);
	
	# 5.2 空值问题：注意有NULL值，有NULL则返回的结果为空
	
	
# 6. 相关子查询
	# 6.1
	# 查询员工中工资大于本部门平均工资的员工的last_name, salary,department_id
	# 方式1：使用相关子查询
	SELECT e1.last_name, e1.salary, e1.department_id
	FROM employees e1
	WHERE e1.salary > (
									SELECT AVG(e2.salary)
									FROM employees e2
									WHERE e2.department_id = e1.department_id
									);
	
	# 方式2:
	SELECT e1.last_name, e1.salary, e1.department_id
	FROM employees e1 JOIN (
			SELECT department_id ,AVG(salary) AS "avg_salary"
			FROM employees
			WHERE department_id IS NOT NULL
			GROUP BY department_id
	) sub ON e1.department_id = sub.department_id AND e1.salary > sub.avg_salary;
	
	# 查询员工的id,salary,按照department_name排序
	SELECT e.employee_id, e.salary, d.department_name
	FROM employees e LEFT JOIN departments d
	ON e.department_id = d.department_id
	ORDER BY d.department_name;
	
	# 结论：除了GROUP BY 和 LIMIT之外，其他位置都可以声明子查询
	
	# 若employees表中employee_id与job_history表中employee_id相同的数目不小于2，
	# 输出这些相同id的员工的employee_id, last_name,job_id
	SELECT e.employee_id, e.last_name, e.job_id
	FROM employees e
	WHERE 2 <= (
							SELECT COUNT(*)
							FROM job_history j 
							WHERE j.employee_id = e.employee_id
					  	);
	
	
	# 6.2 EXISTS 与 NOT EXISTS 关键字
	
	# 查询公司管理者的employee_id, last_name, job_id, department_id信息
	# 方式1
	SELECT employee_id, last_name, job_id, department_id
	FROM employees
	# IN 有自定去重的功能，不用写DISTINCT也可以 
	WHERE employee_id IN (
												SELECT DISTINCT manager_id
												FROM employees
												WHERE manager_id IS NOT NULL
												);
											
	# 方式2：使用EXISTS
	SELECT e1.employee_id, e1.last_name, e1.job_id, e1.department_id
	FROM employees e1
	WHERE EXISTS(
								SELECT *
								FROM employees e2
								WHERE e1.employee_id = e2.manager_id
	)
	
	# 查询departments表中，不存在于employees表中的部门的department_name
	# 方式1
	select e.employee_id, d.department_name
	FROM employees e RIGHT JOIN departments d 
	ON e.department_id = d.department_id
	WHERE e.department_id IS NULL;
	
	# 方式2
	SELECT d.department_name
	FROM departments d
	WHERE NOT EXISTS (
										SELECT *
										FROM employees e 
										WHERE d.department_id = e.department_id	
										);
	
	# 练习1. 查询和Zlotkey相同部门的员工姓名和工资
	SELECT e1.department_id, e1.last_name, e1.salary
	FROM employees e1 JOIN(
											SELECT e2.department_id
											FROM employees e2
											WHERE	e2.last_name = 'Zlotkey'		
											) sub
	ON e1.department_id = sub.department_id;
	
	
	# 练习2.查询工资比公司平均工资高的员工的员工号，姓名和工资
	SELECT employee_id, last_name, salary
	FROM employees JOIN (
											SELECT AVG(salary) AS "avg_salary"
											FROM employees
											) sub
	ON salary > sub.avg_salary;
	
 # 练习3：选择工资大于所有job_id = 'SA_MAN'的工资的员工的last_name,job_id,salary 
	SELECT e1.last_name, e1.job_id, e1.salary 
	FROM employees e1 
	WHERE e1.salary > ALL (SELECT e2.salary "salary"
												 FROM employees e2
												 WHERE e2.job_id = 'SA_MAN'
												 );

# 练习4： 查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT e.employee_id, e.last_name, e.department_id
FROM employees e JOIN (
									SELECT DISTINCT department_id
									FROM employees 
									WHERE last_name LIKE "%u%"
									) sub 
ON e.department_id = sub.department_id;

# 练习5： 查询在部门的location_id为1700的部门工作的员工的员工号
SELECT e.employee_id
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE d.location_id = 1700


# 练习6： 查询管理者是King的员工姓名和工资
SELECT e.last_name, e.salary, e.manager_id
FROM employees e JOIN (
												SELECT employee_id
												FROM employees
												WHERE last_name = 'King'
												)	sub
ON e.manager_id = sub.employee_id;
	
SELECT e1.last_name, e1.salary
FROM employees e1
WHERE EXISTS (
							SELECT *
							FROM employees e2
							WHERE e1.manager_id = e2.employee_id
							AND e2.last_name = 'King'
							);
							
# 练习7：查询工资最低的员工信息：last_name, salary 
SELECT last_name, salary
FROM employees JOIN (
										SELECT MIN(salary) "min_salary"
										FROM employees
										)	sub
ON salary = sub.min_salary;

SELECT last_name, salary
FROM employees
ORDER BY salary 
LIMIT 1;											
	
# 练习8：查询平均工资最低的部门信息
SELECT * 
FROM departments 
WHERE department_id = (SELECT department_id
											 FROM employees
											 GROUP BY department_id
											 HAVING AVG(salary) = (
																		SELECT MIN(avg_sal)
																		FROM (SELECT AVG(salary) AS "avg_sal"
																				  FROM employees
																					GROUP BY department_id) t_dept_avg_sal
											)	);


SELECT * 
FROM departments 
WHERE department_id = (SELECT department_id
											 FROM employees
											 GROUP BY department_id
											 HAVING AVG(salary) <= ALL (
																							SELECT AVG(salary)
																							FROM employees
																							GROUP BY department_id
																							)
												);
# 练习9：查询平均工资最低的部门信息和该部门的平均工资
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) <= ALL(SELECT AVG(salary) 
													FROM employees
													GROUP BY department_id)


SELECT d.*, (SELECT AVG(salary) FROM employees WHERE department_id = d.department_id) avg_sal
FROM departments d ,(SELECT department_id, AVG(salary) "avg_sal"
											FROM employees
											GROUP BY department_id
											ORDER BY avg_sal ASC
											LIMIT 1) t_avg_sal
WHERE d.department_id = t_avg_sal.department_id;


	
# 练习10：查询平均工资最高的job信息	
SELECT *
FROM jobs
WHERE job_id = (SELECT job_id
								FROM employees
								GROUP BY job_id
								HAVING AVG(salary) >= ALL (	SELECT AVG(salary)
																						FROM employees
																						GROUP BY job_id));

	
# 练习11：查询平均工资高于公司平均工资的部门有哪些？

SELECT department_id, AVG(salary) "dept_avg_sal"
FROM employees
WHERE department_id IS NOT NULL 
GROUP BY department_id
HAVING 	dept_avg_sal > (SELECT AVG(salary)
												FROM employees);
	

# 练习12：查询公司中所有manager的详细信息
SELECT *
FROM employees m
WHERE EXISTS (
							SELECT *
							FROM employees e
							WHERE m.employee_id = e.manager_id
							);

# IN 的语句通常可以写成EXIST的形式
SELECT *
FROM employees
WHERE employee_id IN (
										SELECT DISTINCT manager_id
										FROM employees
										);

SELECT DISTINCT m.* 
FROM employees e, employees m 
WHERE m.employee_id = e.manager_id
	
# 练习13：计算各个部门的最高工资，并在这些部门的最高工资中找出最低的那个部门，显示这个部门的最低工资是多少
	SELECT MIN(salary)
	FROM employees 
	WHERE department_id = (	SELECT department_id
													FROM employees
													GROUP BY department_id 
													HAVING MAX(salary) <= ALL (
																											SELECT MAX(salary)
																											from employees
																											GROUP BY department_id))
	

	
	
# 练习14：查询平均工资最高的部门的manager的详细信息：last_name, department_id, email, salary

SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN (
										SELECT  DISTINCT manager_id
										FROM employees
										WHERE department_id = (
																					SELECT department_id
																					FROM employees
																					GROUP BY department_id
																					ORDER BY AVG(salary) DESC
																					LIMIT 1
																					)
										);
	
	
	
# 练习15：查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号

SELECT department_id 
FROM departments
WHERE department_id NOT IN(
												SELECT department_id
												FROM employees
												WHERE job_id = 'ST_CLERK');

	
	
# 练习16：选择所有没有管理者的员工的last_name
SELECT last_name
FROM employees
WHERE manager_id IS NULL;	
	
SELECT last_name
FROM employees e
WHERE NOT EXISTS(
								SELECT *
								FROM employees m
								WHERE e.manager_id = m.employee_id
							);
	

# 练习17：查询员工号、姓名、雇佣时间、工资，其中员工的管理者为'De Haan'
SELECT e.employee_id, e.last_name, e.hire_date, e.salary
FROM employees e JOIN (
										SELECT employee_id
										FROM employees
										WHERE last_name = 'De Haan'
										) sub 
ON e.manager_id = sub.employee_id;
	
	
# 练习18：查询各个部门中工资比本部门平均工资高的员工的员工号，姓名和工资
SELECT e.employee_id, e.last_name, e.salary
FROM employees e
WHERE salary > (
								SELECT AVG(salary)
								FROM employees
								GROUP BY department_id
								HAVING department_id = e.department_id
								);

SELECT e.employee_id, e.last_name, e.salary
FROM employees e
WHERE e.salary > (
								SELECT AVG(salary)
								FROM employees
								WHERE department_id = e.department_id
								);
								
# 练习19：查询每个部门下的部门人数大于5的部门名称
SELECT d.department_name
FROM departments d JOIN (
											SELECT department_id, COUNT(employee_id) "count"
										  FROM employees
											WHERE department_id IS NOT NULL
										  GROUP BY department_id) sub 
ON d.department_id = sub.department_id AND sub.count > 5;


# 练习20：查询每个国家下的部门个数大于2的国家编号
SELECT l.country_id
FROM locations l JOIN (
										SELECT location_id, COUNT(department_id) "count"
										FROM departments
										GROUP BY location_id) sub
ON l.location_id = sub.location_id AND sub.count > 2;
	
	
	
	
	
	
	
	
	
	
	
	