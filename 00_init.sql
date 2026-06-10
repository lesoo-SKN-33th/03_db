create user skn_ai@'%' identified by '1234'; #계정

#MySQL에서는 database와 schema를 같은 의미로 사용
# database(데이터 참고) = schema(참고 설계도, 명세서)
create database menudb; # 데이터 저장 공간 생성

 # 계정 권한 부여(menub db에 대한 모든 권한)
grant all privileges on menudb.* to skn_ai@'%';
grant all privileges on employeedb.* to skn_ai@'%';

show grants for skn_ai; # 부여된 권한 조회

show databases;
create schema employeedb;




