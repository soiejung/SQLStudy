SELECT * FROM BOX_OFFICE;
SELECT movie_name, years FROM BOX_OFFICE;
SELECT COUNT(*) FROM BOX_OFFICE;

SELECT * FROM BOX_OFFICE WHERE years=2004;
SELECT COUNT(*) FROM BOX_OFFICE WHERE years=2004; 

SELECT COUNT(*) FROM BOX_OFFICE WHERE 2004 <= years AND years <=2005; -- 첫번째 조건 AND 두번째 조건 
SELECT COUNT(*) FROM BOX_OFFICE WHERE 2004 <= years && years <=2005;
SELECT COUNT(*) FROM BOX_OFFICE WHERE years BETWEEN 2004 AND 2005;

SELECT movie_name FROM BOX_OFFICE WHERE movie_name LIKE '천년여우'; -- LIKE 딱 그 문자열이 있는 경우 
SELECT movie_name FROM BOX_OFFICE WHERE movie_name LIKE '천년%'; -- %(몇글자이든 상관없이), _  -- 천년으로 시작하는  
SELECT movie_name FROM BOX_OFFICE WHERE movie_name LIKE '%천년'; -- 천년으로 끝나는
SELECT movie_name FROM BOX_OFFICE WHERE movie_name LIKE '%천년%'; -- 어디든 포함되는 (contains)
SELECT movie_name FROM BOX_OFFICE WHERE movie_name LIKE '천년_'; -- _ 언더바 하나당 한 글자를 의미
SELECT movie_name FROM BOX_OFFICE WHERE movie_name LIKE '천년__';  

SELECT movie_name FROM BOX_OFFICE WHERE movie_name IN ('여우', '학');  

SELECT * 
FROM BOX_OFFICE 
WHERE movie_name LIKE '%천년%' -- 조건1
	AND years=2004; -- 조건2
    
SELECT * 
FROM BOX_OFFICE 
WHERE movie_name LIKE '%천년%' -- 조건1
	&& years=2004; -- 조건2

-- SELECT COUNT(DISTINCT rep_country) FROM BOX_OFFICE; 
SELECT * 
FROM BOX_OFFICE;
-- 2018년 개봉한 한국 영화 조회하기
SELECT COUNT(*)
FROM BOX_OFFICE 
WHERE release_date LIKE '2018%' -- 조건1
	&& rep_country = '한국'; -- 조건2
    
SELECT COUNT(*)
FROM BOX_OFFICE 
WHERE release_date between '2018-01-01' AND '2018-12-31' -- 조건1
	&& rep_country = '한국'; -- 조건2       
    
-- 2019년 개봉 영화 중 관객수가 500만 명 이상인 영화 조회하기
SELECT COUNT(*)
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND audience_num >= 5000000; -- 조건2    
    
-- 2019년 개봉 영화(release_date) 중 관객수(audience_num)가 500만 명 이상이거나 매출액(sale_amt)이 400억 원 이상인 영화 조회하기
-- 더 하위 조건은 () 로 묶어줍니다 그렇지 않으면... 각 조건을 동등한 관계로 연산하는 오류를 범할 수 있습니다 
SELECT *
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000); -- 조건2 - 2 

# 필요한 컬럼에 특정 연산을 가해서 출력할 수 있습니다 * 이 아니라 해당 컬럼을 직접 요청해주셔야 됩니다 
# AS "sale_amt(단위:억원)" 처럼 AS 뒤에 별칭을 붙여서 컬럼명을 대신할 수 있고, ALIAS(알리아스)
SELECT years, ranks, movie_name, release_date, ROUND(sale_amt / 100000000) AS "sale_amt(단위:억원)"
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000); -- 조건2 - 2 
    
SELECT years, ranks, movie_name, release_date, ROUND(sale_amt / 100000000) AS sale_amt
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000); -- 조건2 - 2 
    
-- 2012년에 제작(years)됐지만, 2019년에 개봉(release_date)된 영화를 조회하기
SELECT * 
FROM box_office 
WHERE years=2012 AND release_date LIKE '2019%';

-- 위 데이터를 release_date를  “특이사항”이라는  열 이름으로 출력하기
-- * 내부적으로는 간단한 확인용으로 사용하기도 합니다
-- 서비스용 코드를 짜실 때, 데이터가 많은 테이블에서 값을 조회할 때는 쓰지 않는 것이 좋습니다 
SELECT years, movie_name, release_date 특이사항 -- 컬럼명 ALIAS 
FROM box_office
WHERE years=2012 AND release_date LIKE '2019%';

