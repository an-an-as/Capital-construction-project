create table 全校班级信息 (
班级 tinyint primary key, 
班主任 varchar(255) not null,
学生数量 tinyint not null,
更新时间 timestamp not null default current_timestamp on update current_timestamp
);

create table 全校学生信息 (
学生编号 int primary key auto_increment,
姓名 varchar(255) not null,
年龄 tinyint,
家长 varchar(255),
班级 tinyint,
更新时间 timestamp not null default current_timestamp on update current_timestamp,
foreign key(班级) references 全校班级信息(班级) ON DELETE CASCADE ON UPDATE CASCADE 
) AUTO_INCREMENT = 2019000; 

DELETE from 全校学生信息 where 年龄 = 100;
update 全校学生信息 set 年龄 = 20 where 姓名 = 'Jack'; -- 不区分大小写
select 学生编号, 家长 from 全校学生信息 where 姓名 = 'jack'

select * from 全校学生信息 where 姓名 in ('Tom', 'Jack');
select * from 全校学生信息 where 姓名 = 'Ben';

select 姓名 from 全校学生信息 where 年龄 > 20 and 年龄 <25;  
select * from 全校学生信息 where 姓名 not between 'a' and 'c';
select * from 全校学生信息 ORDER BY 年龄 DESC;
SELECT * from 全校学生信息 ORDER BY 年龄 LIMIT 1; 

select * from 全校学生信息 where 更新时间 between'2019-02-27 00:00:00' and '2019-02-27 02:05:00';
select * from 全校学生信息 where to_days(更新时间) = to_days(now()); 		           -- 查询今天的数据
SELECT * FROM 全校学生信息 WHERE TO_DAYS( NOW() ) - TO_DAYS(更新时间) = 1              -- 查询昨天的数据
SELECT * FROM 全校学生信息 where DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= date(更新时间) -- 近7天
