-- 서브쿼리 : 다른 SQL 쿼리문에 포함되는 쿼리문 / 다른 언어의 2중for문같은방식

-- 주로 데이터를 필터링하거나 집계할 때 사용
-- 서브쿼리는 연산자와 같은 비교, 조회 대상의 오른쪽에 놓이며, 소괄호()로 묶어서 표현
-- SELECT문, INSERT문, UPDATE문, DELETE문에 모두 사용 가능
-- 특정한 경우를 제외하고는 ORDER BY 절을 사용할 수 없음
-- 서브쿼리의 SELECT절에 명시한 열은 메인쿼리의 비교대상과 같은 자료형과 같은 개수로 지정해야 함

-- JOIN문보다 순회 회수가 많아져 이점이 없음
-- 관계를 이해하기가 편리함
-- 스프링부트 JPA에서는 서브쿼리를 지원하지 않아 JPQL에서 작성해야 함

-- 단일행 서브쿼리 : 결과가 하나의 행으로 반환
-- 다중행 서브쿼리 : 결과가 여러개의 행으로 반환

-- 기본 SELECT문
SELECT dname AS "부서이름"
FROM DEPT
WHERE deptno = 10;

-- 서브쿼리로 특정한 사원이 소속된 부서의 이름 가져오기
SELECT dname AS "KING의 부서이름"
FROM DEPT
WHERE deptno = (
	SELECT deptno
	FROM EMP
	WHERE ename = 'KING'
);

-- 등가조인으로 특정 사원이 소속된 부서의 이름 가져오기
SELECT dname
FROM EMP e
JOIN DEPT d
ON E.deptno = d.deptno
WHERE e.ename = 'KING';

-- 서브쿼리로 JONES보다 급여를 많이 받는 사원 정보 출력
SELECT *
FROM EMP
WHERE sal > (
	SELECT sal
	FROM EMP
	WHERE ename = 'JONES'
);

-- 자체 조인(SELF)으로 JONES보다 급여를 많이 받는 사원 정보 출력
SELECT e1.*
FROM EMP e1
JOIN EMP e2
ON e1.sal > e2.sal
WHERE e2.ename = 'JONES';


-- [실습1] EMP 테이블의 사원 정보 중에서 사원 이름이 ALLEN인 사원의 추가 수당보다 많은 추가 수당을 받는 사원 정보 출력
SELECT *
FROM EMP
WHERE comm > (
	SELECT comm
	FROM EMP
	WHERE ename = 'ALLEN'
);

-- [실습2] JAMES보다 먼저 입사한 사원들의 정보 출력
SELECT *
FROM EMP
WHERE hiredate < (
	SELECT hiredate
	FROM EMP
	WHERE ename = 'JAMES'
);

-- [실습3] 20번 부서에 속한 사원 중 전체 사원의 평균급여보다 높은 급여를 받는 사원 정보 조회 (사원번호, 이름, 직책, 급여, 부서번호, 부서이름, 부서 위치)
SELECT e.empno AS "사원번호",
	e.ename AS "이름",
	e.job AS "직책",
	e.sal AS "급여",
	e.deptno AS "부서번호",
	d.dname AS "부서이름",
	d.loc AS "위치"
FROM EMP e
JOIN DEPT d
ON e.deptno = d.deptno
WHERE e.deptno = 20
AND e.sal > (
	SELECT AVG(sal)
	FROM EMP
);


-- 실행 결과가 여러개인 다중행 서브쿼리
-- IN : 메인쿼리의 데이터와 서브쿼리의 데이터가 하나라도 일치하면 true
-- ANY, SOME : 메인쿼리의 조건식을 만족하는 서브쿼리의 결과가 하나 이상이면 true
-- ALL : 메인쿼리의 조건식을 서브쿼리의 결과 모두가 만족하면 true
-- EXISTS : 서브쿼리의 결과가 존재하면 true (한개 이상의 행)

-- 부서별 급여를 가장 많이 받는 사원 정보 출력
-- 메인쿼리에서 급여가 서브쿼리에서 각 부서의 최대 급여와 같은 사원의 모든 정보 출력
SELECT *
FROM EMP
WHERE sal IN (
	SELECT MAX(sal)
	FROM EMP
	GROUP BY deptno
)
ORDER BY deptno;

-- SALES맨들의 급여 중 최솟값보다 많은 급여를 받는 사원 출력
-- 집계함수 사용
SELECT empno, ename, sal
FROM EMP
WHERE sal > (
	SELECT MIN(sal)
	FROM EMP
	WHERE job = 'SALESMAN'
)
ORDER BY sal;

-- ANY 사용
-- SALES맨들 중 누구의 급여보다 높으면 만족 = 최솟값
SELECT empno, ename, sal
FROM EMP
WHERE sal > ANY (
	SELECT sal
	FROM EMP
	WHERE job = 'SALESMAN'
)
ORDER BY sal;

-- SALES맨들의 급여와 같은 급여를 받는 사원 출력
-- SALES맨 중 한명이라도 급여가 일치하면 만족
SELECT empno, ename, sal
FROM EMP
WHERE sal = ANY (
	SELECT sal
	FROM EMP
	WHERE job = 'SALESMAN'
);

