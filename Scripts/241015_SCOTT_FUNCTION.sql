-- 함수 : 오라클에서 함수는 특정한 결과 데이터를 얻기 위해 데이터를 입력할 수 있는 특수 명령어를 의미
-- 함수에는 내장 함수와 사용자 정의 함수가 있음
-- 내장 함수는 단일행 함수와 다중행 함수(집계함수)로 나누어짐
-- 단일행 함수 : 데이터가 한 행씩 입력되고 결과가 한 행씩 반환되는 함수
-- 다중행 함수 : 여러 행이 입력되어서 결과가 하나의 행으로 반환되는 함수

-- 숫자 함수 : 수학 계산식을 처리하기 위한 함수

-- DUAL은 간단한 범위 테이블 등을 출력하기 위한 가상의 테이블 (더미 테이블)
-- 두개의 컬럼을 출력
SELECT -10, abs(-10) FROM DUAL;

-- ROUND(숫자, 반올림할 위치) : 반올림한 결과를 반환하는 함수
-- 기본 ROUND는 소수점 첫째자리에서 반올림해 정수부의 값을 반환
SELECT ROUND(1234.5678) AS ROUND,
	ROUND(1234.5678, 0) AS ROUND_0,
	ROUND(1234.5678, 1) AS ROUND_1,
	ROUND(1234.5678, 2) AS ROUND_2,
	ROUND(1234.5678, -1) AS ROUND_MINUS1,
	ROUND(1234.5678, -2) AS ROUND_MINUS2
	FROM DUAL;
	
-- ABS : 절대값을 구하는 함수
SELECT ABS(-10) AS ABS_MINUS10, ABS(10) AS ABS_10 FROM DUAL;

-- TRUNC(숫자, 버림할 위치) : 버림을 한 결과를 반환하는 함수, 자릿수 지정 가능
SELECT TRUNC(1234.5678) AS TRUNC,
	TRUNC(1234.5678, 0) AS TRUNC_0,
	TRUNC(1234.5678, 1) AS TRUNC_1,
	TRUNC(1234.5678, 2) AS TRUNC_2,
	TRUNC(1234.5678, -1) AS TRUNC_MINUS1,
	TRUNC(1234.5678, -2) AS TRUNC_MINUS2
	FROM DUAL;
	
-- MOD(대상 수, 나눌 수) : 나누기한 후 나머지를 반환하는 함수
SELECT MOD(21, 5) FROM DUAL;

-- CEIL : 소수점 이하를 올림
SELECT CEIL(12.345) FROM DUAL;

-- FLOOR : 소수점 이하를 날림
SELECT FLOOR(12.999) FROM DUAL;

-- POWER : 제곱하는 함수
-- POWER(3, 4) = 3^4
SELECT POWER(3, 4) FROM DUAL;

-- DUAL : SYS 계정에서 제공하는 테이블, 테이블 참조 없이 실행해보기 위해 FROM절에 사용하는 더미 테이블
SELECT 20*30 FROM DUAL;


-- 문자 함수 : 문자 데이터로부터 특정 결과를 얻고자 할 때 사용하는 함수
SELECT ename, UPPER(ename), LOWER(ename), INITCAP(ename)
	FROM EMP;
	
-- UPPER 함수로 문자열 비교하기
SELECT * FROM EMP
	WHERE UPPER(ename) LIKE UPPER('%james%');
	
-- 문자열 길이를 구하는 LENGTH 함수, LENGTHB 함수
-- LENGTH : 문자열의 길이를 반환
-- LENGTHB : 문자열의 바이트를 반환
-- 영어는 1Byte, 길이와 바이트수가 동일함
SELECT LENGTH(ename), LENGTHB(ename)
	FROM EMP;
	
-- '팜하니'는 없는 값이니까 듀얼(더미)로 출력
-- 오라클 XE 버전에서 한글은 3Byte
SELECT LENGTH('팜하니'), LENGTHB('팜하니')
	FROM DUAL;
	
-- [실습] 직책 이름의 길이가 6글자 이상아고, COMM 있는 사원의 모든 정보 출력
SELECT * FROM EMP
	WHERE LENGTH(job) >= 6 AND comm IS NOT NULL AND comm != 0;
	
-- SUBSTR / SUBSTRB : 시작 위치로부터 선택 개수만큼의 문자를 반환하는 함수, 인덱스는 1부터 시작 (파이썬의 슬라이싱, 자바의 SUBSTR)
-- 추출 길이가 없으면 끝까지 추출
SELECT job, SUBSTR(job, 1, 2), SUBSTR(job, 3, 2), SUBSTR(job, 5)
	FROM EMP;
	
