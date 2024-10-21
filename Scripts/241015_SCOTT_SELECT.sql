-- SELECT와 FROM
-- SELECT문은 데이터베이스에 보관되어 있는 데이터를 조회할 때 사용
-- SELECT절은 FROM절에 명시한 테이블에서 조회할 열을 지정할 수 있음
-- SELECT [조회할 열], [조회할 열] FROM 테이블이름;
SELECT * FROM EMP; -- * 모든컬럼을 의미, FROM 다음에 오는 것이 테이블 이름, SQL 수행문은 ;로 끝나야 함


-- 특정 컬럼만 선택해서 조회
SELECT EMPNO, ENAME, DEPTNO FROM EMP;

-- 사원번호와 부서번호만 나오도록 SQL 작성 (EMPNO, DEPTNO)
SELECT EMPNO, DEPTNO FROM EMP;


-- 한눈에 보기 좋게 별칭 부여하기
SELECT ENAME, SAL, COMM, SAL * 12 + COMM
	FROM EMP;

-- 한눈에 보기 좋기 별칭 부여하기
SELECT ENAME "사원 이름", SAL AS "급여", COMM AS "성과급", SAL * 12 "연봉"
	FROM EMP;


-- 중복 제거하는 DISTINCT, 데이터를 조회할 때 중복되는 행이 여러 행 조회될 때 중복된 행을 한 개씩만 선택
SELECT DISTINCT DEPTNO
FROM EMP
ORDER BY DEPTNO;


-- 컬럼값을 계산하는 산술 연산자(+, -, *, /)
SELECT ename, sal, sal * 12 "연간 급여", sal * 12 + comm " 총 연봉"
FROM EMP;

-- 연습문제 : 직책(job)을 중복 제거하고 출력하기
SELECT DISTINCT job FROM emp;


-- WHERE 구문 (조건문)
-- 데이터를 조회시 사용자가 원하는 조건에 맞는 데이터만 조회할 때 사용
SELECT * FROM EMP -- 먼저 테이블이 선택되고, WHERE절에서 행을 제한하고 출력할 열을 결정
WHERE DEPTNO = 10;

-- 사원번호가 7369인 사원의 모든 정보를 보여줘
SELECT * FROM emp
	WHERE EMPNO = 7369; -- 데이터베이스에서 비교 연산자는 =
	
-- 급여가 2500 초과인 사원번호, 이름, 직책, 급여 출력
-- 동작 순서 : emp테이블을 가져옴 > 급여가 2500 초과인 행 선택 > 사원번호 > 이름 > 직책 > 급여
SELECT empno, ename, job, sal
	FROM EMP
	WHERE sal > 2500;
	

-- WHERE절에 기본 연산자 사용
SELECT * FROM EMP -- e가 뜨는 이유는 별칭 때문에, JOIN을 걸 때 별칭을 넣어줘야 함
	WHERE sal * 12 = 36000;
	

-- WHERE절에 사용하는 비교 연산자 : >, >=, <, <=
-- 성과급이 500 초과인 사람의 모든 정보 출력
SELECT * FROM EMP
	WHERE comm > 500;
	
-- 입사일이 81년 1월 1일 이전인 사람의 모든 정보 출력
SELECT * FROM EMP
	WHERE HIREDATE < '81/01/01'; -- 데이터베이스 문자열 비교시 '', DATE 타입은 날짜의 형식에 맞으면 가능
	
	
-- 같지 않음을 표현하는 여러가지 방법 : <>, !=, ^=, NOT 컬럼명 =
SELECT * FROM EMP
	WHERE DEPTNO <> 30;
	
SELECT * FROM EMP
	WHERE DEPTNO != 30;

SELECT * FROM EMP
	WHERE DEPTNO ^= 30;

SELECT * FROM EMP
	WHERE NOT DEPTNO = 30;


-- 논리 연산자 : AND, OR, NOT
-- 급여가 3000 이상이고, 부서가 20번인 사원의 모든 정보 출력하기
SELECT * FROM EMP
	WHERE sal >= 3000 AND deptno = 20;

-- 급여가 3000 이상이거나, 부서가 20번인 사원의 모든 정보 출력하기
SELECT * FROM EMP
	WHERE sal >= 3000 OR deptno = 20;
	
