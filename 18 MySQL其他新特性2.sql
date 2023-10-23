# 公用表表达式
	# 1.普通公用表表达式
	WITH cte_emp
	AS (SELECT DISTINCT department_id FROM employees)
	SELECT *
	FROM departments d JOIN cte_emp e 
	ON d.department_id = e.department_id;
	
	
	# 2.递归公用表表达式
	# 找出公司employees表中所有的下下属
	WITH RECURSIVE cte
	AS
	(
	SELECT employee_id,last_name,manager_id,1 AS n 
	FROM employees WHERE employee_id = 100
	-- 种子查询，找到第一代领导
	UNION ALL
	SELECT a.employee_id,a.last_name,a.manager_id,n+1 
	FROM employees a JOIN cte
	ON a.manager_id = cte.employee_id -- 递归查询，找出以递归公用表表达式的人为领导的人
	)
	SELECT employee_id,last_name FROM cte WHERE n >= 3;