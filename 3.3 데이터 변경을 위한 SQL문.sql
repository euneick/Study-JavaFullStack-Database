/*
	insert 문
		테이블에 행 데이터를 추가하여 저장 할 때 사용하는 SQL문
		문법
			insert into 테이블 이름 (열 이름1, 열 이름2, ...)
			values(열 1의 값, 열 2의 값, ...);
*/

-- market_db DB 선택
use market_db;

-- hongong1 이라는 이름의 테이블을 생성
-- int 형식의 toy_id, char(4) 형식의 toy_name, int 형식의 age 열을 갖는다.
create table hongong1(
	toy_id 		int,
    toy_name 	char(4),
    age 		int
);

-- 만들어진 hongong1 테이블에 (1, '우디', 25)를 삽입(추가)
-- 열 이름을 생략할 때 값은 반드시 테이블의 열 순서에 맞춰서 작성해야 한다.
insert into hongong1 values (1, '우디', 25);

-- 만들어진 hongong1 테이블에 toy_id 열에 값 2, toy_name 열에 값 '버즈'를 삽입(추가)
insert into hongong1 (toy_id, toy_name)
values (2, '버즈');

-- 값을 추가 할 때 열 순서를 바꿀 수 있다. 단, 값은 바뀐 열 순서에 맞춰서 작성해야 한다.
insert into hongong1 (toy_name, age, toy_id)
values ('제시', 20, 3);

-- =================================================================================================

/*
	auto_increment
		테이블을 새로 생성 할 때 열이름 옆에 작성하는 예약어
		열에 대한 값을 insert문장으로 추가하지 않아도 자동으로 1씩 증가하면서 추가되게 하는 예약어
		auto_increment로 지정하는 열은 반드시 primary key로 지정해야 함
*/

create table hongong2(
	toy_id 		int auto_increment primary key,
    toy_name 	char(4),
    age 		int
);

select * from hongong2;

-- hongong2 테이블에 자동 증가하는 열의 데이터를 null값으로 채워 놓고 데이터 추가
insert into hongong2 values (null, '보핍', 25);
insert into hongong2 values (null, '슬링키', 22);
insert into hongong2 values (null, '렉스', 21);

-- toy_id값은 자동으로 증가하기 때문에 toy_id열을 생략하고 데이터 추가
insert into hongong2 (toy_name, age)
values ('맹구', 100);

-- auto_increment를 통해 얼마만큼 증가했는지 알아보는 구문
select last_insert_id();

-- auto_increment의 시작값을 100부터 설정
alter table hongong2 auto_increment = 100;
-- hongong2 테이블에 (null, '재남', 35) 값 추가
insert into hongong2 values (null, '재남', 35);

-- =================================================================================================

/*
	toy_id, toy_name, age열을 갖는 hongong3 테이블 생성
	toy_id 는 int, toy_name은 char(4), age는 int 형식
	toy_id는 1000부터 3씩 자동으로 증가하게끔 설정
*/
create table hongong3(
	toy_id 		int auto_increment primary key,
    toy_name 	char(4),
    age 		int
);		-- 테이블 생성
alter table hongong3 auto_increment = 1000;	-- auto_increment 의 시작값을 1000으로 설정
set @@auto_increment_increment = 3;			-- 시스템변수 @@auto_increment_increment를 3으로 설정하여 3씩 증가하게끔 설정

-- @는 변수, @@는 시스템변수를 뜻함

insert into hongong3 values (null, '토마스', 20);
insert into hongong3 values (null, '제임스', 23);
insert into hongong3 values (null, '고든', 25);
-- 여러 줄의 insert 구문을 한 줄로 작성
insert into hongong3 values 
	(null, '친구1', 20),
    (null, '친구2', 21),
    (null, '친구3', 22);

-- =================================================================================================

/*
	insert into ~ select 구문
		- 특정 테이블에 select 구문을 이용하여 조회한 표 형태의 결과를 insert into 문장을 이용해 추가 시키는 구문
		- 즉, select로 찾은 결과를 다른 테이블에 insert 하여 데이터를 추가하는 구문
		- 문법
			insert into 테이블이름 (열이름1, 열이름2, ...)
			select 열이름1, 열이름2, ... from 테이블이름
		- select 문의 열 갯수는 insert할 테이블의 열 갯수와 반드시 같아야 함
*/

-- world DB의 city 테이블의 행의 총 갯수
select count(*) as '총 레코드 수' from world.city;
-- world DB의 city 테이블의 구조를 확인
desc world.city;
-- world DB의 city 테이블의 자료 중 5건만 확인
select * from world.city limit 5;		-- limit 0, 5

-- char(35) 형식의 city_name 열과 int 형식의 population 열을 갖는 테이블 city_popul 생성
create table city_popul (
	city_name 	char(35),
    population	int
);

-- world DB의 city 테이블에 있는 데이터 중 Name과 Population 열의 데이터를 조회하여 가져와
-- city_popul 테이블에 삽입
insert into city_popul (city_name, population)
	select Name, Population
    from world.city;

