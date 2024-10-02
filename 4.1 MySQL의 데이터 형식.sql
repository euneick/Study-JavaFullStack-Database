use market_db;
create table hongong4(
	tinyint_col 	tinyint,	-- 1 Byte
    smallint_col 	smallint, 	-- 2 Byte
    int_col 		int, 		-- 4 Byte
    bigint_col 		bigint 		-- 8 Byte
);

-- 	insert 구문을 이용하여 hongong4 테이블에 데이터 추가
insert into hongong4(tinyint_col, smallint_col, int_col, bigint_col)
values(127, 32767, 2147483647, 9000000000000000000);

-- 데이터가 제대로 추가되었는지 확인
select * from hongong4;

-- 위의 insert 구문에 1을 추가 (마지막 열은 0 하나 추가) 하여 데이터 추가
insert into hongong4(tinyint_col, smallint_col, int_col, bigint_col)
values(128, 32768, 2147483648, 90000000000000000000);		-- out of range 에러 발생

create table big_table(
	data1 char(256), 		-- 255까지 지정 가능
    data2 varchar(16384) 	-- 16383까지 지정 가능
);			-- column length too big 에러 발생

-- ===================================================================================

-- netflix_db DB를 만들고 선택한 후 movie 테이블 생성
create database netflix_db;
use netflix_db;
create table movie(
	movie_id 		int,
    movie_title 	varchar(30),
    movie_director 	varchar(20),
    movie_star 		varchar(20),
    movie_script 	longtext, 	-- 4 Byte 긴 문자열 최대 4GB
    movie_film 		longblob 	-- 4 Byte 긴 바이너리 데이터 최대 4GB, 사진 또는 동영상 같은 데이터 저장
);

-- ===================================================================================

/*
	변수의 사용
		- 사용자 변수를 생성해서 사용 할 수 잇다.
        - 변수를 생성하는 문법
			set @변수명 = 변수에 저장 할 값;
		- 변수에 저장된 값을 조회하는 문법
			select @변수명;
*/

use market_db;
-- 변수 선언 및 초기화
set @myVar1 = 5;		-- 정수 저장
set @myVar2 = 4.25;		-- 실수 저장

-- 변수 출력
select @myVar1;
select @myVar1 + @myVar2;

-- 변수 선언 및 초기화 후 select 문을 이용하여 사용
set @txt = '가수 이름 ==> ';
set @height = 166;
select 
	@txt as '가수 이름', 
    mem_name as '그룹 명'
from member
where height > @height; 		-- height : member 테이블의 열 이름 // @height : 변수 이름

/*
	limit을 사용하여 제한할 행 갯수도 변수를 선언하여 저장 후 변수명을 이용하여 값을 불러와서 사용 할 수 있다
*/
set @count = 3;

select mem_name, height
from member
order by height asc
limit @count;		-- SQL syntax 에러 발생 (limit 구문에는 변수를 사용 할 수 없음)

-- 위의 에러를 해결하기 위에서는 prepare - execute 구문을 사용
prepare mySQL			-- mySQL 이름으로 준비(prepare)만 해놓음
from
	'select mem_name, height
	from member
	order by height asc
	limit ?';			-- ? : 지금은 설정하지 않고 나중에 채워 넣겠다.

-- 준비(prepare)된 mySQL을 호출하고, 값이 설정되지 않은 ? 에 @count변수를 사용(using)
execute mySQL using @count;

-- ===================================================================================

/*
	데이터 형 변환
		- 명시적 형 변환
			직접 함수를 사용해서 변환
            cast
				- 문법
					cast(값 as 데이터 형식[길이])
            convert
				- 문법
					convert(값, 데이터 형식[길이])                    
			- 데이터 형식
				char, signed, unsigned, data, time, datetime 등
				signed 는 부호가 있는 정수, unsigned 는 부호가 없는 정수
        - 암시적 형 변환 (자동 형 변환)
			별도의 지시 없이 자연스럽게 변환
*/

-- 실습 1. buy 테이블에서 그룹들이 구매한 평균가격을 조회
select avg(price) as '평균 가격'
from buy;

-- 실습 2. 실습 1 의 값을 실수가 아닌 정수로 조회
-- 			실수를 정수로 변환 할 때 소숫점 이하 자리를 버리는 것이 아닌 반올림을 함
select cast(avg(price) as signed) as '평균 가격'
from buy;
select convert(avg(price), signed) as '평균 가격'
from buy;

-- 실습 3. 날짜 데이터를 만들기 위해 데이터 유형 date를 사용해 데이터 형 변환
-- 			YYYY-MM-DD 형식을 구분하기 위해 특수문자를 사용하면 됨
select cast('2024$12$12' as date);
select cast('2024/12/12' as date);
select cast('2024%12%12' as date);
select cast('2024@12@12' as date);

-- 실습 4. 정수형의 데이터를 char형의 데이터로 형 변환하여 문자열로 사용
-- 			concat() : 쉼표(,)로 구분된 문자열들을 하나의 문자열로 합치는 함수
select
	num,
	concat(cast(price as char), ' X ', cast(amount as char), ' = ') as '가격 X 수량',
    price * amount as '구매액'
from buy;

-- 실습 5. '100' + '200'을 조회
-- 기대값은 '100200' 이지만 + 연산자에 의해 자동으로 정수형으로 변환되어 값이 계산되므로 결과는 300이 됨
select '100' + '200';

-- 실습 6. '100' + '200'을 '100200'으로 조회
select concat('100', '200');

-- 실습 7. 숫자와 문자열을 concat으로 합침
-- 정수형 200은 문자열 '200'으로 자동 형 변환 됨
select concat('100', 200);

-- 실습 8. + 연산자를 사용하여 정수 + 문자열을 조회
-- 문자열이 정수형으로 자동 형 변환
select '100' + 200;





