-- 다중행 함수(집계함수) : 여러 행에 대해서 함수가 적용되어 하나의 결과를 나타내는 함수
-- 다중행 함수(집계함수)는 NULL값을 무시함

-- GROUP BY : 기준 열에 대해 같은 데이터 값끼리 그룹으로 묶고, 묶은 행의 집합에 대해 그룹 함수의 연산이 필요할 때 사용
-- 그룹으로 묶은 열 이외에는 찍을 수 없음, SELECT절에 잘 써줘야함..
SELECT deptno, SUM(sal)
FROM EMP
GROUP BY deptno;

-- 다중행 함수의 종류
-- 공통점 : 여러 행에 걸쳐 있지만 결과는 하나로
-- SUM() : 지정한 데이터의 합을 반환
-- COUNT() : 지정한 데이터의 개수를 반환
-- MAN() : 지정한 데이터의 최댓값 반환
-- MIN() : 지정한 데이터의 최솟값 반환
-- AVG() : 지정한 데이터의 평균값 반환

-- 급여의 합 구하기
-- DISTINCT : 중복된 값 제거
SELECT SUM(DISTINCT sal), SUM(sal)
FROM EMP;

-- 모든 사원에 대해 급여와 추가수당의 합을 구하기
SELECT SUM(sal), SUM(comm)
FROM EMP;

-- 30번 부서의 모든 사원에 대해 급여와 추가수당의 합을 구하기
SELECT SUM(sal), SUM(comm)
FROM EMP
WHERE deptno = 30;

SELECT deptno, SUM(sal), SUM(comm)
FROM EMP
GROUP BY deptno;

-- 각 직책별로 급여와 추가수당의 합 구하기
SELECT job AS 직책, SUM(sal), SUM(comm)
FROM EMP
GROUP BY job;

-- EMP 테이블의 데이터 개수 출력하기
SELECT COUNT(*)
FROM EMP;

-- 각 부서별 최대(MAX) 급여 출력
SELECT MAX(sal), deptno
FROM EMP
GROUP BY deptno;

-- 각 부서별 최대(MAX) 급여 출력 / GROUP BY 없이
SELECT MAX(sal) FROM EMP WHERE DEPTNO = 10;
SELECT MAX(sal) FROM EMP WHERE DEPTNO = 20;
SELECT MAX(sal) FROM EMP WHERE DEPTNO = 30;

-- 나중에 UNION을 배워서 이렇게 출력 가능
SELECT MAX(sal) FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT MAX(sal) FROM EMP WHERE DEPTNO = 20
UNION ALL
SELECT MAX(sal) FROM EMP WHERE DEPTNO = 30;

-- 부서 번호가 20인 사원 중 가장 최근 입사자 출력
SELECT MAX(hiredate)
FROM EMP
WHERE deptno = 20;

-- 서브쿼리 사용하기 : 각 부서별 최대(MAX) 급여를 받는 사원의 사원번호, 이름, 직책, 부서번호 출력
-- 외부의 부서번호(e2)와 내부 부서번호(e)가 같은 경우 최대급여 출력 (e.deptno가 10인 경우 10에 대한 최대 급여, 20인 경우 20에 대한 최대 급여, 30인 경우 30에 대한 최대 급여)
-- 바깥의 SELECT empno, ename, job, deptno의 모든 행을 돌면서 각 값을 내부 SELECT에 대입하는 이중 for문과 비슷한 방식
SELECT empno, ename, job, deptno
FROM EMP e
WHERE sal = (
	SELECT MAX(sal)
	FROM EMP e2
	WHERE e2.deptno = e.deptno
);

-- 부서 번호가 30인 사원들의 평균 급여 출력하기
SELECT AVG(SAL)
FROM EMP
WHERE DEPTNO = 30;


-- HAVING절 : 그룹화되어있는 대상에 대한 출력 제한
-- GROUP BY가 존재할 때만 사용할 수 있음
-- GROUP으로 묶여진 상태에서 WHERE 조건절과 동일하게 동작, 그룹화된 결과값의 범위를 제한할 때 사용
-- GROUPING하지 않은 열은 WHERE, GROUPING한 열은 HAVING 사용

-- deptno, job로 그룹을 나눠 sal이 2000 이상인 사람만 deptno에 대해 오름차순 정렬로 출력
SELECT deptno, job, AVG(sal)
FROM EMP
GROUP BY deptno, job
	HAVING AVG(sal) >= 2000
ORDER BY deptno;

-- WHERE절과 HAVING절을 동시에 사용하기
-- 수행 순서 : FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY
-- EMP 테이블을 가져와서 > sal 3000 이상만 > deptno, job 열로 그룹화 > 그룹 내에서 sal 평균이 2000 이하인 행만 (행 제한) > dept, job, AVG(sal) 열만 (열 제한) > deptno, job 기준 오름차순 정렬로 출력
SELECT deptno, job, AVG(sal)
FROM EMP
WHERE sal <= 3000
GROUP BY deptno, job
	HAVING AVG(sal) <= 2000