--SUBSTR 함수와 다른 함수 함께 사용하기
--마이너스 LENGTH(-LENGTH)는 뒤에서부터 카운트 (파이썬과 동일)
--(-LENGTH(job) = -5) = 1, SUBSTR(job, -LENGTH(job)) = SUBSTR(job, 1)
SELECT job,
	SUBSTR(job, -LENGTH(job)),
	SUBSTR(job, -LENGTH(job), 2),
	SUBSTR(job, -3)
	FROM EMP;
	

-- INSTR : 문자열 데이터 안에 특정 문자나 문자열이 어디에 포함되어 있는지를 알고자 할 때 사용
-- INSTR(대상 문자열, 위치를 찾으려는 부분 문자, 시작 위치(선택), N번째로 나타나는 위치(선택))
-- 시작 위치가 바뀌어도 인덱스 숫자는 동일함
-- 특정 구간을 건너뛰고 해당 위치를 찾고싶을 때 등에 시작 위치 사용
SELECT INSTR('HELLO, ORACLE', 'L') AS INSTR_1,
	INSTR('HELLO, ORACLE', 'L', 5) AS INSTR_2,
	INSTR('HELLO, ORACLE', 'L', 2, 2) AS INSTR_3
	FROM DUAL;
	
-- 특정 문자가 포함된 행 찾기
-- INSTR(name, 'S') S가 있으면 무조건 0보다 큼(인덱스는 1부터 시작), 따라서 S라는 문자가 포함된 행을 출력하게 됨
SELECT * FROM EMP
	WHERE INSTR(ename, 'S') > 0;
	
-- REPLACE : 특정 문자열 데이터에 포함된 문자를 다른 문자로 대체할 때 사용
-- 대체할 문자를 지정하지 않으면 찾는 문자가 삭제됨
SELECT '010-1234-5678' AS "변경전",
	REPLACE('010-1234-5678', '-', ' ') AS "변경1",
	REPLACE('010-1234-5678', '-') AS "변경2"
	FROM DUAL;
	
-- LPAD / RPAD : 기준 공간 칸수를 지정하고 빈칸만큼을 특정 문자로 채우는 함수
SELECT LPAD('ORACLE', 10, '+'), RPAD('ORACLE', 10, '+'), FROM DUAL;

SELECT RPAD('901111-', 14, '*') AS RPAD_JUMIN,
	RPAD('010-2222-', 13, '*') AS RPAD_PHONE
	FROM DUAL;
	
-- 두 문자열을 합치는 CONCAT 함수
SELECT CONCAT(empno, ename) AS 사원정보,
	CONCAT(empno, CONCAT(' : ', ename)) AS "사원정보 : "
	FROM EMP
	WHERE ename = 'JAMES';
	
-- TRIM / LTRIM / RTRIM : 문자열 데이터 내에서 특정 문자를 지우기 위해 사용, 문자를 지정하지 않으면 공백 제거
-- || 문자열을 이어붙이는 연산자
SELECT '[' || TRIM('    _ORACLE_    ') || ']' AS "TRIM_공백제거",
	'[' || LTRIM('    _ORACLE_    ') || ']' AS "LTRIM_공백제거",
	'[' || RTRIM('    _ORACLE_    ') || ']' AS "RTRIM_공백제거",
	'[' || LTRIM('<    _ORACLE_    >', '<') || ']' AS "LTRIM_<제거",
	'[' || RTRIM('<    _ORACLE_    >', '>') || ']' AS "RTRIM_>제거"
	FROM DUAL;
	

-- 날짜 데이터를 다루는 함수
-- 날짜 데이터 + 숫자 : 가능, 날짜에서 숫자만큼 이후 날짜
-- 날짜 데이터 - 숫자 : 가능, 날짜에서 숫자만큼 이전 날짜
-- 날짜 데이터 - 날짜 데이터 : 가능, 두 날짜간의 일수 차이
-- 날짜 데이터 + 날짜 데이터 : 연산 불가
-- SYSDATE : 운영체제로부터 시간을 가져오는 함수
SELECT SYSDATE FROM DUAL;

SELECT SYSDATE AS "현재시간",
	SYSDATE + 1 AS "내일",
	SYSDATE - 1 AS "어제"
	FROM DUAL;
	
-- 몇 개월 이후 날짜를 구하는 ADD_MONTHS 함수 : 특정 날짜에 지정한 개월수 이후의 날짜 데이터를 반환
-- ADD_MONTHS(날짜 데이터, 더할 개월 수)
SELECT SYSDATE AS "오늘 날짜",
	ADD_MONTHS(SYSDATE, 3) AS "3개월 이후 날짜"
	FROM DUAL;
	
