# 1.算数运算符： + - * / div % mod 

SELECT 100, 100 + 1, 100 / 3, 100 DIV 3,100 % 3,100 MOD 3
FROM DUAL;

SELECT 100 + '1' 
FROM DUAL;    # 在Java语言中结果是1001，而在SQL中 + 没有连接的作用，就表示加法运算

SELECT 100 + 'a'
FROM DUAL;	# 此时将a看作是0来处理

# 练习：查询员工id为偶数的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE employee_id % 2 = 0;				   


# 2. 比较运算符
# 2.1 =   <=>   <>  !=  <  <=  >   >=
SELECT 0 = 'a'
FROM DUAL;  # 字符串存在隐式转换，如果转换数值不成功，则看做0

SELECT 1 = NULL, NULL = NULL
FROM DUAL;  # 只要有null参与判断，结果就为null


SELECT last_name, salary
FROM employees
-- WHERE salary = 6000;
WHERE commission_pct = NULL;  # 此时执行不会有任何结果


# <=>:安全等于
SELECT 1 <=> 2, 1 <=> 1, 1 <=> 'a',0 <=> 'a'
FROM DUAL;  # 此时的结果和 = 的结果一样


SELECT NULL <=> NULL, NULL<=> 1
FROM DUAL;   # 此时两边为null则返回1 

# 练习：查询表中 commission_pct 为 NULL 的数据有哪些 
SELECT last_name, salary
FROM employees
WHERE commission_pct <=> NULL; 


# 2.2
# ① IS NULL / IS NOT NULL / ISNULL

# 练习：查询表中 commission_pct 为 NULL 的数据有哪些 
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NULL;

# 练习：查询表中 commission_pct 不为 NULL 的数据有哪些 
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

SELECT last_name,salary,commission_pct
FROM employees
WHERE NOT commission_pct <=> NULL;

SELECT last_name,salary,commission_pct
FROM employees
WHERE !(commission_pct <=> NULL);

SELECT last_name,salary,commission_pct
FROM employees
WHERE NOT ISNULL(commission_pct);

SELECT last_name,salary,commission_pct
FROM employees
WHERE !(ISNULL(commission_pct));

# ② LEAST(value1,value2,...)  / GREATEST(value1,value2,...)
SELECT LEAST('a','g','v','aa'), GREATEST('ad','tg','fc','yj')
FROM DUAL;

SELECT LEAST(first_name,last_name), LEAST(LENGTH(first_name),LENGTH(last_name))
FROM employees;


# ③  BETWEEN 条件①  AND 条件②  (查询条件1和条件2范围内的数据，包含边界)
# 查询工资在 6000 到 8000的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE salary BETWEEN 6000 AND 8000;


SELECT employee_id,last_name,salary
FROM employees
WHERE salary >= 6000 AND salary <= 8000;


SELECT employee_id,last_name,salary
FROM employees
WHERE salary >= 6000 && salary <= 8000;


SELECT employee_id,last_name,salary
FROM employees
WHERE salary NOT BETWEEN 6000 AND 8000;

# ④ IN(set)  / NOT IN(set)
# 练习： 查询部门为10，20，30部门员工的员工信息
SELECT department_id,employee_id,last_name
FROM employees
WHERE department_id = 10 OR department_id = 20 OR department_id = 30;

SELECT department_id,employee_id,last_name
FROM employees
WHERE department_id in (10,20,30);

# 练习：查询工资不是6000，7000，8000的员工信息
SELECT employee_id, salary
FROM employees
WHERE salary != 6000 AND salary != 7000 AND salary != 8000;

SELECT employee_id, salary
FROM employees
WHERE salary NOT IN(6000,7000,8000);


# ⑤ LIKE：模糊查询

# 练习：查询last_name中包含字符'a'的员工信息
SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE '%a%';


# 练习：查询last_name中包含以字符'a'开头的员工信息
SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE 'a%'; 


SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE '%a';  # 以字符'a'结尾的


# 练习：查询last_name中包含字符'a'且包含字符'e'的员工信息
SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';

SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE '%a%e%' OR '%e%a%';

# 查询第二个字符为'a'的员工信息: _ 一个下划线代表一个不确定的字符
SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE '_a%';

# 查询第2个字符是 _ 且第3个字符是'a'的员工信息: 需要使用转义字符
SELECT employee_id,last_name
FROM employees
WHERE last_name LIKE '_\_a%';


# ⑥ REGEXP(regular express) / RLIKE：正则表达式


# 3. 逻辑运算符： OR ||  AND && NOT !  XOR:异或（一个满足一个不满足）


# 4. 位运算符：&  |  ~  ^   >>   <<  



# 练习

# 1. 选择工资不在5000到12000的员工的姓名和工资
SELECT last_name,salary
FROM employees
WHERE NOT salary BETWEEN 5000 AND 12000;


# 2.选择在20或50号部门工作的员工姓名和部门号
SELECT last_name,department_id
FROM employees
WHERE department_id IN (20,50);



# 3.选择公司中没有管理者的员工姓名及job_id
SELECT last_name,job_id
FROM employees
WHERE manager_id IS NULL;
	
	
# 4.选择公司中有奖金的员工姓名，工资和奖金级别
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;


# 5.选择员工姓名的第三个字母是a的员工姓名
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';



# 6.选择姓名中有字母a和k的员工姓名
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%k%' OR last_name LIKE '%k%a%';

SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%k%';


# 7. 显示出表 employees 表中 first_name 以'e'结尾的员工信息
SELECT * 
FROM employees
WHERE first_name LIKE '%e';

SELECT * 
FROM employees
WHERE first_name REGEXP 'e$';


# 8.显示出表 employees 部门编号在80-100之间的姓名、工种
SELECT last_name,job_id
FROM employees
WHERE department_id BETWEEN 80 AND 100;


 # 9. 显示出表 employees 的 manager_id 是100,101,110的员工姓名、工资、管理者id

SELECT last_name,salary,manager_id
FROM employees
WHERE manager_id IN (100,101,110);
