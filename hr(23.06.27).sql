/* 수업전 컬럼확인용 */
select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;
DESC salgrade;
/*23/06/27*/
/*인덱스
  - 인덱스는 SQL 명령문의 처리 속도를 향상시키기 위해 칼럼에 대해 생성하는 객체
  - WHERE 절이나 조인 조건절에서 자주 사용되는 칼럼  */
/*고유 인덱스(unique index)
  - 고유인덱스는 유일한 값을 가지는 칼럼에 대해 생성하는 인덱스로 모든 인덱스 키는 테이블의 하나의 행과 연결
  사용예 : 부서테이블에서 name 칼럼을 고유인덱스로 생성하여라. 단, 고유인덱스의 이름을 idx_dept_name으로 정의한다*/
CREATE UNIQUE INDEX idx_dept_name
ON department(dname);
/*비고유 인덱스(non unique index)
  - 비고유 인덱스는 중복된 값을 가지는 카럼에 대해 생성하는 인덱스로 하나의 인덱스 키는 테이블의 여러행과 연결될 수 있다.
  사용예: 학생테이블의 birthdate 칼럼을 비고유 인덱스로 생성하라 비고유 인덱스의 이름은 idx_stud_birthdate로 전의한다*/
CREATE INDEX idx_stud_birthdate
ON student(birthdate);
/*단일 인덱스 : 단일인덱스는 하나의 칼럼으로만 구성된 인덱스이다.
  결합 인덱스 : 결합인덱스는 두개 이상의 칼럼을 결합하여 생성하는 인덱스이다.
  사용예 : 학생테이블의 deptno, grade 칼럼을 결합 인덱스로 생성하여라
  결합 힌덱스의 이름은 idx_stud_dno_grade로 정의한다*/
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);
/*DESCENDING INDEX : 칼럼별로 정렬순서를 별도로 지정하여 결합 인덱스를 생성하기 위한 방법이다.
  사용예 : 학생테이블의 deptn와 name 칼럼으로 결합 인덱스를 생성하여라 단, deptno 칼럼을 내림차순으로 name 칼럼은 오름차순으로 생성하여라*/
CREATE INDEX fidx_stud_no_name ON student(deptno DESC, name ASC);
/*함수기반 인덱스(function based index)
 사용예*/
CREATE INDEX uppercase_idx ON emp (UPPER(ename));
SELECT * FROM emp WHERE UPPER(ename) = 'KING';
/*함수기반 인덱스(FBI)
 사용예: 학생테이블에서 학생들의 비만도 측정을 위해 표준체중을 구하고자한다 표준체중에 대한 함수기반 인덱스를 생성하라*/
CREATE INDEX idx_standard_weight ON student((height-100)*0.9);

/*인덱스 실행경로 확인
  사용예 : 학과테이블에서 학과 이름이 '정보미디어학부'인 학과번호를 검색한 결과에 대한
          실행결로를 분석하여라. dname 컬럼에 고유인덱스가 생성되어 있다. */
SELECT deptno, dname
FROM department
WHERE dname = '정보미디어학부'; /*F10 누르면 경로확인 가능*/

DROP INDEX IDX_DEPT_NAME; /*인덱스 삭제*/

/*실행경로 사용예 : 학생테이블에서 생일이 '79/04/02'인 학생 이름을 검색한 결과에 대한 실행경로를 분석하여라*/
SELECT name, birthdate
FROM student
WHERE birthdate = '79/04/02';

DROP INDEX idx_stud_birthdate;

/*인덱스 정보 조회
 - USER_INDEXES : 인덱스 이름과 유일성 여부 등을 확인
  사용예 : 학생테이블에 생성된 인덱스를 조회하여라 */
SELECT index_name, uniqueness
FROM user_indexes
WHERE table_name = 'STUDENT';
/*인덱스 삭제 
  - DROP INDEX문 사용*/

/*인덱스 재구성
  - 인덱스 재구성은 인덱스를 정의한 테이블의 칼럼값에 대해 변경 작업이 자주 발생하여,
    불필요하게 생성된 인데스 내부 노드를 정리하는 작업*/
    
/*뷰(view)
  - 하나 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블
  - 전체의 데이터중에서 일부만 접근할 수 있도록 제한*/