-- [실습] 입사 10주년이 되는 사원들 데이터 출력하기
-- 입사일로부터 10년이 경과한 날짜 데이터 반환
SELECT empno, ename, hiredate AS "입사일",
	ADD_MONTHS(hiredate, 120) AS "10주년"
	FROM EMP;

-- 두 날짜 간의 개월수 차이를 구하는 MONTHS_BETWEEN 함수
-- MONTHS_BETWEEN(날짜데이터1, 날짜데이터2)
-- 날짜데이터1에서 날짜데이터2를 빼줌
-- TRUNC로 월 이하 소수점은 버림
SELECT empno, ename, hiredate, SYSDATE,
	MONTHS_BETWEEN(hiredate, SYSDATE) AS "MINUS 재직기간",
	MONTHS_BETWEEN(SYSDATE, hiredate) AS "재직기간",
	TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) AS "재직기간 정수변환"
	FROM EMP;

-- 돌아오는 요일을 구하는 NEXT_DAY, 달의 마지막 날짜를 구하는 LAST_DAY 함수
-- NEXT_DAY(날짜 데이터, 요일 문자)
-- LAST_DAY(날짜 데이터)
SELECT SYSDATE,
	NEXT_DAY(SYSDATE, '월요일') AS "돌아오는 월요일",
	LAST_DAY(SYSDATE) AS "10월의 마지막 날"
	FROM DUAL;
	
SELECT LAST_DAY('24/8/28') FROM DUAL;

-- 날짜 정보 추출 함수 : EXTRACT
SELECT EXTRACT(YEAR FROM DATE '2024-10-16')
	FROM DUAL;
	
SELECT * FROM EMP
	WHERE EXTRACT(MONTH FROM hiredate) = 12; -- 12월에 입사한 사람만 출력
	
	
-- 자료형을 변환하는 형 변환 함수
SELECT empno, ename, empno + '500' -- 오라클의 기본 형변환 가능, 숫자로 변환
	FROM EMP
	WHERE ename = 'FORD';
	
-- 날짜, 숫자를 문자로 변환하는 TO_CHAR 함수 : 자바의 SimpleDateFormat과 유사
SELECT SYSDATE AS "기본시간형태",
	TO_CHAR(SYSDATE, 'YYYY/MM/DD') AS "변형시간형태"
	FROM DUAL;
	
-- 다양한 형식으로 출력하기
SELECT SYSDATE,
    TO_CHAR(SYSDATE, 'CC') AS 세기,
    TO_CHAR(SYSDATE, 'YY') AS 연도,
    TO_CHAR(SYSDATE, 'YYYY/MM/DD PM HH:MI:SS ') AS "년/월/일 시:분:초",
    TO_CHAR(SYSDATE, 'Q') AS 쿼터,
    TO_CHAR(SYSDATE, 'DD') AS 일,
    TO_CHAR(SYSDATE, 'DDD') AS 경과일,
    TO_CHAR(SYSDATE, 'HH') AS "12시간제",
    TO_CHAR(SYSDATE, 'HH12') AS "12시간제",
    TO_CHAR(SYSDATE, 'HH24') AS "24시간제",
    TO_CHAR(SYSDATE, 'W') AS 몇주차
FROM DUAL;

-- 특정 언어에 맞춰서 날짜 출력하기
SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'MM') AS MM,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MON_KOR,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = JAPANESE') AS MON_JPN,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MON_ENG,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MONTH_KOR,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = JAPANESE') AS MONTH_JPN,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MONTH_ENG
FROM DUAL;

-- 특정 언어에 맞춰서 요일 출력하기
SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'MM') AS MM,
     TO_CHAR(SYSDATE, 'DD') AS DD,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = KOREAN' ) AS DY_KOR,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = JAPANESE') AS DY_JPN,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS DY_ENG,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = KOREAN' ) AS DAY_KOR,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = JAPANESE') AS DAY_JPN,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS DAY_ENG
FROM DUAL;


-- 숫자 데이터 형식을 지정하여 출력하기
-- 9는 순자의 한 자리를 의미하고 빈자리를 채우지 않음
-- 0은 빈자리를 0으로 채움
-- $는 $ 표시를 붙여서 출력
-- L은 지역 화폐 단위 기호를 붙여서 출력
-- .은 소수점 표시
-- ,는 천단위 구분 기호 표시
SELECT sal,
	TO_CHAR(sal, '$999,999') AS sal_$,
	TO_CHAR(sal, '000,999,999.00') AS sal_90,
	TO_CHAR(sal, '999,999.00') AS sal_0,
	TO_CHAR(sal, 'L999,999') AS sal_L
	FROM EMP;

