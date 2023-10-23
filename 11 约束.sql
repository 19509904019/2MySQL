# 1. 基础知识
/*
		1.1 为什么需要约束？ 
				为了保证数据的完整性
				
		1.2 什么叫约束？
				对表中字段的限制
				
		1.3 约束的分类
				角度1：约束的字段的个数
						单列约束  vs  多列约束
						
				角度2：约束的作用范围
						列级约束： 将此约束声明在对应字段的后面
						表级约束： 在表中所有字段都声明完，在所有字段的后面声明的约束

				角度3：约束的作用(或功能)
						① not null (非空约束)
						② unique  (唯一性约束)
						③ primary key (主键约束) 
						④ foreign key (外键约束)
						⑤ check (检查约束)
						⑥ default (默认值约束)
						
			1.4 如何添加约束？
				CREATE TABLE 添加约束
				ALTER TABLE 时增加约束、删除约束
*/



# 2.如何查看表中的约束
SELECT *  FROM information_schema.TABLE_CONSTRAINTS
WHERE table_name = 'employees';


# 3. not null (非空约束)
	# 3.1 在 CREATE TABLE 时添加约束
		USE test01_office;
		SELECT DATABASE();
		
		CREATE TABLE test01(
		id INT NOT NULL,
		last_name VARCHAR(15) NOT NULL,
		email VARCHAR(25),
		salary DECIMAL(10,2)
		);

DESC test01;
SELECT * FROM test01;

	# 3.2 在 ALTER TABLE 时添加约束
	 ALTER TABLE test01 
	 MODIFY email VARCHAR(25) NOT NULL;

	#3.3 在 ALTER TABLE 中删除约束
	 ALTER TABLE test01 
	 MODIFY email VARCHAR(25) NULL;

# 4. 唯一性约束
		# 创建表时添加约束
		CREATE TABLE test02(
		id INT UNIQUE,  # 列级约束
		last_name VARCHAR(15) NOT NULL,
		email VARCHAR(25),
		salary DECIMAL(10,2),
		
		# 表级约束:CONSTRAINT 约束名 约束类型(字段名)
		CONSTRAINT uk_test2_email UNIQUE(email)
		
		# 在创建唯一约束的时候，如果不给唯一约束命名，就默认和列名相同
-- 		UNIQUE(email)
		);

		DESC test02;
		SELECT * FROM information_schema.TABLE_CONSTRAINTS
		WHERE table_name = 'test02';
		
		# 可以向声明位unique的字段上添加null值，w而且可以多次添加null

		
	# 4.2 在ALTER TABLE时添加约束:如下两种方式
	ALTER TABLE test02 
	ADD CONSTRAINT uk_test_salary UNIQUE(salary);
	
	ALTER TABLE test02 
	MODIFY salary DECIMAL(10,2) UNIQUE;


	# 4.3 复合的唯一性约束
	CREATE TABLE USER(
	id INT,
	`name`VARCHAR(10),
	`password` VARCHAR(30),
	
	# 表级约束
	CONSTRAINT uk_user_id_name UNIQUE(id,`name`)
	
	);

	INSERT INTO `user` 
	VALUES (1,'yujun','abc');

	INSERT INTO `user` 
	VALUES (1,'yujun1','abc');
	
	SELECT * FROM `user`;


	# 4.4 删除唯一性约束
		/**
			> 添加唯一性约束的列上也会自动创建唯一索引
			> 删除唯一约束只能通过删除唯一索引的方式删除
			> 删除时需要指定唯一索引名，唯一索引名就和唯一约束名一样
			> 如果创建唯一约束时未指定名称，如果是单列，就默认和列名相同；
				如果时组合列，那么默认和()中排在第一个的列名相同。
				也可以自定义唯一性的约束名
				
				
				ALTER TABLE test02 
				DROP INDEX 唯一索引名;
		
		*/

		ALTER TABLE test02 
		DROP INDEX id;