/*단순 뷰(simple view)
  - 하나의 기본 테이블에 의해 정의한 뷰
  - 단순 뷰에 DML명령문의 실행 결과 기본 테이블에 반영
  복합 뷰(comples view)
  - 두개 이상의 기본 테이블로 구성한 뷰
  - 무결성 제약조건, 표현식*/

/*뷰 생성
  - CREATE VIEW 명령문 사용
  
  사용예 : 학생 테이블에서 101번 학과 학생들의 학번, 이름, 학과 번호로 정의되는 단순 뷰를 생성하라*/
CREATE VIEW v_stud_dept101 as
SELECT studno, name, deptno
FROM student
WHERE deptno = 101;

SELECT * FROM v_stud_dept101;
/*복합뷰 생성예 : 학생테이블과 부서테이블을 조인하여 102번 학과 학생들의 학번,이름,학년,학과이름으로 정의되는 복합 뷰를 생성하라 */
CREATE VIEW v_stud_dept102 AS
SELECT s.studno, s.name, s.grade, d.dname
FROM student s, department d
WHERE s.deptno = d.deptno 
AND s.deptno = 102;

SELECT * FROM v_stud_dept102;
/*함수 사용 뷰생성예 : 교수테이블에서 학과별 평균급여와 총계로 정의되는 뷰를 생성하여라*/
CREATE VIEW v_prof_avg_sal AS
SELECT deptno, sum(sal) sum_sal, avg(sal) avg_sal /*함수사용시 꼭 컬럼별명을 사용해야 오류가 발생하지 않는다*/
FROM professor
GROUP BY deptno;

SELECT * FROM v_prof_avg_sal;
/*인라인 뷰(inline view)
  - FROM 절에서 참조하는 테이블의 크기가 클 경우, 필요한 행과 컬럼만으로 구성된 집합을 재정의하여 질의문을 효율적 구정
  - FROM 절에서 서브쿼리를 사용하여 생성한 임시 뷰
  사용예 : 인라인뷰를 사용하여 학과별로 학생들의 평균 키와 몸무게, 학과이름을 출력하라*/
SELECT dname, avg_height, avg_weight
FROM(SELECT deptno, avg(height) avg_height, avg(weight) avg_weight
     FROM student
     GROUP BY deptno) s, department d
WHERE s.deptno = d.deptno;
/*문제: 학과별 최대키를 구하고 최대키를 가진 학생의 학과명, 최대키, 이름, 키를 출력하세요*/
SELECT dname, max_height, s.name, s.height
FROM(SELECT deptno, max(height) max_height
     FROM student
     GROUP BY deptno) a, student s, department d
WHERE s.deptno = a.deptno
AND s.height = a.max_height
AND s.deptno = d.deptno;

/*뷰의 내부처리과정*/
/*뷰조회
  USER_VIEWS
  - 사용자가 생성한 모든뷰에 대한 정의를 저장*/
SELECT view_name, text
FROM user_views;
/*뷰의 변경
  - 뷰의 변경은 기존뷰에 대한 정의를 삭제한 후 재생성
  - CREATE 명령문에서 OR REPLACE 옵션을 이용하여 재생성*/
/*뷰에 대한 데이터 조작
 단순뷰
  - 단순 뷰는 기본 테이블과 동일하게 DML 명령문 사용
 복합뷰
  - DML명령어 사용 제한*/  
/*뷰의 삭제*/
DROP VIEW v_stud_dept101;

/*사용자 권한 제어*/
/*데이터베이스 보안
  다중 사용자 환경(multi-user environment)
   - 불법적인 접근 및 유출 방지를 위해 보안 대책 필요
  중앙 집중적인 데이터 관리
   - 분산적으로 관리되는 기존의 파일 시스템보다 보안이 취약할 수 있으므로 철저한 보안 대책 필요*/
/*권한(Privilege)
  - 권한은 사용자가 데이터베이스 시스템을 관리하거나 객체를 이용할 수 있는 권리
  권한의 종류
  1. 시스템 권한
  2. 객체 권한*/
/*시스템 권한 부여
conn system/manager
grant query rewrite to scott;*/
/*현재 세션에 부여된 시스템 권한 조회
 SESSION_PRIVS
  - 현재 세션에서 사용자와 롤에 부여된 시스템 권한을 조회 가능*/
SELECT * FROM session_privs;
/*시스템 권한 철회 (REVOKE 명령문 사용)
사용예 : REVOKE query rewrite FROM scott;*/

