# 1. 创建触发器语法
	/*
	CREATE TRIGGER 触发器名称
	{BEFORE | AFTER} {INSERT | UPDATE | DELETE} ON 表名
	FOR EACH ROW
	触发器执行的语句块;
	*/
	
	CREATE TABLE test_trigger_log(
		id INT PRIMARY KEY AUTO_INCREMENT,
		t_log VARCHAR(30)
	);
	
	CREATE TABLE test_trigger(
		id INT PRIMARY KEY AUTO_INCREMENT,
		t_note VARCHAR(30)
	);
	
	# ① 创建触发器
  # 创建名称为before_insert_test_tri的触发器，向test_trigger数据表插入数据之前，
	# 向test_trigger_log数据表中插入before_insert的日志信息
	
	CREATE TRIGGER before_insert_test_tri
	BEFORE INSERT ON test_trigger 
	FOR EACH ROW
	BEGIN
			 INSERT INTO test_trigger_log(t_log)
			 VALUES('before insert ...');
	 END
	 
	 
	 # ② 测试
	 INSERT INTO test_trigger(t_note)
	 VALUES('Tom...');
		
	 SELECT * FROM test_trigger;
		
	 SELECT * FROM test_trigger_log; 
	
	
	/*
		定义触发器"salary_check_trigger"，基于员工表"employees"的INSERT事件，
	  在INSERT之前检查将要添加的新员工薪资是否大于他领导的薪资，如果大于领导
		薪资，则报sqlstate_value为'HY000'的错误，从而使得添加失败
	*/
		CREATE TRIGGER salary_check_trigger
		BEFORE INSERT ON employees
		FOR EACH ROW 
		BEGIN
				DECLARE mgr_sal DOUBLE;
				
				SELECT salary INTO mgr_sal
				FROM employees
				WHERE employee_id = NEW.manager_id;  # 已经存在的数据用OLD.xxx
				
				IF NEW.salary > mgr.salar 
														THEN SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导薪资';
				END IF;
		END
	
	
	# 查看、删除触发器
		# 查看 
		SHOW TRIGGERS;
		
		SHOW CREATE TRIGGER salary_check_trigger;
		
		SELECT * 
		FROM information_schema.`TRIGGERS`;
	
		
		# 删除
		DROP TRIGGER salary_check_trigger;
	
	
	# 优点：
			/*
				1. 触发器可以确保数据得完整性
				（删除某一个数据使需要改变总数，总数没改变就是数据不一致）
				2. 触发器可以帮助我们记录操作日志
				3. 触发器还可以用在操作数据前，对数据进行合法性检查
			*/
	
	
	# 缺点：
			/*
				1. 触发器最大的一个问题就是可读性差
				2. 相关数据的变更，可能会导致触发器出错
			
			*/
	