-- 30번 부서의 사원보다 급여가 적은 사원 정보 출력
-- 집계함수 사용
SELECT empno, ename, sal, deptno
FROM EMP
WHERE sal < (
	SELECT MIN(sal)
	FROM EMP
	WHERE deptno = 30
);

-- ALL 사용
-- 30번 부서의 사원 전부의 급여보다 적어야 함 = 최솟값
SELECT empno, ename, sal, deptno
FROM EMP
WHERE sal < ALL (
	SELECT sal
	FROM EMP
	WHERE deptno = 30
);

-- [실습] 직책이 'MANAGER'인 사원보다 많은 급여를 받는 사원의 사원번호, 이름, 급여, 부서이름 출력하기
-- NATURAL JOIN, 집계함수 사용
SELECT empno, ename, sal, dname
FROM EMP NATURAL JOIN DEPT
WHERE sal > (
		SELECT MAX(sal)
		FROM EMP
		WHERE job = 'MANAGER'
);

-- 동등 JOIN, 집계함수 사용
SELECT e.empno, e.ename, e.sal, d.dname
FROM EMP e JOIN DEPT d ON e.deptno = d.deptno
WHERE sal > ALL (
	SELECT sal
	FROM EMP
	WHERE job = 'MANAGER'
);

-- EXISTS : 서브쿼리의 결과값이 하나 이상 존재하면(행이 하나 이상이면) true(화면에 표시)
-- 서브쿼리의 결과값(DEPT테이블의 deptno가 10인 값)이 존재하면 메인쿼리(EMP테이블) 전부 다(*) 찍기
SELECT *
FROM EMP
WHERE EXISTS (
	SELECT dname
	FROM DEPT
	WHERE deptno = 10
)
ORDER BY deptno;

-- DEPT테이블에 존재하지 않는 deptno = 50을 입력하면 빈 테이블 출력
SELECT *
FROM EMP
WHERE EXISTS (
	SELECT dname
	FROM DEPT
	WHERE deptno = 50
)
ORDER BY deptno;


-- 다중열 서브쿼리 : 서브쿼리의 결과가 두 개 이상의 컬럼으로 반환되어 메인쿼리에 전달하는 쿼리
-- 다중열 서브쿼리는 IN, EXISTS밖에 사용할 수 없음
-- 30번 부서의, deptno/sal값을 가진 사람을 모두 출력
SELECT empno, ename, sal, deptno
FROM EMP
WHERE (deptno, sal) IN (
	SELECT deptno, sal
	FROM EMP
	WHERE deptno = 30
);

-- 각 부서에서 최대 급여를 받는 사원 정보 출력
SELECT *
FROM EMP
WHERE (deptno, sal) IN (
	SELECT deptno, MAX(sal)
	FROM EMP
	GROUP BY deptno
)
ORDER BY deptno;

-- FROM절에 사용하는 서브쿼리 : 인라인뷰
-- 테이블 내 데이터 규모가 크거나 현재 작업에 불필요한 데이터가 많아서 일부 행이나 열만 사용하고자 할 때 유용함
-- FROM절에 행이나 열 제한을 걸어서 일부만 가져옴

-- 행 제한 예시
-- EMP테이블의 deptno = 10인 데이터만 가져와서 DEPT테이블과 조인, deptno = 10인 데이터만 출력
SELECT e10.empno, e10.ename, e10.deptno, d.dname, d.loc
FROM (
	SELECT *
	FROM EMP
	WHERE deptno = 10) e10
JOIN DEPT d ON e10.deptno = d.deptno;

-- 열 제한 예시
-- EMP테이블의 ename, empno, deptno열만 가져와서 DEPT테이블과 조인, EMP테이블의 empno, ename, deptno와 DEPTNO의 (deptno), dname, loc가 조인되어 출력
SELECT e10.empno, e10.ename, e10.deptno, d.dname, d.loc
FROM (
	SELECT ename, empno, deptno
	FROM EMP) e10
JOIN DEPT d ON e10.deptno = d.deptno
ORDER BY deptno;

-- 먼저 정렬하고 해당 개수만 가져오기
-- ROWNUM : 오라클에서 제공하는 예약어, 행번호(일련번호) 매기기
-- 급여가 기준으로 내림차순, ROWNUM 3 이하만 출력 = 급여가 가장 많은 3명 출력
SELECT ROWNUM, ename, sal
FROM (
	SELECT *
	FROM EMP
	ORDER BY sal DESC)
WHERE ROWNUM <= 3;

