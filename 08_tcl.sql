# TCL (Transaction Cotrol Language)
# 트랜잭션 제어 언어
# commit, rollback, savepoint


# Transaction이란?
# 한번에 수행될 DML 논리적 작업 단뒤
# 한번에 완료 또는 취소할수 있게하기 우해 사용

# mysql은 autocommit이 default

set autocommit = ON;
set autocommit = OFF;

#commit : DML로 인한 변경 사항(transaction)을 DB에 저장
#rollback : DML 변경사항을 취소(Transaction 내부 내용 폐기)

#트랜잭션 시작 == 이후 실행되는 DML 구문을 트랜잭션에 저장
#트랜잭션 종료 == commit , rollback
start transaction ; # autocommit이 활성화 되어도 사용 가능

select * from tbl_menu
where menu_code = 21;

update tbl_menu set orderable_status = 'N'
where  menu_code = 21;


# 수정 후 commit 을 수행하지 않았는데 조회 시 수정내용이 반영된것처럼 보이는 이유
# -> 실제 DB에 반영은 안됐지만 조회시 트랜잭션에 저장된 DML구무을 반영해서 보여줌
rollback ;

delete from tbl_menu
where menu_code = 100;

commit;

insert into tbl_menu
values(null,
       'txtest',
       3000,
        5,
       'N');
select * from tbl_menu;



