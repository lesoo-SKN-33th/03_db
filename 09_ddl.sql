# DDL (Data Definition Language)
# - 테이터베이스 스키마(객체)를 만들고, 수정하고, 삭제하는 구문
# DDL 구문은 실행시 바로 DB에 반영됨(transaction없음)

# [주의 사항]
# 1. DML 구문 수행 -> 트랜잭션에 담김
# 2. 중간에 DDL 구문 수행
# 3. 트랜잭션 내용이 자동 commit

# create table
/*
 [작성법]
 create table [if not exists] 테이블명(
    컬럼1 자료형 [제약조건 | auto increment] [default] [comment],
    컬럼2 자료형 [제약조건] [default] [comment],
    컬럼3 자료형 [제약조건] [default] [comment]
 );
 */
# auto increment = 숮자 자동증가 옵션
# 기본적으로 pk 에만 사용가능

drop table product;
 create table if not exists product(
    id int primary key auto_increment comment '상품식별코드',
    name varchar(100) not null comment '상품명',
    price int not null default 0 comment '상품가격',
    created_at datetime default current_timestamp comment '상품 등록 일시'
 );

select * from product;

#테이블 생성 구문 확인
show create table product;
#생성한 테이블 설명 조회
desc product;

select * from information_schema.TABLES
where table_schema = 'menudb'
    and table_name = 'product';

insert into product(name) values('텀블러');
insert into product(name,price) values('머그컵', 3000);

commit;


# 제약조건 (constraint)
# 테이블 컬럼에 붙어 insert, update시 각 컬럼에 기록되는 값에 대한 조건을 설정하는 방법
# 데이터 무겨성을 보장하는 목적으로 사용
# 종류 : not null, unique, primary key, foreign key, check

select *
from information_schema.TABLE_CONSTRAINTS
where CONSTRAINT_schema = 'menudb'
    and TABLE_NAME = 'product'

#not null : 지정된 컬럼 은 null일수 없다 == 값 필수
#
DROP TABLE IF EXISTS user_unique;
CREATE TABLE IF NOT EXISTS user_unique (
    user_no INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL UNIQUE, # 유일한값이어야함
    email VARCHAR(255)
    # , UNIQUE (phone)
) ENGINE=INNODB;

INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_unique;

# unique 제약조건 에러 발생(전화번호 중복값 적용)
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# unique 제약조건 에러  해결 후 notnull 위배
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, null, 'pass03',
 '이순신', '남',
 '010-8888-8888', 'lee222@gmail.com');

# unique 제약조건 에러  해결 후 notnull 위배
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03',
 '이순신', '남',
 '010-8888-8888', 'lee222@gmail.com');


# primary key (중요)
# 테이블 내 행을 구별하기 위한 식별자 역할의 컬럼에 추가하는 제약 조건
# not null + unique : 중복되지 않는 값 필수
# primary key는 테이블 내에 1개만 설정 가능
# pk는 테이블 내에 1개만 설정 가능
# 단 pk설정이 적용되는 컬럼은 1개또는 여러개 묶음 가능

DROP TABLE IF EXISTS user_primarykey;
CREATE TABLE IF NOT EXISTS user_primarykey (
--     user_no INT PRIMARY KEY,
    user_no INT,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    PRIMARY KEY (user_no)
) ENGINE=INNODB;

INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_primarykey;

