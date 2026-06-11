use employeedb;

show tables;
-- Q1
# 재직여부, 폰범호, 입사일 최슨 3명
# 사원번호, 직원명, 전화번호, 입사일, 퇴직여부
select
    emp_id
     , emp_name
     , employee.PHONE
    , employee.HIRE_DATE
    , employee.ENT_YN
from employee
where ent_yn = 'N'
    and phone like '%2'
order by hire_date desc
limit 3;


-- Q2
# 재직중인 대리  직원명, 직급명, 급여, 사원번호
# , 이메일, 전번 입사일
# 급여 기준 내림차순
select e.emp_name
     , j.job_name
    , e.salary
    , e.emp_id
    , e.email
    , e.phone
    , e.hire_date
from employee e
    , job j
where  j.job_code = e.job_code
    and j.job_name = '대리'
    and e.ent_yn = 'N'
order by salary desc;