SELECT years, movie_name, release_date 특이사항
FROM box_office 
WHERE years=2012 AND release_date LIKE '2019%';

SELECT years, ranks, movie_name, release_date, ROUND(sale_amt / 100000000) AS sale_amt
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000) -- 조건2 - 2 
ORDER BY ranks, movie_name ASC;

SELECT years, ranks, movie_name, release_date, ROUND(sale_amt / 100000000) AS sale_amt
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000) -- 조건2 - 2 
ORDER BY 2 DESC; -- SELECT 절에 넣었던 컬럼 순서대로 1, 2, 3, 4, 5 이렇게 숫자를 통해 정렬순서를 매길수도 있습니다 

SELECT years, ranks, movie_name, release_date, ROUND(sale_amt / 100000000) AS sale_amt
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000) -- 조건2 - 2 
ORDER BY 2 DESC
LIMIT 5; -- 조건에 맞는 값에서 N개만 가져올 때 

SELECT years, ranks, movie_name, release_date, ROUND(sale_amt / 100000000) AS sale_amt
FROM BOX_OFFICE 
WHERE release_date LIKE '2019%' -- 조건1
	AND (audience_num >= 5000000 -- 조건2 - 1 
    OR sale_amt >= 40000000000) -- 조건2 - 2 
ORDER BY 2 DESC
LIMIT 5; -- 조건에 맞는 값에서 N개만 가져올 때 

-- 2019년 개봉하고 500만 명 이상의 관객을 동원한 매출액 기준 상위 5편의 영화만 조회
SELECT movie_name 
FROM box_office
WHERE release_date LIKE '2019%'
AND audience_num >= 5000000
ORDER BY sale_amt DESC
LIMIT 5;

-- 2019년 제작한 영화 중 관객수 1~10위 영화를 조회 -- 나중에 재사용 할 수도 있기 때문에 조건을 다 달아두는게 좋습니다 
SELECT *
FROM box_office
WHERE release_date LIKE '2019%'
AND audience_num >= 5000000
ORDER BY audience_num DESC
LIMIT 10;

/* box_office 테이블에서 2019년 제작된 영화 중 영화 유형(movie_type 칼럼)이 
장편이 아닌 영화를 순위(ranks)대로 조회. -- 오름? 내림? */
SELECT *
FROM box_office
WHERE years LIKE '2019%'
	AND movie_type NOT IN ('장편')
ORDER BY ranks;
    
SELECT COUNT(*)
FROM box_office
WHERE years LIKE '2019%'
	AND movie_type NOT LIKE '장편';

-- USE DB명 -> TABLE 하나 하나만 호칭 
-- 패키지명.모듈명 처럼 DB명.테이블명 
SELECT * FROM student_mgmt.students;

SELECT AVG(math) FROM student_mgmt.students;
SELECT AVG(korean) FROM student_mgmt.students;

SELECT AVG(math) 
FROM student_mgmt.students
GROUP BY gender;

SELECT gender, AVG(math) 
FROM student_mgmt.students
GROUP BY gender; -- 원본 테이블에는 없는 값이 되는 거죠 

SELECT gender, AVG(math) 
FROM student_mgmt.students
GROUP BY gender -- 원본 테이블에는 없는 값이 되는 거죠 
HAVING AVG(math) > 61; -- GROUP BY에 결과에서 조건을 만족하는 값만 조회 


-- 영어, 수학 평균을 구하고 컬럼명을 한글로 표기해주세요 
SELECT id, name, gender, birth, english as 영어, math 수학, korean 
FROM student_mgmt.students; 

-- 성별 평균을 구하고 70점이 넘는 값는 수학점수와 영어점수의 평균이 70점 이상인 사람들만 출력하려면?
SELECT
  name,  gender,  AVG(english) AS average_english, AVG(math) AS average_math
FROM
  student_mgmt.students
GROUP BY
  name, gender
HAVING
  AVG(english) >= 70 AND AVG(math) >= 70;

# 연도별 개봉한 영화의 편수를 집계해서 출력해주세요 
 SELECT YEAR(release_date) release_year, COUNT(*)
  FROM box_office
 GROUP BY YEAR(release_date)
 ORDER BY 1 DESC;
 
  SELECT release_date release_year, COUNT(*)
  FROM box_office
 GROUP BY release_date
 ORDER BY 1 DESC;

SELECT  rep_country FROM box_office;
SELECT  COUNT(rep_country) FROM box_office;
SELECT  COUNT( DISTINCT rep_country) FROM box_office; -- unique 한 값을 출력하는 명령어
SELECT  DISTINCT rep_country FROM box_office; 
-- '한국' '한국 ' 처럼 우리 눈에는 같아보이지만 실제로는 다른 값들은 별개의 값으로 계산된다는 점을 유의하세요

