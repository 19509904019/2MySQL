# 熟悉常见的几个表
DESC employees;
DESC departments;
DESC locations;

# 1. 出现笛卡尔积错误:缺少了多表的连接条件
SELECT employee_id,last_name
FROM employees,departments; # 2889：每个员工都与部门匹配了一遍

SELECT employee_id FROM employees;  # 107
SELECT department_id FROM departments; # 27


# 2. 多表查询的正确方式：需要有连接条件
SELECT employee_id, department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id; 


# 3. 如果查询语句中出现了多个表都有的字段，则必须指明此字段所在的表
-- SELECT employee_id, department_name,department_id
SELECT employee_id, department_name,employees.department_id
FROM employees, departments
WHERE employees.department_id = departments.department_id; 

# 建议：从sql优化的角度，建议多表查询时每个字段前都指明其所在的表


# 4. 可以给表起别名，在 SELECT 和 WHERE 中使用表的别名
# 如果给表起了别名，一旦在SELECT和WHERE中使用表明的话，则必须使用表的别名，而不能再使用表的原名
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;


# 5. 如果有 n 个表实现多表的查询，则需要至少n-1个连接条件
# 练习：查询员工的employee_id, last_name, department_name, city

SELECT emp.employee_id,emp.last_name,dept.department_name, loc.city
FROM employees emp, departments dept, locations loc
WHERE emp.department_id = dept.department_id AND dept.location_id = loc.location_id;

# 6.多表查询的分类
/*

角度1：等值连接 vs 非等值连接

角度2：自连接 vs 非自连接

角度3：内连接 vs 外连接


*/

# 6.1 等值连接 vs 非等值连接
# 非等值连接的例子：
SELECT * 
FROM job_grades;


SELECT e.employee_id, e.last_name, j.grade_level
FROM employees e, job_grades j
WHERE salary BETWEEN j.lowest_sal AND j.highest_sal;


# 6.2 自连接 vs 非自连接

# 练习：查询员工id,员工姓名，管理者的id和姓名
SELECT e.employee_id, e.last_name,m.employee_id, m.last_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;


# 6.3 内连接 vs 外连接

#内连接：合并具有同一列的两个以上的表的行，结果集中不包含一个表与另一个表
#				 不匹配的行
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;

# 外连接：合并具有同一列的两个以上的表的行，结果集中除了包含一个表与另一个表
#         匹配的行之外，还查询到了左表 或 右表中不匹配的行

# 外连接的分类： 左外连接、右外连接、满外连接
	# 左外连接：两个表在连接过程中除了返回满足连接条件的行以外还返回左表中不满足
#             条件的行，这种连接称为左外连接

	# 右外连接：两个表在连接过程中除了返回满足连接条件的行以外还返回右表中不满足
#             条件的行，这种连接称为右外连接

# 练习：查询所有的员工的last_name,department_name信息
SELECT e.last_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

# SQL92语法实现外连接： 使用 +  ----MySQL不支持SQL92的外连接语法
SELECT e.last_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);

# SQL99语法中使用JOIN ... ON 的方式实现多表的查询。这种方式也能解决外连接的问题。
#SQL语法实现内连接：
SELECT e.last_name,d.department_name
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id;
# 可以省略INNER
SELECT e.last_name,d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id;


SELECT e.last_name,d.department_name,l.city
FROM employees e JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON l.location_id = d.location_id;


# SQL99 语法实现外连接：
# 练习：查询所有员工的last_name, department_name信息
# 左外连接
SELECT e.last_name,d.department_name
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id;

# 右外连接
SELECT e.last_name,d.department_name
FROM employees e RIGHT JOIN departments d
ON e.department_id = d.department_id;

# 7. 满全连接：MySQL不支持FULL OUTER JOIN 　
SELECT e.last_name,d.department_name
FROM employees e FULL JOIN departments d
ON e.department_id = d.department_id;

# 8. UNION 和 UNION ALL的使用
# UNION：会执行去重操作
# UNION ALL：不会执行去重操作
# 结论：如果明确知道合并数据后的结果数据不存在重复数据，或者不需要
#       去除重复的数据，则尽量使用UNION ALL语句，以提高数据查询的效率