# 5. PRIMARY KEY 约束：不为空且唯一,用于唯一标识表中的一条记录

	# 5.1 在CREATE TABLE时添加约束 
		CREATE TABLE test03(
		id INT PRIMARY KEY,
		`name` VARCHAR(20),
		emai VARCHAR(30) UNIQUE,
		salary DECIMAL(10, 2)
		);
		
		INSERT INTO test03 
		VALUE (1,'yujun','132@163.com',15000);
		
		INSERT INTO test03 
		VALUE (1,'haiyan','132@163.com',12000);

		SELECT * FROM test03;
		
		#5.2 MySQL的主键名总是PRIMARY,在使用表级约束的时候没有必要起名字
		# 使用复合操作是，每一个主键字段都不可以为空
		CREATE TABLE test04(
		id INT,
		`name` VARCHAR(20),
		email VARCHAR(30) UNIQUE,
		salary DECIMAL(10, 2),
		
-- 		CONSTRAINT pk_test04_id PRIMARY KEY(id)  没必要
		PRIMARY KEY (id, email)
		);
		
		SELECT * from test04;
		
		INSERT INTO test04
		VALUES (1,'yujun','132@163.com',15000);
		
		INSERT INTO test04
		VALUES (1,'yujun','1232@163.com',15000);
		
		INSERT INTO test04
		VALUES (null,'yujun','1232@163.com',15000);
		
		
		# 5.3 在 ALTER TABLE 时添加约束
		ALTER TABLE 表名
		ADD PRIMARY KEY (字段名);
		
		ALTER TABLE test04 
		ADD PRIMARY KEY (`name`);
	

# 6. 自增长列：AUTO_INCREMENT 

		# 6.1 创建表时添加
		CREATE TABLE test05(
		id INT PRIMARY KEY AUTO_INCREMENT,
		`name` VARCHAR(20),
		email VARCHAR(30),
		salary DECIMAL(10, 2)
		);
		
		 # 开发中一旦主键作用的字段上声明有AUTO_INCREMENT，则我们再添加数据就不要给对应的字段去赋值
		INSERT INTO test05(`name`,email,salary)
		VALUE ('yujun','145@163.com',15000);
	
		SELECT * FROM test05;
		TRUNCATE TABLE test05;
		
		# 当我们像主键(含AUTO_INCREMENT)的字段上添加0或null时，实际上会自动往上添加指定字段的数值
		INSERT INTO test05(id,`name`,email,salary)
		VALUE (0,'yujun','145@163.com',15000);


		# 6.2 在 ALTER TABLE 时添加
			ALTER TABLE test05
			MODIFY id INT AUTO_INCREMENT;



		# 6.3 MySQL8.0新特性：自增变量的持久化
			# MySQL5.7将计数器放到内存中维护，MySQL8.0将计数器持久化到重做(redo)日志中


# 7.FOREIGN KEY 约束
		/*
		
		不同的表之间有级联关系需要用到外键约束
		在开发中，不得使用外键与级联，一切外键概念必须在应用层解决
		说明：学生表中的student-id为主键，那么成绩表中的student_id为外键。如果更新学生表中的
					student_id,同时触发成绩表中的student_id更新，即为级联更新。级联更新是强阻塞，存在
					数据库更新风暴的风险，外键影响数据库的插入速度
		
		*/


# 8. CHECK 约束：检查某个字段的值是否符合符号要求，一般指的是值的范围
			CREATE TABLE temp(
			id INT AUTO_INCRMENT,
			salary DECIMAL(10,2) CHECK(salary > 2000),
			PRIMARY KEY (id)
			);


# 9. DEFAULT约束
			# 9.1 在 CREATE TABLE 添加 DEFAULT 约束
			CREATE TABLE temp(
			id INT AUTO_INCRMENT,
			salary DECIMAL(10,2) DEFAULT 0,
			PRIMARY KEY (id)
			);
			
			# 9.2 在 ALTER TABLE 添加 DEFAULT 约束
			ALTER TABLE temp 
			MODIFY salary DECIMAL(10,2) DEFAULT 2000;

			# 9.3 在ALTER TABLE 删除DEFAULT约束
			ALTER TABLE temp 
			MODIFY salary DECIMAL(10,2);








