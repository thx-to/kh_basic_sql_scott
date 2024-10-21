
-- 트랜잭션(Transaction) : 데이터베이스에서의 하나의 논리적 작업 단위, 여러 개의 쿼리가 모여 하나의 작업을 수행하는 것
-- 세션 : 오라클 데이터베이스에서 세션은 데이터베이스 접속을 시작으로 여러 데이터베이스에서 관련 작업을 수행한 후 접속을 종료하기까지의 전체 시간을 의미

SELECT * FROM DEPT_TEMP;

UPDATE DEPT_TEMP
	SET loc = 'SUWON'
WHERE deptno = 60;

SELECT * FROM DEPT_TEMP;