-- TO_NUMBER : 숫자 타입의 문자열을 숫자 데이터 타입으로 변환해주는 함수
-- 출력 결과는 변하지 않고 데이터 타입만 변환
-- 자동 형 변환이 잘 되어 있어서 많이 사용하지는 않음
SELECT 1300 - '1500' AS "기본빼기",
	'1300' + 1500 AS "기본더하기",
	TO_NUMBER('1300') - TO_NUMBER('1500') AS "TO_NUMBER 빼기",
	TO_NUMBER('1300') + TO_NUMBER('1500') AS "TO_NUMBER 더하기"
	FROM DUAL;
	
-- TO_DATE : 문자열로 명시된 날짜로 반환하는 함수
SELECT TO_DATE('24-10-24', 'YY/MM/DD') AS "날짜타입1",
	TO_DATE('20240714', 'YYYY/MM/DD') AS "날짜타입2"
	FROM DUAL;

-- 1981년 7월 1일 이후 입사한 사원 정보 출력하기
-- 뒤에 'YYYY/MM/DD' 등 비교 날짜의 타입과 같은 형식으로 반환하여 비교해야 하지만 생략해도 자동으로 변환 및 비교됨
SELECT *
	FROM EMP
	WHERE hiredate > TO_DATE('1981/07/01', 'YYYY/MM/DD');


-- NULL 처리 함수 : 특정 열의 행에 데이터가 없는 경우 데이터값이 NULL이 됨(NULL = 값이 없음, 값이 지정되지 않음)
-- NULL의 특징 : 할당되지 않았거나 알려져 있지 않아 적용이 불가능한 값, 0이나 공백과는 다른 의미, NULL값을 포함하는 산술 연산의 결과는 NULL (연산 불가)
-- NVL(NULL 여부를 검사할 데이터 또는 열, 앞의 데이터가 NULL인 경우 대체하여 반환할 데이터)
SELECT empno, ename, sal, comm, sal + comm,
	NVL(comm, 0),
	sal + NVL(comm, 0),
	sal * 12 + NVL(comm, 0) AS 연봉
	FROM EMP;
	
-- NVL2(NULL 여부를 검사할 데이터 또는 열, 앞의 데이터가 NULL이 아닌 경우 대체하여 반환할 데이터, 앞의 데이터가 NULL인 경우 대체하여 반환할 데이터)
-- 성과급 열 : comm 열을 검사하여 NULL이 아니면(comm값이 있으면) O, NULL이면(comm값이 없으면) X 반환
-- 연봉 열 : comm값을 검사하여 NULL이 아니면(comm값이 있으면) 월급*12+성과급 반환, NULL이면(comm값이 없으면) 월급*12 반환
SELECT empno, ename, comm,
	NVL2(comm, 'O', 'X') AS 성과급,
	NVL2(comm, sal * 12 + comm, sal * 12) AS 연봉
	FROM EMP;
	
-- NULLIF : 두 값을 비교하여 동일하면 NULL, 동일하지 않으면 첫 번째 값을 반환
SELECT NULLIF (10, 10),
	NULLIF ('A', 'B')
	FROM DUAL;
	

-- DECODE : 주어진 데이터 값이 조건 값과 일치하는 값을 출력하고 일치하는 값이 없으면 기본값 출력
SELECT empno, ename, job, sal,
	DECODE(job,
	'MANAGER', sal * 1.1,
	'SALESMAN', sal * 1.05,
	'ANALYST', sal,
	SAL * 1.03) AS "DECODE 연봉인상"
	FROM EMP;
	
-- CASE : SQL의 표준 함수, 일반적으로 SELECT절에서 많이 사용됨
SELECT empno, ename, job, sal,
	CASE job
		WHEN 'MANAGE' THEN sal * 1.1
		WHEN 'SALESMAN' THEN sal * 1.05
		WHEN 'ANALYST' THEN sal
		ELSE sal * 1.03
	END	AS "CASE 연봉인상"
	FROM EMP;
	
-- 열 값에 따라서 출력이 달라지는 CASE문 : 기준 데이터를 지정하지 않고 사용하는 방법
-- 값이 찍혀야 하는 곳은 작은따옴표로 입력
SELECT empno, ename, comm,
	CASE
		WHEN comm IS NULL THEN '해당사항 없음'
		WHEN comm = 0 THEN '성과급 없음'
		WHEN comm > 0 THEN '성과급 : ' || comm
	END AS "성과급 정보"
	FROM EMP;


