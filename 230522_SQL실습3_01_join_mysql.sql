-- 5.join.sql
-- mysql용

DROP DATABASE IF EXISTS fisa;
CREATE DATABASE fisa DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

USE fisa;

drop table IF EXISTs emp;
drop table IF EXISTs dept;
DROP TABLE IF EXISTS salgrade;

CREATE TABLE dept (
    deptno               int  NOT NULL ,
    dname                varchar(20),
    loc                  varchar(20),
    CONSTRAINT pk_dept PRIMARY KEY ( deptno )
 );
 
CREATE TABLE emp (
    empno                int  NOT NULL  AUTO_INCREMENT,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint ,
    hiredate             date,
    sal                  numeric(7,2),
    comm                 numeric(7,2),
    deptno               int,
    CONSTRAINT pk_emp PRIMARY KEY ( empno )
 );
 
CREATE TABLE salgrade
 ( 
	GRADE INT,
	LOSAL numeric(7,2),
	HISAL numeric(7,2) 
);

ALTER TABLE emp 
ADD CONSTRAINT fk_emp_dept FOREIGN KEY ( deptno ) REFERENCES dept( deptno ) 
ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 부서번호, 부서이름, 부서가 있는 지역 
insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');

desc dept;
desc emp;
desc salgrade;

-- STR_TO_DATE() : 단순 문자열을 날짜 형식의 타입으로 변환 
insert into emp values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp values( 7788, 'SCOTT', 'ANALYST', 7566, DATE_ADD(STR_TO_DATE('13-7-1987','%d-%m-%Y'), INTERVAL -85 DAY)  , 3000, null, 20);
insert into emp values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp values( 7876, 'ADAMS', 'CLERK', 7788, DATE_ADD(STR_TO_DATE('13-7-1987', '%d-%m-%Y'),INTERVAL -51 DAY), 1100, null, 20);
insert into emp values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);


INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

COMMIT;

SELECT * FROM DEPT;
SELECT * FROM EMP;
SELECT * FROM SALGRADE;
/*
1. 조인이란?
	다수의 table간에  공통된 데이터를 기준으로 검색하는 명령어
	
	다수의 table이란?
		동일한 table을 논리적으로 다수의 table로 간주
			- self join
			- emp의 mgr 즉 상사의 사번으로 이름(ename) 검색
				: emp 하나의 table의 사원 table과 상사 table로 간주

		물리적으로 다른 table간의 조인
			- emp의 deptno라는 부서번호 dept의 부서번호를 기준으로 부서의 이름/위치 정보 검색
  
2. 사용 table 
	1. emp & dept 
	  : deptno 컬럼을 기준으로 연관되어 있음

	 2. emp & salgrade
	  : sal 컬럼을 기준으로 연관되어 있음

  
3. table에 별칭 사용 
	검색시 다중 table의 컬럼명이 다를 경우 table별칭 사용 불필요, 
	서로 다른 table간의 컬럼명이 중복된 경우,
	컬럼 구분을 위해 오라클 엔진에게 정확한 table 소속명을 알려줘야 함

	- table명 또는 table별칭
	- 주의사항 : 컬럼별칭 as[옵션], table별칭 as 사용 불가


4. 조인 종류 
	1. 동등 조인
		 = 동등비교 연산자 사용
		 : 사용 빈도 가장 높음
		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 

	2. not-equi 조인
		: 100% 일치하지 않고 특정 범위내의 데이터 조인시에 사용
		: between ~ and(비교 연산자)

	3. self 조인 
		: 동일 테이블 내에서 진행되는 조인
		: 동일 테이블 내에서 상이한 칼럼 참조
			emp의 empno[사번]과 mgr[사번] 관계

	4. outer 조인 
		: 조인시 조인 조건이 불충분해도 검색 가능하게 하는 조인 
		: 두개 이상의 테이블이 조인될때 특정 데이터가 모든 테이블에 존재하지 않고 컬럼은 존재하나 
		  null값을 보유한 경우
		  검색되지 않는 문제를 해결하기 위해 사용되는 조인
*/		


use fisa;

-- 1. dept table의 구조 검색
show tables;

-- dept, emp, salgrade table의 모든 데이터 검색
select * from dept;
select * from emp;
select * from salgrade;



-- *** 1. 동등 조인 ***
-- = 동등 비교연산자 사용해서 검색
SELECT ename, job, loc --  ename, job, deptno는 emp 테이블,  deptno, loc는 dept 테이블에 있습니다
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT ename, job, d.deptno, loc --  ename, job, deptno는 emp 테이블,  deptno, loc는 dept 테이블에 있습니다
FROM emp AS e , dept AS d
WHERE e.deptno = d.deptno;

