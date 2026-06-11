### Set operators(집합연산)
# 두개 이상의 select 결과를 결합

#union
# 두 개 이상의 SELECT 문의 결과를 결합하여 중복된 레코드를 제거한 후 반환하는 SQL 연산자이다.
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10 #6행 2,3,4,11,12,17
UNION
SELECT # 9행 1,2,3,4,10,12,13,17,23
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;


# intersect : 교집합
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10 #6행 2,3,4,11,12,17
    intersect
SELECT # 9행 1,2,3,4,10,12,13,17,23
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;


# UNION ALL : 중복 미제거 = 합집합 + 교집합
# 두 개 이상의 SELECT 문의 결과를 결합하며 중복된 레코드를 제거하지 않고 모두 반환하는 SQL 연산자이다.
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10 #6행 2,3,4,11,12,17
    union all
SELECT # 9행 1,2,3,4,10,12,13,17,23
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;



## 1-4. MINUS : 차집합
# - 첫 번째 SELECT 문의 결과에서 두 번째 SELECT 문의 결과가 포함하는 레코드를 제외한 레코드를 반환하는 SQL 연산자이다.
# - MySQL은 MINUS를 제공하지 않는다. 하지만 LEFT JOIN을 활용해서 구현하는 것은 가능하다.

 SELECT
    a.menu_code,
    a.menu_name,
    a.menu_price,
    a.category_code,
    a.orderable_status
FROM
    tbl_menu a
LEFT JOIN (SELECT #9개
		menu_code,
		menu_name,
		menu_price,
		category_code,
		orderable_status
	FROM
		tbl_menu
	WHERE
		menu_price < 9000 ) b on (a.menu_code = b.menu_code)
WHERE
    a.category_code = 10 AND
    b.menu_code IS NULL;




-- ===================================
-- SUBQUERY
-- ===================================
-- 하나의 SQL문(main-query) 안에 포함되어 있는 또 다른 SQL문(sub-query)
-- 존재하지 않는 조건에 근거한 값들을 검색하고자 할때 사용.
-- 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계이다.
-- 메인 쿼리 실행중에 서브 쿼리를 실행해서 그 결과값을 다시 메인쿼리에 전달하는 방식이다.

# 서브쿼리(SUBQUERY) 유형
-- 1. 일반 서브쿼리
-- 2. 상관 서브쿼리
-- 3. 인라인뷰(파생테이블)

# 규칙
-- 서브쿼리는 반드시 소괄호로 묶어야 함 - (SELECT ... ) 형태
-- 서브쿼리는 연산자의 오른쪽에 위치 해야 함
-- 서브쿼리 내에서 order by 문법은 지원 안됨

# 1. 메뉴테이블에서 '민트미역국'의 카테고리 코드 조회
SELECT  tbl_menu.category_code
from tbl_menu
where menu_name = '민트미역국'; #4

# 2. 메뉴 테이블에서 카테고리 코드가 4인 메뉴 조회
select *
from tbl_menu
where category_code = '4';

# 3. 메뉴 테이블에서 카테고리 코드가 4인 메뉴 조회
select *
from tbl_menu
where
    category_code = (
        SELECT  tbl_menu.category_code
        from tbl_menu
        where menu_name = '민트미역국' #4
    );


# 메뉴테이블에서 민트미역국 보다 비싼 메뉴 가격 내림차순 출력
select *
from tbl_menu
where
    menu_price > (
        select menu_price
        from tbl_menu
        where menu_name = '민트미역국'
        )
order by menu_price desc;

select * from tbl_menu

#다중행 단일열 서브쿼리
# 서브쿼리가 여러개의 값을 반환
# 카테고리 테이블에서 ref category code 값이 1인 카테고리코드를 찾아 메뉴테이블에서
# 같은 카테고리의 메뉴를 모두 조회
select *
from tbl_menu
where category_code in (
    select category_code
    from tbl_category
    where ref_category_code = 1
    );


# 상관서브쿼리 (상호연관)
-- 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음
-- 그 결과를 다시 메인쿼리로 반환하는 방식으로 수행되는 서브쿼리

-- 서브쿼리의 WHERE 절 수행을 위해서는 메인쿼리가 먼저 수행되는 구조
-- 메인쿼리 테이블의 레코드(행)에 따라 서브쿼리의 결과값도 바뀜
-- 메인 쿼리에서 처리되는 각 행의 컬럼값에 따라 응답이 달라져야 하는 경우에 유용

# 구분
-- 메인쿼리에 있는 것을 서브쿼리에서 가져다 쓰면 상관 서브쿼리 (블럭 잡아 단독으로 실행할수 없다.)
-- 그렇지 않고 서브쿼리가 독단적으로 사용이 되면 일반 서브쿼리

# 카테고리별 가장 비싼 메뉴 조회

# 1. 4번 카테고리 메뉴중 가장 비싼 메뉴
select max(tbl_menu.menu_price)
from tbl_menu
where category_code = '4'
;
# 2. 카테고리별 가장 비싼 메뉴
select category_code, max(tbl_menu.menu_price)
from tbl_menu
group by category_code
;

# 카테고리별 평균 금액보다 비싼 메뉴만 조회
select fro
from tbl_menu main
where menu_price > 20000;

# 카테고리별 최고가 메뉴
select *
from tbl_menu main
where menu_price = (
    select max(menu_price)
    from tbl_menu sub
    where sub.category_code = main.category_code

    )
;

# 카테고리별 평균보다 큼
select *
from tbl_menu main
where menu_price > (
    select avg(menu_price)
    from tbl_menu sub
    where sub.category_code = main.category_code
    )
;

# 스칼라 서브쿼리
# select 절에서 사용하는 결과 값이 1개인 서브쿼리

select
    menu_name
     , category_code
    , (select category_name
       from tbl_category sub
       where main.category_code = sub.category_code) category_name
from
    tbl_menu main;


## 인라인 뷰(INLINE VIEW)
# from 절에 작성된 서브쿼리
# 서브쿼리의 결과 집함(ResultSet)을 테이블처럼 사용
#
select *
from (select m.menu_code as 메뉴코드
           , m.menu_name as 메뉴명
           , c.category_name as 카테고리명
      from tbl_menu m
               join tbl_category c
                    on (m.category_code = c.category_code)
      ) menu_view
where 카테고리명 = '한식';



## CTE (Common Table Expression)
# 인라인뷰로 사용할 서브쿼리를 테이블변수에 저장하고 사용할수 있게 하는 문법
/*
 [작성법]
 with 변수명 as (서브쿼리)
 select * from 변수명
 */


with menu_view as (select m.menu_code as 메뉴코드
           , m.menu_name as 메뉴명
           , c.category_name as 카테고리명
      from tbl_menu m
               join tbl_category c
                    on (m.category_code = c.category_code))
select *
from  menu_view
where 카테고리명 = '한식'




