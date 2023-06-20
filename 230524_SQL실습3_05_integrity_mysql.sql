-- 9.integrity.sql
-- DB 자체적으로 강제적인 제약 사항 설정

/*
1. table 생성시 제약조건을 설정하는 기법 
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
    ....
);

2. Data Dictionary란?
	- 제약 조건등의 정보 확인
	- MySQL Server의 개체에 관한 모든 정보 보유하는 table
		- 일반 사용자가 검색은 가능하나 insert/update/delete 불가
	- information_schema

3. 제약 조건 종류
	emp와 dept의 관계
		- dept 의 deptno가 원조 / emp 의 deptno는 참조
		- dept : 부모 table / emp : 자식 table(dept를 참조하는 구조)
		- dept의 deptno는 중복 불허(not null) - 기본키(pk, primary key)
		- emp의 deptno - 참조키(fk, foreign key, 외래키)
	
	
	2-1. PK[primary key] - 기본키, 중복불가, null불가, 데이터들 구분을 위한 핵심 데이터
		: not null + unique
	2-2. not null - 반드시 데이터 존재
	2-3. unique - 중복 불가, null 허용
	2-4. check - table 생성시 규정한 범위의 데이터만 저장 가능 
	2-5. default - insert시에 특별한 데이터 미저장시에도 자동 저장되는 기본 값
				- 자바 관점에는 멤버 변수 선언 후 객체 생성 직후 멤버 변수 기본값으로 초기화
	* 2-6. FK[foreign key] 
		- 외래키[참조키], 다른 table의 pk를 참조하는 데이터 
		- table간의 주종 관계가 형성
		- pk 보유 table이 부모, 참조하는 table이 자식
	
4. 제약조건 적용 방식
	4-1. table 생성시 적용
		- create table의 마지막 부분에 설정
			방법1 - 제약조건명 없이 설정
			방법2 - constraints 제약조건명 명식
			
		- 참고 : mysql의 pk에 설정한 사용자 정의 제약조건명은 data 사전 table에서 검색 불가
			oracle db는 명확하게 사용자 정의 제약조건명 검색 

	4-2. alter 명령어로 제약조건 추가
	- 이미 존재하는 table의 제약조건 수정(추가, 삭제)명령어
		alter table 테이블명 modify 컬럼명 타입 제약조건;
		
	4-3. 제약조건 삭제(drop)
		- table삭제 
		alter table 테이블명 alter 컬럼명 drop 제약조건;
		
*/

use fisa;


-- 1. table 삭제
drop table if exists emp01;


-- 2. 사용자 정의 제약 조건명 명시하기
-- 개발자는 sql 문법 ok된 상태로 table + 제약조건 생성
-- db 관점에서 기록
create table emp01(
	empno int not null,
	ename varchar(10)
);

desc emp01;

-- mysql에 사전 table 검색 : 테이블에 대한 테이블 (현재 DB에 대한 메타데이터)
select TABLE_SCHEMA, TABLE_NAME 
from information_schema.TABLES
where TABLE_SCHEMA = 'information_schema';

-- 3. emp table의 제약조건 조회
-- table 생성시 컬럼 선언시에 not null ???

select * from information_schema.TABLE_CONSTRAINTS tc 
where TABLE_NAME = 'emp01';

DESC emp01;

-- empno : not null / ename : null
insert into emp01 (empno, ename) values (1, '재석');
select * from emp01;

insert into emp01 (empno) values (2);  -- ok
select * from emp01;

-- ? 실행해 보기
insert into emp01 (ename) values ('연아');
select * from emp01;



-- *** not null ***
-- 4. alter 로 ename 컬럼을 not null로 변경
desc emp01;

-- 추가하는 게 아니라 수정
ALTER TABLE emp01 MODIFY ename varchar(10) NOT NULL;
select * from emp01;

-- emp01의 ename엔 null이 없어야 정상 실행 - 조건을 바꾸려면 기존 데이터에 수정을 가해야 합니다 
delete from emp01 where ename is null;
select * from emp01;

