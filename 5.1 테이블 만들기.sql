/*
	데이터베이스 설계
		1단계 	요구사항 분석		DB의 목적과 사용자의 요구사항 파악
        
        2단계		개념적 설계			ER 다이어그램 그리기(DB의 주요 개체(엔티티)와 이들 간의 관계를 시각적으로 표현
			* 엔티티 - DB에서 관리할 개체
			* 속성 - 각 엔티티의 특성
            * 관계 - 각 엔티티 간의 관계 (1:1 관계, 1:N 관계 등)
            
		3단계		논리적 설계			개념적 설계를 바탕으로 테이블 구조 정의 단계
			* 외래키 설정 - 테이블 간의 관계를 정의하여 데이터의 무결성을 유지
            
		4단계 	물리적 설계			DBMS 선택 후 SQL을 사용하여 테이블을 생성
			* 인덱스 개체 및 열에 특정 제약 조건 설정 (성능 향상 및 데이터 무결성 유지)
            
		5단계 	데이터베이스 구현		실제 테이블에 데이터를 입력, 테스트 및 검증
*/

/*
	테이블
		- 하나의 DB 내부에 생성하는 하나의 개체
        - 표 형태로 구성된 2차원 구조
        - 생성 문법
			create table 테이블명 (
				열이름1	자료형 [제약조건],
                열이름2	자료형 [제약조건],
                ...
                [테이블 제약 조건]
            );
		 * 열 제약 조건
			primary key			테이블 내에서 고유하고 NULL이 될 수 없는 기본키 설정
            foreign key			다른 테이블의 기본키 열의 데이터를 참조하여 테이블 간의 관계 설정
            unique 				열의 모든 값이 고유하게끔 설정
            not null			열의 값에 null 값을 허용하지 않게 설정
            default 			열에 데이터가 insert되지 않을 경우 삽입할 값 설정
            check 				특정 조건을 만족하면 열에 값을 저장
            auto_increment		테이블에 값이 추가 될 때마다 값이 자동으로 증가 (주로 int형 사용)
            
		 * 테이블 제약 조건
			primary key 		하나 이상의 열을 기본키로 설정
            foreign key 		다른 테이블과의 관계 설정
            unique (열목록)		여러 열의 조합의 고유하게끔 설정
            check				특정 조건을 만족해야 하게끔 설정
*/

drop database if exists internet_market;
create database internet_market;

use internet_market;

-- 고객 정보 customers 테이블
drop table if exists customers;
create table customers(
	customer_id 	int auto_increment primary key,
    customer_name 	varchar(100) not null,
    email			varchar(100) unique not null,
    phone 			varchar(20),
    address 		varchar(255),
    regist_date		timestamp default current_timestamp
);

insert into customers(customer_name, email, phone, address)
values ('Alpha', 'Alpha@example.com', '010-1111-2222', '서울시 강남구'),
	('Bravo', 'Bravo@example.com', '010-2222-3333', '서울시 송파구'),
	('Charile', 'Charile@example.com', '010-3333-4444', '부산시 해운대구'),
	('Delta', 'Delta@example.com', '010-4444-5555', '대구시 중구'),
	('Echo', 'Echo@example.com', '010-5555-6666', '인천시 남구');

select * from customers;

-- 물품 정보 products 테이블
drop table if exists products;
create table products(
	product_id		int auto_increment primary key,
    product_name	varchar(100) not null,
    description 	text,
    price 			decimal(10, 2) not null, 		-- 최대 10자리 숫자 중 소수점 2자리 까지 저장
    stock 			int not null,
    regist_date 	timestamp default current_timestamp
);

insert into products(product_name, description, price, stock)
values ('스마트폰', '최신형 스마트폰, 128GB', 799000.00, 50),
	('노트북', '고성능 게이밍 노트북, 16GB RAM', 1999000.00, 30),
	('무선 이어폰', '액티브 노이즈 캔슬링 기능', 150000.00, 100),
	('스마트워치', '건강 모니터링 기능이 탑재된 스마트 워치', 299000.00, 70),
	('태블릿', '10인치 태블릿, 64GB', 450000.00, 50);
    
select * from products;

-- 주문 정보 orders 테이블
drop table if exists orders;
create table orders(
	order_id 		int auto_increment primary key,
    customer_id		int not null,
    order_date 		timestamp default current_timestamp,
    status 			enum('pending', 'shipped', 'delivered', 'cancelled') default 'pending',
    
    foreign key(customer_id) references customers(customer_id)
);

insert into orders(customer_id, order_date, status)
values (1, '2024-10-01 10:30:42', 'shipped'),
	(2, '2024-04-05 19:10:42', 'pending'),
    (3, '2024-01-19 01:52:42', 'delivered'),
    (1, '2024-02-11 00:23:42', 'delivered'),
    (2, '2024-06-25 14:00:00', 'cancelled');

select * from orders;

-- 주문 품목 정보 order_items 테이블
drop table if exists order_items;
create table order_items(
	order_item_id	int auto_increment primary key,
    order_id 		int not null,
    product_id 		int not null,
    quantity 		int not null,
    price 			decimal(10, 2) not null,
    
    foreign key(order_id) references orders(order_id),
    foreign key(product_id) references products(product_id)
);

insert into order_items(order_id, product_id, quantity, price)
values (1, 1, 1, 799000.00),
	(1, 3, 2, 150000.00),
	(2, 2, 1, 1999000.00),
	(3, 4, 1, 299000.00),
	(4, 5, 1, 450000.00),
	(5, 2, 2, 1999000.00);
    
select * from order_items;





