/*객체 권한 부여
  - 데이터베이스 관리자나 객체 소유자가 사용자와 롤에게 부여
  - GRANT 명령문을 사용해 권한 부여*/

/*문제*/
conn system/manager
CREATE tablespace encore
datafile 'C:\oraclexe\app\oracle\oradata\XE\encore.dbf' size 100m;
CREATE USER encore IDENTIFIED BY encore123
DEFAULT TABLESPACE encore
TEMPORARY TABLESPACE temp;
GRANT connect, resource to encore;
conn hr/hr
GRANT SELECT ON hr.student TO encore;
conn encore/encore123
select*from hr.student;
/*롤(role)
  - 다수 사용자와 다양한 권한을 효과적으로 관리하기 위하여 서로 관련된 권한을 그룹화한 개념
  롤 종류
   - CONNECT : 사용자가 데이터베이스에 접속하여 세션을 생성할 수 있는 권한 테이블 또는 뷰와 같은 객체를 생성할 수 있는 권한
   - RESOURCE : 사용자에게 자신의 테이블, 시퀀스, 프로시져, 트리거 객체 생성할 수 있는 권한
   - DBA : 시스템 자원의 무제한적인 사용이나 시스템 관리에 필요한 모든 권한 
  롤 생성
   - CREATE ROLE 명령문으로 생성
   - 롤에 암호부여 가능
   - 롤 이름은 사용자나 다른 롤과 중복될 수 없음
사용예 : 암호를 지정한 롤과 지정하지 않은 롤을 생성하라*/
CONN system/manager
CREATE ROLE hr_clerk;
CREATE ROLE hr_mgr
IDENTIFIED BY manager;
/*롤에 권한 또는 롤 부여
  - 롤에 시스템 권한이나 객체 권한 또는 다른 롤을 부여 가능
  - GRANT 명령문 사용*/
/*롤에 시스템 권한부여 : DBA 또는 GRANT ANY PRIVILEGE 구너한을 가진 사용자는 롤에 시스템 권한을 부여가능
  롤에 객체 권한 부여 : 사용자가 롤에 객체를 부여할 수 있는 경우*/
/*롤부여
  - 롤은 사용자 또는 다른 롤에게 롤 부여
  - WITH ADMIN OPTION*/  
/*롤 조회
  - role_sys_privs : 롤에 부여한 시스템 권한 조회
  - user_role_privs : 사용자가 부여받은 롤 조회*/  
  
/*동의어 : 하나의 객체에 대해 다른 이름을 정의하는 방법
 전용동의어
   - 객체에 대한 접근 권한을 부여 받은 사용자가 정의한 동의어로 해당 사용자만 사용
 공용동의어
   - 권한을 주는 사용자가 정의한 동의어로 누구나 사용
   - DBA 권한을 가진 사용자만 생성*/

/*계층적 질의문
  - 관계형 데이터베이스에서 데이터간의 부모 관계를 표현할 수 있는 칼럼을 지정하여 계층적인 관계를 표현
  사용법
   - SELECT 명령문에서 START WITH와 CONNECT BY 절을 이용
   - 계층적 질의문에서는 계층적인 출력 형식과 시작 위치 제어*/
   
/*top-down 사용예 : 계층적 질의문을 사용하여 부서테이블에서 학과,학부,단과대착을 검색하여
단대,학부,학과순으로 top-down 형식의 계층 구조로 출력 단, 시작데이터는 10번부터*/
SELECT deptno, dname, college
FROM department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college;
/*bottom-up 사용예 : 계층적 질의문을 사용하여 부서테이블에서 학과,학부,단과대착을 검색하여
단대,학부,학과순으로 bottom-up 형식의 계층구조로 출력, 단 시작데이터는 102번 부터*/
SELECT deptno, dname, college
FROM department
START WITH deptno = 102
CONNECT BY PRIOR college = deptno;
/*레벨별 구분 사용예 : 계층적 질의문을 사용하여 부서테이블에서 학과,학부,단과대착을 검색하여
  단대,학부,학과순으로 top-down 형식의 계층 구조로 출력 단, 시작데이터는 10번부터*/
SELECT LEVEL, LPAD(' ', (LEVEL-1)*2) || dname 조직도
FROM department
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;