ORDER BY deptno, job;


-- [실습1] HAVING절을 사용해서 부서별 직책의 평균 급여가 500 이상인 사원들의 부서번호, 직책, 부서별 직책의 평균 급여 출력
SELECT deptno AS "부서번호",
	job AS "직책",
	AVG(sal) AS "평균 급여"
FROM EMP
GROUP BY deptno, job
	HAVING AVG(sal) >= 500
ORDER BY deptno, job;

-- [실습2] 부서번호, 평균 급여, 최고 급여, 최저 급여, 사원수 출력 (단, 평균 급여 출력시 소수점 제외하고 부서 번호별로 출력)
SELECT deptno AS "부서번호",
	TRUNC(AVG(sal)) AS "평균 급여",
	MAX(sal) AS "최고 급여",
	MIN(sal) AS "최저 급여",
	COUNT(*) AS "사원수"
FROM EMP
GROUP BY deptno
ORDER BY deptno;

-- [실습3] 사원이 3명 이상인 직책과 인원을 출력
SELECT job AS "직책",
	COUNT(*) AS "인원"
FROM EMP
GROUP BY job
	HAVING COUNT(*) >= 3;

-- [실습4] 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력
SELECT EXTRACT(YEAR FROM hiredate) AS "입사 연도",
	deptno AS "부서",
	COUNT(*) AS "입사 사원수"
FROM EMP
GROUP BY EXTRACT(YEAR FROM hiredate), deptno
ORDER BY EXTRACT(YEAR FROM hiredate), deptno;

-- [실습5] 추가수당을 받는 사원 수와 받지 않는 사원수 출력 (O, X로 표기)

-- 처음에 이렇게 했었는데, 이렇게 하니까 0까지 NOT NULL이라 O 표기됨
SELECT NVL2(comm, 'O', 'X') AS "추가수당 수령여부", COUNT(*) AS "사원수"
FROM EMP
GROUP BY NVL2(comm, 'O', 'X')
ORDER BY NVL2(comm, 'O', 'X');

-- 수정 이렇게 진행
SELECT
	CASE
		WHEN comm IS NULL THEN 'X'
		WHEN comm = 0 THEN 'X'
		ELSE 'O'
	END AS "추가수당 수령여부",
	COUNT(*) AS "사원수"
FROM EMP
GROUP BY CASE
		WHEN comm IS NULL THEN 'X'
		WHEN comm = 0 THEN 'X'
		ELSE 'O'
	END
ORDER BY "추가수당 수령여부";

-- [실습6] 각 부서의 입사 연도별 사원수, 최고 급여, 급여 합계, 평균 급여 출력
SELECT deptno AS "부서",
	EXTRACT(YEAR FROM hiredate) AS "입사 연도",
	COUNT(empno) AS "사원수",
	MAX(sal) AS "최고 급여",
	SUM(sal) AS "급여 합계",
	AVG(sal) AS "평균 급여"
FROM EMP
GROUP BY deptno, EXTRACT(YEAR FROM hiredate)
ORDER BY deptno, EXTRACT(YEAR FROM hiredate);


-- 그룹화 관련 기타 함수 : ROLLUP
-- ROLLUP : 그룹별 결과를 출력하고 마지막에 총 데이터 결과 출력

-- 기존 GROUP BY 그룹화
SELECT deptno AS "부서번호",
	job AS "직책",
	COUNT(*) AS "사원수",
	MAX(sal) AS "최고 급여",
	SUM(sal) AS " 급여 합계",
	ROUND(AVG(sal)) AS "평균 급여"
FROM EMP
GROUP BY deptno, job
ORDER BY "부서번호", "직책";

-- ROLLUP 그룹화
SELECT deptno AS "부서번호",
	job AS "직책",
	COUNT(*) AS "사원수",
	MAX(sal) AS "최고 급여",
	SUM(sal) AS " 급여 합계",
	ROUND(AVG(sal)) AS "평균 급여"
FROM EMP
GROUP BY ROLLUP(deptno, job)
ORDER BY "부서번호", "직책";

-- ROLLUP NULL값 변환하기
SELECT NVL(TO_CHAR(deptno), '전체부서') AS "부서번호",
	NVL(TO_CHAR(job), '합계') AS "직책",
	COUNT(*) AS "사원수",
	MAX(sal) AS "최고 급여",
	SUM(sal) AS " 급여 합계",
	ROUND(AVG(sal)) AS "평균 급여"
FROM EMP
GROUP BY ROLLUP(deptno, job)
ORDER BY "부서번호", "직책";