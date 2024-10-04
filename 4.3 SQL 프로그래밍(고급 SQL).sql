/*
	스토어드 프로시저 (stored procedure)
		- 데이터베이스 서버에 저장되어 있는 일련의 SQL 문장들로 구성된 프로그램(개체)
        - 문법
			delimiter $$						// 구분문자를 $$로 변경
            create procedure 프로시져이름()			// 프로시저 선언
            begin								// 프로시저 블록 시작
				이 부분에 SQL 프로그래밍 코딩			// 프로시저 로직 작성 
            end $$								// 프로시저 블록 종료 알림
            delimiter ;			-- 공백 중요		// 구분문자를 ;로 되돌림
		- 호출
			call 프로시져이름();
		- 일반적으로 구분문자는 $$를 많이 사용. /, &, @ 등을 사용해도 상관은 없음
        - 구분문자(delimiter)의 목적
			프로시저, 트리거, 함수와 같은 복잡한 SQL블록을 작성 할 때, 블록 내부에서도 세미콜론이 사용 되기 때문에 명령어의 끝을 제대로 구분 할 수가 없음.
            이런 경우에 delimiter를 $$로 지정하여 블록 내부에서 세미콜론을 자유롭게 사용 할 수 있음
            프로시저가 끝난 이후엔 end $$ 를 표시하여 프로시저가 종료되었음을 알리고, delimiter ; 를 작성해 구분문자를 원래대로 되돌림.
*/

-- ====================================================================================

/*
	조건문 IF
		- 문법
			if 조건식 then
				sql 문장들
			end if;
*/

-- 만약 ifProc1 이름의 프로시져가 만들어져 있으면 삭제
drop procedure if exists ifProc1;

-- 프로시져 생성
delimiter $$
create procedure ifProc1()
begin
	if 100 = 100 then
		select '100은 100과 같습니다.' as '조회결과';
	end if;
end $$
delimiter ;

-- 만들어진 프로시져 호출
call ifProc1();

/*
	if ~ else 조건문
		- 문법
			if 조건식 then
				SQL 문장 1;
			else
				SQL 문장 2;
			end if;
*/

-- 만약 ifProc2 이름의 프로시져가 만들어져 있으면 삭제
drop procedure if exists ifProc2;

delimiter $$
create procedure ifProc2()
begin
	declare myNum int;	-- int 형식의 myNum 이라는 이름의 변수를 선언(declare)
    set myNum = 200;	-- 선언된 변수 myNum에 값 200을 초기화(set)
    
    if myNum = 100 then
		select '100 입니다.' as '조회결과';
	else
		select '100이 아닙니다.' as '조회결과';
    end if;
end $$
delimiter ;

call ifProc2();

/*
	스토어드프로시져와 if문 활용
	
    market_db DB 내부의 member테이블의 정보를 활용해서 스토어드프로시져 생성 후 사용
    
    그룹아이디가 APN(에이핑크)인 회원그룹의 데뷔일자가 5년이 넘었는지 확인해보고,
    5년이 넘었으면 축하 메세지를 만들어서 출력해보자.
*/

drop procedure if exists ifProc3;

delimiter $$
create procedure ifProc3()
begin
	declare debutDate DATE;	-- 데뷔 일자
    declare curDate DATE;	-- 오늘
    declare days int;		-- 활동 일수
    
    -- member 테이블에서 멤버아이디가 APN 인 회원의 debut_date 조회하여 debutDate에 대입(into)
    select debut_date into debutDate
    from market_db.member
    where mem_id = 'APN';
    
    /*
		current_date() - 오늘의 컴퓨터 시스템 날짜를 반환하는 함수
					   - 많이 사용 함
        datediff(d1, d2) - d2 에서 d1 까지 지난 일 수를 반환하는 함수
						 - 절대값이 아닌 d2를 기준으로 차이를 계산하기 때문에
                           d1 변수는 타겟 날짜, d2 변수는 기준 날짜로 설정하는 것이 좋음
    */
    
    set curDate = current_date();
    set days = datediff(curDate, debutDate);
    
    if (days / 365) >= 5 then
		select concat('데뷔한 지 ', days, '일이나 지났습니다. 축하합니다!') as '출력결과';
	else
		-- select '데뷔한 지 ' + days + '일 밖에 안되었네요.. 화이팅!' as '출력결과';		-- 버전때문인지 문자열 + 연산이 안됨
        select concat('데뷔한 지 ', days, '일 밖에 안되었네요.. 화이팅!') as '출력결과';
    end if;
end $$
delimiter ;

call ifProc3();

/*
	current_timestamp()
		- 현재 오늘 날짜 정보와 시간 정보를 함께 반환하는 함수
*/

-- ====================================================================================

/*
	case 문
		- 문법
			case
				when 조건식1 then
					SQL 문장
				when 조건식2 then
					SQL 문장
				...
                else
					SQL 문장
			end case;
*/

-- 점수가 88점 일 때 학점을 구하는 프로그램
-- 90점 이상은 A, 80점 이상은 B, 70점 이상은 C, 60점 이상은 D, 60점 미만은 F
drop procedure if exists caseProc;

delimiter $$
create procedure caseProc()
begin
	declare score int;
    declare grade char(1);
    
    set score = 88;
    case
		when score >= 90 then
			set grade = 'A';
		when score >= 80 then
			set grade = 'B';
		when score >= 70 then
			set grade = 'C';
		when score >= 60 then
			set grade = 'D';
		else
			set grade = 'F';
    end case;
    
    select
		concat('취득 점수 ==> ', score) as '취득점수',
        concat('학점 ==> ', grade) as '학점';
end $$
delimiter ;

call caseProc();

-- ====================================================================================

/*
	case 문의 활용
		회원들의 총 구매액을 계산해서 회원의 등급을 4단계로 나누는 예제
*/

-- 순서 1. 그룹 아이디 별 총 구매액 조회
select
	mem_id,
    sum(price * amount) as total_price
from buy
group by mem_id;

-- 순서2. 1의 순서를 내림차순으로 정렬
select
	mem_id,
    sum(price * amount) as total_price
from buy
group by mem_id
order by total_price desc;

-- 순서 3. 2의 과정에서 그룹 아이디의 이름을 같이 조회
select
	B.mem_id,
    M.mem_name,
    sum(B.price * B.amount) as total_price
from buy B join member M
	on B.mem_id = M.mem_id
group by B.mem_id
order by total_price desc;

-- 순서 4. 3에서 구매 이력이 없는 그룹도 함께 조회
select
	M.mem_id,
    M.mem_name,
    sum(B.price * B.amount) as total_price
from buy B right outer join member M
	on B.mem_id = M.mem_id
group by M.mem_id
order by total_price desc;

-- 순서 5. case 문을 활용하여 등급 분류
select
	M.mem_id,
    M.mem_name,
    sum(B.price * B.amount) as total_price,
    case
		when (sum(B.price * B.amount) >= 1500) then '최우수고객'
		when (sum(B.price * B.amount) >= 1000) then '우수고객'
		when (sum(B.price * B.amount) >= 1) then '일반고객'
        else '유령고객'
    end member_grade
from buy B right outer join member M
	on B.mem_id = M.mem_id
group by M.mem_id
order by total_price desc;