SELECT e.ename, e.job, d.deptno, d.loc --  ename, job, deptno는 emp 테이블,  deptno, loc는 dept 테이블에 있습니다
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- 2. SMITH 의 이름(ename), 사번(empno), 근무지역(부서위치)(loc) 정보를 검색
-- emp/dept
-- 비교 기준 데이터를 검색조건에 적용해서 검색
-- table명이 너무 복잡한 경우 별칭 권장
select ename, empno, deptno from emp where ename='SMITH';

select loc, deptno from dept;
select loc, deptno from dept where deptno=20;

select ename, empno, loc
from emp, dept
where ename='SMITH' and emp.deptno = dept.deptno;



-- 3. deptno가 동일한 모든 데이터(*) 검색
-- emp & dept 
select *
from emp, dept
where emp.deptno = dept.deptno;
-- deptno가 2번 출력되고 있는데 좋지 않음 (중복 발생)

desc emp;
desc dept;
select e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm, e.deptno, d.dname, d.loc
from emp e, dept d
where e.deptno = d.deptno; 

DESC emp;

-- 4. 2+3 번 항목 결합해서 SMITH에 대한
--  모든 정보(ename, empno, sal, comm, deptno, loc) 검색하기
select ename, empno, sal, comm, d.deptno, loc
from emp e, dept d
where ename='SMITH' and e.deptno = d.deptno;

select e.ename, e.empno, e.sal, e.comm, d.deptno, d.loc
from emp e, dept d
where e.ename='SMITH' and e.deptno = d.deptno;


-- 5.  SMITH에 대한 이름(ename)과 부서번호(deptno), 
-- 부서명(dept의 dname) 검색하기
select e.ename, d.deptno, d.dname
from emp e, dept d
where e.ename='SMITH' and e.deptno = d.deptno;



-- 6. 조인을 사용해서 뉴욕('NEW YORK')에 근무하는 사원의 이름(ename)과 급여(sal)를 검색 
select loc from dept;

desc emp;

select e.ename, e.sal
from emp e, dept d
where d.loc='New York' and e.deptno = d.deptno;

-- 7. 조인 사용해서 ACCOUNTING 부서(dname)에 소속된 사원의
-- 이름과 입사일 검색
select deptno, dname from dept;


select ename, hiredate
from emp e, dept d
where dname='ACCOUNTING' and d.deptno=e.deptno;


-- 8. 직급(job)이 MANAGER인 사원의 이름(ename), 부서명(dname) 검색

select ename, dname, job, e.deptno
from emp e, dept d
where job='MANAGER' and e.deptno=d.deptno;


-- *** 2. not-equi 조인 ***

-- salgrade table(급여 등급 관련 table)
select * from salgrade s;

-- 9. 사원의 급여가 몇 등급인지 검색
-- between ~ and : 포함 

select * from emp; 

SELECT e.ename, e.sal, s.grade 
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal; -- 꼭 똑같은 값이 아니어도 단위나 범위가 일치한다면 join이 가능합니다 

-- SMITH 씨의 GRADE를 출력해주시고
SELECT e.ename, e.sal, s.grade 
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal AND e.ename='SMITH';

-- 부서번호 30인 사람들의 각 이름, GRADE와 SAL, 상한선, 하한선 출력해주세요
SELECT e.ename, e.sal, s.grade, s.losal, s.hisal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal AND e.deptno=30;

-- 동등조인 review
-- 10. 사원(emp) 테이블의 부서 번호(deptno)로 
-- 부서 테이블(dept)을 참조하여 사원명(ename), 부서번호(deptno),
-- 부서의 이름(dname) 검색
select ename, e.deptno, dname
from emp e, dept d
where e.deptno=d.deptno;




-- *** 3. self 조인 ***
-- 11. SMITH 직원의 매니저 이름 검색
-- emp e : 사원 table로 간주 / emp m : 상사 table로 간주
SELECT * FROM emp;

SELECT e.ename, e.empno, m.mgr, m.ename
FROM emp e, emp m -- 같은 테이블에 다른 별칭을 붙여서 self 조인 
WHERE e.mgr = m.empno AND e.ename='SMITH'; -- e의 mgr과 m의 empno를 조인 -> e는 직원정보, m은 매니저의 정보를 조회

-- 12. 매니저 이름이 KING(m ename='KING')인 
-- 사원들의 이름(e ename)과 직무(e job) 검색
SELECT * FROM emp;

SELECT e.ename 팀원, e.job 직군, m.ename 부서장
FROM emp e, emp m
WHERE e.mgr = m.empno AND m.ename='KING';

SELECT * FROM emp;

