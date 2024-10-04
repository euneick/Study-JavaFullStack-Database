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

drop table if exists customers;
create table customers(
	customer_id 	int auto_increment primary key,
    customer_name 	varchar(100) not null,
    email			varchar(100) unique not null,
    phone 			varchar(20),
    address 		varchar(255),
    regist_date		timestamp default current_timestamp
);

drop table if exists products;
create table products(
	product_id		int auto_increment primary key,
    product_name	varchar(100) not null,
    description 	text,
    price 			decimal(10, 2) not null, 		-- 최대 10자리 숫자 중 소수점 2자리 까지 저장
    stock 			int not null,
    regist_date 	timestamp default current_timestamp
);

drop table if exists orders;
create table orders(
	order_id 		int auto_increment primary key,
    customer_id		int not null,
    order_date 		timestamp default current_timestamp,
    status 			enum('pending', 'shipped', 'delivered', 'cancelled') default 'pending',
    
    foreign key(customer_id) references customers(customer_id)
);

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





















