-- mysql (root/root)
-- 7.DDL.sql - DATABASE DEFINITION LANGAUGE 
-- table 생성(create)과 삭제(drop), table 구조 수정(alter)
-- DDL(Data Definition Language)

/* TCL
 * - 트랜잭선 처리 명령어
 * 	- insert/update/delete(DML) 문장에 한해서만 영향을 줌
 * 	- table create/drop/alter(DDL) 명령어와 무관
 * - commit
 * - rollback 
 */

/*
 DB에 데이터를 CRUD 작업 가능하게 해주는 기본 구성
   
[1] table 생성 명령어
    create table table명(
		칼럼명1 칼럼타입[(사이즈)] [제약조건] ,
		칼럼명2....
    ); 

[2] table 삭제 명령어
	drop table table명;
	- 삭제 시도시 table 미존재시 에러 발생

[3] table 구조 수정 명령어
	alter table table명
*/

use fisa;

-- mysql상에서의 table 목록 검색 
show tables;

-- 1. table삭제 
-- 존재해야만 실행 에러가 없는 drop 문장
drop table test; 

-- 존재 여부 확인 후에 존재할 경우에만 삭제하는 drop 문장
drop table if exists test;


-- 2. table 생성  
-- name(varchar(5), age(int) 칼럼 보유한 people table 생성
-- name은 최대 5개 글자 크기의 문자열 데이터 저장 
drop table if exists people;

CREATE TABLE people (
	name varchar(5) NOT NULL, 
    age int 
);

desc people;
describe people;

-- 들어가게 데이터를 2개 넣어주시고,
SELECT * FROM people;

-- INSERT INTO 테이블명 VALUES (컬럼1의값, 컬럼2의값); -- 모든 컬럼에 들어갈 값을 넣어줘야합니다
-- INSERT INTO 테이블명(컬럼명) VALUES (해당 컬럼에 들어갈 값);
INSERT INTO people VALUES ('김연지', 25);
INSERT INTO people (name) VALUES ('김연지');

-- 안들어가게 데이터를 1개 넣어보세요 
INSERT INTO people VALUES (NULL, 25);
INSERT INTO people VALUES (25, 25);

DESC people;


-- 3. 서브 쿼리 활용해서 emp01 table 생성(이미 존재하는 table기반으로 생성)
-- 구조와 데이터는 복제 가능하나 제약조건은 적용 불가
-- 제약조건 만드는 방법 1. 테이블을 만들 때 걸어주는 방법 
--  	           2. 이미 만들어진 테이블에 ALTER 명령어 사용 
drop table if exists emp01;

CREATE TABLE emp01 SELECT * FROM emp;
CREATE TABLE emp02 AS SELECT * FROM emp; -- AS는 ~로써 라는 뜻으로 위와 같은 방식으로 작동합니다 
select * from emp02;
drop table if exists emp02;
drop table if exists emp01;


-- 거짓 조건(WHERE)식 적용시에는 table 구조만 복제
CREATE TABLE emp01 SELECT * FROM emp WHERE 0=1;

select * from emp01;



-- 4. 서브쿼리 활용해서 특정 칼럼(empno)만으로 emp02 table 생성
CREATE TABLE emp02 SELECT empno, ename FROM emp;

-- DB는 기본적으로 깊은 복사 / 파이썬, 얕은복사 : 메모리(ram) 
INSERT INTO emp02 VALUES (1111, '김연지'); 

select * from emp02;
select * from emp;



-- 5. deptno=10 조건문 반영해서 empno, ename, deptno로 emp03 table 생성
DROP TABLE IF EXISTS emp03;
CREATE TABLE emp03 select empno, ename, deptno from emp WHERE deptno=10;
SELECT * FROM emp03;
desc emp;
desc emp03;

-- 6. 데이터 insert없이 table 구조로만 새로운 emp04 table생성시 
-- 사용되는 조건식 : where=거짓, 제약조건이 실제로 복사되지 않는지 확인해보세요 
DROP TABLE IF EXISTS emp04;
CREATE TABLE emp04 SELECT * FROM emp WHERE 1=0;
SELECT * FROM emp04;
desc emp;
desc emp04;

-- 이미 존재하는 table의 구조를 변경하는 sql문장 
desc emp04;
-- 추가 
-- 새 컬럼을 추가합니다 
ALTER TABLE emp04 ADD JOB_2 VARCHAR(5);
SELECT * FROM emp04;

-- 만약 원래 데이터가 들어있는 테이블에 컬럼을 추가하면 어떻게 될까요?
-- NULL이 들어간 새 데이터프레임이 만들어집니다 

-- 새 컬럼 추가(ADD), 삭제(DROP)
ALTER TABLE emp03 ADD JOB_2 VARCHAR(5);
SELECT * FROM emp03;

ALTER TABLE emp03 DROP JOB_2;
SELECT * FROM emp03;

-- 이미 값이 있는 컬럼을 DROP하면 어떻게 될까요? 걍 없어집니다 
ALTER TABLE emp03 DROP deptno;
SELECT * FROM emp03;

-- 이미 있는 컬럼의 자료형(OR 크기) 수정(MODIFY)
desc emp03;
ALTER TABLE emp03 MODIFY ename VARCHAR(10);
SELECT * FROM emp03;

-- 줄일 때는 이미 있는 값보다 더 줄일 수 있을까?? 불가능 
ALTER TABLE emp03 MODIFY ename VARCHAR(2);
SELECT * FROM emp03;

-- 새 제약조건 추가, 삭제
desc emp03;
ALTER TABLE emp03 ADD CONSTRAINT PRIMARY KEY (empno);
ALTER TABLE emp03 DROP PRIMARY KEY; --  PK 는 하나라 삭제할 때는 컬럼명이 필요 없음

desc emp03;
ALTER TABLE emp03 ADD CONSTRAINT UNIQUE (ename);
desc emp03;
ALTER TABLE emp03 DROP INDEX ename; -- 삭제할 때 컬럼명이 필요
desc emp03;

desc emp04;
-- 7. emp01 table에 job이라는 특정 칼럼 추가(job varchar(10))
-- 이미 데이터를 보유한 table에 새로운 job칼럼 추가 가능 
-- add  : 컬럼 추가 연산자
drop table if exists emp01;

create table emp01 as select empno, ename from emp; -- 모든  empno, ename 데이터 가져올 것 
desc emp01;
select * from emp01;

-- 최대 10byte 문자열 저장 가능한 job 컬럼 생성 및 추가 
alter table emp01 add job varchar(10);

desc emp01;
select * from emp01;


-- 8. 이미 존재하는 칼럼 사이즈 변경 시도해 보기
-- 데이터 미 존재 칼럼의 사이즈 수정(크게/작게 다 수정 가능)
-- modify : 컬럼 변경

drop table if exists emp01;
desc emp01;
create table emp01 as select empno, ename, job from emp;
select * from emp01;

select MAX(CHAR_length(job)) from emp01; 
select MAX(CHAR_length('김연지')); -- 한글 3글자 3  
select MAX(length('김연지')); -- 한글은 1글자에 3바이트가 9BYTE  
-- 가장 큰 값을 조회해보세요 
select job from emp01;

-- job 크기를 10으로 변경
desc emp01;
alter table emp01 modify job varchar(10);
desc emp01; -- 10으로 정상 변경

select * from emp01;  -- 모든 데이터 정상 검색

-- 9. 이미 데이터가 존재할 경우 칼럼 사이즈가 큰 사이즈의 컬럼으로 변경 가능 
-- alter table emp01 modify job varchar(3);  실패 
desc emp01;


-- 10. job 칼럼 삭제 
-- 데이터 존재시에도 자동 삭제 
-- drop 
-- add시 필요 정보(컬럼명 타입(사이즈)) / modify 필요 정보(컬럼명 타입(사이즈)) / drop 필요 정보(컬럼명)
alter table emp01 ADD column job VARCHAR(10);
alter table emp01 drop column job;
desc emp01;


-- 11. table 자체가 아닌  순수 데이터만 완벽하게 삭제하는 명령어 
-- 주의사항 : tool 사용시 tool 기능 auto commit 즉 삭제시 영구 삭제하는지 반드시 확인
-- commit 불필요
-- DELETE  or TRUNCATE 

-- delete 
select * from emp01;
select * from emp01 WHERE ename='SMITH';
-- emp01의 SMITH 삭제
delete from emp01 where ename='ALLEN';
select * from emp01;

-- WORKBENCH는 기본적으로 autocommit이 걸려있어서 자동으로 db에 변경이 되었는데요 
SELECT @@autocommit;
SET @@autocommit=1;
commit; -- AUTOCOMMIT이 지정되어 있지 않다면 UPDATE, DELETE 같은 작업은 실제로 COMMIT 하기 전에는 원DB에는 반영되지 않습니다 
rollback;   -- 복원(임시 메모리에 저장되었던 작업을 무효화), 삭제 작업 무효화

select * from emp01; -- SMITH 검색

delete from emp01 where ename='SMITH';
select * from emp01;
commit;  -- 수정된 작업들 영구 저장

select * from emp01;
rollback; -- commit 이후에 작업된 내용에 한해서만 복원
select * from emp01;

SET @@autocommit=0;
SELECT @@autocommit;
commit; -- AUTOCOMMIT이 지정되어 있지 않다면 UPDATE, DELETE 같은 작업은 실제로 COMMIT 하기 전에는 원DB에는 반영되지 않습니다 

select * from people;
insert into people values ('김연아', 30);
select * from people;

commit; -- 데이터의 무결성을 보장하기 위해서, 속도, 효율성 
-- 비슷하게 속도, 효율성 면을 고려해서 AS 별칭을 붙여서 긴 서브쿼리나, 긴 컬럼명을 대체하기도 합니다 

insert into people values ('신동엽', 10);
select * from people;
rollback;
select * from people;

-- 같이 일하는 사람들이 환경을 동일하게 설정해주셔야 과정에서 생기는 문제를 겪지 않습니다.
SET @@autocommit=0;
SELECT @@autocommit;

-- truncate (구조는 남겨놓고 데이터 행들만 버리는 명령어)
DROP TABLE IF EXISTS emp01;
CREATE TABLE emp01 SELECT empno, ename FROM emp;
select * from emp01;
delete from emp01;
select * from emp01;
rollback;  -- delete 문장 무효화, 데이터 복구
select * from emp01;

-- EMP의 empno, ename을 복제하여 emp01을 다시 만들어볼게요 
DROP TABLE IF EXISTS emp01;
CREATE TABLE emp01 SELECT empno, ename FROM emp;

truncate table emp01; -- emp01 table의 모든 내용 삭제, 영구 저장 되어 버림(commit 불필요)
select * from emp01; -- 데이터 없음
rollback;  -- insert/update/delete 문장에만 적용
select * from emp01;  -- 데이터 없음

SET @@autocommit=1;
SELECT @@autocommit;




