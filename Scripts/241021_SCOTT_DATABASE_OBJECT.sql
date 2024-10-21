-- 데이터 사전 : 데이터베이스를 구성하고 운영하는데 필요한 모든 정보를 저장하는 특수한 테이블을 의미함
-- 데이터 사전에는 데이터베이스 메모리, 성능, 사용자, 권한, 객체 등의 정보가 포함됨

SELECT * FROM DICT;
SELECT * FROM DICTIONARY;

-- 인덱스 구조
SELECT *
FROM USER_INDEXES;

-- 인덱스 생성 : 오라클에서는 자동으로 생성해주는 인덱스(PK, Primary Key) 외 사용자가 직접 인덱스를 만들 수 있음, CREATE문 사용
-- sal 열에 대해 IDX_EMP_SAL이라는 이름으로 인덱스 등록하기
CREATE INDEX IDX_EMP_SAL ON EMP(sal);
SELECT * FROM USER_INDEXES;

-- 인덱스 삭제
DROP INDEX IDX_EMP_SAL;
SELECT * FROM USER_INDEXES;


-- 테이블뷰
-- 뷰 : 가상 테이블(실제 물리적인 테이블이 아니고, 어떤 조건에 의해 만들어진 테이블), 하나 이상의 테이블을 조회하는 SELECT문을 저장한 객체
-- EMP테이블을 자른 테이블을 하나 새로 만듦 (CREATE TABLE 대신에 CREATE VIEW)
-- 원본이 바뀌면 내용도 바뀜
CREATE VIEW VW_EMP20
AS (SELECT empno, ename, job, deptno
	FROM EMP
	WHERE deptno = 20
	);
SELECT * FROM VW_EMP20;

-- 서브쿼리의 인라인뷰(FROM절에 들어가는 서브쿼리)
-- WHERE조건절에 들어가는 일반적인 서브쿼리는, 테이블을 다 가져와서 필요에 의해 WHERE절에서 잘라서 일부만 사용함
-- FROM절에 들어가는 서브쿼리는 가져올 때부터 지정한 조건에 의해 잘라서 가져옴
-- 원본이 바뀌면 내용도 바뀜
SELECT *
FROM (
	SELECT empno, ename, job, deptno
	FROM EMP
	WHERE deptno = 20
);


-- 규칙에 따라 순번을 생성하는 시퀀스
-- 시퀀스 : 오라클 데이터베이스에서 특정 규칙에 맞는 연속 숫자를 생성하는 객체
-- WHERE 1 <> 1; : 1과 1은 같지 않을 수 없으니 항상 FALSE, 내용은 다 지워지고 껍데기만 복사됨
CREATE TABLE DEPT_SEQUENCE
AS SELECT *
FROM DEPT
WHERE 1 <> 1;
SELECT * FROM DEPT_SEQUENCE;

-- 시퀀스 생성하기 (일련번호 부여)
-- 10씩 증가 (INCREMENT BY)
-- 10부터 시작 (START WITH)
-- 최댓값은 90 (MAXVALUE)
-- 최솟값은 0 (MINVALUE)
-- 반복하지 않는다 (NOCYCLE)
-- 캐시 사이즈는 2 (CACHE)
CREATE SEQUENCE SEQ_DEPT_SEQUENCE
INCREMENT BY 10
START WITH 10
MAXVALUE 90
MINVALUE 0
NOCYCLE
CACHE 2;
SELECT * FROM USER_SEQUENCES;

INSERT INTO DEPT_SEQUENCE (deptno, dname, loc)
	VALUES (SEQ_DEPT_SEQUENCE.NEXTVAL, 'DATABASE', 'SEOUL');
INSERT INTO DEPT_SEQUENCE (deptno, dname, loc)
	VALUES (SEQ_DEPT_SEQUENCE.NEXTVAL, 'JAVA', 'BUSAN');
SELECT * FROM DEPT_SEQUENCE
ORDER BY deptno;
