select * from test_demo;
show databases;
show tables;

create table t_emp(
    id int,
    name string,
    age int,
    dept_name string
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',';

create table t_person(
    id int,
    name string,
    like array<string>,
    tedian map<string,string>
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '_'
MAP KEYS TERMINATED BY ':';


create table dept_count(
    dname string,
    num int
);

insert into table dept_count select dept_name,count(1) from t_emp group by dept_name;

select * from dept_count;

drop table dept_count;

create table dept_count(
    num int
) PARTITIONED  by (dname string)
row format delimited fields terminated by ',';

select * from dept_count;

insert into table dept_count partition (dname='销售部1') select count(1) from t_emp where dept_name='销售部' group by dept_name;

drop table t_emp;