-- ? emp01 table의 ename 컬럼을 not null로 제약조건 추가해 보기
-- varchar(10)
ALTER TABLE emp01 MODIFY ename varchar(10) NOT NULL;

desc emp01;

-- 테이블의 메타데이터 
select * from information_schema.TABLE_CONSTRAINTS tc 
where TABLE_NAME = 'emp01';

-- 각 테이블별로 컬럼에 대한 메타데이터를 관리하는 다른 테이블이 있음
-- NULL/NOT NULL은 컬럼에는 영향을 미치지만 다른 테이블에는 영향을 미치지 않음 -> COLUMNS 단위로 관리됩니다. 
select *
from information_schema.COLUMNS
WHERE TABLE_NAME='emp01';

desc emp01;

-- 5. drop 후 dictionary table 검색
drop table if exists emp01;

-- emp01에 대한 정보가 소멸된 상태 확인을 위한 명령어
-- table 삭제시 제약조건도 자동 삭제
select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp01';

select *
from information_schema.COLUMNS
WHERE TABLE_NAME='emp01';

-- 6. 제약 조건 설정후 insert 
create table emp01(
	empno int not null,
	ename varchar(10)
);

insert into emp01 values(1, 'tester');
select * from emp01;
insert into emp01 (empno, ename) values(2, 'tester');
insert into emp01 (empno) values(3);
select * from emp01;

select *
from information_schema.COLUMNS
WHERE TABLE_NAME='emp01';

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp01';

-- *** unique ***
-- 7. unique : 고유한 값만 저장 가능, null 허용  -- UNIQUE는 제약조건을 거는 순간 INDEX(색인)이 들어갑니다
-- 내부적으로 다른 테이블,컬럼에 영향을 미칩니다 (인덱스를 만드는 용량 / 속도 값을 넣거나 수정하거나 삭제할 때 인덱스에 추가, 변경, 삭제) 
drop table if exists emp02;

-- empno 컬럼에 UNIQUE라는 제약조건을 걸어보세요 
create table emp02(
	empno int UNIQUE,
	ename varchar(10)
);

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';

select *
from information_schema.COLUMNS
WHERE TABLE_NAME='emp02';

insert into emp02 values(1, 'tester');
select * from emp02;

insert into emp02 (ename) values('master');  -- ok 즉 null 허용
select * from emp02; -- NULL이 여러개 있는 것은 중복이 아닙니다 IS NULL인 이유와 같음.


insert into emp02 (empno) values(2);  -- ok 즉 null 허용
select * from emp02;

-- 2 = 2 이기 때문에 중복 에러가 납니다. 1062 Duplicate entry '2' for key 'emp02.empno'
insert into emp02 (empno) values(2);  
select * from emp02;



-- 8. alter 명령어로 ename에 unique 적용
desc emp02;
select * from emp02;

ALTER TABLE emp02 ADD UNIQUE (ename); -- 에러의 이유는 이미 있는 데이터에 중복값이 있기 때문 

-- ename이 master인 사람 삭제
delete from emp02 where ename='master';
ALTER TABLE emp02 ADD UNIQUE (ename); 
desc emp02;
select * from emp02;

-- ? ename 컬럼에 unique 설정 추가


desc emp02;

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';

-- *** Primary key ***

-- 9. pk설정 : 데이터 구분을 위한 기준 컬럼, 중복과 null 불허
DROP TABLE IF EXISTS emp03;

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

create table emp03(
	empno int,
	ename varchar(10),
    CONSTRAINT pk_empno_emp03 PRIMARY KEY (empno)
);

-- 제약조건을 위배해서 값이 안 들어가는 경우 : SQLException이라는 별도의 예외가 생성됩니다 
select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

select *
from information_schema.COLUMNS
WHERE TABLE_NAME='emp03';

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

desc emp03;

-- ? 동일한 1값 insert 시도해 보기
insert into emp03 values (1, 'tester');
insert into emp03 values (1, 'master'); 

select * from emp03;



