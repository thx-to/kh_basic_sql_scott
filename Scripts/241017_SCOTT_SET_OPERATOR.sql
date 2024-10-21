-- 집합연산자 : 두 개 이상의 쿼리 결과를 하나로 결합하는 연산자 (수직적 처리, 세로로 연결)
-- 수평적 처리(가로로 연결)는 조인
-- 여러개의 SELECT문을 하나로 연결하는 기능
-- 집합 연산자로 결합하는 결과의 컬럼은 데이터 타입이 동일해야 함

-- 합집합 : UNION
-- 여러 개의 SQL문의 결과에 대한 합집합 반환
-- UNION은 중복 제거, UNION ALL은 중복 모두 출력
SELECT empno, ename, sal, deptno
FROM EMP
WHERE deptno = 10
UNION
SELECT empno, ename, sal, deptno
FROM EMP
WHERE deptno = 20
UNION
SELECT empno, ename, sal, deptno
FROM EMP
WHERE deptno = 30;

-- 교집합 : INTERSECT
-- 여러 개의 SQL문의 결과에 대한 교집합을 반환
SELECT empno, ename, sal 
	FROM emp 
	WHERE sal > 1000 
INTERSECT
SELECT empno, ename, sal 
	FROM emp 
WHERE sal < 2000;

-- 차집합 : MINUS
-- 여러 개의 SQL문의 결과에 대한 차집합을 반환, 중복 행에 대한 결과는 하나로 보여줌
SELECT empno, ename, sal 
FROM emp
MINUS
SELECT empno, ename, sal 
FROM emp 
WHERE sal > 2000;