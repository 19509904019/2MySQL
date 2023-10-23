# 1.窗口函数

/*

	窗口函数本质也是分组，跟 GROUP BY 不同的是，窗口函数不像 GROUP BY 将数据整合到一起，
	而是按照数据表中的数据进行分组进行排列，可以在分组的组内对数据继续进行排序

*/
	# 使用窗口函数前后对比
-- 	CREATE TEMPORARY TABLE 表名   # 创建临时表

	CREATE TABLE goods(
		id INT PRIMARY KEY AUTO_INCREMENT,
		category_id INT,
		category VARCHAR(15),
		NAME VARCHAR(30),
		price DECIMAL(10,2),
		stock INT,
		upper_time DATETIME
		);
		
		INSERT INTO goods(category_id,category,NAME,price,stock,upper_time)
		VALUES
		(1, '女装/女士精品', 'T恤', 39.90, 1000, '2020-11-10 00:00:00'),
		(1, '女装/女士精品', '连衣裙', 79.90, 2500, '2020-11-10 00:00:00'),
		(1, '女装/女士精品', '卫衣', 89.90, 1500, '2020-11-10 00:00:00'),
		(1, '女装/女士精品', '牛仔裤', 89.90, 3500, '2020-11-10 00:00:00'),
		(1, '女装/女士精品', '百褶裙', 29.90, 500, '2020-11-10 00:00:00'),
		(1, '女装/女士精品', '呢绒外套', 399.90, 1200, '2020-11-10 00:00:00'),
		(2, '户外运动', '自行车', 399.90, 1000, '2020-11-10 00:00:00'),
		(2, '户外运动', '山地自行车', 1399.90, 2500, '2020-11-10 00:00:00'),
		(2, '户外运动', '登山杖', 59.90, 1500, '2020-11-10 00:00:00'),
		(2, '户外运动', '骑行装备', 399.90, 3500, '2020-11-10 00:00:00'),
		(2, '户外运动', '运动外套', 799.90, 500, '2020-11-10 00:00:00'),
		(2, '户外运动', '滑板', 499.90, 1200, '2020-11-10 00:00:00');
		
		SELECT * FROM goods;
		
		# 1. 序号函数
			#1.1 ROW_NUMBER()函数
			
			# 查询goods数据表中每个商品分类下价格降序排序的各个商品信息
			SELECT ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num,
			id, category_id, category, NAME, price, stock 
			FROM goods;
			
			
			# 查询goods数据表中每个商品分类下价格最高的3种商品信息
			SELECT * 
			FROM (
						SELECT ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num,
						id, category_id, category, NAME, price, stock 
						FROM goods) t 
			WHERE row_num <= 3;
			
			
			#1.2 RANK()函数
			# 使用RANK()函数获取goods数据表中各类别的价格从高到低排序的各商品信息
			SELECT RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num,
			id, category_id, category, NAME, price, stock 
			FROM goods;
			
			
			# 1.3 DENSE_RANK()函数
			# 使用 DENSE_RANK() 函数获取 goods 数据表中各类别的价格从高到低排序的各商品信息
			SELECT DENSE_RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num,
			id, category_id, category, NAME, price, stock 
			FROM goods;
			
			
		# 2.分布函数
			#2.1 PERCENT_RANK()函数
			
			# 计算goods数据表中名称为"女装 / 女士精品"的类别下的商品的 PERCENT_RANK值
			SELECT RANK() OVER w AS r,
			PERCENT_RANK() OVER w AS pr,
			id, category_id, category, NAME, price, stock 
			FROM goods
			WHERE category_id = 1 WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);
			
			
			#2.2 CUME_DIST()函数
				# 查询goods数据表中小于或等于当前价格的比例
				SELECT CUME_DIST() OVER(PARTITION BY category_id ORDER BY price ASC) AS cd,
				id, category, NAME, price 
				FROM goods;
				
		#	3. 前后函数
			# 3.1 LAG(expr,n) 函数
			# 查询goods数据表中前一个商品价格与当前商品价格的差值
			
			SELECT id, category, NAME, price, pre_price, price - pre_price AS diff_price	
			FROM (
						SELECT id, category, NAME, price, LAG(price, 1) OVER w AS pre_price 
						FROM goods 
						WINDOW w AS (PARTITION BY category_id ORDER BY price)) t;
				
			# 3.2 LEAD(expr,n)函数
			SELECT id, category, NAME, price, pre_price, -(price - pre_price) AS diff_price	
			FROM (
						SELECT id, category, NAME, price, LEAD(price, 1) OVER w AS pre_price 
						FROM goods 
						WINDOW w AS (PARTITION BY category_id ORDER BY price)) t;
				
				
		# 4. 首尾函数
			# 4.1 FIRST_VALUE(expr)函数
			# 按照价格排序，查询第1个商品的价格信息
			SELECT id, category, NAME, price, stock, FIRST_VALUE(price) OVER w AS first_price
			FROM goods
			WINDOW w AS (PARTITION BY category_id ORDER BY price);
			
			# 4.2 LAST_VALUE(expr)函数
			SELECT id, category, NAME, price, stock, LAST_VALUE(price) OVER w AS last_price
			FROM goods
			WINDOW w AS (PARTITION BY category_id ORDER BY price 
									RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);	
				
				
		
		# 5.其他函数 
		 # 5.1 NTH_VALUE(expr,N)函数
			# 查询goods数据表中排名第3和第4的价格信息
			SELECT id, category, NAME, price,
			NTH_VALUE(price,2) OVER (PARTITION BY category_id ORDER BY price) AS second_price,
			NTH_VALUE(price,3) OVER (PARTITION BY category_id ORDER BY price) AS third_price
			FROM goods;
			
		  # 5.2 NTILE(N)函数
				# 将goods表中的商品按照价格分为3组
				SELECT NTILE(3) OVER (PARTITION BY category_id ORDER BY price) AS nt, id, category, NAME, price 
				FROM goods;
				
			
				
				
				
				
				
				
				