SELECT e.ename 팀원, e.job 직군, m.ename 부서장
FROM emp e, emp m
WHERE e.mgr = m.empno AND m.ename='KING';
-- 13. SMITH와 동일한 부서에서 근무하는 사원의 이름 검색
-- 단, SMITH 이름은 제외하면서 검색 : 부정연산자 사용 != 
select e.ename as 동료이름, e.deptno 부서명
from emp m, emp e -- e employee 관련 테이블(조건을 만족시키는 값 뽑아내기 위한 테이블)  m employee 관련 테이블인데 (deptno를 비교하는 테이블)
where m.ename='SMITH' and m.deptno=e.deptno and e.ename != 'SMITH';  -- != 은 NOT && AND || OR

-- *** 4. outer join ***
/* 두 개 이상의 테이블을 조인할 때 
emp m의 deptno는 참조되는 컬럼(PK)
emp d의 deptno는 참조하는 컬럼(외래키, FK)의 역할을 하게 됩니다

SELECT 컬럼명
FROM A테이블 LEFT JOIN B테이블
WHERE A테이블.컬럼 = B테이블.컬럼 
-- A테이블에는 있고, B테이블에는 없는 값들이 NULL로 출력이 된다 
*/ 
select * from dept;
select empno, deptno from emp;  -- 40번 부서에 근무하는 직원들도 없음
select distinct deptno from emp;  -- 40번 부서에 근무하는 직원들도 없음

select ename, mgr from emp;   -- KING의 mgr은 null 


-- 14-1. 모든 사원명, 매니저 명 검색,  -- INNER JOIN은 두 테이블 컬럼에 모두 있어야만 출력. NULL인 값은 조회하지 않습니다 
SELECT e.ename 사원명, m.ename 매니저명
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT * FROM EMP;

-- 14-2. 모든 사원명(KING포함), 매니저 명 검색, 단 매니저가 없는 사원(KING)도 검색되어야 함
SELECT e.ename 사원명, m.ename 매니저명
FROM emp e LEFT JOIN emp m -- LEFT 컬럼에는 있고, RIGHT 컬럼에는 없는 값을 NULL로 도출
ON e.mgr = m.empno;

SELECT e.ename 사원명, m.ename 매니저명
FROM emp e LEFT OUTER JOIN emp m -- LEFT JOIN은 LEFT OUTER JOIN의 줄임말로 둘은 같은 결과를 출력
ON e.mgr = m.empno;

select e.ename 사원명, m.ename 매니저명
from emp m right join emp e -- RIGHT 테이블 컬럼에는 있고, LEFT 테이블의 컬럼에는 없는 값을 NULL로 도출
on e.mgr=m.empno;

-- 15. 모든 직원명(ename), 부서번호(deptno), 부서명(dname) 검색
-- 부서 테이블의 40번 부서와 조인할 사원 테이블의 부서 번호가 없지만,
-- outer join이용해서 40번 부서의 부서 이름도 검색하기 
SELECT * FROM emp;
SELECT * FROM dept;

SELECT ename, e.deptno, dname
FROM dept d LEFT JOIN emp e
ON d.deptno = e.deptno;

SELECT ename, e.deptno, dname
FROM emp e RIGHT JOIN dept d  
ON d.deptno = e.deptno;

-- 미션? 모든 부서번호가 검색(40)이 되어야 하며 급여가 3000이상(sal >= 3000)인 사원의 정보 검색
-- 특정 부서에 소속된 직원이 없을 경우 사원 정보는 검색되지 않아도 됨
-- 검색 컬럼 : deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm
/*

검색 결과 예시

+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
| deptno | dname      | loc      | empno | ename | job       | mgr  | hiredate   | sal     | comm |
+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
|     10 | ACCOUNTING | NEW YORK |  7839 | KING  | PRESIDENT | NULL | 1981-11-17 | 5000.00 | NULL |
|     20 | RESEARCH   | DALLAS   |  7788 | SCOTT | ANALYST   | 7566 | 1987-04-19 | 3000.00 | NULL |
|     20 | RESEARCH   | DALLAS   |  7902 | FORD  | ANALYST   | 7566 | 1981-12-03 | 3000.00 | NULL |
|     30 | SALES      | CHICAGO  |  NULL | NULL  | NULL      | NULL | NULL       |    NULL | NULL |
|     40 | OPERATIONS | BOSTON   |  NULL | NULL  | NULL      | NULL | NULL       |    NULL | NULL |
+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
*/

-- step01 : 40번 부서 정보 미검색
use fisa;

select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, round(sal), comm
from emp e, dept d 
where e.deptno=d.deptno;

-- step02 : 40번 부서 정보 검색
select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, round(sal), comm
from emp e right join dept d 
on e.deptno=d.deptno;

-- step03 : 요청한 조건 다 충족
select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm
from dept d left join emp e 
on d.deptno = e.deptno 
and sal >= 3000;


