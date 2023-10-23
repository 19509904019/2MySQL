# 1. 排序

# 如果没有使用排序操作，默认情况下查询返回的数据是按照添加数据的顺序显示的
SELECT * FROM employees;
# 1.1 基本使用
	# 使用 ORDER BY 对查询的数据进行排序操作
	# 升序：ASC（ascend）
	# 降序：DESC（descend）


# 练习：按照salary从高到低的顺序显示员工信息
SELECT last_name,salary
FROM employees
ORDER BY salary DESC;


# 练习：按照salary从高到低的顺序显示员工信息
SELECT last_name,salary
FROM employees
ORDER BY salary ASC;

SELECT last_name,salary
FROM employees
ORDER BY salary;  # 如果在ORDER BY 后没有显式指明排序的方式的话，则默认按照升序排列

# 1.2 按照列的别名进行排序
SELECT last_name,salary, 12* salary annual_sal
FROM employees
ORDER BY annual_sal DESC;

# 列的别名只能在 ORDER BY 中使用，不能在WHERE中使用
# 如下操作报错
SELECT last_name,salary, 12* salary annual_sal
FROM employees
WHERE annual_sal > 12000;


# 1.3 强调格式：WHERE 需要声明在FROM后，ORDER BY之前
SELECT employee_id,salary
FROM employees
WHERE department_id IN (50,60,70)
ORDER BY department_id DESC;


# 1.4 二级排序
# 显示员工信息，按照department_id降序排列，salary升序排列
SELECT employee_id,salary,department_id
FROM employees
ORDER BY department_id DESC, salary ASC;




# 2. 分页

# 2.1 mysql使用LIMIT实现数据的分页显示
# 每页显示20条记录，此时显示第一页
SELECT employee_id,last_name
FROM employees
LIMIT 0,20;

# 每页显示20条记录，此时显示第二页
SELECT employee_id,last_name
FROM employees
LIMIT 20,20;

# 每页显示pageSize条记录，此时显示第pageNo页
# LIMIT (pageNo - 1) * pageSize, pageSize;


# 2.2 WHERE ... ORDER BY ... LIMIT 声明顺序如下：

# LIMIT格式：严格来说，LIMIT位置偏移量，条目数
# 结构"LIMIT0， 条目数"等价于 "LIMIT 条目数"
	SELECT employee_id,last_name,salary
	FROM employees
	WHERE salary > 6000
	ORDER BY salary DESC
-- 	LIMIT 0,10;
	LIMIT 10;
	
# 练习：表里有107条数据，显示第32、33条数据
	SELECT employee_id,last_name,salary
	FROM employees
	WHERE salary > 6000
	ORDER BY salary DESC
	LIMIT 31,2;

# 2.3 MySQL8.0新特性：LIMIT...OFFSET...
# 练习：表里有107条数据，显示第32、33条数据
	SELECT employee_id,last_name,salary
	FROM employees
	WHERE salary > 6000
	ORDER BY salary DESC
	LIMIT 2 OFFSET 31;

# 练习：查询员工表中工资最高的员工信息
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1;


#练习1：查询员工的姓名和部门号和年薪，按年薪降序，按姓名升序显示
SELECT last_name,department_id,salary * 12 annual_salary
FROM employees
ORDER BY annual_salary DESC,last_name ASC;


# 练习2：选择工资不在8000到17000的员工的姓名和工资，按工资降序，显示第21到40位置的数据
SELECT last_name,salary
FROM employees
WHERE NOT salary BETWEEN 8000 AND 17000
ORDER BY  salary DESC
LIMIT 20,20;


# 练习3：查询邮箱中包含 e 的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT * 
FROM employees
WHERE email LIKE '%e%'
-- WHERE email REGEXP '[e]'
ORDER BY LENGTH(email) DESC, department_id ASC;



