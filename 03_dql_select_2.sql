-- =============================
-- JOIN
-- =============================
-- 두개 이상의 테이블의 레코드를 연결해서 가상테이블(relation) 생성
-- 연관성을 가지고 있는 컬럼을 기준(데이터)으로 조합

# relation을 생성하는 2가지 방법
-- 1. join : 특정컬럼 기준으로 행과 행을 연결한다. (가로)
-- 2. union : 컬럼과 컬럼을 연결한다.(세로)
-- join은 두 테이블의 행사이의 공통된 데이터를 기준으로 **선을 연결해서** 새로운 하나의 행을 만든다.

# JOIN 구분
-- 1. Equi JOIN : 일반적으로 사용하는 Equality Condition(=)에 의한 조인
-- 2. Non-Equi JOIN : 동등조건(=)이 아닌 BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN, !=  등으로 사용.

# EQUI JOIN 구분
-- 1. INNER JOIN(내부 조인) : 교집합 (일반적으로 사용하는 JOIN)
-- 2. OUTER JOIN(외부 조인) : 합집합
        -- LEFT (OUTER) JOIN (왼쪽 외부 조인)
        -- RIGHT (OUTER) JOIN (오른쪽 외부 조인)
-- 3. CROSS JOIN
-- 4. SELF JOIN(자가 조인)
-- 5. MULTIPLE JOIN(다중 조인)


#inner join (내부 조인)
# - 두 테이블의 교집합을 반환하는 sQL JOIN
# - == 조인에 사용될 두 테이블의 특정 컬럼값이 같은 행만 join

#tbl_menu, tbl_category

select *
from tbl_menu a
inner join # inner는 생략 가능
    tbl_category b
    on a.category_code = b.category_code;


select c.category_name, m.*
from
    tbl_menu m
    , tbl_category c
where m.category_code = c.category_code;

#메뉴명 가격 카테고리명 가격 내림차순 출력
#
select m.menu_name, m.menu_price, c.category_name
from
    tbl_menu m
join tbl_category c
on m.category_code = c.category_code
order by menu_price desc;


#outer join
-- 좌/우측 기준 테이블의 모든 행을 relation에 포함하는 join
-- left [outer] join
-- right [outer] join

# employeedb 로 변겅
select emp_name, dept_code
from employee;





insert into tbl_menu(menu_name, menu_price, category_code, orderable_status)
values('초콜릿 덮밥', 10000, 7, 'Y');
commit;


;
select * from tbl_menu;


#employee tbl, department tbl innerjoin
# empl -> 23행 , depart  -> 9행
# -> 21행
# 원인 -> dept_code 값이 없는
# 하동운, 이오리 2행이 join결과에 포함되지 않음

select a.emp_id, a.emp_name, a.dept_code, b.dept_id, b.dept_title
from employee a
inner join
    department b
on a.dept_code = b.dept_id
order by a.emp_id asc;

# join 구문 기준 왼쪽에 작섣된 테이블의 모든 행이
# relation에 포함되게 하기
# inner join 결과 21행 + employee join 안된 3행 => 24행
select
    a.emp_id
     , a.emp_name
     , a.dept_code
     , b.dept_id
     , b.dept_title
from employee a left outer join department b
on a.dept_code = b.dept_id
order by a.emp_id asc;

# join 구문 기준 오른쪽에 작섣된 테이블의 모든 행이
# relation에 포함되게 하기
# inner join 결과 21행 + depart join 안된 3행 => 24행
select a.emp_id
     , a.emp_name
     , a.dept_code
     , b.dept_id,
       b.dept_title
from employee a right outer join department b
on a.dept_code = b.dept_id
order by a.emp_id asc;

##  menudb
# cross join(카테시안곱, 곱집함)
# join 되는 두 테이블의 모든 경우의 수 처리
select count(*) from tbl_menu;#22
select count(*) from tbl_category;#12
# => 264
select * from tbl_menu
cross join
    tbl_category;

# self join
# 하나의 테이블에서 한 행이 다른행을 참조하는 관계가 있는 경우
# 같은 테이블끼리 조인하는것
select * from tbl_category; # 12 행

select * from (select a.category_code as '대분류 코드'
                    , a.category_name as '대분류 명'
                    , b.category_code as '소분류 코드'
                    , b.category_name as '소분류명'
               from tbl_category a
                        join tbl_category b
                             on a.category_code = b.ref_category_code) a
where `대분류 명` = '식사'
;
#     and a.ref_category_code is null

# multiple join
# 3개 이상의 테이블을 조인하는것
# join 순서가 매우 중요함
# ex) a join b join c
# -> (a+b) join c
# -> (a+b+c)
select * from tbl_order;
select * from tbl_order_menu;
select * from tbl_menu;

select
    *
from
    tbl_order o
    join
        tbl_order_menu om
on o.order_code = om.order_code # o + om 합쳐진 relation 생성
    join tbl_menu m
on om.menu_code = m.menu_code
;

# employeedb 로 변경
select * from employee; #dept code 23 (dept null 2개)
select * from department; # dept id 9
select * from location; # location id, local code 5

select *
from employee e
    , department d
    , location l
where e.DEPT_CODE = d.DEPT_ID
    and d.LOCATION_ID = l.LOCAL_CODE
;

select *
from employee e
    join department d
on e.DEPT_CODE = d.DEPT_ID
    join location l
        on d.LOCATION_ID = l.LOCAL_CODE
;





