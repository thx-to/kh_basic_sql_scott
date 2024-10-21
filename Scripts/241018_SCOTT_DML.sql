-- DML(Data Manipulation Language) : Insert(입력), Update(수정), Delete(삭제)
-- DML은 테이블 관점이 아니고 데이터 관점
-- 트랜잭션 단위로 처리, 커밋되기 전까지는 반영되지 않음 (오류 발생시 롤백 가능)
-- DDL은 테이블 관점, Create(생성), Alter(변경), Drop(제거) > 커밋하지 않아도 즉시 반영

-- 연습용 테이블 생성하기
-- DEPT 테이블을 그대로 가져와서 테이블 복사
CREATE TABLE DEPT_TEMP
AS SELECT * FROM DEPT;

SELECT * FROM DEPT_TEMP;

-- 테이블에 데이터를 추가하는 INSERT문
-- INSERT INTO 테이블명(컬럼명..) VALUES(데이터..)
INSERT INTO DEPT_TEMP(deptno, dname, loc) VALUES (50, 'DATABASE', 'SEOUL');
SELECT * FROM DEPT_TEMP;

INSERT INTO DEPT_TEMP VALUES(60, 'BACKEND', 'BUSAN');
SELECT * FROM DEPT_TEMP;

-- 컬럼을 지정하면 지정한 컬럼에만 값을 넣고 나머지는 NULL값으로 입력할 수 있음
INSERT INTO DEPT_TEMP(deptno) VALUES(70);
SELECT * FROM DEPT_TEMP;

-- 컬럼을 아예 지정하지 않으면 모든 값을 다 넣어줘야 함, 넣지 않으면 오류
INSERT INTO DEPT_TEMP VALUES(80, 'FROENTEND', 'INCHEON');
SELECT * FROM DEPT_TEMP;

-- 만약 프라이머리키가 지정이 되어 있다면 NULL 불가능
-- deptno가 PK였으면 아래 값이 INSERT가 안되는데 입력이 되는 것으로 보아 PK설정이 되어 있지 않음을 알 수 있음..
INSERT INTO DEPT_TEMP(dname, loc) VALUES ('APP', 'DAEGU');
SELECT * FROM DEPT_TEMP;

-- 아래처럼 deptno같은 중복되면 안되는(부서번호) 값이 PK로 등록되어 있지 않음, 중복이 발생될 수 있음
-- DB는 중복되면 안되기 때문에 PK는 반드시 설정해 줘야 함
INSERT INTO DEPT_TEMP VALUES(80, 'FROENTEND', 'INCHEON');
SELECT * FROM DEPT_TEMP;

-- 기본 DEPT 테이블은 PK설정이 되어 있어, 이미 존재하는 40번 테이블 중복 입력이 불가능
-- 여기서 새로 복사한 DEPT_TEMP는 복사하면서 PK나 NOT NULL 등의 조건이 깨진 듯 보임
INSERT INTO DEPT VALUES (40, 'BACKEND', 'BUSAN');
SELECT * FROM DEPT_TEMP;

-- 쓸데없이 추가한 데이터 지워주기
DELETE FROM DEPT_TEMP
WHERE dname = 'APP';
DELETE FROM DEPT_TEMP
WHERE deptno = 70;
DELETE FROM DEPT_TEMP
WHERE deptno = 80;
SELECT * FROM DEPT_TEMP;

INSERT INTO DEPT_TEMP VALUES (70, '웹개발', '');
SELECT * FROM DEPT_TEMP;

CREATE TABLE EMP_TEMP
AS SELECT *
FROM EMP;

-- EMP 테이블의 열 정보를 갖고, 세부 데이터 없이 복사하기
CREATE TABLE EMP_TEMP1
AS SELECT *
FROM EMP
WHERE 1 != 1;

SELECT * FROM EMP_TEMP1;

-- 테이블에 날짜 데이터 입력하기
-- 1) 날짜 그대로 입력
INSERT INTO EMP_TEMP1 (empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES (9001, '나영석', 'PD', NULL, '2020/01/01', 9900, 1000, 50);
-- 2) TO_DATE() 형식으로 입력
INSERT INTO EMP_TEMP1 (empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES (9002, '강호동', 'MC', NULL, TO_DATE('2021/01/02', 'YYYY/MM/DD'), 8000, 1000, 60);
-- 3) SYSDATE로 현재 날짜 입력
INSERT INTO EMP_TEMP1 (empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES (9003, '서장훈', 'MC', NULL, SYSDATE, 9000, 1000, 60);


-- 롤백 테스트
-- DBeaver는 Auto Commit 설정되어 있어서 롤백 기능을 이용하려면 상단 메뉴 데이터베이스 - 트랜잭션 모드 - Manual Commit으로 변경해 줘야 함
INSERT INTO DEPT_TEMP(deptno, dname, loc) VALUES(80, 'FRONTEND', 'SUWON');
SELECT * FROM DEPT_TEMP;
ROLLBACK;
SELECT * FROM DEPT_TEMP;

-- 테이블 데이터 수정 UPDATE
UPDATE DEPT_TEMP
	SET dname = 'WEB-PROGRAM',
	loc = 'SUWON'
	WHERE deptno = 70;
SELECT * FROM DEPT_TEMP;

-- 테이블 전체 삭제하기
-- WHERE 없이 FROM절만 작성
DELETE FROM DEPT_TEMP;

-- loc가 수원인 데이터만 지워주기
SELECT * FROM DEPT_TEMP;
DELETE FROM DEPT_TEMP
WHERE loc = 'SUWON';
SELECT * FROM DEPT_TEMP;