-- 10. 사용자 정의 제약 조건명 명시 하면서 pk 설정(권장)
-- 제약 조건명 : pk_empno_emp03
/* table명 관련컬럼명 제약조건을 적용한 이름 권장
 * pk_empno_emp03 : emp03 table의 empno 컬럼은 pk > 작은거부터 큰거 
 * 	emp03_empno_pk or pk_emp03_empno ..
 */
 use fisa;
drop table if exists emp03;

create table emp03(
	empno int,
	ename varchar(10) not null,
	constraint pk_empno_emp03 primary key (empno)
);

-- 사용자 정의 제약조건명 확인도 가능
-- pk와 not null은 확인 불가 : 한테이블에 하나밖에 없어서 고유한 값 
select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

select * from information_schema.TABLE_CONSTRAINTS;
desc emp03;

-- ?
insert into emp03 values (1, 'tester');
-- insert into emp03 values (1, 'master');  에러

select * from emp03;


-- 11. alter & pk 명령어 적용
drop table if exists emp03;

CREATE TABLE emp03(
	empno int,
	ename varchar(10) NOT null
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';

-- ? alter 명령어로 empno 칼럼을 pk로 설정하기
-- pk_empno_emp03
alter table emp03 add constraint pk_empno_emp03 primary key (empno);

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

-- ?
insert into emp03 values (1, 'tester');
-- insert into emp03 values (1, 'master');  에러

select * from emp03;


-- 12. 제약 조건 삭제
alter table emp03 drop primary key;

desc emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';

alter table emp03 add constraint pk_empno_emp03 primary key(empno);

desc emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';
select * from information_schema.TABLE_CONSTRAINTS;

/* emp의 pk - empno      사원번호가 기본키, 고유값, 중복 : 사원은 중복될 수 없으니까 
 * dept의 pk - deptno    부서번호가 기본키, 고유값, 중복 : 부서간에 사무실은 공유할 수 있으니까 
 */

-- *** foreign key ***

-- 13. 외래키[참조키]
-- emp table 기반으로 emp04 복제 단 제약조건은 적용되지 않음
-- alter 명령어로 table의 제약조건 추가 

drop table if exists emp04;
create table emp04 as select * from emp;

desc emp;
desc emp04;

-- 제약조건 정보 보유한 table
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp';

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';


-- dept table의 deptno를 emp04의 deptno에 참조 관계 형성
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp';

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='dept';

desc dept;

-- 생성시 fk 설정
/* dept의 deptno를 참조하는 emp04의 deptno 생성
 */
drop table if exists emp04;
desc dept;

CREATE TABLE emp04(
	empno int,
	ename varchar(10) NOT null,
	deptno int,
	primary key (empno),
	-- foreign key (deptno) references dept (deptno)
    constraint fk_empno_emp04 foreign key (deptno) references dept (deptno)
);

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';

select * from emp04;
insert into emp04 values (1, '연아', 10);
insert into emp04 values (2, '재석', 10);
insert into emp04 values (3, '구씨', 70); --  SQL Exception이라는 에러를 발생: 70부서 없음 dept에 없는 데이터 error  

select * from emp04;

-- 14. alter & fk drop : dict table에서 이름 확인후 삭제 
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';

-- 이름으로 제약조건 삭제 : emp04_ibfk_1
alter table emp04 drop foreign key fk_empno_emp04;

-- 삭제한 fk 확인
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';


-- alter & fk add
drop table if exists emp04;

create table emp04(
	empno int,
	ename varchar(10) not null,
	deptno int
);
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';


-- ? dept의 deptno를 참조하는 fk 설정하기
alter table emp04 add foreign key (deptno) references dept (deptno);

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';

-- ? 제약조건 이름 검색해서 삭제하기
alter table emp04 drop foreign key emp04_ibfk_1 ;

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';


-- alter & fk & 사용자 정의 제약조건명 명시
-- fk_deptno_emp04 or ...
alter table emp04 
add constraint emp04_deptnofk
foreign key (deptno) references dept (deptno);

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';

-- ? 사용자 정의 제약 조건명으로 fk 설정 삭제
alter table emp04 drop foreign key emp04_deptnofk;
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp04';


-- *** check ***	
-- 15. check : if 조건식과 같이 저장 직전의 데이터의 유효 유무 검증하는 제약조건 

drop table if exists emp05;

-- 0초과 데이터만 저장 가능한 check
create table emp05(
	empno int primary key,
	ename varchar(10) not null,
	age int,
	check (age > 0)
);

desc emp05;

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp05';

-- ?
insert into emp05 values(1, 'master', 10);
-- insert into emp05 values(2, 'master', -10);  에러, java 관점 :  SQLException

select * from emp05;


-- ? age값이 1~100까지만 DB에 저장
-- 힌트 : between ~ and ~
drop table if exists emp05;

create table emp05(
	empno int primary key,
	ename varchar(10) not null,
	age int,
	check (age between 1 and 100)
);
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';
desc emp05;
-- ?
insert into emp05 values(1, 'master', 10);
-- insert into emp05 values(2, 'master', 200); 에러
select * from emp05;


-- 16. alter & check
drop table if exists emp05;
create table emp05(
	empno int,
	ename varchar(10) not null,
	age int
);
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp05';

alter table emp05 add check (age > 0)

desc emp05;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';
insert into emp05 values(1, 'master', 10);
-- insert into emp05 values(2, 'master', -10); 에러

select * from emp05;


-- 17. drop a check : 제약조건명 검색 후에 이름으로 삭제
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp05';

alter table emp05 drop check emp05_chk_1; 

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp05';


-- 18. ? gender라는 컬럼에는 데이터가 'M' 또는(or) 'F'만 저장되어야 함
drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1),
	check ( gender in ('M', 'F') )
);

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp06';

