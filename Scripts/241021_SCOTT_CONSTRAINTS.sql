-- 제약 조건 : 데이터의 무결성(정확하고 일관된 값)을 보장하기 위해 테이블에 설정되는 규칙
-- NOT NULL : 지정한 열에 값이 있어야 함, NULL 허용하지 않음
-- UNIQUE : 지정한 열의 값이 유일해야 함, NULL 허용함
-- PRIMARY KEY(PK) : 지정한 열의 값이 유일해야 함, NULL 허용하지 않음
-- FOREIGN KEY(FK) : 다른 테이블의 열 참조, 존재하는 값만 입력 가능
-- CHECK : 설정한 조건식을 만족하는 데이터만 입력 가능 (정규식과 비슷함)

CREATE TABLE TABLE_NOTNULL (
	LOGIN_ID VARCHAR2(20) NOT NULL,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR2(20)
);
SELECT * FROM TABLE_NOTNULL;

-- 테이블에 데이터를 삽입하는 DML 명령어 INSERT 사용
-- 열을 명시하는 방법으로 사용 (명시하지 않고 사용도 가능)
-- LOGIN_ID 열과 LOGIN_PWD 열은 NOTNULL 특성을 넣었기 때문에 NULL값 입력 불가능 (SQL Error[1400] [23000] : ORA-01400 : cannot intsert NULL)
INSERT INTO TABLE_NOTNULL (LOGIN_ID, LOGIN_PWD, TEL)
	VALUES('PHAM', 'njsphn', NULL);
SELECT * FROM TABLE_NOTNULL;

-- 제약 조건이 지정된 열의 값 변경
-- NULL값이 아니면 변경 가능
UPDATE TABLE_NOTNULL
	SET LOGIN_PWD = 'TEST12345'
WHERE LOGIN_ID = 'PHAM'

-- 이미 만들어진 테이블에 제약 조건 지정하기
-- TEL값을 NOT NULL로 지정해주기 위해 미리 값을 넣어줌
UPDATE TABLE_NOTNULL
	SET tel = '010-1111-1111'
WHERE LOGIN_ID = 'PHAM';

-- 제약 조건이 없던 TEL 열에 NOT NULL 특성을 넣어줌
ALTER TABLE TABLE_NOTNULL
	MODIFY tel NOT NULL;
	

-- UNIQUE 제약 조건 : 중복 허용하지 앟는 특성
CREATE TABLE TABLE_UNIQUE (
	LOGIN_ID VARCHAR2(20) UNIQUE,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR2(20)
);
SELECT * FROM TABLE_UNIQUE;

INSERT INTO TABLE_UNIQUE (LOGIN_ID, LOGIN_PWD, TEL)
	VALUES('PHAM', 'njsphn', '010-1111-1111');
SELECT * FROM TABLE_UNIQUE;

-- LOGIN_ID는 UNIQUE 특성을 가져 중복 불가능
INSERT INTO TABLE_UNIQUE (LOGIN_ID, LOGIN_PWD, TEL)
	VALUES('PHAM', 'njsphn', '010-1111-1111');

-- 이름을 바꾸면 가능
INSERT INTO TABLE_UNIQUE (LOGIN_ID, LOGIN_PWD, TEL)
	VALUES('KIM', 'njsphn', '010-1111-1111');
SELECT * FROM TABLE_UNIQUE;

-- NULL 입력 가능
INSERT INTO TABLE_UNIQUE (LOGIN_ID, LOGIN_PWD, TEL)
	VALUES(NULL, 'njsphn', '010-2222-2222');
SELECT * FROM TABLE_UNIQUE;


-- 유일하게 하나만 있는 값(PRIMARY KEY) : UNIQUE, NOT NULL 제약 조건의 특성을 모두 가짐
-- PRIMARY KEY로 지정하면 해당 열에는 자동으로 인덱스가 만들어짐 > 검색 속도가 빨라짐
-- PRIMARY KEY로 지정하지 않아도 인덱스 지정 가능, 인덱스 여러개 지정 가능, 검색 속도는 빨라지지만 삽입/삭제는 느려짐

CREATE TABLE TABLE_PK (
	LOGIN_ID VARCHAR2(20) PRIMARY KEY,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR(20)
);
SELECT * FROM TABLE_PK;

