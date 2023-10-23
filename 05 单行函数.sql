# 1. 常用函数
SELECT ROUND(-12.52)  # 加0.5向上取整
FROM DUAL;

# 截断：TRUNCATE
SELECT TRUNCATE(12.542,2)
FROM DUAL;

SELECT TRUNCATE(12.542,0)
FROM DUAL;

# 角度与弧度的互换
SELECT RADIANS(30), DEGREES(2 * PI())
FROM DUAL;

# 三角函数的参数为弧度值
SELECT SIN(RADIANS(30))
FROM DUAL;

# 指数和对数  POW(X,Y) POWER(X,Y) EXP(X) LN(X)

# 进制间的转换 BIN(N) OCT(N)  HEX(N_or_S) 
# CONV(N,from_base,to_base) 进制从from_base转换到to_base
SELECT CONV(10010101,2,10)
FROM DUAL;


# 2. 字符串函数
# ASCII(str)  CHAR_LENGTH(str)：字符个数 LENGTH(str)；字节长度
# CONCAT(str1,str2,...)：字符串连接 CONCAT_WS(separator,str1,str2,...):分隔符写在前
SELECT CONCAT_WS('-','hello','world','!')
FROM DUAL;

# INSERT(str,pos,len,newstr):用newstr替换str中从pos到len的字符，索引从1开始
# REPLACE(str,from_str,to_str):直接替换字符
# LEFT(str,len):从左取字符  RIGHT(str,len)：从右取字符
SELECT INSERT('helloworld',2,5,'aaa'),REPLACE('helloworld','ll','lol')
FROM DUAL;


# LPAD(str,len,padstr):右对齐，在左边填充
# RPAD(str,len,padstr):左对齐，在右边填充
# LTRIM(str) RTRIM(str)  TRIM(str)
# TRIM(s1 FROM s):去除字符串s开始与结尾的s1
# TRIM(LEADING s1 FROM s):去除字符串s开始处的s1
# TRIM(TRAILING s1 FROM s):去除字符串s结尾处的s1
# REPEAT(str,count):返回str重复n次的结果
# SPACE(N)
# STRCMP(expr1,expr2)
# SUBSTR(str,pos,len)：取子字符串
# LOCATE(substr,str):substr首次在str出现的位置
# ELT(N,str1,str2,str3,...)；根据N返回字符串str1、str2、str3...
# FIND_IN_SET(str,strlist):返回字符串s1在字符串s2中出现的位置
# FIELD(str,str1,str2,str3,...)：返回字符串str在字符串列表中第一次出现的位置
# NULLIF(expr1,expr2)：相等返回NULL，不相等返回expr1


# 3. 日期和时间函数
-- 	3.1 获取日期、时间
SELECT CURDATE(),CURRENT_DATE,CURRENT_TIME,CURTIME(),NOW(),SYSDATE(),
UTC_DATE(),UTC_TIME()
FROM DUAL;

-- 3.2 日期与时间戳的转换
SELECT UNIX_TIMESTAMP(),UNIX_TIMESTAMP('2023-10-17 17:16:52')
FROM DUAL;

-- 3.3 获取月份、星期、星期数、天数等函数
SELECT YEAR(CURRENT_DATE),MONTH(CURRENT_DATE),DAY(CURRENT_DATE),
HOUR(CURRENT_TIME),MINUTE(CURRENT_TIME),SECOND(CURRENT_TIME)
FROM DUAL;

# EXTRACT(unit FROM date):返回指定日期中特定的部分，type指定返回的值

# TIME_TO_SEC(time)  SEC_TO_TIME(seconds)

# 计算日期和时间的函数
SELECT DATE_ADD(CURRENT_DATE,INTERVAL -1 YEAR)
FROM DUAL;

#格式化：DATE_FORMAT(date,format)
SELECT DATE_FORMAT(CURRENT_DATE,"%Y-%m-%d")
FROM DUAL;
# 解析：STR_TO_DATE(str,format)

# 4.流程控制函数
# IF(VALUE,VALUE1,VALUE2)
SELECT last_name,salary,IF(salary >= 6000,'高工资','低工资')
FROM employees;


# IFNULL(expr1,expr2):如果expr1的值不为NULL则返回当前值，为NULL则返回expr2
SELECT last_name,commission_pct, IFNULL(commission_pct,0) AS "details"
FROM employees;