-- SELECT절에 사용하는 (단일행)서브쿼리 : 스칼라 서브쿼리
-- SELECT절에 명시하는 서브쿼리는 반드시 하나의 결과만 반환하도록 작성 (SELECT절은 컬럼 제한, 하나의 컬럼만 들어가야 하기 때문)
-- 1) FROM절에서 EMP 테이블을 가져옴
-- 2) SELECT절에서 empno, ename, job, sal 출력
-- 3) SELECT절의 첫번째 서브쿼리, SALGRADE 테이블을 가져와서 EMP테이블의 sal값이 losal과 hisal 사이에 위치하도록 해당하는 등급 출력
-- 4) SELECT절에서 deptno 출력
-- 5) SELECT절의 두번째 서브쿼리, DEPT 테이블을 가져와서 EMP테이블의 deptno값(e.deptno)과 같은 deptno(d.deptno)를 출력
-- 6) ORDER BY절에서 "급여 등급" 오름차순 정렬
SELECT empno AS "사원 번호",
	ename AS "이름",
	job AS "직책",
	sal AS "급여",
	(SELECT grade FROM SALGRADE WHERE e.sal BETWEEN losal AND hisal) AS "급여 등급",
	deptno AS "부서 번호",
	(SELECT dname FROM dept d WHERE e.deptno = d.deptno) AS "부서 이름"
FROM EMP e
ORDER BY "급여 등급";

-- 조인문으로 변경하기
-- SALGRADE는 비등가조인, 겹치는 열이 없음
-- DEPT는 등가조인, deptno 열로 조인
SELECT e.empno AS "사원 번호",
	e.ename AS "이름",
	e.job AS "직책",
	e.sal AS "급여",
	s.grade AS "급여 등급",
	d.deptno AS "부서 번호",
	d.dname AS "부서 이름"
FROM EMP e
JOIN SALGRADE s ON e.sal BETWEEN losal AND hisal
JOIN DEPT d ON e.deptno = d.deptno
ORDER BY "급여 등급";

-- 부서 위치가 NEW YORK인 경우에는 본사, 그 외는 분점으로 반환
SELECT empno, ename,
	CASE
		WHEN deptno = (
			SELECT deptno
			FROM DEPT
			WHERE loc = 'NEW YORK') THEN '본사'
		ELSE '분점'
	END AS "소속"
FROM EMP
ORDER BY "소속";
	

-- [실습1] 전체 사원 중 ALLEN과 같은 직책인 사원의 정보 출력 (직책, 사원번호, 사원이름, 급여, 부서번호, 부서이름)
SELECT e.job AS "직책",
	e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.sal AS "급여",
	d.deptno AS "부서번호",
	d.dname AS "부서이름"
FROM EMP e JOIN DEPT d ON e.DEPTNO = d.DEPTNO
WHERE e.job = (
	SELECT job
	FROM EMP
	WHERE ename = 'ALLEN'
);

-- [실습2] 전체 사원의 평균 급여보다 높은 급여를 받는 사원의 정보 출력
-- (사원번호, 이름, 입사일, 급여, 급여등급, 부서이름, 부서위치 / 급여가 많은 순으로 정렬, 급여가 같을 경우에는 사원번호 기준 오름차순 정렬)
SELECT e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.hiredate AS "입사일",
	e.sal AS "급여",
	s.grade AS "급여등급",
	d.dname AS "부서이름",
	d.loc AS "부서위치"
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
JOIN SALGRADE s ON e.sal BETWEEN s.losal AND s.hisal
WHERE sal > (
	SELECT AVG(sal)
	FROM EMP
)
ORDER BY e.sal DESC, e.empno;

-- [실습3] 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원의 정보 출력
-- (사원번호, 사원이름, 직책, 부서번호, 부서이름, 부서위치)
-- 다중행 함수 ALL 연산자 사용
SELECT e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.job AS "직책",
	d.deptno AS "부서번호",
	d.dname AS "부서이름",
	d.loc AS "부서위치"
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
WHERE e.deptno = 10 AND e.job != ALL (
	SELECT DISTINCT job
	FROM EMP
	WHERE deptno = 30
	);

-- 다중행 함수 IN 연산자 사용 (NOT IN)
SELECT e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.job AS "직책",
	d.deptno AS "부서번호",
	d.dname AS "부서이름",
	d.loc AS "부서위치"
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
WHERE e.deptno = 10 AND e.job NOT IN (
	SELECT DISTINCT job
	FROM EMP
	WHERE deptno = 30
	);

-- [실습4] 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원의 정보 출력
-- (사원번호, 사원이름, 급여, 급여등급 / 서브쿼리를 사용할 때 다중행 함수를 사용하는 방법과 사용하지 않는 방법을 통해 사원번호를 기준으로 오름차순 정렬)

-- 집계함수 사용
SELECT e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.sal AS "급여",
	s.grade AS "급여등급"
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
JOIN SALGRADE s ON e.sal BETWEEN s.losal AND s.hisal
WHERE sal > (
	SELECT MAX(sal)
	FROM EMP
	WHERE job = 'SALESMAN'
)
ORDER BY empno;

-- 다중행 함수 ALL 연산자 사용
SELECT e.empno AS "사원번호",
	e.ename AS "사원이름",
	e.sal AS "급여",
	s.grade AS "급여등급"
FROM EMP e
JOIN DEPT d ON e.deptno = d.deptno
JOIN SALGRADE s ON e.sal BETWEEN s.losal AND s.hisal
WHERE sal > ALL (
	SELECT sal
	FROM EMP
	WHERE job = 'SALESMAN'
)
ORDER BY empno;


