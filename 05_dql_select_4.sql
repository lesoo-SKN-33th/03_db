# 내장함수
# mysql dbms에 이미 구현된 함수
# 문자형, 숫자형, 날짜형별 함수가 따로 제공
# 반드시 반환값을 갖는다

# 문자열 관련 함수
# ascii : char to ascii
# char : ascii to char
select ascii('A'), char(65);
# => 65, A

# 문자 인코딩 : 컴퓨터에서 문자를 표시하는 방법
# utf-8 : 아스키코드 문자는 1byte, 나머지는 3byte 표시(mysql 차용)
# utf-16 : 모든 문자를 2byte(16bit)로 표시

# BIT_LENGTH: 할당된 비트 크기 반환
# CHAR_LENGTH: 문자열의 길이 반환
# LENGTH: 할당된 BYTE 크기 반환
SELECT BIT_LENGTH('pie')
     , CHAR_LENGTH('pie')
     , LENGTH('pie'); # utf-8이라서 -> 3

SELECT menu_name
     , LENGTH(menu_name)
     , BIT_LENGTH(menu_name)
     , CHAR_LENGTH(menu_name)
from tbl_menu;

# CONCAT(문자열1, 문자열2, ...), CONCAT_WS(구분자, 문자열1, 문자열2, ...)
# CONCAT: 문자열을 이어붙임
# CONCAT_WS: 구분자와 함께 문자열을 이어붙임
SELECT CONCAT('호랑이', '기린', '토끼');
SELECT CONCAT_WS(',', '호랑이', '기린', '토끼');
SELECT CONCAT_WS('-', '2023', '05', '31');

# ELT(위치, 문자열1, 문자열2, ...), FIELD(찾을 문자열, 문자열1, 문자열2, ...),
# FIND_IN_SET(찾을 문자열, 문자열 리스트), INSTR(기준 문자열, 부분 문자열),
# LOCATE(부분 문자열, 기준 문자열)
# ELT: 해당 위치의 문자열 반환
# FIELD: 찾을 문자열 위치 반환
# FIND_IN_SET: 찾을 문자열의 위치 반환
# INSTR: 기준 문자열에서 부분 문자열의 시작 위치 반환
# LOCATE: INSTR과 동일하고 순서는 반대
SELECT
    ELT(2, '사과', '딸기', '바나나')
    , FIELD('딸기', '사과', '딸기', '바나나')
     , FIND_IN_SET('바나나', '사과,딸기,바나나')
     , INSTR('사과딸기바나나', '딸기')
     , LOCATE('딸기', '사과딸기바나나');


# INSTR(가준문자열, 검색문자열): 기준 문자열에서 부분 문자열의 시작 위치 반환
# 기준문자열에서 부분 문자열의 시작위치 반환
select instr('사과딸기바나나', '딸기');
# => 3
select instr('사과딸기바나나', '포도');
# => 0 : 없음

# 메뉴테이ㅏ블에서 메뉴명에 마늘이 포함된 메뉴 조회
select *
from tbl_menu
where
#     menu_name like '%마늘%';
    instr(menu_name, '마늘') ; >0;



# LPAD(문자열, 길이, 채울 문자열), RPAD(문자열, 길이, 채울 문자열)
# LPAD: 문자열을 길이만큼 왼쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
# RPAD: 문자열을 길이만큼 오른쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
SELECT LPAD('왼쪽', 6, '@'), RPAD('오른쪽', 6 ,'@');


# SUBSTRING(문자열, 시작위치, 길이)
# SUBSTRING: 시작 위치부터 길이만큼의 문자를 반환(길이를 생략하면 시작 위치부터 끝까지 반환)
SELECT
    SUBSTRING('안녕하세요 반갑습니다.', 7, 2)
     , SUBSTRING('안녕하세요 반갑습니다.', 7)
     , SUBSTRING('안녕하세요 반갑습니다.', (instr('안녕하세요 반갑습니다.','반갑')));


