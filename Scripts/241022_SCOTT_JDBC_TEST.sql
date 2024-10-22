-- 기존 테이블의 열 구조와 데이터를 복사하여 새 테이블 생성하기
-- DEPT 테이블을 다 복사해서 DEPT_DDL 테이블을 하나 만듦
CREATE TABLE EMP_TEST01
	AS SELECT * FROM EMP;
SELECT * FROM EMP;
