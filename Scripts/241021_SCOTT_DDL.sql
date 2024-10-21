-- DDL(Data Definition Language) : 데이터베이스에 데이터를 보관하기 위해 제공되는 생성, 변경, 삭제 관련 기능 수행
-- CREATE : 새로운 데이터베이스 개체(Entity)를 생성
-- ALTER : 기존 데이터베이스의 개체(Entity)를 수정
-- DROP : 데이터베이스 개체(Entity)를 삭제
-- TRUNCATE : 모든 데이터를 삭제하지만 테이블 구조는 남겨 둠
-- TABLE : 데이터베이스의 기본 데이터 저장 단위, 사용자가 접근 가능한 데이터를 보유하며 레코드(행)와 컬럼(열)으로 구성
-- 테이블과 테이블의 관계를 표현하는데 외래키(FK, Foreign Key) 사용

-- 자바는 데이터 타입이 먼저, 변수가 그 다음
-- DB는 컬럼 이름이 먼저 나오고 타입이 나옴
-- NUMBER(4) : 숫자형 데이터(NUMBER) 타입, 4자리로 선언(자릿수는 생략 가능, 생략시 최대크기만큼)
-- VARCHAR(10) : 가변 문자 데이터 타입, 실제 입력된 크기만큼 차지
-- DATE : 날짜와 시간을 지정하는 날짜형 데이터 타입
-- NUMBER(7, 2) : 전체 범위가 7자리, 소수점 이하가 2자리 (정수부는 5자리가 됨)
CREATE TABLE emp_ddl(
	empno NUMBER(4),
	ename VARCHAR2(10),
	job VARCHAR2(9),
	mgr NUMBER(4),
	hiredate DATE,
	sal NUMBER(7, 2),
	comm NUMBER(7, 2),
	deptno NUMBER(2)
);

SELECT * FROM emp_ddl;


-- 기존 테이블의 열 구조와 데이터를 복사하여 새 테이블 생성하기
-- DEPT 테이블을 다 복사해서 DEPT_DDL 테이블을 하나 만듦
CREATE TABLE DEPT_DDL
	AS SELECT * FROM DEPT;

SELECT * FROM DEPT_DDL;


-- EMP 테이블을 복사하여 EMP_ALTER라는 새 테이블 생성
CREATE TABLE EMP_ALTER
	AS SELECT * FROM EMP;

-- 생성된 테이블 확인
SELECT * FROM EMP_ALTER;

-- 열 이름을 추가하는 ADD : 기존 테이블에 새로운 컬럼을 추가하는 명령어
ALTER TABLE EMP_ALTER
	ADD HP VARCHAR2(20);
SELECT * FROM EMP_ALTER;

-- 열 이름을 변경하는 RENAME
ALTER TABLE EMP_ALTER
	RENAME COLUMN hp TO tel;
SELECT * FROM EMP_ALTER;

-- 열의 자료형을 변경하는 MODIFY
-- 자료형 변경 시 데이터가 이미 존재하는 경우 크기를 크게 하는 경우는 문제가 되지 않으나 크기를 줄이는 경우 저장되어 있는 데이터 크기에 따라 변경되지 않을 수 있음
ALTER TABLE EMP_ALTER
	MODIFY empno number(5);
SELECT * FROM EMP_ALTER;

-- 특정 열을 삭제하는 DROP
ALTER TABLE EMP_ALTER DROP COLUMN tel;
SELECT * FROM EMP_ALTER;

-- 테이블 이름을 변경하는 RENAME
RENAME EMP_ALTER TO EMP_RENAME;
SELECT * FROM EMP_RENAME;
-- 테이블의 데이터를 삭제하는 TRUNCTE : 테이블의 모든 데이터 삭제, 테이블 구조에 영향 주지 않음
-- DDL 명령어이기 때문에 ROLLBACK 불가능

-- DELETE는 DML이기 때문에 롤백 가능
DELETE FROM EMP_RENAME;
SELECT * FROM EMP_RENAME;
ROLLBACK;
SELECT * FROM EMP_RENAME;

-- TRUNCATE은 DDL이기 때문에 롤백 불가능
TRUNCATE TABLE EMP_RENAME;
ROLLBACK;
SELECT * FROM EMP_RENAME;

-- 테이블을 삭제하는 DROP : 테이블이 삭제되므로 테이블에 저장된 데이터도 모두 삭제됨
DROP TABLE EMP_RENAME;
SELECT * FROM EMP_RENAME;