-- 급여가 3000 이상이고, 부서가 20번이고, 입사일이 82년 1월 1일 이전인 사원의 모든 정보 출력하기
SELECT * FROM EMP
	WHERE sal >= 3000 AND deptno = 20 AND HIREDATE < '82/01/01';

-- 급여가 3000 이상이고, 부서가 20번이거나, 입사일이 82년 1월 1일 이전인 사원의 모든 정보 출력하기
SELECT * FROM EMP
	WHERE sal >= 3000 AND (deptno = 20 OR HIREDATE < '82/01/01');

-- 급여가 2500 이상이고 직책이 MANAGER인 사원의 모든 정보 출력
SELECT * FROM EMP
	WHERE sal >= 2500 AND job = 'MANAGER';
	

-- IN 연산자 : 여러 개의 열 이름을 조회할 경우 연속해서 나열할 수 있음
SELECT * FROM EMP
	WHERE job = 'MANAGER' OR job = 'SALESMAN' OR job = 'CLERK';
	
SELECT * FROM EMP
	WHERE job IN ('MANAGER', 'SALESMAN', 'CLERK');
	
-- IN 연산자를 사용해 20번과 30번 부서에 포함된 사원의 모든 정보 조회
SELECT * FROM EMP
	WHERE deptno IN (20, 30);
	
-- NOT IN 연산자를 사용해 20번과 30번 부서에 포함된 사원 조회
SELECT * FROM EMP
	WHERE deptno NOT IN (10);
	

-- 비교 연산자와 AND 연산자를 사용하여 출력하기
SELECT * FROM EMP
	WHERE job != 'MANAGER' AND job <> 'SALESMAN' AND job ^= 'CLERK';
	

-- BETWEEN A AND B 연산자 : 일정한 범위를 조회할 때 사용하는 연산자
-- 급여가 2000에서 3000 사이인 사원의 모든 정보를 출력
SELECT * FROM EMP
	WHERE sal >= 2000 AND sal <= 3000;
	
SELECT * FROM EMP
	WHERE sal BETWEEN 2000 AND 3000;
	
-- 사원번호가 7689에서 7902까지인 모든 사원의 모든 정보를 출력
SELECT * FROM EMP
	WHERE empno BETWEEN 7689 AND 7902;
	
-- 1980년이 아닌 해에 입사한 사원의 모든 정보를 출력
SELECT * FROM EMP
	WHERE NOT hiredate BETWEEN '80/01/01' AND '80/12/31';
	

-- LIKE, NOT LIKE 연산자 : 문자열을 검색할 때 사용하는 연산자
-- % : 길이와 상관 없이 모든 문자 데이터를 의미
-- _ : 문자 1개를 의미
SELECT empno, ename FROM EMP
	WHERE ename LIKE '%K%'; -- 앞과 뒤의 문자열 길이에 상관 없이 K라는 문자가 ename에 포함된 사원의 정보 출력
	
	
-- 사원의 이름의 두 번째 글자가 L인 사원만 출력하기
SELECT * FROM EMP
	WHERE ename LIKE '_L%';
	
-- [실습] 사원 이름에 AM이 포함되어 있는 사원 데이터만 출력
SELECT * FROM EMP
	WHERE ename LIKE '%AM%';

-- [실습] 사원 이름에 AM이 포함되어 있지 않은 사원 데이터만 출력
SELECT * FROM EMP
	WHERE ename NOT LIKE '%AM%';
	

-- 와일드 카드 문자가 데이터 일부일 경우(%, _) escape로 지정된 '\' 뒤에 오는 %는 와일드카드가 아니라는 의미
-- ESCAPE로 지정된 \ 뒤에 오는 %는 와일드 카드가 아니고 포함된 데이터로서 처리됨
SELECT * FROM EMP
	WHERE ename LIKE '%\%S' ESCAPE '\'; -- 이름이 %S로 끝나는 사원을 조회
	
-- DML
-- 출력을 위해 이름에 %S가 들어가는 사원을 임의로 추가해 줌
INSERT INTO EMP(empno, ename, job, mgr, hiredate, sal, comm, deptno)
	VALUES(1001, 'JAME%S', 'MANAGER', '7839', '24/10/15', 3500, 450, 30);