insert into emp06 values(1, 'master', 'F');
-- insert into emp01 values(2, 'master', 'T'); 에러
select * from emp06;



-- 19. alter & check

drop table if exists emp06;

/* oracle db의 varchar 즉 문자열 비교
 * mysql 에선 글자수 / oracle에선 byte값
 */
-- char(3) -  무조건 3개 글짜 메모리 점유(고정 문자열 크기 타입)
-- varchar(10) - 가변적인 문자열 메모리 즉 최대 10개 글자 의미 (가변적 문자열 크기 타입)
create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

alter table emp06 add check ( gender in ('F', 'M') );

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

-- ?
insert into emp06 values(1, 'master', 'F');
-- insert into emp01 values(2, 'master', 'T'); 에러
select * from emp06;


-- *** default ***
-- 20. 컬럼에 기본값 자동 설정
-- insert시에 데이터를 저장하지 않아도 자동으로 기본값으로 초기화(저장)
/* java 관점에선 멤버 변수가 있는 클래스를 기반으로 객체 생성시에
 * 자동 초기화 되는 원리와 흡사
 * 단지, table 생성시에 기본 초기값 지정 
 */
drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int default 1
);

desc emp06;
select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp06';
 
insert into emp06 values(1, 'master', 10);
select * from emp06;

-- age 컬럼에 데이터 저장 생략임에도 1이라는 값 자동 저장
insert into emp06 (empno, ename) values(2, 'master');  
select * from emp06;


-- 21. alter & default

drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int
);

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp06';

-- ? "alter 컬럼명 set default 값"
alter table emp06 alter age set default 1;

insert into emp06 values(1, 'master', 10);
select * from emp06;
insert into emp06 (empno, ename) values(2, 'use02');
select * from emp06;

select * from information_schema.TABLE_CONSTRAINTS 
where table_name='emp06';
desc emp06;

-- 22. default drop 
-- defalut 제약조건 삭제
-- age 컬럼은 존재만 하는 상황
alter table emp06 alter age drop default;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
desc emp06;

-- ? defalut 값 설정없이 age값 저장 안 할 경우 에러 발생
-- insert into emp06 (empno, ename) values(3, 'use03');  에러

insert into emp06 (empno, ename, age) values(4, 'use04', 10);  
insert into emp06 (ename, age) values('use05', 50);  

select * from emp06;
