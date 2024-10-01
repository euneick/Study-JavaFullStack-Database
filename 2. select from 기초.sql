-- member 테이블의 모든 열에 저장된 데이터 조회
select * from member;

-- member 테이블의 member_name열 과 member_addr열에 저장된 데이터 조회
select member_name, member_addr from member;

-- member 테이블의 member_name열에 저장된 값이 '아이유'인 데이터만 조회
select * from member where member_name='아이유';

-- member 테이블의 member_id열에 저장된 데이터가 jyp인 member_name열의 정보만 조회
select member_name from member where member_id='jyp';