-- 출력을 위해 임시로 추가했던 JAME%S 데이터 지워주기
DELETE FROM EMP
	WHERE ename = 'JAME%S';


-- in null 연산자 : 데이터는 null 값을 가질 수 있음, 값이 정해지지 않음을 의미, 연산(계산, 비교, 할당 등) 불가
-- comm이 없는 사람은 아래 연산 수행시 null이 반환됨
SELECT ename, sal, sal * 12 + comm "연봉", comm
	FROM emp;

-- 비교 연산으로 null 비교하기
SELECT * FROM EMP
	WHERE COMM = NULL; -- NULL은 비교 불가이므로 결과가 나오지 않음
	
-- 해당 데이터가 null인지 확인하는 방법 : in null 연산자 사용
SELECT * FROM EMP
	WHERE COMM IS NULL;

-- null이 아닌 데이터만 출력하기
SELECT * FROM EMP
	WHERE comm IS NOT NULL;

-- 직속 상관이 있는 사원의 데이터만 출력하기
SELECT * FROM EMP
	WHERE MGR IS NOT NULL;


-- 정렬을 위한 ORDER BY 절 : 오름차순 또는 내림차순 정렬 가능
-- 급여에 대한 오름차순 정렬
SELECT * FROM EMP
	ORDER BY sal;
	
-- 급여에 대한 내림차순 정렬
SELECT * FROM EMP
	ORDER BY sal DESC;

-- 사원번호에 대한 내림차순 정렬
SELECT * FROM EMP
	ORDER BY empno DESC;

-- 정렬 조건으로 여러 컬럼을 설정하기
-- 급여에 대해 내림차순으로 정렬, 급여가 같으면 이름에 대해 사전순 정렬
SELECT * FROM EMP
	ORDER BY sal DESC, ename;
	
-- 별칭 사용과 ORDER BY
-- 따옴표 써야하는 경우 : 공백이 들어가는 경우, 아니면 생략 가능
-- 별칭 부여시 as 생략도 가능
-- ASC는 기본 오름차순, 생략 가능
-- 여기서 순서 1번은 FROM절(먼저 테이블을 가져옴), 2번은 WHERE절(조건으로 행 또는 튜플을 제한함), 3번은 SELECT절(별칭 지정), 4번은 ORDER BY절
-- SELECT절이 ORDER BY절보다 먼저 수행되기 때문에 별칭으로 정렬이 가능함
SELECT empno 사원번호, ename 사원명, sal 월급, hiredate 입사일
	FROM EMP
	WHERE sal >= 2000
	ORDER BY 월급 DESC, 사원명 ASC;


-- 연결 연산자 : SELECT문 조회시 컬럼 사이에 특정한 문자를 넣을 때 사용
SELECT ename || '의 직책은 ' || job "사원 정보"
	FROM EMP;


-- SELECT 실습문제

-- [실습문제 1] 이름이 S로 끝나는 사원 데이터를 모두 출력하기
SELECT *
	FROM EMP
	WHERE ename
	LIKE '%S';

-- [실습문제 2] 30번 부서에 근무하고 있는 사원 중 직책이 SALESMAN인 사원의 사원번호, 이름, 직책, 급여, 부서번호 출력하기
SELECT empno, ename, job, sal, deptno
	FROM EMP
	WHERE deptno = 30
	AND job = 'SALESMAN';

-- [실습문제 3] 20번과 30번 부서에 근무하고 있는 사원 중 급여가 2000 초과인 사원의 사원번호, 이름, 직책, 급여, 부서번호 출력하기
SELECT empno, ename, job, sal, deptno
	FROM EMP
	WHERE (deptno = 20 OR deptno = 30)
	AND sal > 2000;

-- [실습문제 4] 급여가 2000 이상 3000 이하 범위 이내의 값을 가진 사원의 모든 정보 출력하기
SELECT *
	FROM EMP
	WHERE sal
	BETWEEN 2000 AND 3000;