# primary key 제약조건 에러 발생(null값 적용)
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(null, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# primary key 제약조건 에러 발생(중복값 적용)
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(2, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# 복합 pk
create table order_composite_pk (
    user_id int,
    prod_id int,
    count int default 1,
    ordered_at datetime default (current_timestamp),
    primary key(user_id, prod_id, ordered_at)
);
insert into order_composite_pk
values (1, 1, 10, now());
insert into order_composite_pk
values (2, 1, 5, now());
insert into order_composite_pk
values (3, 100, default, now());

# pk컬럼값 3개가 모두 일치하는 중복데이터 삽입
insert into order_composite_pk
(select * from order_composite_pk where user_id = 3)
;

select * from order_composite_pk;

# foreign key(외래키)
# 참조(reference)된 다른 테이블에서 제공하는 값만 사용가능
# 참조 무결성을 위배하지 않기 위해 사용
# 다른 테이블의 pk나 unique가 설정된 컬럼만 참조 가능

# FK 제약조건 설정 시 두 테이블간의 관계(relationship)이 형성된다

# 부모테이블 : 참조를 당해서 컬럼값을 제공하는 테이블
# 자식테이블 : 참조를 통해 다른 테이블의 컬럼값을 사용하는 테이블

# 제공되는 값 외에 null 사용가능


DROP TABLE IF EXISTS user_grade;
CREATE TABLE IF NOT EXISTS user_grade (
    grade_code INT NOT NULL UNIQUE,
    grade_name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO user_grade
VALUES
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

SELECT * FROM user_grade;


DROP TABLE IF EXISTS user_foreignkey1;
CREATE TABLE IF NOT EXISTS user_foreignkey1 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
) ENGINE=INNODB;

INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey1;

# foreign key 제약조건 에러 발생(참조 컬럼에 없는 값 적용) :50
INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com', 50);
# [23000][1452] Cannot add or update a child row: a foreign key constraint fails (`menudb`.`user_foreignkey1`, CONSTRAINT `user_foreignkey1_ibfk_1` FOREIGN KEY (`grade_code`) REFERENCES `user_grade` (`grade_code`))



# FK 삭제옵션 설정
# 기본값 : 부모 컬럼 값을 자식이 참조중이면 변경, 삭제 불가능
# update/delete set null :
# 부모컬럼값을 자식이 참조중이면 변경, 삭제 시 자식컬럼값을 null로 변경
#
# update/delete cascade:
# 부모 컬럼 값을 자식이 참조중이면 변경, 삭제 시 자식테이블에서 참조값이 포함된 모든 행을 삭제



DROP TABLE IF EXISTS user_foreignkey2;
CREATE TABLE IF NOT EXISTS user_foreignkey2 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
        ON UPDATE SET NULL
        ON DELETE SET NULL
) ENGINE=INNODB;

INSERT INTO user_foreignkey2
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey2;

DROP TABLE IF EXISTS user_foreignkey1;

UPDATE user_grade
SET grade_code = 50
WHERE grade_code = 10;


-- 자식 테이블의 grade_code가 10이 었던 회원의 grade_code값이 NULL이 된 것을 확인
SELECT * FROM user_foreignkey2;


# check 제약 조건
#     컬럼에 삽입될수 있는 값에 대한 조건을 설정

DROP TABLE IF EXISTS user_check;
CREATE TABLE IF NOT EXISTS user_check (
    user_no INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3) CHECK (gender IN ('남','여')),
    age INT CHECK (age >= 19)
) ENGINE=INNODB;

INSERT INTO user_check
VALUES
    (null, '홍길동', '남', 25),
    (null, '이순신', '남', 33);

SELECT * FROM user_check;
INSERT INTO user_check
VALUES (null, '안중근', '남성', 27);
# [HY000][3819] Check constraint 'user_check_chk_1' is violated.

INSERT INTO user_check
VALUES (null, '유관순', '여', 17);
# [HY000][3819] Check constraint 'user_check_chk_2' is violated.

# alter 테이블 수정
-- alter table 테이블명 [서브명령어] ....
-- - add 컬럼/제약조건 추가
-- - drop 컬럼/제약조건 삭제
-- - modify 컬럼 자료형/not null/기본값 변경
-- - change 컬럼명 변경
-- - rename 테이블명 변경

select * from product;

# 컬럼 추가
alter table product
add description varchar(255)
not null
default '설명없음'
after price;
# 컬럼삭제
alter table product
drop description ;


# 제약조건 추가
alter table product
add unique (name);
desc product;

# 제약조건 삭제
alter table product
drop constraint name;


alter table product
modify name varchar(100) null;


# 컬럼명 변경
alter table product
change name product_name varchar(100) not null;

desc product;




# DROP 버림
drop table if exists product;