#   CASE case_value
-- 	WHEN when_value THEN
-- 		statement_list
-- 	ELSE
-- 		statement_list
-- END CASE;
-- 相当于if...else...结构
SELECT salary, last_name, CASE WHEN salary > 15000 THEN '高富帅'
															 WHEN salary > 10000 THEN '白富美'
														   WHEN salary > 80000 THEN '潜力股'
						                   ELSE '' END 'details'
FROM employees;
						
/*

练习1： 
查询部门号为10，20，30的员工信息，若部门号为
10则打印其工资的1.1倍
20号部门则打印其工资的1.2倍
30号部门则打印其工资的1.3倍
其他部门打印工资的1.4倍

*/
SELECT department_id,salary,CASE WHEN department_id = 10 THEN salary * 1.1
						WHEN department_id = 20 THEN salary * 1.2
						WHEN department_id = 30 THEN salary * 1.3
						ELSE salary * 1.4 END "details"
FROM employees;


/*

练习2： 
查询部门号为10，20，30的员工信息，若部门号为
10则打印其工资的1.1倍
20号部门则打印其工资的1.2倍
30号部门则打印其工资的1.3倍

*/
SELECT department_id,salary,CASE WHEN department_id = 10 THEN salary * 1.1
																 WHEN department_id = 20 THEN salary * 1.2
																 WHEN department_id = 30 THEN salary * 1.3
																END "details"
FROM employees
WHERE department_id IN (10,20,30);

# 5.加密与解密
SELECT PASSWORD('yujun')
FROM DUAL;  # PASSWORD(str)在mysql8.0弃用

SELECT MD5('yujun') AS "MD5",SHA('yujun') AS "SHA"
FROM DUAL;

# 6. MySQL信息函数
SELECT VERSION(), CONNECTION_ID(),DATABASE(),SCHEMA();

# 7. 其他函数
SELECT FORMAT(132.123,2) AS "format";

# BENCHMARK(count,expr)用于测试表达式的执行效率
SELECT BENCHMARK(10000000,MD5('mysql'));

# CHARSET(str)
SELECT CHARSET('yujun'),CHARSET(CONVERT('yujun' USING 'gbk'));


# 练习1：显示系统时间
SELECT NOW(),SYSDATE(),LOCALTIME,LOCALTIMESTAMP;

# 练习2：查询员工号，姓名，工资，以及工资提高20%后的结果
SELECT employee_id, last_name, salary, salary * 1.2 "new salary"
FROM employees;

# 练习3：将员工的姓名按首字母排序，并写出姓名的长度
SELECT last_name, LENGTH(last_name) AS "length"
FROM employees
ORDER BY last_name ASC;
# 练习4：查询员工id,last_name,salary,并作为一个列输出，别名OUT_PUT
SELECT CONCAT(employee_id, ',',last_name, ',',salary) AS "OUT_PUT"
FROM employees;

# 练习5：查询公司各员工工作的年数、工作的天数，并按工作年数的降序排序
SELECT DATEDIFF(CURRENT_DATE, hire_date) / 365 AS "years", DATEDIFF(CURRENT_DATE, hire_date) AS "days",TO_DAYS(CURRENT_DATE) - TO_DAYS(hire_date) " days1"
FROM employees
ORDER BY years DESC;

# 练习6：查询员工姓名,hire_date,department_id,满足以下条件：雇佣时间在1997年之后，
#				  department_id 为 80 或 90 或 110，commission_pct 不为空
SELECT last_name, hire_date, department_id
FROM employees
WHERE YEAR(hire_date) >= 1997 
AND department_id IN (80,90,110)
AND commission_pct IS NOT NULL;

# 练习7：查询公司中入职超过10000天的姓名、入职时间
SELECT last_name, hire_date, DATEDIFF(CURRENT_DATE, hire_date) AS "days"
FROM employees
WHERE DATEDIFF(CURRENT_DATE, hire_date) > 10000;

# 练习8：做一个查询，产生下面的结果
SELECT CONCAT(last_name, ' earns ', TRUNCATE(salary,0), ' monthly but wants ',salary * 3) AS "Dream Salary"
FROM employees;

# 练习9：流程控制
SELECT last_name,job_id, CASE job_id WHEN'AD_PRES' THEN 'A'
																	   WHEN'ST_MAN' THEN 'B'
																		 WHEN 'IT_PROG' THEN 'C'
																		 WHEN'SA_REP' THEN 'D'
																		 WHEN'ST_CLERK' THEN 'E'
																		 END "Grade"
FROM employees;




