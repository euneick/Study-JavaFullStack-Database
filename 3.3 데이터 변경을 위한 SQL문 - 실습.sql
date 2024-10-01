use market_db;
drop table if exists city_popul;

-- char(35) 형식의 city_name 열과 int 형식의 population 열을 갖는 테이블 city_popul 생성
create table city_popul(
	city_name 	char(35),
    population 	int
);

-- world DB의 city 테이블에 있는 데이터 중 Name과 Population 열의 데이터를 조회하여 가져와 city_popul 테이블에 삽입
insert into city_popul
select Name, Population
from world.city;

-- city_popul 테이블에 값이 제대로 추가되었는지 확인
select * from city_popul;

-- city_popul 테이블의 데이터 중 도시이름이 'Seoul'인 데이터의 모든 열을 행 단위로 조회
select * from city_popul where city_name = 'Seoul';

-- city_popul 테이블의 데이터 중 도시이름이 'Seoul'인 데이터를 '서울'로 변경
update city_popul
set city_name = '서울'
where city_name = 'Seoul';

-- city_popul 테이블의 데이터 중 도시이름이 '서울'인 데이터의 모든 열을 행 단위로 조회
select * from city_popul where city_name = '서울';

-- city_popul 테이블의 데이터 중 도시이름이 'New York'인 데이터의 모든 열을 행 단위로 조회
select * from city_popul where city_name = 'New York';

-- city_popul 테이블의 데이터 중 도시이름이 'New York'인 데이터의 도시이름을 '뉴욕'으로, 인구수를 0으로 변경
update city_popul
set city_name = '뉴욕', population = 0
where city_name = 'New York';

-- city_popul 테이블의 데이터 중 도시이름이 '뉴욕'인 데이터의 모든 열을 행 단위로 조회
select * from city_popul where city_name = '뉴욕';

-- city_popul 테이블의 데이터 중 인구수 열의 모든 값을 10000으로 나눈 값을 저장
update city_popul
set population = population / 10000;

-- city_popul 테이블의 모든 데이터 값 확인
select * from city_popul;

-- city_popul 테이블에 저장된 데이터 중 도시이름이 'New'단어로 시작하는 데이터를 삭제
delete from city_popul
where city_name like 'New%';

-- city_popul 테이블의 행 갯수 확인
select count(*) from city_popul;