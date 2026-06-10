/* SQL(Strudtured Query Language
   - 구조화된 질의 언어
   - RDBMS에서 저장ㄷ괸 데이터를 관리, 조직하거나 DB 구조를 제어할때 사용하는 언어

## SQL 종류
 - DQL(Data Query Language)
   - 데이터 질의어
   - 테이블에 데이터를 검색/조회
 - DML(Data Manipulation Language) - 데이터 조작언어
   - 테이블에 값을 수정하는
 - DDL(Data Definition Language)
 - DCL(Data Control Language)
 - TCL(Transaction Control Language)

 */

 # DQL구조
/*
    select 컬럼명 (5)  -- 필수
    from 테이블 (1)  -- 필수
    where 조건절(필터링) (2)
    group by 그룹핑 (3)
    having 조건절(그룹핑에 대해 필터링) (4)
    order by 정렬기준 (6)
    limit 행수제한 (7)

    1. SELECT : 조회하고자 하는 컬럼명을 기술함. 여러개를 기술하고자 하면 쉼표(,)로 구분하고 모든 컬럼 조회시 '*'을 사용
    2. FROM : 조회 대상 컬럼이 포함된 테이블명을 기술
    3. WHERE :
        행을 선택하는 조건을 기술함.
        여러 개의 제한 조건을 포함할 수 있으며, 각각의 제한 조건은 논리 연산자로 연결함
        제한조건을 만족시키는 행들만 Result Set에 포함됨
    4. ORDER BY : 정렬할 컬럼을 기준으로 오름/내림차순 지정
    5. GROUP BY : 행을 그룹핑함
    6. HAVING : 그룹핑된 행을 선택하는 조건을 기술함
*/

# tbl_menu(메뉴테이블)의 모든(*) 컬럼 조회
select
    *
from
    tbl_menu;

## 조회된 컬럼에 연산 가능
# 메뉴 테이블에서 메뉴명, 가격, 부가세(10%), 부가세 포함가격
select
    menu_name
     , menu_price as '메뉴 가격' # 따옴표로 띄어쓰기 묶어쓰기
     , menu_price *0.1 as tax
     , menu_price+menu_price * 0.1 as icld_tax
from tbl_menu;

#-----------------------------------------
# ResultSet : select 조회 결과 행의 집합
# 컬럼명 as 별칭 : ResultSet에 표기되는 컬럼명에 별칭(alias) 부여 가능
#-----------------------------------------

# 산술연산
select
    10 + 3
    , 10 - 3
    , 10 * 3
    , 10 / 3
    , 10 % 3
    , 10 div 3 # = /
    , 10 mod 3 # = %

# 문자열 연결 처리(이어쓰기)
   # concat('abc', 'def')
   #메뉴테이블서 메뉴명, 메뉴가격(원)
select menu_name as 메뉴명
, concat(menu_price, '원') as '메뉴가격(원)'
from tbl_menu;


# 컬럼 값 중복 제거
# 지정된 컬럼의 값이 중복되는 행을 제거

select distinct(tbl_menu.category_code), menu_name
from tbl_menu
/*
# order by 절
# 조회 결과의 정렬 순서를 지정하는 구문
특정 컬럼을 기준으로 삼아 오름차순(asc), 내림차순(desc) 지정
기준으로 삼은 컬럼이 여러개 존재하면 그룹화된 정렬 수행
*/

# 메뉴테이블 조회
select
    menu_name
    , tbl_menu.menu_price
from tbl_menu
order by menu_price desc;


# 문자열(유니코드 순서), 날짜(과거>미래)도 정렬기준 가능
# select 절에 작성되지 않은 컬럼도 정렬기준 가능

# 메뉴테이블에서 메뉴명 카테고리 코드, 가격을 조회
# 단 카테고리코드 오름차순, 가격 내림차순 조회
# 타테고리 코드로 오름차순 정렬 면저수행
# 같은 카테고리 코드를 지닌 행들끼리 붙어있게 됨
# 같은 카테고리 코드를 지닌 행 내에서 가격 내림차순 정렬 수행

select
    tbl_menu.menu_name
    , tbl_menu.category_code
    , tbl_menu.menu_price
from tbl_menu
order by category_code, menu_price desc


# WHERE 행 필터링
# - 각행별로 제시한 조건을 검사하고, TRUE인 행만 결과집합에 포함시킨다.

# WHERE 비교 연산자
-- 표현식 사이의 관계를 비교하기 위해 사용하고, 비교 결과는 논리 결과중에 하나 (TRUE/FALSE/NULL)가 됨
-- 단, 비교하는 두 컬럼 값/표현식은 서로 동일한 데이터 타입이어야 함