-- 중복 불가능
INSERT INTO TABLE_PK VALUES('PHAM', 'njsphn', '010-1111-1111');

-- NULL 불가능
INSERT INTO TABLE_PK VALUES(NULL, 'njsphn', '010-1111-1111');
SELECT * FROM TABLE_PK;


-- 다른 테이블과 관계를 맺는 FOREIGN KEY
-- 서로 다른 테이블 간 관계를 정의하는 데 사용되는 제약 조건
-- 참조하고 있는 기본키의 데이터타입과 일치해야 하며, 외래키에 참조되고 있는 기본키는 삭제 불가능

CREATE TABLE DEPT_FK (
	deptno NUMBER(2) PRIMARY KEY,
	dname VARCHAR2(14),
	loc VARCHAR2(13)
);
SELECT * FROM DEPT_FK;

-- DEPT_FK에 있는 deptno를 참조키로 쓰겠다
CREATE TABLE EMP_FK (
	empno NUMBER(4) PRIMARY KEY,
	ename VARCHAR2(10),
	job VARCHAR2(9),
	mgr NUMBER(4),
	hiredate DATE,
	sal NUMBER(7, 2),
	comm NUMBER(7, 2),
	deptno NUMBER(2) REFERENCES DEPT_FK(deptno)
);
SELECT * FROM EMP_FK;

-- EMP_FK 테이블에 데이터 삽입
-- 현재 DEPT_FK 테이블이 비어 있음, 외래 키로 사용되는 deptno에 값이 없는 상태라 이대로는 deptno 10 값이 들어갈 수가 없음
INSERT INTO EMP_FK VALUES(2001, 'PHAM', 'NewJeans', '1001', '2024/09/01', 9000, 1000, 10);

-- DEPT_FK 테이블에 데이터 먼저 삽입하기
INSERT INTO DEPT_FK VALUES(10, 'IDOL', 'SEOUL');

-- EMP_FK 테이블에 데이터 다시 넣어보기
INSERT INTO EMP_FK VALUES(2001, 'PHAM', 'NewJeans', '1001', '2024/09/01', 9000, 1000, 10);
SELECT * FROM EMP_FK;

-- 삭제해보기
-- 현재 deptno가 FOREIGN KEY로서 EMP_FK 테이블에 참조되고 있어서 삭제 불가능
DELETE FROM DEPT_FK WHERE deptno = 10;

-- EMP_FK 테이블의 데이터 먼저 삭제해주기
DELETE FROM EMP_FK WHERE deptno = 10;

-- DEPT_FK 데이터 다시 삭제해보기 (가능)
DELETE FROM DEPT_FK WHERE deptno = 10;


-- 데이터의 형태와 범위를 정하는 CHECK
-- ID 및 PWD 등의 길이 제한, 유효 범위값 확인 등에 사용

CREATE TABLE TABLE_CHECK (
	LOGIN_ID VARCHAR2(20) PRIMARY KEY,
	LOGIN_PWD VARCHAR2(20) CHECK(LENGTH(LOGIN_PWD) > 6),
	TEL VARCHAR2(20)
);
SELECT * FROM TABLE_CHECK;

-- 제약 조건에 맞지 않아(PWD가 6보다 짧음) 입력 불가능
INSERT INTO TABLE_CHECK VALUES ('PHAM', 'njphn', '010-1111-1111');


-- 기본값을 정하는 DEFAULT
-- 특정 열에서 저장할 값을 지정하지 않는 경우 기본값 지정
CREATE TABLE TABLE_DEFAULT (
	LOGIN_ID VARCHAR2(20) PRIMARY KEY,
	LOGIN_PWD VARCHAR2(20) DEFAULT '1234567',
	TEL VARCHAR2(20)
);
SELECT * FROM TABLE_DEFAULT;

-- DEFAULT 특성 적용한 LOGIN_PWD 자리를 비워두면, DEFAULT로 설정한 1234567로 자동 설정
-- 비워두지 않고 NULL로 넣으면 NULL이라고 들어가므로 주의
INSERT INTO TABLE_DEFAULT(LOGIN_ID, TEL) VALUES ('PHAM', '010-1111-1111');
INSERT INTO TABLE_DEFAULT VALUES ('KIM', NULL, '010-2222-2222');
SELECT * FROM TABLE_DEFAULT;
