-- 개체 : 데이터로 표현하고자 하는 데이터베이스의 구성요소
-- 개체 종류 : 테이블, 인덱스, 뷰, 스토어드 프로시저, 트리거, 함수, 커서 등등

-- =================================================================================================
-- 인덱스 : 데이터베이스 테이블에 저장된 데이터의 검색 속도를 향상 시키기 위한 개체

-- 인덱스 개체를 사용하지 않고 member 테이블에 저장되어 있는 데이터 중 이름이 '아이유'인 한 사람의 정보를 조회
select member_id, member_name, member_addr from member where member_name='아이유';

-- 인덱스 개체 만들기
-- 		create index 생성할인덱스개체명 on 테이블이름(열이름);
-- member 테이블의 member_name열에 인덱스 개체 생성
create index idx_member_name on member(member_name);

-- member 테이블에 저장된 member_name열의 값이 '아이유'와 같으면 아이유의 정보를 행 단위로 조회
select * from member where member_name='아이유';
-- =================================================================================================

-- =================================================================================================
-- 뷰 : 가상의 테이블
-- 뷰 개체 만들기
-- 		create view 생성할뷰이름
-- 		as select * from 조회할테이블이름;

-- member 테이블과 연결되는 회원뷰(member_view) 생성
create view member_view as select * from member;

-- 회원 테이블(member)의 아닌 회원뷰(member_view)로 조회
select * from member_view;

-- 굳이 view를 사용하는 이유
-- 		member테이블을 조작하면 데이터가 변경되거나 삭제 될 수 있어 보안에 좋지 않음
-- 		긴 SQL문을 간략하게 만들 수 있음
-- =================================================================================================

-- =================================================================================================
-- 스토어드 프로시저 : 프로그램 코드를 묶어 놓은 함수와 같은 개체

-- 회원테이블(member)에 저장된 member_name열의 값이 '나훈아'인 모든 열의 값 조회
select * from member where member_name='나훈아';
-- 상품테이블(product)에 저장된 prodect_name열의 값이 '삼각김밥'인 모든 열의 값 조회
select * from product where product_name='삼각김밥';

-- 참고. 조회 결과를 보면 매번 두 줄의 SQL을 입력해야 한다면 상당히 불편할 것이고, SQL의 문법을 잊거나 오타를 입력 할 수도 있다.

-- 스토어드 프로시저 만드는 문법
-- delimiter //
-- create procedure 만들프로시저이름()
-- begin
-- 		실행 구문
-- end //
-- delimiter ;
-- 참고. 첫 행과 마지막 행에 구분 문자라는 의미의 DELIMITER // ~~ DELIMITER ;
-- 		스토어드 프로시저를 만들기 위해 묶어 주는 약속의 문법
delimiter //
create procedure myProc()
begin
	select * from member where member_name='나훈아';
	select * from product where product_name='삼각김밥';
end //
delimiter ;

-- 만든 프로시져 호출
call myProc();

-- 만든 프로시져 삭제
drop procedure myProc;
-- =================================================================================================

-- =================================================================================================
-- 주제 : 기본 조회문 select ~ from 절 배우기
/*
	use문
			테이블의 데이터를 조회하기 전에 먼저 사용 할 DB를 선택 할 때 사용하는 예약어
	문법
			use 사용할DB이름;
*/
use market_db;

/*
	select 문
			특정 테이블에 저장되어 있는 데이터를 조회할 때 사용하는 구문
	전체 문법
			select 조회할열이름, 조회할열이름, ...
			from 조회할테이블이름
				where 조건식
				group by 그룹으로묶을_데이터가_저장된_열이름
				having 조건식
				order by 정렬할데이터가_저장된_열이름 acs 또는 desc
				limit 정수

	select 핵심문법 1
			select 조회할열이름, 조회할열이름, ...
				from 조회할테이블이름
				where 조건식;
*/

-- member 테이블에 저장된 모든 열의 값을 행 단위로 조회
select * from member;

-- 실습 1. member 테이블에서 그룹이름이 저장된 mem_name열의 데이터들만 조회
select mem_name from member;

-- 실습 2. member 테이블에서 주소 addr, 입사연도 debut_date, 그룹이름 mem_name열의 데이터들만 조회
select addr, debut_date, mem_name from member;

