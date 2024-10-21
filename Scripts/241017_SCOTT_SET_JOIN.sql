-- JOIN : 여러 테이블을 하나의 테이블처럼 사용하는 것
-- 필요한 것 : PK(Primary Key), FK(Foreign Key, 상대방의 PK를 내 FK로, 테이블 간 공통 값)를 사용

-- Join의 종류
-- Inner Join (동등 조인) : 두 테이블에서 일치하는 데이터만 선택
-- Left Join : 왼쪽 테이블의 모든 데이터와 일치하는 데이터 선택
-- Right Join : 오른쪽 테이블의 모든 데이터와 일치하는 데이터 선택
-- Full Outer Join : 두 테이블의 모든 데이터를 선택

-- 카테시안의 곱 : 두 개의 테이블을 조인할 때 기준 열을 지정하지 않으면 모든 행 * 모든행
SELECT *
FROM EMP, DEPT
ORDER BY empno;

-- Join의 기준열을 deptno로 지정
-- EMP 테이블의 deptno와 DEPT 테이블의 deptno가 중복 출력됨 (같은 데이터)
SELECT *
FROM EMP e, DEPT d
WHERE e.deptno = d.deptno
ORDER BY empno;

-- 출력 열을 EMP테이블의 deptno만으로 제한
-- 등가 조인 (동등 조인) : 일치하는 열이 존재, Inner Join이라고도 함, 가장 일반적인 조인 방식
SELECT empno, ename, job, e.deptno
FROM EMP e, DEPT d
WHERE e. deptno = d.deptno
ORDER BY empno;

-- ANSI(American National Standards Institute) 조인 : SQL 표준에서 지정한 조인
-- DEPT 테이블과 EMP 테이블은 1:N 관계를 가짐 (부서 테이블의 부서번호에는 여러 명의 사원이 올 수 있음)
SELECT empno, ename, job, sal, e.deptno
FROM EMP e JOIN DEPT d ON e.deptno = d.deptno;

-- Join 에서 출력 범위 설정하기
SELECT empno, ename, sal, d.deptno, dname, loc
FROM EMP e JOIN DEPT d ON e.deptno = d.deptno
WHERE sal > = 3000;

-- [실습] EMP 테이블 별칭을 E로, DEPT 테이블 별칭을 D로 하여 다음과 같이 등가 조인을 했을 때, 급여가 2500 이하이고 사원 번호가 9999 이하인 사원의 정보가 출력되도록 작성 (오라클 조인이나 ANSI 조인 중 아무거나 사용)
-- 오라클 조인
SELECT *
FROM EMP E, DEPT D
WHERE E.deptno = D.deptno AND sal <= 2500 AND empno <= 9999;
-- ANSI 조인
SELECT *
FROM EMP E JOIN DEPT D ON E.deptno = D.deptno
WHERE sal <= 2500 AND empno <= 9999;

-- 비등가 조인 : 동일한 컬럼이 존재하지 않는 경우에 실행하는 조인, 일반적인 조인 방식은 아님
-- 급여와 LOSAL, HISAL의 비등가 조인
SELECT ename, sal, grade
FROM EMP e JOIN SALGRADE s ON sal BETWEEN s.LOSAL AND s.HISAL;

-- 자체 조인(Self Join) : 자기 자신의 테이블과 조인
SELECT e1.empno AS "사원 번호",
	e1.ename AS "사원 이름",
	e1.mgr AS"매니저 사원번호",
	e2.empno AS "매니저 사원번호",
	e2.ename AS "매니저 이름"
FROM EMP e1 JOIN EMP e2 ON e1.mgr = e2.empno;

-- 외부 조인 (Outer Join) : Left, Right, Full
-- DEPT에는 40번 부서까지 있지만, EMP 테이블에 40번 부서인 사람이 아무도 없어서 출력되지 않음
SELECT e.ename, e.deptno, d.dname
FROM EMP e JOIN DEPT d ON e.deptno = d.deptno
ORDER BY e.DEPTNO;

-- RIGHT OUTER JOIN으로 사원이 없는 부서까지 출력하기
SELECT e.ename, e.deptno, d.dname
FROM EMP e RIGHT OUTER JOIN DEPT d ON e.deptno = d.deptno
ORDER BY e.deptno;

-- NATURAL JOIN : 등가 조인과 비슷하지만 WHERE 조건절 없이 사용
-- 두 테이블에서 동일한 이름이 있는 열을 자동으로 찾아서 조인
SELECT empno, ename, dname, deptno
FROM EMP NATURAL JOIN DEPT;

-- JOIN ~ USING : 등가 조인을 대신하는 방법
-- ON e.deptno = d.deptno 대신 USING(deptno)로 써줌
SELECT e.empno, e.ename, e.job, deptno, d.dname, d.loc
FROM EMP e JOIN DEPT d USING(deptno)
ORDER BY e.empno;


-- [실습1] 급여가 2000 초과인 사원들의 정보 출력 (부서번호, 부서이름, 사원번호, 사원이름, 급여)
-- JOIN ~ ON, NATURAL JOIN, JOIN ~ USING 아무거나 사용
SELECT deptno AS "부서번호",
	dname AS "부서이름",
	empno AS "사원번호",
	ename AS "사원이름",
	sal AS "급여"
FROM EMP NATURAL JOIN DEPT
WHERE sal > 2000
ORDER BY sal;

-- [실습2] 각 부서별 평균 급여, 최대 급여, 최소 급여, 사원수 출력 (부서번호, 부서이름, 평균 급여, 최대 급여, 최소 급여, 사원수)
SELECT deptno AS "부서번호",
	dname AS "부서이름",
	ROUND(AVG(sal)) AS "평균 급여",
	MAX(sal) AS "최대 급여",
	MIN(sal) AS "최소 급여",
	COUNT(*) AS "사원수"
FROM EMP NATURAL JOIN DEPT
GROUP BY deptno, dname
ORDER BY deptno;

-- [실습3] 모든 부서 정보와 사원 정보 출력 (부서 번호와 부서 이름순으로 정렬), 모든 부서가 나와야 함
SELECT deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm
FROM EMP NATURAL JOIN DEPT
ORDER BY deptno, dname;

