USE mywork;

-- SQL함수 : 진짜 많아요. 쓰시게 되는 것만 쓰게 될 거, 똑같은 동작을 하는 여러개 함수 - RDBMS 종류마다 쓰는 함수명을 다 넣어놓은 경우도 있습니다  
SELECT CHAR_LENGTH('SQL'), LENGTH('SQL'), CHAR_LENGTH('홍길동'), LENGTH('홍길동'); 
# SQL에서 한글 1글자 : 3바이트 LENGTH로 확인 

SELECT CONCAT('This', 'Is', 'MySQL', '.') AS CONCAT1, 
       CONCAT('SQL', NULL, 'Books') AS CONCAT2, # NULL과 문자열을 연결하면 그 결과는 NULL
       CONCAT_WS(' ', 'This', 'Is', 'MySQL') AS CONCAT_WS; 
		# CONCAT_WS() 함수는 구분자인 첫 번째 매개변수가 콤마(,)이므로 두 번째부터 네 번째 매개변수를 연결하면서 그 사이에 구분자 콤마 기입

SELECT FORMAT(123456789.123456, 4) fmt, -- FORMAT(숫자를 3개씩 끊어서 ,로 출력, 소수점이후 N번째 자리까지 반올림 출력)
       INSTR('ThisIsSQL', 'sql') instring, -- index string, MySQL은 1부터 시작, 윈도우서버 SQL은 대소문자 구분 없음 
       LOCATE('my', 'TheMyDBMSMySQL', 5) locates, -- 'TheMyDBMSMySQL'에서 'my'를 찾아줘 5번째인덱스 이후에서 
       POSITION('my' IN 'TheMyDBMSMySQL') pos; -- LOCATE('my', 'TheMyDBMSMySQL', 1) 과 같은 동작
       
SELECT LOWER('ABcD'), LCASE('ABcD'),
       UPPER('abcD'), UCASE('abcD');
       
SELECT REPEAT('SQL', 3),
       REPLACE('생일 축하해 철수야', '철수', '영희') REP,
       REVERSE('SQL');

# SUBSTR() 함수는 첫 번째 매개변수 str의 문자열에서 두 번째 매개변수 pos로 지정된 위치부터 세 번째 매개변수 len만큼 잘라 반환합니다.
-- len은 생략 가능하며, 생략하면 str의 오른쪽 끝까지 잘라냅니다. 또한 pos 값에 음수도 넣을 수 있는데, 이때는 시작 위치를 왼쪽이 아닌 오른쪽 끝을 기준으로 잡습니다. 
-- 그리고 SUBSTRING(), MID() 함수는 SUBSTR() 함수와 사용법이 같습니다.
SELECT SUBSTR('This Is MySQL', 6, 2) FIRST,
       SUBSTRING('This Is MySQL', 6) SECOND,
       MID('This Is MySQL', -5) THIRD; -- 음수인덱싱

SELECT CURDATE(), CURRENT_DATE(), CURRENT_DATE,
       CURTIME(), CURRENT_TIME(), CURRENT_TIME,
       NOW(), CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP;
       
SELECT DATE_FORMAT('2021-01-20 13:42:54', '%d-%b-%Y') Fmt1,
       DATE_FORMAT('2021-02-20 13:42:54', '%U %W %j') Fmt2;

SELECT STR_TO_DATE('21,01,2021', '%d,%m,%Y') CONV1,
       STR_TO_DATE('19:30:17', '%H:%i:%s') CONV2,
       STR_TO_DATE('09:30:17', '%h:%i:%s') CONV3,
       STR_TO_DATE('17:30:17', '%h:%i:%s') CONV4;  -- ‘19:30:17’에서 시간이 19시로 24시간 형태인데, %h는 12시간 형태이므로 변환에 실패해 결국 NULL을 반환

SELECT SYSDATE(), SLEEP(2), SYSDATE(); -- 매번 함수 호출시의 시간

SELECT NOW(), SLEEP(2), NOW(); -- 문장 단위로 실행됨


 
SELECT DATE_ADD('2021-01-20', INTERVAL 5 DAY) DATEADD,
	   ADDDATE('2021-01-20', INTERVAL 5 MONTH) ADD_DATE1,
       ADDDATE('2021-01-20', 5 ) ADD_DATE2,
       ADDDATE('2021-01-20', INTERVAL '1 1' YEAR_MONTH) ADD_DATE3;
       
SELECT DATE_SUB('2021-01-20', INTERVAL 5 DAY) DATEADD,
	   SUBDATE('2021-01-20', INTERVAL 5 MONTH) ADD_DATE1,
       SUBDATE('2021-01-20', 5 ) ADD_DATE2,
       SUBDATE('2021-01-20', INTERVAL '1 1' YEAR_MONTH) ADD_DATE3;
       