-- 실습 3. member 테이블에서 조회할 열이름 대신 별칭을 지어서 조회된 결과를 보기 위해서는 다음 문법을 사용
-- 			select 조회할열이름 별칭이름, 조회할열이름 별칭이름, ... from 조회할테이블이름;
-- 			또는
-- 			select 조회할열이름 as 별칭이름, 조회할열이름 as 별칭이름, ... from 조회할테이블이름;
select addr as "주소", debut_date as "입사연도", mem_name "그룹명" from member;

-- 실습 4. member 테이블에서 그룹명이 '블랙핑크'인 모든 열의 데이터를 조회
select * from member where mem_name='블랙핑크';

-- 실습 5. member 테이블에서 mem_number열의 데이터가 4인 그룹의 모든 열의 데이터를 조회
select * from member where mem_number = 4;

-- 실습 6. 비교연산자 <   >   <=   >=
-- member 테이블에서 회원그룹 평균 키 데이터가 162 이하인 회원그룹의 아이디와 회원그룹명 데이터를 조회 
select mem_id, mem_name from member
where height <= 162;

-- 실습 7-1. 논리연산자 and
-- member 테이블에서 회원그룹 평균 키 데이터가 165 이상이면서 회원그룹 인원이 6명 초과인 회원그룹의
-- 회원그룹명, 회원그룹의 평균 키, 회원그룹의 인원 데이터를 조회
select mem_name, height, mem_number from member
where height >= 165 and mem_number > 6;

-- between ~ and 절 문법
-- 		where 조건을 따질 열 이름 between 최솟값 and 최댓값;

-- 실습 7-2. between A and B 
-- member 테이블에서 그룹의 평균 키가 163이상 그리고 165이하인 회원그룹의 그룹명, 평균키, 그룹인원수 조회
select mem_name, height, mem_number from member
where height between 163 and 165;
-- where height >= 163 and height <= 165;

-- 실습 8-1. 논리연산자 or
-- member 테이블에서 회원그룹 평균 키 데이터가 165 이상이거나 회원그룹 인원이 6명 초과인 회원그룹의 
-- 회원그룹명, 회원그룹의 평균 키, 회원그룹의 인원 데이터를 조회
select mem_name, height, mem_number from member
where height >= 165 or mem_number > 6;

-- 실습 8-2. in()
-- member 테이블에서 회원그룹의 주소가 경기 또는 전남 또는 경남 중 한 곳이라도 해당되는
-- 그룹의 이름, 주소 조회
select mem_name, addr from member
where addr in('경기', '전남', '경남');
-- where addr='경기' or addr='전남' or addr='경남';

-- like 절
--  	문자열 데이터의 일부 글자가 포함되어 있는 열의 데이터를 조회 할 수 있는 예약어

-- 실습 9-1. member 테이블에서 그룹명이 '우' 문자로 시작하는 데이터의 모든 열의 데이터들을 행 단위로 조회
select * from member where mem_name like '우%';

-- 실습 9-2. member 테이블에서 그룹명의 앞 두 글자는 상관없고 뒤 단어가 '핑크'인 데이터의 모든 열의 데이터들을 행 단위로 조회
select * from member where mem_name like '__핑크';

-- 실습 9-3. member 테이블에서 그룹명이 '마' 문자를 포함하는 데이터의 모든 열의 데이터들을 행 단위로 조회
select * from member where mem_name like '%마%';

-- 실습 9-4. member 테이블에서 그룹명이 '친구'로 끝나는 데이터의 모든 열의 데이터들을 행 단위로 조회
select * from member where mem_name like '%친구';

-- 서브쿼리
-- 		안 쪽 select 구문을 이요하여 조회한 결과 데이터 들을 바깥 쪽 select 구문을 이용해 다시 조회하는 구문
-- 		문법
-- 			select ~ from ~ where 조건식 (select ...);

-- 실습 10. member 테이블에서 그룹이름이 '에이핑크'인 회원그룹의 평균 키보다 큰 그룹회원의 그룹이름, 평균 키 데이터를 조회
select mem_name, height from member
where height > (
	select height
	from member where mem_name = '에이핑크');