-- 실습문제 1) 사번, 사원명, 급여 조회 (단, 급여는 100단위까지의 값만 출력 처리하고 급여 기준 내림차순 정렬)
SELECT empno, ename, TRUNC(sal, -2)
	FROM EMP
	ORDER BY sal DESC;

-- 실습문제 2) 9월에 입사한 직원의 정보 조회
SELECT *
	FROM EMP
	WHERE EXTRACT(MONTH FROM hiredate) = 9;
	
-- 실습문제 3) 사번, 사원명, 입사일, 입사일로부터 40년 되는 날짜 조회
SELECT empno, ename, hiredate, ADD_MONTHS(hiredate, 12 * 40) AS "입사 40주년"
	FROM EMP;

-- 실습문제 4) 입사일로부터 38년 이상 근무한 직원의 정보 조회
SELECT *
	FROM EMP
	WHERE MONTHS_BETWEEN(SYSDATE, hiredate) / 12 >= 38;

-- 실습문제 5) EMPNO 열에 이름이 다섯글자 이상 여섯글자 미만인 사원 정보 출력,
-- MASKING_EMPNO 열에 사원 번호 앞 두자리와 뒷자리는 * 기호로 출력,
-- MASKING_ENAME 열에는 사원 이름의 첫 글자만 보여 주고 나머지 글자수만큼 * 기호로 출력
SELECT empno, RPAD(SUBSTR(empno, 1, 2), 4, '*') AS "MASKING_EMPNO", ename, RPAD(SUBSTR(ename, 1, 1), 5, '*') AS MASKING_ENAME
	FROM EMP
	WHERE LENGTH(ename) BETWEEN 5 AND 6;

-- 실습문제 6) 사원들의 월 평균 근무일 수는 21.5일, 하루 근무 시간을 8시간으로 봤을 때 사원들의 하루 급여(DAY_PAY)와 시급(TIME_PAY)를 계산하여 결과 출력
-- (단, 하루 급여는 소수점 세 번째 자리에서 버리고, 시급은 두 번째에서 반올림)
SELECT sal, TRUNC(sal/21.5, 2) AS "DAY_PAY", ROUND(sal/21.5/8, 1) AS "TIME_PAY"
	FROM EMP;
	

-- 실습문제 7) 입사일 기준으로 3개월이 지난 후 첫 월요일에 정규직 전환, 각 사원이 정직원이 되는 날짜(R_JOB)를 YYYY-MM-DD 형식으로 출력
-- (단, 추가 수당이 없는 사원의 추가 수당은 N/A로 출력)
SELECT hiredate, TO_CHAR(NEXT_DAY(ADD_MONTHS(hiredate, 3), '월요일'), 'YYYY-MM-DD') AS "R_JOB", NVL(TO_CHAR(comm), 'N/A') AS "COMM"
	FROM EMP;

	
-- 실습문제 8) 모든 사원을 대상으로 직속 상관의 사원 번호를 다음과 같은 조건 기준으로 변환해서 CHG_MGR 열에 출력
-- 실습문제 8 - 조건 1) 직속 상관의 사원번호가 존재하지 않을 경우 : 0000
-- 실습문제 8 - 조건 2) 직속 상관의 사원번호 앞 두자리가 75일 경우 : 5555
-- 실습문제 8 - 조건 3) 직속 상관의 사원번호 앞 두자리가 76일 경우 : 6666
-- 실습문제 8 - 조건 4) 직속 상관의 사원번호 앞 두자리가 77일 경우 : 7777
-- 실습문제 8 - 조건 5) 직속 상관의 사원번호 앞 두자리가 78일 경우 : 8888
-- 실습문제 8 - 조건 6) 그 외 직속 상 사원번호인 경우 : 본래 직속 상관의 사원번호 그대로 출력
SELECT empno, ename, mgr,
	CASE 
		WHEN mgr IS NULL THEN '0000'
		WHEN SUBSTR(TO_CHAR(mgr), 1, 2) = '75' THEN '5555'
		WHEN SUBSTR(TO_CHAR(mgr), 1, 2) = '76' THEN '6666'
		WHEN SUBSTR(TO_CHAR(mgr), 1, 2) = '77' THEN '7777'
		WHEN SUBSTR(TO_CHAR(mgr), 1, 2) = '78' THEN '8888'
		ELSE TO_CHAR(mgr)
	END AS "CHG_MGR"
	FROM EMP;
		