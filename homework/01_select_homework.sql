# 상위 카테고리 코드가 null이 아닌
# 카테고리의 카테고리 코드와 카테고리명을 출력하세요.
# 단, 카테고리명을 기준으로 내림차순 정렬하여 출력하세요.
use menudb;

-- Q1
select category_code
, category_name
from tbl_category
where ref_category_code is not null
order by category_name desc;

-- Q2
select
    menu_name
    , menu_price
from tbl_menu
where menu_name like '%밥%'
    and menu_price between 20000 and 30000;

-- Q3
select *
from tbl_menu
where menu_price < 10000 or menu_name like '%김치%'
order by menu_price asc, menu_name desc;

-- Q4
select *
from tbl_menu
where menu_price = 13000
  and category_code not in (8,9,10);

select *
from tbl_menu
where menu_price = 13000
    and category_code not in (
        select category_code
        from tbl_category
        where category_name in ('기타', '쥬스', '커피')
    )
;



