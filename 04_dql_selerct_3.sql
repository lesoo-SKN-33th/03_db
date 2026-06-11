# 그룹 함수
# 그룸의 통계를 반환하는 함수
# sum(), avg(), count(), max(), min()

#sum(컬럼명)
# null (빈칸 상태)이 아닌 컬럼의 합

select
    avg(menu_price)
from tbl_menu;

# 카테고리 코드가 10인 메뉴의 평균 가격
select
    avg(tbl_menu.menu_price)
from tbl_menu
where category_code = 10;

# 메뉴 가격 최대 최소
select
    max(menu_price)
    ,min(menu_price)
from tbl_menu;


#null과 연산수행시 항상 null
select 1+ null ;# null

# 합계, 평균 -> 숫자 데이터 컬럼에만 적용가능
# 최대 최소 -> 숫자, 문자, 날짜 모두 가능

select max(menu_name), min(menu_name)
from tbl_menu;

# count(*|컬럼명) : 행의 갯수 조회
# count(*) : 모든 행(null포함)
# count(컬럼명) : 지정된 컬럼 값 중 null인 컬럼을 제외한 행의 갯수

select count(*) , count(ref_category_code) from tbl_category;#9


# gruop by 절
# 지정된 컬럼 값이 일치하는 행을 그룹화 시키는 구문
select category_code as 코드
     , count(*) as 갯수
     , sum(menu_price) as 합계
    , avg(menu_price) as 평균
    , min(menu_price) as 최소
    , max(menu_price) as 최대
from tbl_menu
group by category_code;

# group by 사용시 주의할점
# 1. null도 별도 그룹으로 묶인다
# 2. select 절에는 group by 기준이 된 컬럼 + 그룹합수만 작성 가능하다

select
    ref_category_code, count(*)
from tbl_category
group by ref_category_code;

## 그룹 내 하위 그룹 구성 가능
# category_code 로 1ck 그룹하 후
# 각 그룹에서 orderable_status가 같은 행끼리 2차 그룹화

select category_code
     , orderable_status
    , count(*)
from tbl_menu
group by category_code, orderable_status
order by category_code;

# where + group by : 필터링된 행 중 컬럼값이 같은 행 그룹화
# - where : 지정된 테이블에서 행을 필터링
# - group by : 컬럼값이 같은 행을 그룹화

# 메뉴 가격이 10000원 이상인 메뉴 중  카테고리별 갯수, 합계 구하기
select category_code
     , count(menu_price)
     , sum(menu_price)
from tbl_menu
where menu_price >= 10000
group by category_code
;

# 메뉴테이블에서 주문이 가능한 메뉴 중 ctg 코드가 4,10인 메뉴의 카테고리별 갯수
select m.category_code, c.category_name, count(*)
from tbl_menu m
, tbl_category c
where m.category_code in (4, 10)
  and m.category_code = c.category_code
    and orderable_status = 'Y'
group by m.category_code;


# having 절
# group by 를 통해 만들어진 그룸에 대한 조건을 작성하는 구문
# having절 작성 시 항상 그룸함수가 포함됨

# 메뉴 테이ㅏ블에서 카테고리별 메뉴 개수가 2개 이상인 카테고리의 카테고리 번호, 개수 출력
select tbl_menu.category_code, count(*)
from tbl_menu
group by category_code
having count(*) >=2;

# 카테고리 테이블에서 부모 카테고리별로 개수가 3개 이상dls
# 부모카테고리 번호, 개수 조히
# 부모 카테고리 오름차순
select tbl_category.ref_category_code, count(*)
from tbl_category
where ref_category_code is not null
group by ref_category_code
having count(*) >= 3
#    and ref_category_code is not null
order by ref_category_code asc
limit 1,1;

select tbl_category.ref_category_code, count(*)
from tbl_category
where ref_category_code is not null
group by ref_category_code
having count(*) >= 3
#    and ref_category_code is not null
order by count(*) asc
limit 1;



