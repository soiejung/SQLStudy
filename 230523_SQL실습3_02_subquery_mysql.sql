-- 6.subQuery.sql

-- select문 내에 포함된 또 다른 select문 작성 방법

-- 문법 : 비교 연산자(대소비교, 동등비교) 오른쪽에 () 안에 select문 작성 
--	   : create 및 insert 에도 사용 가능
-- 실행순서 : sub query가 main 쿼리 이전에 실행

use fisa;
SELECT * FROM emp;

-- 스칼라 서브쿼리 : 결과를 한 행에 1개만 도출 
-- 동작원리: 내부 쿼리 -> 외부쿼리 동작 
-- 내부쿼리에서는 외부쿼리에서 FROM에 사용한 테이블을 참조할 수 있다 
SELECT d.dname='ACCOUNTING' 
FROM dept d, emp e 
WHERE e.deptno = d.deptno;

SELECT e.ename FROM emp e;

SELECT e.ename, (SELECT d.dname='ACCOUNTING' FROM dept d WHERE e.deptno = d.deptno) AS ACCOUNTING부서확인
FROM emp e;

SELECT b.deptno, b.empno, c.ename
					  FROM emp b,
					       emp c
					 WHERE b.empno = c.empno;
-- derived query : FROM 절에 서브쿼리를 사용할 때
SELECT a.deptno, a.dname, mgr.empno
  FROM dept a,
       (SELECT b.deptno, b.empno, c.ename
					  FROM emp b,
					       emp c
					 WHERE b.empno = c.empno
       ) mgr
 WHERE a.deptno = mgr.deptno
 ORDER BY 1;

SELECT * FROM emp;

-- 서브쿼리가 반환하는 결과 집합을 하나의 테이블처럼 사용할 수 있습니다. 
SELECT b.deptno, b.empno, c.ename
  FROM emp b,
       emp c
 WHERE b.empno = c.empno;


-- 1. SMITH라는 직원 부서명 검색

-- inner join
SELECT d.DNAME 
FROM emp e INNER JOIN DEPT d
ON e.ENAME = 'SMITH' AND e.DEPTNO = d.DEPTNO;
  

-- sub query
SELECT ename
FROM emp
WHERE ename = 'SMITH';

-- main query
SELECT dname 
FROM dept
WHERE deptno = ???? ;

SELECT dname 
FROM dept
WHERE deptno = (SELECT deptno 
		FROM emp
		WHERE ename = 'SMITH');

-- 2. SMITH와 동일한 직급(job)을 가진 사원들의 모든 정보 검색(SMITH 포함)
DESC emp;
SELECT job FROM emp; 
SELECT job FROM emp WHERE ename='SMITH'; 

SELECT *
FROM emp
WHERE job = (SELECT job 
			FROM emp WHERE 
			ename='SMITH'); 
 

-- 3. SMITH와 급여가 동일하거나 더 많은(>=) 사원명과 급여 검색
-- SMITH 가 포함된 검색 후에 SMITH 제외된 검색해 보기 

SELECT *
FROM emp
WHERE sal >= (SELECT sal 
			FROM emp WHERE 
			ename='SMITH') -- 조건1 
		AND ename != 'SMITH'; -- 조건2 



-- 4. DALLAS에 근무하는 사원의 이름, 부서 번호 검색
select * from emp; -- 메인쿼리 
select loc from dept where loc='DALLAS';  -- 서브쿼리

select ename, deptno
from emp
WHERE deptno = (select deptno from dept where loc='DALLAS');

 
SELECT  e.ename, e.deptno
FROM emp e
WHERE e.deptno=(SELECT d.deptno
				FROM dept d
                WHERE d.loc='DALLAS');

select e.ename, d.deptno
from emp e left join dept d
on e.deptno = d.deptno
where loc='DALLAS';



-- 5. 평균 급여(avg(sal))보다 더 많이 받는(>) 사원만 검색
-- 평균을 구하는 서브쿼리 (값 1개) 
SELECT AVG(SAL) FROM EMP;

-- 바탕으로 더 많이 받는 사원 검색하는 메인쿼리 
SELECT ename, sal FROM emp WHERE 2073 < sal;  -- 값 1개 

SELECT ename, sal FROM emp WHERE sal > (SELECT AVG(SAL) FROM EMP); -- 값 1개를 기준으로 메인쿼리가 동작합니다 

SELECT e.ename, e.sal
FROM emp e
WHERE e.sal > SOME (SELECT ROUND(AVG(e.sal))
FROM emp e); -- ALL ANY SOME 


-- 다중행 서브 쿼리(sub query의 결과값이 하나 이상)
-- 6.급여가 3000이상 사원이 소속된 부서에 속한 사원이름, 급여 검색
	-- 급여가 3000이상 사원의 부서 번호
	-- in

SELECT sal, deptno FROM emp WHERE sal >= 3000;
SELECT ename, sal FROM emp WHERE deptno IN (10, 20); -- 10, 20 부서에 있는 사람을 검색 