-- EXTRACT() -- 매개변수의 date에서 특정 날짜 단위를 추출한 결과 반환
SELECT EXTRACT(YEAR_MONTH    FROM '2020-01-20 13:32:03') YEARMON,
       EXTRACT(DAY_HOUR      FROM '2020-01-20 13:32:03') DAYHOUR,
       EXTRACT(MINUTE_SECOND FROM '2020-01-20 13:32:03') MINSEC;

-- int('10') type casting 
SELECT CAST(10 AS CHAR)                 CONV_CHAR,
       CAST('-10' AS SIGNED )           CONV_INT, -- 양수, 음수 다 받는 자료형 
       CAST('10.2131' AS DECIMAL)       CONV_DEC1,
       CAST('10.2131' AS DECIMAL(6, 2)) CONV_DEC2, -- 고정소수점
       CAST('10.2131' AS DOUBLE)        CONV_DOUBLE, -- 부동소수점 -> 앞으로는 뺄거래요 
       CAST('2021-10-31' AS DATE)       CONV_DATE,
       CAST('2021-10-31' AS DATETIME)   CONV_DATETIME;

-- CONVERT() 함수도 CAST() 함수와 마찬가지로 형 변환하나, CAST() 함수와 달리 AS type 대신 type을 두 번째 매개변수로 받음
SELECT CONVERT(10, CHAR)                 CONV_CHAR,
       CONVERT('-10', SIGNED)            CONV_INT,
       CONVERT('10.2131', DECIMAL)       CONV_DEC1,
       CONVERT('10.2131', DECIMAL(6, 4)) CONV_DEC2,
       CONVERT('10.2131', DOUBLE)        CONV_DOUBLE,
       CONVERT('2021-10-31', DATE)       CONV_DATE,
       CONVERT('2021-10-31', DATETIME)   CONV_DATETIME;
       
 
 -- 흐름제어 함수
# 흐름 제어(flow control) 함수란 특정 조건을 확인해 조건에 부합하는 경우와 그렇지 않은 경우에 다른 값을 반환하는 함수
# 흐름 제어 함수에는 IF(), IFNULL(), NULLIF() 함수가 있고, 흐름 제어 함수와 비슷한 역할을 하는 CASE 연산자도 있다
SELECT IF(2 > 1, 1, 0) IF1,  -- IF(조건, 참일때 리턴값, 거짓일 때 리턴값)
       IF('A' = 'a', 'SAME', 'NOT SAME') IF2, -- window의 MYSQL에서는 대소문자 구분 X 
       IF(1 = 2, 1, 'A') IF3;

-- NULLIF() 함수는 두 매개변수 expr1과 expr2 값이 같으면 NULL을, 같지 않으면 expr1을 반환
SELECT NULLIF(1, 1) NULLIF1,
       NULLIF(1, 0) NULLIF2,
       NULLIF(NULL, NULL) NULLIF3;
       
SELECT CASE 1 WHEN 0 THEN 'A' -- CASE 값 WHEN 첫번째 명제 THEN 첫번째 명제가 참일 경우 출력할 값
              WHEN 1 THEN 'B' --         WHEN 두번째 명제 THEN 두번째 명제가 참일 경우 출력할 값
       END CASE1,             --         ELSE 앞의 모든 명제가 거짓인 경우 출력할 값 
							  -- END 해당 조건을 부르기 위한 ALIAS
       CASE 9 WHEN 0 THEN 'A'
              WHEN 1 THEN 'B'
              ELSE 'None'
       END CASE2,
       CASE WHEN 25 BETWEEN 1 AND 19 THEN '10대' -- 범위 지정도 가능합니다
            WHEN 25 BETWEEN 20 AND 29 THEN '20대'
            WHEN 25 BETWEEN 30 AND 39 THEN '30대'
            ELSE '30대 이상'
       END CASE3;
       
-- DATABASE()와 SCHEMA() 함수는 현재 접속해 있는 데이터베이스 이름을, USER() 함수는 현재 로그인한 사용자 이름을 반환       
SELECT DATABASE(), SCHEMA(), USER(); -- MYSQL에서는 DATABASE(), SCHEMA()가 동일합니다 

# box_office 테이블에서 2015년 이후 개봉한 영화 중 연도별로 2번 이상 
# 관객수 100만을 넘긴 영화의 감독과 해당 관객의 영화를 본 관객수를 
# 연도별, 감독별로 구하는 쿼리를 작성하세요.
SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*)   -- SUM, AVG, MAX, MIN 같은 SQL함수들은 집계함수(GROUP BY)에서 동작 
FROM box_office
WHERE YEAR(release_date) >= 2015
	AND audience_num > 1000000
GROUP BY 1, 2 -- GROUP BY에서 만들어진 기준으로 
HAVING COUNT(*) > 1 -- 다시 조건을 추출 
order by 1;

