/*
	조인 (join ~ on)
		- 두 개의 테이블의 열에 저장된 데이터들을 묶어서 하나의 표 형태의 결과로 조회하는 구문
	
    1. 내부 조인 (inner join)
		- 두 테이블 양쪽의 열에 저장된 데이터가 있을 때 사용되는 조인 (양쪽 테이블 모두에 반드시 데이터 값이 있어야 함)
		- 두 테이블을 연결 할 때 가장 많이 사용 됨
        - 일대다 (one to many) 관계
			- 한 쪽 테이블에는 하나의 값만 존재하고, 다른 테이블에는 여러개의 값이 존재 할 때의 관계
            - 주로 PK(primary key ,고유 값), FK(foreign key, 외래 값) 로 지정되어 있음
		- 문법
			select 열 이름
            from 첫번째테이블이름.첫번째테이블열이름, 두번째테이블이름.두번째테이블열이름
				inner join 두번째테이블이름		-- join 이라고만 써도 inner join 으로 인식
                on 첫번째테이블열이름 = 두번째테이블열이름
			where 검색조건식;
            
    2. 외부 조인 (outer join)
		- 두 테이블 중에 한 쪽 테이블 열에만 데이터가 저장되어 있어도 두 테이블의 열을 모두 조회하기 위한 구문
		- 문법
			select 열 이름
            from 첫번째테이블이름(Left 테이블)
				left | right | full outer join 두번째테이블이름(Right 테이블)
                on 조인될 조건
			where 검색조건식;
		- left outer join
			- 기준이 되는 테이블의 열 데이터를 모두 조회한다는 의미
        - right outer join
			- 오른쪽 테이블을 기준으로 열에 모든 데이터가 저장되어 있으면 왼쪽 테이블의 열 데이터가 저장되어 있지 않아도 모두 조회
        - full outer join
			- 양 쪽 모든 테이블의 데이터를 조회
            - 현업에선 잘 쓰이지 않음
			- MySQL에선 지원하지 않음. union 키워드를 통해 구현 할 수 있음.
    
    3. 상호 조인 (cross join)
		- 한쪽 테이블의 모든 행과 다른쪽 테이블의 모든 행을 모두 조인
        - 10 행의 테이블 과 12 행의 테이블의 cross join = 120행의 테이블
        - on 구문 사용 불가
        - 주 목적은 테스트를 위한 대용량 데이터를 생성
    
    4. 자체 조인 (self join)
		- 자신이 자신과 조인. 즉, 1개의 테이블 사용
        - 문법
			select 열이름
            from 테이블이름 별칭A
				inner join 테이블 별칭B
                on 조인될조건
			where 검색조건식;
*/

use market_db;

-- buy 테이블과 member 테이블에서 GRL이라는 그룹아이디를 가진 회원의 회원이름/주소/연락처/구매한 상품명 등을 inner join을 통해 조회
select 
	member.mem_name, 
    member.addr, 
    member.phone1, 
    member.phone2, 
    buy.prod_name
from buy inner join member
	on buy.mem_id = member.mem_id
where buy.mem_id = 'GRL';

-- from 절에 테이블 명 작성 시 테이블 명에 대한 별칭명을 작성하여 호출하는 방법으로 간소화 할 수 있음
select 
	B.mem_id,
    M.mem_name,
    B.prod_name,
    M.addr,
    concat(M.phone1, M.phone2) as '연락처'
from buy B inner join member M
	on B.mem_id = M.mem_id
where B.mem_id = 'GRL';

-- buy 테이블과 member 테이블을 join 하여
-- 전체 회원의 아이디, 이름, 구매한 제품명, 주소 정보를 회원 아이디를 기준으로 오름차순 정렬하여 조회
select
	B.mem_id,
    M.mem_name,
    B.prod_name,
    M.addr
from buy B inner join member M
	on B.mem_id = M.mem_id
order by B.mem_id asc;

-- 한 번이라도 구매한 적이 있는 회원의 정보를 조회
select 
	distinct M.mem_id,
    M.mem_name,
    M.addr
from buy B inner join member M
	on B.mem_id = M.mem_id
order by M.mem_id;

-- =================================================================================

use market_db;

-- 전체 회원 중에서 구매기록이 없는 그룹회원의 정보도 모두 조회 (left outer join)
select 
	M.mem_id,
    M.mem_name,
    B.prod_name,
    B.mem_id,
    M.addr
from member M left outer join buy B
	on M.mem_id = B.mem_id
order by M.mem_id asc;

-- 전체 회원 중에서 구매기록이 없는 그룹회원의 정보도 모두 조회 (right outer join)
select 
	M.mem_id,
    M.mem_name,
    B.prod_name,
    B.mem_id,
    M.addr
from buy B right outer join member M
	on M.mem_id = B.mem_id
order by M.mem_id asc;

-- 전체 회원 그룹 중에서 한번도 구매한 기록이 없는 회원 목록을 조회
-- left outer join 사용, 열의 데이터가 중복되면 하나로 합쳐서 조회
select 
	distinct member.mem_id,
    member.mem_name,
    buy.prod_name,
    member.addr
from member left outer join buy
	on member.mem_id = buy.mem_id
where buy.prod_name is null
order by member.mem_id asc;

-- =================================================================================

/*
	left outer join, right outer join 예제
*/
-- 회원 정보 테이블
create table A (
	id 		int primary key,
    name	varchar(50)
);

-- 주문 정보 테이블
create table B (
	id 				int primary key,
    order_item		varchar(50)
);

insert into A (id, name)
values (1, 'Alpha'), (2, 'Bravo'), (3, 'Charlie');

select * from A;

insert into B (id, order_item)
values (2, 'Laptop'), (3, 'Smartphone'), (4, 'Tablet');

select * from B;

select
	A.id, A.name, B.order_item
from A left outer join B
on A.id = B.id;

select
	B.id, A.name, B.order_item
from A right outer join B
on A.id = B.id;

-- =================================================================================

use market_db;
-- 자체조인 실습을 위한 테이블 생성 및 데이터 추가
create table emp_table(
	emp char(4),
    mamager char(4),
    phone varchar(8)
);
insert into emp_table values('대표', null, '0000');
insert into emp_table values('영업이사', '대표', '1111');
insert into emp_table values('관리이사', '대표', '2222');
insert into emp_table values('정보이사', '대표', '3333');
insert into emp_table values('영업과장', '영업이사', '1111-1');
insert into emp_table values('경리부장', '관리이사', '2222-1');
insert into emp_table values('인사부장', '관리이사', '2222-2');
insert into emp_table values('개발팀장', '정보이사', '3333-1');
insert into emp_table values('개발주임', '정보이사', '3333-1-1');
select * from emp_table;

-- 경리부장의 상관의 사내번호 조회
select 
	A.emp as '직원직급',
    B.emp as '직속상관',
    B.phone as '직속상관연락처'
from emp_table A inner join emp_table B
	on A.mamager = B.emp
where A.emp = '경리부장';