-- city_popul 테이블에 값이 제대로 추가되었는지 확인
select * from city_popul;

-- =================================================================================================

/*
	(workbench는 기본적으로 update, delete를 허용하지 않음)
	([edit - preference - SQL Editor - Safe Updates(~) 체크 해제 - SQL 재접속] 해야 가능)
    
	데이터 수정 update
		- 테이블에 이미 저장되어 있는 열의 데이터를 수정하는 SQL 구문
		- 문법
			update 테이블이름
			set 열1 = 값1, 열2 = 값2, ...
			where 조건식;
		- where 절을 되도록이면 반드시 작성
*/

use market_db;

-- city_popul 테이블의 데이터 중 도시이름이 'Seoul'인 데이터의 모든 열을 행 단위로 조회
select *
from city_popul
where city_name = 'Seoul';

-- city_popul 테이블의 데이터 중 도시이름이 'Seoul'인 데이터를 '서울'로 변경
update city_popul
set city_name = '서울'
where city_name = 'Seoul';		-- where 절 생략 시 city_name 열의 모든 데이터가 '서울'로 변경됨

-- city_popul 테이블의 데이터 중 도시이름이 '서울'인 데이터의 모든 열을 행 단위로 조회
select *
from city_popul
where city_name = '서울';

-- city_popul 테이블의 데이터 중 도시이름이 'New York'인 데이터의 모든 열을 행 단위로 조회
select *
from city_popul
where city_name = 'New York';

-- city_popul 테이블의 데이터 중 도시이름이 'New York'인 데이터의 도시이름을 '뉴욕'으로, 인구수를 0으로 변경
update city_popul
set city_name = '뉴욕', population = 0
where city_name = 'New York';

-- city_popul 테이블의 데이터 중 도시이름이 '뉴욕'인 데이터의 모든 열을 행 단위로 조회
select *
from city_popul
where city_name = '뉴욕';

-- where 절 없이 update 구문 사용
-- update 구문은 되도록이면 반드시 where 절을 같이 작성
update city_popul
set population = population / 10000;	-- population열의 모든 데이터를 10000로 나눈 값을 저장

select * from city_popul;

-- =================================================================================================

/*
	데이터 삭제 delete
		- 행 단위로 데이터를 삭제하는 SQL 구문
		- 문법
			delete from 테이블이름
            where 조건식;
		- update 구문과 마찬가지로 where 절이 없으면 모든 행이 삭제되므로 되도록이면 반드시 where 절과 함께 사용해야 함
*/

-- city_popul 테이블에 저장된 데이터 중 도시이름이 'New'단어로 시작하는 데이터를 삭제
delete from city_popul
where city_name like 'New%';	-- 11row(s) affected

select count(*) from city_popul;

-- =================================================================================================

/*
	대용량의 데이터가 저장된 테이블을 삭제 하기 위해 먼저 실습 준비
    
    대용량 데이터를 저장하기 위해 일단 테이블 3개 준비
    방법 : 대용량의 데이터들이 저장된 테이블을 select 구문으로 조해해서 create 구문을 이용하여 총 3개의 테이블을 생성
*/

create table market_db.big_table1(
	select * from world.city, sakila.country
);
select count(*) from market_db.big_table1;		-- 444611 레코드 조회됨

create table market_db.big_table2(
	select * from world.city, sakila.country
);
select count(*) from market_db.big_table2;		-- 444611 레코드 조회됨

create table market_db.big_table3(
	select * from world.city, sakila.country
);
select count(*) from market_db.big_table3;		-- 444611 레코드 조회됨

-- delete : 테이블에 저장된 행 단위의 데이터를 삭제하는 SQL 구문
delete from market_db.big_table1;		-- 테이블은 남아있고, 데이터 삭제 조건을 확인하기에 오래 걸림
select * from market_db.big_table1;

-- drop : 테이블 자체를 삭제하는 SQL 구문
drop table market_db.big_table2;		-- 데이터와 상관없이 테이블 자체를 삭제하기에 빠름
select * from market_db.big_table2;		-- 테이블이 drop으로 인해 없으므로 조회 불가

-- truncate : delete와 마찬가지로 행 단위의 데이터를 삭제하는 SQL 구문
-- 			  delete와는 다르게 where 절을 사용 할 수 없음
-- 			  조건식 없이 전체 행을 삭제 할 경우 사용
truncate table big_table3;				-- 테이블은 남아있고, 데이터 삭제 조건을 확인하지 않기에 빠름
select * from market_db.big_table3;

/*
	테이블은 남기고 조건에 따라 삭제 하고 싶을 때 			delete from 테이블이름
    테이블은 남기고 모든 행을 삭제 하고 싶을 때				truncate table 테이블이름
    테이블 자체를 삭제하여 모든 데이터를 삭제 하고 싶을 때 		drop table 테이블이름
*/










