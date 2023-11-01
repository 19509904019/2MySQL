/*
概念：
    索引(index)是帮助数据库高效获取数据的数据结构
    格式： create index 索引名(idx_表名_字段名) on 表名(字段名)
    create index idx_employee on employees (employee_id);

    删除索引：drop index idx_employee on employees;

    查看索引：show index from 表名;

注意事项：
    > 主键字段，在建表时，会自动创建主键索引
    > 添加唯一约束时，数据库实际上会添加唯一索引

优缺点：
    优点：
        > 提高数据查询效率，降低数据库的IO成本
        > 通过索引列对数据进行排序，降低数据排序的成本，降低CPU消耗

    缺点：
        > 索引会占用存储空间
        > 索引大大提高了查询效率，同时却也降低了insert、update、delete的效率


结构：
    MySQL如果没有特别指明，都是默认的B+树结构组织的索引
    B+树的所有value值都存放在叶子节点
        > 每一个节点，可以存储多个key(有n个key,就有n个指针)
        > 所有的数据都存储在叶子节点，非叶子节点仅用于索引数据
        > 叶子节点形成了一颗双向链表，便于数据的排序及区间范围查询

    */