SELECT director, YEAR(release_date) as 연도, SUM(audience_num) as '누적 관객 수' , COUNT(director)
FROM box_office
WHERE release_date >= '2015-01-01 00:00:00' AND audience_num >= 1000000
GROUP BY director, YEAR(release_date)
HAVING COUNT(audience_num)>=2;

 # 2019년 1분기 개봉 영화 중 매출액이 천만 원 이상인 영화의 월별, 영화 유형별 매출액 소계를 구하는 쿼리
SELECT MONTH(release_date), movie_type, SUM(sale_amt)
FROM box_office
WHERE YEAR(release_date) = 2019 
	  AND QUARTER(release_date) = 1
GROUP BY MONTH(release_date), movie_type WITH ROLLUP
ORDER BY MONTH(release_date);

SET @year1 = 2019; -- 변수 선언 및 값 대입
SELECT @year1; -- 변수의 값 출력

SELECT MONTH(release_date), movie_type, SUM(sale_amt)
FROM box_office
WHERE YEAR(release_date) = @year1 -- 2019 
	  AND QUARTER(release_date) = 1
GROUP BY MONTH(release_date), movie_type WITH ROLLUP
ORDER BY MONTH(release_date);

SELECT MONTH(release_date), movie_type, sale_amt,
	CASE WHEN QUARTER(release_date) IN (1, 2) THEN '상반기'-- 1,2 이면 상반기, -- 3,4 이면 하반기 
		ELSE '하반기'
	END '상/하반기'
FROM box_office
WHERE YEAR(release_date) = 2019
ORDER BY 1;


-- 부제 ':' 2015년 이후의 개봉영화 중에서 부제가 달려있는 영화의 개수 세어보기 
SELECT YEAR(release_date), COUNT(movie_name) AS 영화개수
FROM BOX_OFFICE
WHERE YEAR(release_date) >= 2015 AND movie_name LIKE '%:%'
GROUP BY YEAR(release_date)
ORDER BY 1;

SELECT YEAR(release_date), COUNT(movie_name) AS 영화개수
FROM BOX_OFFICE
WHERE YEAR(release_date) >= 2015 AND INSTR(movie_name, ":") > 0
GROUP BY YEAR(release_date)
ORDER BY 1;

 # 감독이 두 명 이상이면 콤마(,)로 이어져 있습니다(예, ‘홍길동,김감독’). 감독이 1명이면 그대로, 
 # 두 명 이상이면 콤마 대신 ‘/’ 값으로 대체해(예, ‘홍길동/김감독’) 조회하는 쿼리를 작성해 보세요.
select replace(director, ',' , '/') '감독' from box_office;

SELECT years, count(movie_name)
FROM box_office
group by years; -- 특정 기준으로 행들을 묶을 때 사용합니다 

SELECT years, count(movie_name)
FROM box_office
WHERE years = 2019; -- 묶을 기준이 한개라면 GROUP BY 없어도 집계 함수는 동작합니다 

SELECT CONCAT(years, '에 제작된 영화 편수는 ', count(movie_name), '입니다')
FROM box_office
WHERE years = 2019; 


# SELECT문에서 행의 개수를 제한하는 LIMIT문, ORDER BY와 HAVING 절에서는 변수를 사용할 수 없습니다.
# 이 때는 PREPARE, EXCUTE문을 사용합니다. 
SET @count = 1;

SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*) -- * 대신 아무 컬럼이나 넣어도 행 수를 리턴하는 것은 같습니다.
  FROM box_office
 WHERE YEAR(release_date) >= 2015
   AND audience_num >= 1000000
 GROUP BY 1, 2
HAVING COUNT(*) > count
 ORDER BY 1, 2;

SET @count = 1;
SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*)
  FROM box_office
 WHERE YEAR(release_date) >= 2015
   AND audience_num >= 1000000
 GROUP BY count, 2
HAVING COUNT(*) > count
 ORDER BY 1, 2;

SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*)
  FROM box_office
 WHERE YEAR(release_date) >= 2015
   AND audience_num >= 1000000
 GROUP BY count, 2
HAVING COUNT(*) > 1
 ORDER BY count, 2;
 
 
-- 동적 SQL 
PREPARE mySQL FROM 
'SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*)
  FROM box_office
 WHERE YEAR(release_date) >= 2015
   AND audience_num >= 1000000
 GROUP BY 1, 2
HAVING COUNT(*) > ?
 ORDER BY 1, 2;';
EXECUTE mySQL USING @count; 
 
PREPARE mySQL1 FROM 'SELECT YEAR(release_date), director, SUM(audience_num), COUNT(*)
  FROM box_office
 WHERE YEAR(release_date) >= 2015
   AND audience_num >= 1000000
 GROUP BY ?, 2
HAVING COUNT(*) > ?
 ORDER BY 1, 2;';
EXECUTE mySQL1 USING @count, @count; -- 순서대로 여러개 넣음 