# 2019년 개봉 영화의 유형별 최대, 최소 매출액과 전체 매출액 집계하기
SELECT movie_type, MAX(sale_amt) 최대매출영화, MIN(sale_amt) 최소매출영화, SUM(sale_amt) 총계
FROM box_office
WHERE YEAR(release_date) = 2019
GROUP BY movie_type;

-- movie_type에 NULL이 들어있는 2019년 영화 이름을 찾아주세요 
SELECT * FROM box_office 
WHERE movie_type IS NULL 
	AND YEAR(release_date) = 2019; -- NULL 값은 IN LIKE = 같은 연산자로 찾을 수 없습니다 
    
SELECT * FROM box_office 
WHERE movie_type IS NOT NULL 
	AND YEAR(release_date) = 2019; -- NULL 값은 IN LIKE = 같은 연산자로 찾을 수 없습니다 

-- movie_type이 NULL 이 아닌 값들만 출력하기 
SELECT movie_type, MAX(sale_amt) 최대매출영화, MIN(sale_amt) 최소매출영화, SUM(sale_amt) 총계
FROM box_office
WHERE YEAR(release_date) = 2019
GROUP BY movie_type;

select movie_type, max(sale_amt) 최대매출액, min(sale_amt) 최소매출액, sum(sale_amt) 매출액총계
from box_office
where release_date like '2019%' and movie_type is not null -- movie_type이 null인 거 빼고 group by
group by movie_type;

select movie_type, max(sale_amt) as 최대매출액, min(sale_amt) as 최소매출액, sum(sale_amt) as 총계
from box_office
where year(release_date) = 2019
group by movie_type
having movie_type is not null;

select movie_type, max(sale_amt) as 최대매출액, min(sale_amt) as 최소매출액, sum(sale_amt) as 총계
from box_office
where year(release_date) = 2019
group by movie_type
order by max(sale_amt);

select movie_type, max(sale_amt) as 최대매출액, min(sale_amt) as 최소매출액, sum(sale_amt) as 총계
from box_office
where year(release_date) = 2019
group by movie_type
order by 최대매출액; -- ALIAS를 지어주면 해당 쿼리 내에서는 ALIAS로 대신 컬럼명을 부를 수도 있습니다 

select movie_type, max(sale_amt) as 최대매출액, min(sale_amt) as 최소매출액, sum(sale_amt) as 총계
from box_office
where year(release_date) = 2019
group by movie_type
order by 2 DESC;  -- SELECT 절의 컬럼 2번째 순서를 기준으로 

 # roll up은 우리말로 ‘말아(감아) 올린다’는 뜻입니다. 따라서 항목별 소계를 한데 말아서 총계를 구한다는 의미로 생각하면 됩니다. 
select movie_type, max(sale_amt) as 최대매출액, min(sale_amt) as 최소매출액, sum(sale_amt) as 소계
from box_office
where year(release_date) = 2019
group by movie_type WITH ROLLUP;  

# GROUP BY 절에 명시한 칼럼별 합계(소계)는 물론 전체 합계(총계)까지 한 번에 구하는 방법은 없을까요? 
 #  칼럼 값 자체에 NULL이 있을 때 WITH ROLLUP을 포함한 집계 쿼리를 사용하면 NULL인 건이 집계된 로우와 총계가 계산된 로우를 구분하기 어렵습니다. 물론 이 예제에서는 마지막 로우의 금액이 크기 때문에 총계임을 쉽게 유추할 수 있지만, SUM() 함수로 계산된 값이 그리 크지 않으면 보통 구분하기가 쉽지 않습니다. 바로 이럴 때 GROUPING() 함수를 사용합니다.
SELECT movie_type 영화유형, SUM(sale_amt) 금액, GROUPING(movie_type)
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY movie_type WITH ROLLUP;
 
 SELECT IF(GROUPING(movie_type) = 1, '총계', movie_type) 영화유형, SUM(sale_amt) 금액
  FROM box_office
 WHERE YEAR(release_date) = 2019
 GROUP BY movie_type WITH ROLLUP;