#
#
#
# # FORMAT(숫자, 소수점 자릿수)
# # FORMAT: 1000단위마다 콤마(,) 표시를 해 주며 소수점 아래 자릿수(반올림)까지 표현한다.
# SELECT FORMAT(123142512521.5635326, 3);
#
# # BIN(숫자), OCT(숫자), HEX(숫자)
# # BIN: 2진수 표현
# # OCT: 8진수 표현
# # HEX: 16진수 표현
# SELECT BIN(65), OCT(65), HEX(65);
#
# # INSERT(기준 문자열, 위치, 길이, 삽입할 문자열)
# # INSERT: 기준 문자열의 위치부터 길이만큼을 지우고 삽입할 문자열을 끼워 넣는다.
# SELECT INSERT('내 이름은 아무개입니다.', 7, 3, '홍길동');
#
# # LEFT(문자열, 길이), RIGHT(문자열, 길이)
# # LEFT: 왼쪽에서 문자열의 길이만큼을 반환
# # RIGHT: 오른쪽에서 문자열의 길이만큼을 반환
# SELECT LEFT('Hello World!', 3), RIGHT('Hello World!', 3);
#
# # UPPER(문자열), LOWER(문자열)
# # UPPER: 소문자를 대문자로 변경
# # LOWER: 대문자를 소문자로 변경
# SELECT LOWER('Hello World!'), UPPER('Hello World!');
#
#


## 수학 관련 함수
# CEILING(숫자), FLOOR(숫자), ROUND(숫자)
# CEILING: 올림값 반환
# FLOOR: 내림값 반환
# ROUND: 반올림값 반환
# TRUNCATE(숫자, 소수점자리): 버림
SELECT CEILING(1234.56)
     , FLOOR(1234.56)
     , ROUND(1234.56)
    , TRUNCATE(1234.56, 0)
    , TRUNCATE(1234.56, -1);# 12340 -> 1의자리 버림

SELECT CEILING(-1234.56)  #-1234
     , FLOOR(-1234.56) # -1235
     , ROUND(-1234.56) # -1235
    , TRUNCATE(-1234.56, 0); # -1234


# RAND()
# RAND: 0이상 1 미만의 실수를 구한다.
# 'm <= 임의의 정수 < n'을 구하고 싶다면
# FLOOR((RAND() * (n - m) + m)을 사용한다.
# 1부터 10까지 난수 발생: FLOOR(RAND() * (11 - 1) + 1)
SELECT RAND(), FLOOR(RAND() * (11 - 1) + 1);

select rand(), rand(), rand();

# 1-45 사이 난수 1개 조회
select floor(rand()*45);




## 날짜관련 함수
#now() : 현재시감
# adddate(date, 일수)
# subdate(date, 일수)

select now(),
       adddate(now(), 1),
       subdate(now(), 1),
       adddate(now(), interval 1 month),
       subdate(now(), interval 1 month);

# DATEDIFF(날짜1, 날짜2), TIMEDIFF(날짜1 또는 시간1, 날짜1 또는 시간2)
# DATEDIFF: 날짜1 - 날짜2의 일수를 반환
# TIMEDIFF: 시간1 - 시간2의 결과를 구함

SELECT
    DATEDIFF('2023-05-31', NOW()),
    DATEDIFF(now(), '2026-11-20')
     , TIMEDIFF('17:07:11', '13:06:10');

# extract(단위 from date)
# - date에서 해당하는 단위 추출
# - 단위: year, quarter, month,
#    week, day, hour, minute, second, microsecond
select
    now(),
    extract(year from now()),
    extract(month from now()),
    extract(day from now()),
    extract(week from now());


# date_format(datetime, 형식문자열) -> 문자열
select
    date_format(now(), '%y/%m/%d'),
    date_format(now(), '%Y/%m/%d'),
    date_format(now(), '%h:%i');

# str_to_date(문자열, 형식문자열) -> datetime
select
    str_to_date('25/04/21', '%y/%m/%d'),
    str_to_date('2025/04/21', '%Y/%m/%d'),
    cast('2025/04/21' as date); -- 날짜시간형식 유추가 가능한 경우

# 기타함수
# null처리 함수 - ifnull(값, null일때 값)
select
    ifnull(category_code, '미지정') category_code
from
    tbl_menu;

# 삼항연산처리 - if(조건식, 참일때 값, 거짓일때 값)
select
    isnull(category_code),
    if(isnull(category_code), '미지정', category_code) category_code
from
    tbl_menu;

select
    menu_name,
    menu_price,
    if(menu_price < 10000, '싼', '비싼') price_clf
from
    tbl_menu;