/*계층구조에서 가지제거 방법*/
/*가지제거 사용예 : 부서테이블에서 dname칼럼을 단대,학부,학과순으로 top-down 형식의 계층 구조로 출력 단, '정보미디어학부'를 제외하고 출력*/
SELECT deptno, college, dname, loc
FROM department
WHERE dname != '정보미디어학부'
START WITH college is null
CONNECT BY PRIOR deptno = college;

/*CONNECT_BY_ISLEAF 사용예 : 계층적 질의문을 사용하여 LEVEL 1인 최상위로우의 정보를 얻어올 수 있다*/
SELECT LPAD(' ', 4*(LEVEL-1)) || ename 사원명
    , empno 사번
    , CONNECT_BY_ISLEAF leaf_YN
    , LEVEL
FROM emp
START WITH job = UPPER('President')
CONNECT BY NOCYCLE PRIOR empno = mgr;

/*SYS_CONNECT_BY_PATH 사용예 : 계층적 질의문을 사용하여 현재 ROW까지의 PATH 정보를 쉽게 얻어올 수 있다*/
SELECT LPAD(' ', 4*(LEVEL-1)) || ename 사원명
    , empno 사번
    , SYS_CONNECT_BY_PATH(ename,'//') PATH
FROM emp
START WITH job = UPPER('President')
CONNECT BY NOCYCLE PRIOR empno = mgr;

/**/
SELECT LEVEL
    , SYS_CONNECT_BY_PATH(ename,'//') PATH
FROM emp
WHERE CONNECT_BY_ISLEAF = 1
START WITH mgr IS NULL
CONNECT BY PRIOR empno =mgr;

/*ORDER SIBLINGS BY 사용예*/
SELECT LPAD(' ', 4*(LEVEL-1)) || ename 사원명
    , ename ename2, empno 사번, level
FROM emp
START WITH job = UPPER('President')
CONNECT BY NOCYCLE PRIOR empno = mgr
ORDER SIBLINGS BY ename;

/*문제 풀이 시간*/
/*1. emp, dept 테이블을 조회하여 부서번호와 부서별 최대 급여, 부서명을 출력해 보세요.(인라인 뷰를 사용)
    DEPTNO DNAME                               SAL
---------- ---------------------------- ----------
        10 ACCOUNTING                         5000
        20 RESEARCH                            800
        33 SALES                              2850*/
SELECT e.deptno, d.dname, sal
FROM(SELECT deptno, max(sal) max_sal
     FROM emp
     GROUP BY deptno) a, emp e, dept d
WHERE a.deptno = d.deptno
AND e.sal = a.max_sal
AND e.deptno = d.deptno
ORDER BY deptno ASC;        
/*2. EMPNO, ENAME 그리고 DEPTNO 열만을 포함하는 EMP 테이블의 구조를 기초로EMP1 테이블을 생성하세요.
   새 테이블에서 ID, LAST_NAME과 DEPT_ID로 열 이름을 지정하세요.*/
CREATE TABLE EMP1 AS
SELECT EMPNO ID, ENAME LAST_NAME, DEPTNO DEPT_ID
FROM emp;

SELECT * FROM emp1;
/*3. 2.에서 생성한 EMP1 테이블에서 LAST_NAME 필드를 10-->30으로 수정하세요.*/
ALTER TABLE emp1
MODIFY LAST_NAME VARCHAR2(30);
DESC emp1;
/*4. system이나 sys 소유의  테이블을 생성하고, 데이터를 하나 입력하라.
   Name		        Null		Type
  --------    -------------   ------------
   ID				           NUMBER(7)
   LAST_NAME			     VARCHAR2(25)
   FIRST_NAME			     VARCHAR2(25)
   DEPT_ID			           NUMBER(7)  */
conn system/manager
create table employee
(ID number(7),
LAST_NAME varchar2(25),
FIRST_NAME varchar2(25),
DEPT_ID number(7));
insert into employee values(2022018,'lee','kangin',2022008);
/*5.system의 employee테이블에 대해 pub_employee라는 공용 동의어를 생성하여라.*/
create public synonym pub_employee for employee;
/*6. 5에서 생성한 공용 동의어에 의해 system소유의 employee 테이블을 hr 유저가 조회하도록 하여라.*/
grant select on pub_employee to hr;
/*7. 공용동의어 pub_employee를 삭제 하세요.*/
drop public synonym pub_employee;