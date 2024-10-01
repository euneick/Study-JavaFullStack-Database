/*
	order by
		문법
			order by 정렬할 열 이름 asc / desc, 정렬할 열 이름 asc / desc, ...
		asc (ascending) - 오름차순
			차순을 생략하면 asc(오름차순)가 default
		desc (descending) - 내림차순
	반드시 where절 이후에 작성되야 함
*/

-- 실습 1. member 테이블에 저장된 데이터들을 데뷔일자를 기준으로 오름차순으로 정렬하여 조회
select * from member
order by debut_date asc;
-- order by debut_date;

-- 실습 2. member 테이블에 저장된 데이터들을 데뷔일자를 기준으로 내림차순으로 정렬하여 조회
select * from member
order by debut_date desc;

-- 실습 3. member 테이블에서 그룹 평균 키가 164이상인 그룹회원들의 그룹이름, 그룹아이디, 평균키, 데뷔일자의 데이터들을
-- 평균키가 큰 순서대로 정렬하여 조회
select mem_name, mem_id, height, debut_date from member
where height >= 164
order by height desc;

-- 실습 4. 실습 1-3에서 조회한 데이터를 평균키가 큰 순서대로 정렬하고, 평균키가 같으면 데뷔 일자가 빠른 순으로 정렬하여 조회
select mem_name, mem_id, height, debut_date from member
where height >= 164
order by height desc, debut_date asc;

-- =================================================================================================

/*
	limit
		limit 시작번째, 조회갯수
	시작번째를 생략하면 0번째부터 조회갯수 만큼 조회 (limit 갯수 = limit 0, 갯수)
*/

-- 실습 5. member 테이블에서 전체 행 데이터들 중 3개의 행만 조회
select * from member limit 3; -- select * from member limit 0, 3;

-- 실습 6. member 테이블에서 전체 데이터들 중 데뷔일자가 빠른 그룹 3건의 모든 데이터들만 조회
select * from member
order by debut_date asc
limit 3;

-- 실습 7. member 테이블의 데이터를 그룹 평균키가 큰 순으로 정렬하여 조회하되, 3번째 부터 2개의 데이터들만 조회
select * from member
order by height desc
limit 3, 2;

-- =================================================================================================

/*
	distinct
		- 조회된 결과에서 중복된 테이블을 1개만 남김
		- 문법
			select distinct 열이름 from 테이블 ~;
		- distinct 뒤에 열이름은 원칙적으로 1개만 작성해야 함
*/

-- 실습 8-1. member 테이블에서 모든그룹회원의 주소 데이터들을 조회
select addr from member;

-- 실습 8-2. member 테이블에서 모든그룹회원의 주소 데이터들을 오름차순 정렬하여 조회
select addr from member order by addr asc;

-- 실습 8-3. member 테이블에서 모든그룹회원의 주소 데이터들을 오름차순 정렬하고 중복없이 조회
select distinct addr from member order by addr asc;

-- =================================================================================================

/*
	group by
		- 열에 저장된 데이터들을 그룹으로 묶어서 표현하는 구문
		- 집계함수들 중 하나랑 같이 작성해서 사용
		- 집계함수
			- sum()				열에 저장된 데이터들의 합계를 반환
			- avg()				열에 저장된 데이터들의 평균값을 반환
			- min()				열에 저장된 데이터들 중 최솟값을 반환
			- max()				열에 저장된 데이터들 중 최댓값을 반환
			- count()			열에 저장된 데이터들의 갯수를 반환
			- count(distinct)	열에 저장된 데이터들 중 중복된 값을 제외한 나머지 값을 반환. 중복은 1개만 인정
		
		문법
			select 집계함수 from 테이블이름 group by 그룹으로묶을열이름
*/

-- buy 테이블의 모든 데이터들을 조회
select * from buy;

-- 실습 9-1. buy 테이블에서 그룹아이디별로 구매수량의 합계를 조회
select mem_id, sum(amount) from buy group by mem_id;

-- 실습 9-1-1. 9-1의 실행결과에서 열이름에 별칭을 부여
select mem_id '그룹아이디', sum(amount) '총구매수량'
from buy
group by mem_id;

-- 실습 10. buy 테이블에서 그룹아이디별로 구매한 상품들의 총 구매 수량, 총 구매 금액을 계산하고,
-- 			그룹아이디, 총 구매 수량, 총 구매 금액을 조회
select
	mem_id as '그룹아이디',
    sum(amount) as '총 구매 수량',
    sum(amount * price) as '총 구매 금액'
from buy
group by mem_id;

-- 실습 11. buy 테이블에서 전체 그룹이 구매한 총 구매 수량의 평균값을 조회
select avg(amount) as '총 구매 수량의 평균'
from buy;

-- 실습 12. buy 테이블에서 각 그룹 회원들이 몇 개의 상품을 각각 평균 구매 횟수를 조회
select
	mem_id as '그룹아이디',
    avg(amount) as '평균 구매 횟수'
from buy
group by mem_id;

-- 실습 13-1. member 테이블에서 저장된 그룹회원의 전체 행의 갯수를 조회
select count(*) from member;

-- 실습 13-2. member 테이블에서 연락처(phone1)가 저장되어 있는 그룹의 그룹회원의 레코드(행) 갯수 조회
select
	count(phone1) as '연락처가 있는 그룹 수'
from member;

-- =================================================================================================

/*
	having
		where 조건절 대신 그룹으로 묶어준 데이터의 조건검사를 하는 구문
        group by 절 사용 시 where 절 사용 불가
        문법
			select 집계함수
			from 테이블 이름
            group by 그룹으로 묶을 열 이름
            having 조건식
*/

-- 실습 14-1. buy 테이블에서 회원그룹아이디 별로 총 구매 금액 데이터 조회
select
	mem_id as '그룹아이디',
    sum(price * amount) as '총 구매 금액'
from buy
group by mem_id;

-- 실습 14-2. 14-1에서 그룹 아이디 별 총 구매 금액이 1000 이상인 경우만 조회
select
	mem_id as '그룹 아이디',
    sum(price * amount) as '총 구매 금액'
from buy
group by mem_id
having sum(price * amount) >= 1000;
-- where sum(price * amount) >= 1000;     <-- 에러

-- 실습 14-3. 14-2 에서 총 구매 금액 결과를 기준으로 내림차순 정렬
select
	mem_id as '그룹 아이디',
	sum(price * amount) as '총 구매 금액'
from buy
group by 	mem_id
having 		sum(price * amount) >= 1000
order by 	sum(price * amount) desc;