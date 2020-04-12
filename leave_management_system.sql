Create table person
(login		varchar(20) primary key,
Password	varchar(20),
id		varchar(20),
name		varchar(20),
address		varchar(30),
phno		numeric(10,0),
type		varchar(20)
);

insert into person values ('user1','dbms1','s001','Sai','nellore',9010100876,'student');
insert into person values ('user2','dbms2','f001','Nayana','kollam',9020407876,'faculty');
insert into person values ('user3','dbms3','s002','Ayan','tirchur',9010602904,'student');
insert into person values ('user4','dbms4','f002','Navneeth','malappuram',8020407876,'faculty');



select * from person;

Create table leavetype
(ltid		varchar(20) primary key,
ltname		varchar(30),
typecount	numeric(3,0));

insert into leavetype values
	('lt01','casual',14),
	('lt02','maternity',180),
	('lt03','medical',15),
	('lt04','dutyleave',5),
	('lt05','sabbatical',10);


select * from leavetype;

Create table contains
(login	varchar(20) references person(login),
ltid	varchar(20) references leavetype(ltid)); 

insert into contains values
	('user1','lt04'),
	('user2','lt02');
insert into contains values
	('user1','lt03')


select * from contains;

Create table authority
	(aid		varchar(20) primary key,
	aname		varchar(20),
	aaddress	varchar(30),
	aphno		numeric(10,0));

insert into authority values
	('a001','greeshma','kochi',9443322551),
	('a002','anjali','trivandrum',8909014356);



insert into authority values
	('a003','remya','allepey',7443322551)


	
select * from authority;

Create table leave
	(leaveid	varchar(20) primary key,
	Reason		varchar(50),
	count		numeric(3,0),
	apprstatus	varchar(20),
	fromdate	date,
	todate		date,
	aid		varchar(20)  references authority(aid) 
	);

insert into leave values
	('l004','maternity',150,'Y','2007-03-10','2007-08-10','a002'),
	('l003','duty leave',2,'N','2007-07-17','2007-07-19','a001'),
	('l001','sisters marriage',3,'Y','2019-09-11','2019-09-14','a001'),
	('l002','viral fever',7,'Y','2018-12-4','2018-12-10','a002');


insert into leave values
	('l005','jaundice',10,'Y','2006-02-10','2006-02-20','a003');
	

select * from leave natural join authority;

create table apply
	(login	varchar(20) references person(login),
	ltid	varchar(20) references leavetype(ltid),
	leaveid varchar(20) references leave(leaveid));

insert into apply values
	('user1','lt04','l003'),
	('user2','lt02','l004');

insert into apply values
	('user1','lt03','l005')

	
select * from apply natural join leave;

create table specialrequest
	(exid	varchar(20) primary key,
	ecount numeric(3,0));

insert into specialrequest values
	('e001',2),
	('e002',1);


select * from specialrequest;

create table extends
	(leaveid varchar(20) references leave(leaveid),
	exid 	varchar(20) references specialrequest(exid));

insert into extends values
	('l004','e001');
insert into extends values
	('l003','e002');

select * from extends natural join specialrequest;










select login,type from   group by leaveid;

select sum(typecount) from leavetype ;

select * from leave order by fromdate asc;

select extends.exid,ecount from extends
 full outer join  specialrequest
 ON extends.exid=specialrequest.exid;
 
select extends.exid,ecount from extends
 join  specialrequest
 ON extends.exid=specialrequest.exid;


//A query to find where approval status is no and either is leave not taken in the year 2007 or  approved by authority a002
select distinct(leavetype.ltid),leavetype.ltname from leavetype
natural join apply,leave
where leavetype.ltid = apply.ltid 
and apply.leaveid = leave.leaveid  
and   apprstatus = 'N' 
and not extract(year from fromdate) = 2007
or aid ='a002' ;

select * from leave
where  extract(year from fromdate) > 2007
and extract(year from fromdate) <2019
and count = 7;

select * from person
where type like 'f%';

select * from person
where name like '_a%';


select * from leave 
where extract(month from todate) = 9;


 select leaveid,to_char(todate,'DD/Month/YYYY') from leave;

 

select * from leave
where  extract(year from fromdate) between 2007 and  2019
and reason in ('maternity','viral fever')


select * from leave
where  extract(year from fromdate) not between 2017 and  2019
and reason not in ('maternity','viral fever')


select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a001' union
select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a003';

select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a001' union all
select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a003';

select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a001' except
select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a003';

select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a001' intersect
select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a003';

select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a001' intersect all
select distinct(leave.leaveid),authority.aname from leave natural join authority where aid = 'a003';

select name,address,phno from person where login =
(select login from apply where leaveid = ( select leaveid from leave where count = (select max(count) from leave )))


SELECT name,address,phno
FROM person
WHERE NOT EXISTS (SELECT login FROM apply WHERE leaveid in (  select leaveid from leave));

select person.name,person.address,person.phno,leave.leaveid,leave.reason,leave.count,leave.fromdate,leave.todate,specialrequest.exid,specialrequest.ecount
from person
natural join apply,leave,extends,specialrequest
where person.login = apply.login and
apply.leaveid = leave.leaveid and 
leave.leaveid = extends.leaveid and 
extends.exid = specialrequest.exid and
person.type = 'student' and leave.apprstatus = 'Y'

update leave  set apprstatus = 'Y' where leaveid = 'l003'





 