-- --------------------------------------------------------------------------------
-- 연산자                    설명
-- --------------------------------------------------------------------------------
-- =                        같다
-- >,<                        크다/작다
-- >=,<=                    크거나 같다/작거나 같다
-- <>,!=                    같지 않다 (^= 없음)
-- BETWEEN AND                특정 범위에 포함되는지 비교
-- LIKE / NOT LIKE            문자 패턴 비교
-- IS NULL / IS NOT NULL    NULL 여부 비교
-- IN / NOT IN                비교 값 목록에 포함/미포함 되는지 여부 비교
-- --------------------------------------------------------------------------------


# WHERE 논리 연산자
-- 여러 개의 제한 조건 결과를 하나의 논리결과로 만들어 줌 (&&,|| 사용불가)
-- AND &&    여러 조건이 동시에 TRUE일 경우에만 TRUE 값 반환
-- OR ||    여러 조건들 중에 어느 하나의 조건만 TRUE이면 TRUE값 반환
-- NOT !    조건에 대한 반대값으로 반환(NULL은 예외)
-- XOR        두 값이 같으면 거짓, 두 값이 다르면 참


# 메뉴테이블에서 가격이 13000  이상인 메뉴의 메뉴코드, 메뉴명, 가격 조회
#가격 내림차순 정렬
select
    menu_code
    , tbl_menu.menu_name
    , tbl_menu.menu_price
from tbl_menu
where menu_price > 13000
order by menu_price desc;


#menu 테이블에서 카테고리 코드가 10인 메뉴만 조회
# 카테고리 코드, 메뉴명, 가격 컬럼
# 메뉴명 오름차순 정렬
select tbl_menu.category_code
    , tbl_menu.menu_name
    , tbl_menu.menu_price
from tbl_menu
where category_code = 10
order by menu_name;


# 메뉴테이블에서 가격이 10000이상 20000이하인
#메뉴의 메뉴명 가격 카테고리 코드를 가격 내림차순 조회
select
    tbl_menu.menu_name
    , tbl_menu.menu_price
    , tbl_menu.category_code
from tbl_menu
where menu_price >= 10000
  and menu_price <= 20000
# between 10000 and 20000
order by menu_price desc;

#반대 -> 10000 미만, 20000초과
select
    tbl_menu.menu_name
    , tbl_menu.menu_price
    , tbl_menu.category_code
from tbl_menu
where menu_price not between 10000 and  20000
order by menu_price desc;
#





# 메뉴 테이블에서 카테고리 4,6,10 인 메뉴
# 메뉴명, 카테고리코드 조회, 카테고리 코드 오름차순정렬
select tbl_menu.menu_name
, tbl_menu.category_code
from tbl_menu
where category_code in (4,6,10)
order by category_code;


#like
# 문자열 패턴 검사 연산자
# _ 한글자
# % 여러글자
select tbl_menu.menu_name
from tbl_menu
where
    #아 로 시작
#     menu_name like '아%'
#     menu_name like '%밥'# 밥으로 끝내기
# menu_name like '%마늘%'
menu_name like '_____';# 5글자

# DB에서 Null == 저장된 데이터가 없다
# 카테고리 테이블에서 ref_category_code가 null인 행 조회
select *
from tbl_category
where ref_category_code is null;

# null 은 data가 아님. 칸이 비었음을 나타내는 기호
# '='로 구분 불가


#limit
# 조화 결과(ResultSet에서 지정된 크기만큼 행만 골라오기
select * from tbl_menu limit 5;
# limit n : 0-n행만큼만 조회
# limit start, n : start index부터 n개 조회
# limit offset, n : offset 만큼 건너뛰고 n 갸ㅐ 조회
# 페이징 처리 시 limit 사용

# 메뉴 테이블 이용해서 메뉴판 만들때 한페이지다 메뉴 4개씩만 조회
# 메뉴 코드 역순 조회
select * from tbl_menu
order by menu_code
desc limit 0, 4;


#between
# where menu_price not between 10000 and  20000
# in ()
# category_code in (4,6,10)
#like
# 문자열 패턴 검사 연산자
# _ 한글자
# % 여러글자
# null 은 data가 아님. 칸이 비었음을 나타내는 기호
# '='로 구분 불가, -> is null
#limit
# limit n : 0-n행만큼만 조회
# limit start, n : start index부터 n개 조회
# limit offset, n : offset 만큼 건너뛰고 n 갸ㅐ 조회
# 페이징 처리 시 limit 사용