-- SQL함수
SELECT CHAR_LENGTH('SQL'), LENGTH('SQL'), CHAR_LENGTH('홍길동'), LENGTH('홍길동'); # SQL에서 한글 1글자 : 3바이트
 SELECT CONCAT('This', 'Is', 'MySQL') AS CONCAT1,
       CONCAT('SQL', NULL, 'Books') AS CONCAT2,
       CONCAT_WS(',', 'This', 'Is', 'MySQL') AS CONCAT_WS; # NULL과 문자열을 연결하면 그 결과는 NULL
															# CONCAT_WS() 함수는 구분자인 첫 번째 매개변수가 콤마(,)이므로 두 번째부터 네 번째 매개변수를 연결하면서 그 사이에 구분자 콤마 기입
-- FORMAT(x, d), INSTR(str, substr), LOCATE(substr, str, pos), POSITION(substr IN str)
-- FORMAT()은 첫 번째 매개변수(x)에 숫자가 오고 숫자의 정수 부분 3자리마다 콤마를 넣어 문자열로 반환하는 함수입니다. 두 번째 매개변수(d)는 소수점 이하 자릿수를 의미하는데, 0을 입력하면 정수만 반환됩니다.
-- INSTR() 함수는 첫 번째 매개변수의 문자열에서 두 번째 매개변수의 문자열을 찾아 시작 위치를 반환합니다. 두 번째 매개변수의 문자열을 찾지 못하면 0을 반환합니다.
-- LOCATE()와 POSITION() 함수는 INSTR() 함수처럼 문자열의 위치를 반환하는데, 사용법이 약간 다릅니다. LOCATE() 함수는 두 번째 매개변수(str)의 문자열에서 첫 번째 매개변수(substr)의 문자열을 찾아 시작 위치를 반환합니다. INSTR() 함수와 매개변수 위치가 바뀌었죠. 또한, 이 함수는 문자열을 찾는 시작 위치를 세 번째 매개변수에 명시할 수 있습니다. 세 번째 매개변수는 생략할 수 있는데, 생략하면 시작 위치는 1이 됩니다. POSITION() 함수는 매개변수가 하나로 str 문자열에서 substr 문자열의 시작 위치를 찾아 반환합니다.

SELECT FORMAT(123456789.123456, 3) fmt,
       INSTR('ThisIsSQL', 'sql') instring,
       LOCATE('my', 'TheMyDBMSMySQL', 5) locates,
       POSITION('my' IN 'TheMyDBMSMySQL') pos;
       
SELECT LOWER('ABcD'), LCASE('ABcD'),
       UPPER('abcD'), UCASE('abcD');
       
SELECT REPEAT('SQL', 3),
       REPLACE('생일 축하해 철수야', '철수', '영희') REP,
       REVERSE('SQL');

# SUBSTR() 함수는 첫 번째 매개변수 str의 문자열에서 두 번째 매개변수 pos로 지정된 위치부터 세 번째 매개변수 len만큼 잘라 반환합니다. len은 생략 가능하며, 생략하면 str의 오른쪽 끝까지 잘라냅니다. 또한 pos 값에 음수도 넣을 수 있는데, 이때는 시작 위치를 왼쪽이 아닌 오른쪽 끝을 기준으로 잡습니다. 그리고 SUBSTRING(), MID() 함수는 SUBSTR() 함수와 사용법이 같습니다.
SELECT SUBSTR('This Is MySQL', 6, 2) FIRST,
       SUBSTRING('This Is MySQL', 6) SECOND,
       MID('This Is MySQL', -5) THIRD;

SELECT CURDATE(), CURRENT_DATE(), CURRENT_DATE,
       CURTIME(), CURRENT_TIME(), CURRENT_TIME,
       NOW(), CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP;
       
SELECT DATE_FORMAT('2021-01-20 13:42:54', '%d-%b-%Y') Fmt1,
       DATE_FORMAT('2021-02-20 13:42:54', '%U %W %j') Fmt2;

SELECT STR_TO_DATE('21,01,2021', '%d,%m,%Y') CONV1,
       STR_TO_DATE('19:30:17', '%H:%i:%s') CONV2,
       STR_TO_DATE('19:30:17', '%h:%i:%s') CONV3;

SELECT SYSDATE(), SLEEP(2), SYSDATE();

SELECT NOW(), SLEEP(2), NOW();SELECT CAST(10 AS CHAR)                 CONV_CHAR,
       CAST('-10' AS SIGNED )           CONV_INT,
       CAST('10.2131' AS DECIMAL)       CONV_DEC1,
       CAST('10.2131' AS DECIMAL(6, 4)) CONV_DEC2,
       CAST('10.2131' AS DOUBLE)        CONV_DOUBLE,
       CAST('2021-10-31' AS DATE)       CONV_DATE,
       CAST('2021-10-31' AS DATETIME)   CONV_DATETIME;