-- sub query
SELECT ename, sal, deptno
FROM emp 
WHERE deptno IN 
	(SELECT deptno 
    FROM emp 
    WHERE sal >= 3000);


-- sub + order by
-- 급여가 높은 사람 > 낮은 사람 순으로 결과 출력
SELECT ename, sal 
FROM emp 
WHERE deptno IN 
	(SELECT deptno 
    FROM emp 
    WHERE sal >= 3000
    )
ORDER BY 2 DESC;

-- 7. in 연산자를 이용하여 부서별(group by)로 가장 급여(max())를 많이 
-- 받는 사원의 정보(사번, 사원명, 급여, 부서번호) 검색

-- GROUP BY의 결과 행 > 집단 으로 단위가 커짐 : 서브쿼리 
SELECT deptno, max(sal)
FROM emp e 
GROUP BY deptno;

SELECT deptno, ename, sal, empno 
FROM emp
WHERE sal IN (SELECT max(sal)
	FROM emp e 
	GROUP BY deptno);  -- 20번 부서에 5000불을 받는 사람이 있다면? 
-- empno, ename은 행별 데이터기 때문에 에러가 납니다 
	
SELECT deptno, ename, sal, empno 
FROM emp
WHERE (deptno, sal) IN (SELECT deptno, MAX(sal)
	FROM emp e 
	GROUP BY deptno);  
    -- GROUP BY를 통해 도출한 대표값을 서브쿼리로, 행별 데이터를 메인쿼리로 삼으면 대표값을 가진 결과를 행별 출력 가능 
    -- IN 연산자는 여러개의 컬럼에 있는 값을 비교 할 수도 있습니다 
    
-- 8. 직급(job)이 MANAGER인 사람이 속한 부서의 부서 번호 (emp) 와 부서명(dname)과 지역검색(loc) (dept) 
SELECT count(job) FROM emp WHERE job='MANAGER';
SELECT deptno, job FROM emp WHERE job='MANAGER'; -- 서브쿼리 

SELECT deptno, dname, loc 
FROM DEPT d 
WHERE deptno IN (10, 20, 30); -- 메인쿼리 

SELECT deptno, dname, loc 
FROM DEPT d 
WHERE deptno IN (SELECT deptno 
					FROM emp 
					WHERE job='MANAGER');

/*
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT : 행이 많으면 속도가 느려지므로 가장 행을 줄이는 순서로 

SELECT deptno, dname, loc 
FROM DEPT d 
WHERE deptno IN (SELECT deptno 
					FROM emp 
					WHERE job='MANAGER');

-- 메인쿼리의 테이블을 먼저 가져옵니다 > 서브쿼리가 동작합니다 
FROM DEPT d                     
	(FROM emp        
		WHERE job='MANAGER'
			SELECT deptno)
				WHERE deptno IN
					SELECT deptno, dname, loc 
*/

-- 책 읽는 순서: 왼쪽 위부터 -> 오른쪽 아래로 눈이 갑니다 
-- 코드도 순서대로 작성하는 게 직관적이고 이해가 갑니다
-- SQL은 메인쿼리 먼저 쓰고 (서브쿼리)를 작성하는게 SQL 문법인데, 동작은 서브쿼리 먼저 동작하고 메인쿼리가 동작합니다. 
-- 서브쿼리 먼저 쓰고, 메인쿼리를 쓰면 실제 동작순서와 쿼리 작성 순서가 같아서 이해하기 쉽겠죠 

# CTE - 쿼리작성이 간편, 서브쿼리 먼저 정의하고 메인쿼리가 마지막에 있어서 위에서 아래대로 서브쿼리 작성 가능
-- Common Table Expression
-- FROM 절에서 사용하기 위한 파생테이블의 별명만 붙일 수 있습니다
WITH mgr AS 
	(SELECT b.deptno, b.empno, c.ename
					  FROM emp b,
					       emp c
					 WHERE b.empno = c.empno
       ) -- 이 쿼리를 통해 만들어진 테이블을 mgr 이라는 별명으로 부를 수 있습니다
     
SELECT a.deptno, a.dname,
       mgr.empno
  FROM dept a, mgr
 WHERE a.deptno = mgr.deptno
 ORDER BY 1;

SELECT a.deptno, a.dname, mgr.empno
  FROM dept a, (SELECT b.deptno, b.empno, c.ename
					  FROM emp b, emp c
					 WHERE b.empno = c.empno
       ) mgr 
 WHERE a.deptno = mgr.deptno
 ORDER BY 1;

-- 조건을 찾는 경우는 AVG() 처럼 하나의 값일 경우도, 테이블 전체일 경우도 있기 때문에 WITH 별명 AS (서브쿼리) 구문으로는 작동하지 않습니다. 
WITH query1 AS 
(
	SELECT deptno FROM emp WHERE job='MANAGER'
)

SELECT deptno, dname, loc 
FROM DEPT d 
WHERE deptno IN query1;

SELECT deptno, dname, loc 
FROM DEPT d 
WHERE deptno IN (SELECT deptno FROM emp WHERE job='MANAGER');