# 9. 7种JOIN的实现：
# 9.1 内连接：
SELECT e.employee_id, d.department_name
FROM employees e JOIN departments d 
ON e.department_id = d.department_id;

# 9.2 左外连接
SELECT e.employee_id, d.department_name
FROM employees e LEFT JOIN departments d 
ON e.department_id = d.department_id;

# 9.3 右外连接
SELECT e.employee_id, d.department_name
FROM employees e RIGHT JOIN departments d 
ON e.department_id = d.department_id;

# 9.4 差集 A - B
SELECT e.employee_id, d.department_name
FROM employees e LEFT JOIN departments d 
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

# 9.5 差集 B - A
SELECT e.employee_id, d.department_name
FROM employees e RIGHT JOIN departments d 
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

# 9.6 满外连接
# UNION ALL 
SELECT e.employee_id, d.department_name
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id
UNION ALL
SELECT e.employee_id, d.department_id
FROM employees e RIGHT JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

# UNION
SELECT e.employee_id, d.department_name
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id
UNION
SELECT e.employee_id, d.department_name
FROM employees e RIGHT JOIN departments d
ON e.department_id = d.department_id;

# 9.7 补集
SELECT e.employee_id, d.department_name
FROM employees e LEFT JOIN departments d 
ON e.department_id = d.department_id
WHERE d.department_id IS NULL
UNION ALL
SELECT e.employee_id, d.department_name
FROM employees e RIGHT JOIN departments d 
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;


# 10. SQL99语法新特性1：自然连接
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
AND e.manager_id = d.manager_id;


SELECT e.employee_id, e.last_name, d.department_name
FROM employees e NATURAL JOIN departments d;

# 11. SQL99语法新特性2：USING
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
USING (department_id);


# 练习1：显示所有员工的姓名，部门号和部门名称
SELECT e.last_name, e.department_id, d.department_name
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id;

# 练习2：查询90号部门员工的job_id和90号部门的location_id
SELECT e.job_id, d.location_id
FROM employees e JOIN departments d 
ON e.department_id = d.department_id 
WHERE d.department_id = 90;

DESC departments;
DESC employees;
# 练习3：选择所有有奖金的员工的 last_name,department_name,location_id,city
SELECT * 
FROM employees
WHERE  commission_pct IS NOT NULL;  # 35条信息

SELECT e.last_name, d.department_name, d.location_id, l.city 
FROM employees e LEFT JOIN departments d 
ON e.department_id = d.department_id 
LEFT JOIN locations l 
ON d.location_id = l.location_id
WHERE e.commission_pct IS NOT NULL;


DESC employees;
# 练习4：选择city在Toronto工作的员工的last_name,job_id,department_id,department_name
SELECT e.last_name, e.job_id, d.department_id, d.department_name
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

DESC jobs;
# 练习5：查询员工所在的部门名称、部门地址、姓名、工作、工资，
#				 其中员工所在的部门的部门名称为'Executive'
SELECT d.department_name, l.street_address, e.last_name, e.job_id, e.salary
FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id
LEFT JOIN locations l
ON d.location_id = l.location_id
WHERE d.department_name = 'Executive';

# 练习6：选择指定员工的姓名、员工号，以及他的管理者的姓名和员工号
SELECT emp.last_name "emp_name", emp.employee_id "emp_id", emp.manager_id "mgr",mgr.employee_id "mgr_id"
FROM employees emp LEFT JOIN employees mgr
ON emp.manager_id = mgr.employee_id;

DESC departments;
# 练习7：查询哪些部门没有员工
SELECT department_name, employee_id
FROM employees e RIGHT JOIN departments d 
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;


DESC locations;
DESC departments;
# 练习8：查询哪个城市没有部门
SELECT l.city, d.department_name
FROM locations l LEFT JOIN departments d 
ON l.location_id = d.location_id
WHERE d.location_id IS NULL;

# 练习9：查询部门名为sales或IT的员工信息
SELECT * 
FROM departments d JOIN employees e
ON d.department_id = e.department_id
WHERE d.department_name IN ('sales','IT');