-- [실습문제 5] 사원 이름에 E가 포함되어 있는 30번 부서의 사원 중 급여가 1000 ~ 2000 사이가 아닌 사원의 이름, 사원번호, 급여, 부서번호 출력하기
SELECT ename, empno, sal, deptno
	FROM EMP
	WHERE (ename LIKE '%E%')
	AND (deptno = 30)
	AND (sal NOT BETWEEN 1000 AND 2000);

-- [실습문제 6] 추가 수당이 없고, 상급자가 있고, 직책이 MANAGER, CLERK인 사원 중 이름의 두 번째 글자가 L이 아닌 사원의 모든 정보 출력하기
SELECT *
	FROM EMP
	WHERE (comm IS NULL)
	AND (mgr IS NOT NULL)
	AND (job = 'MANAGER' OR job = 'CLERK')
	AND (ename NOT LIKE '_L%');
	

-- SELECT 연습문제

-- [연습문제 1] COMM의 값이 NULL이 아닌 정보 조회
SELECT * FROM EMP
	WHERE comm IS NOT NULL;

-- [연습문제 2] COMM을 받지 못하는 직원 조회
SELECT * FROM EMP
	WHERE COMM IS NULL;

-- [연습문제 3] 관리자가 없는 직원 정보 조회
SELECT * FROM EMP
	WHERE MGR IS NULL;

-- [연습문제 4] 급여를 많이 받는 직원 순으로 조회
SELECT * FROM EMP
	ORDER BY sal DESC;

-- [연습문제 5] 급여가 같을 경우 COMM 기준 내림차순 정렬 조회
SELECT * FROM EMP
	ORDER BY sal DESC, comm DESC;

-- [연습문제 6] 사원번호, 사원명, 직급, 입사일 조회 (입사일 기준 오름차순 정렬)
SELECT empno, ename, job, hiredate FROM EMP
	ORDER BY hiredate;

-- [연습문제 7] 사원번호, 사원명 조회 (사원번호 기준 내림차순 정렬)
SELECT empno, ename FROM EMP
	ORDER BY empno DESC;

-- [연습문제 8] 사원번호, 입사일, 사원명, 급여 조회 (부서번호가 빠른 순, 부서번호가 같은 경우 최근 입사일 순)
SELECT empno, hiredate, ename, sal FROM EMP
	ORDER BY deptno, hiredate DESC;

-- [연습문제 9] 오늘 날짜에 대한 정보 조회
-- 아직 안배움
SELECT SYSDATE
FROM DUAL;

-- [연습문제 10] 사원번호, 사원명, 급여 조회
SELECT empno, ename, sal FROM EMP;
	
-- [연습문제 11] 사원번호가 홀수인 사원 조회
-- 아직 안배움
SELECT *
FROM EMP
WHERE MOD(EMPNO, 2) = 1;

-- [연습문제 12] 사원명, 입사일 조회
SELECT ename, hiredate FROM EMP;

-- [연습문제 13] 9월에 입사한 직원 정보 조회
-- 아직 안배움
SELECT * 
FROM EMP
WHERE EXTRACT(MONTH FROM HIREDATE) = 9;

-- [연습문제 14] 81년도에 입사한 직원 조회
-- 아직 안배움
SELECT *
FROM EMP
WHERE EXTRACT(YEAR FROM HIREDATE) = 1981;

-- [연습문제 15] 이름이 'E'로 끝나는 직원 조회
SELECT * FROM EMP
	WHERE ename LIKE '%E';

-- [연습문제 16] 이름의 세 번째 글자가 'R'인 직원 정보 조회
SELECT * FROM EMP
	WHERE ename LIKE '__R%';

-- [연습문제 17] 사원번호, 사원명, 입사일, 입사일로부터 40년 되는 날짜 조회
-- 아직 안배움
SELECT EMPNO, ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 12*40)
FROM EMP;

-- [연습문제 18] 입사일로부터 38년 이상 근무한 직원의 정보 조회
-- 아직 안배움
SELECT *
FROM EMP
WHERE MONTHS_BETWEEN(SYSDATE, HIREDATE)/12 >= 38;

-- [연습문제 19] 오늘 날짜에서 연도만 추출
-- 아직 안배움
SELECT EXTRACT(YEAR FROM SYSDATE)
FROM DUAL;


