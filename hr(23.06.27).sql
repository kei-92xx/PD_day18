/* ������ �÷�Ȯ�ο� */
select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;
DESC salgrade;
/*23/06/27*/
/*�ε���
  - �ε����� SQL ��ɹ��� ó�� �ӵ��� ����Ű�� ���� Į���� ���� �����ϴ� ��ü
  - WHERE ���̳� ���� ���������� ���� ���Ǵ� Į��  */
/*���� �ε���(unique index)
  - �����ε����� ������ ���� ������ Į���� ���� �����ϴ� �ε����� ��� �ε��� Ű�� ���̺��� �ϳ��� ��� ����
  ��뿹 : �μ����̺��� name Į���� �����ε����� �����Ͽ���. ��, �����ε����� �̸��� idx_dept_name���� �����Ѵ�*/
CREATE UNIQUE INDEX idx_dept_name
ON department(dname);
/*����� �ε���(non unique index)
  - ����� �ε����� �ߺ��� ���� ������ ī���� ���� �����ϴ� �ε����� �ϳ��� �ε��� Ű�� ���̺��� ������� ����� �� �ִ�.
  ��뿹: �л����̺��� birthdate Į���� ����� �ε����� �����϶� ����� �ε����� �̸��� idx_stud_birthdate�� �����Ѵ�*/
CREATE INDEX idx_stud_birthdate
ON student(birthdate);
/*���� �ε��� : �����ε����� �ϳ��� Į�����θ� ������ �ε����̴�.
  ���� �ε��� : �����ε����� �ΰ� �̻��� Į���� �����Ͽ� �����ϴ� �ε����̴�.
  ��뿹 : �л����̺��� deptno, grade Į���� ���� �ε����� �����Ͽ���
  ���� �������� �̸��� idx_stud_dno_grade�� �����Ѵ�*/
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);
/*DESCENDING INDEX : Į������ ���ļ����� ������ �����Ͽ� ���� �ε����� �����ϱ� ���� ����̴�.
  ��뿹 : �л����̺��� deptn�� name Į������ ���� �ε����� �����Ͽ��� ��, deptno Į���� ������������ name Į���� ������������ �����Ͽ���*/
CREATE INDEX fidx_stud_no_name ON student(deptno DESC, name ASC);
/*�Լ���� �ε���(function based index)
 ��뿹*/
CREATE INDEX uppercase_idx ON emp (UPPER(ename));
SELECT * FROM emp WHERE UPPER(ename) = 'KING';
/*�Լ���� �ε���(FBI)
 ��뿹: �л����̺��� �л����� �񸸵� ������ ���� ǥ��ü���� ���ϰ����Ѵ� ǥ��ü�߿� ���� �Լ���� �ε����� �����϶�*/
CREATE INDEX idx_standard_weight ON student((height-100)*0.9);

/*�ε��� ������ Ȯ��
  ��뿹 : �а����̺��� �а� �̸��� '�����̵���к�'�� �а���ȣ�� �˻��� ����� ����
          �����θ� �м��Ͽ���. dname �÷��� �����ε����� �����Ǿ� �ִ�. */
SELECT deptno, dname
FROM department
WHERE dname = '�����̵���к�'; /*F10 ������ ���Ȯ�� ����*/

DROP INDEX IDX_DEPT_NAME; /*�ε��� ����*/

/*������ ��뿹 : �л����̺��� ������ '79/04/02'�� �л� �̸��� �˻��� ����� ���� �����θ� �м��Ͽ���*/
SELECT name, birthdate
FROM student
WHERE birthdate = '79/04/02';

DROP INDEX idx_stud_birthdate;

/*�ε��� ���� ��ȸ
 - USER_INDEXES : �ε��� �̸��� ���ϼ� ���� ���� Ȯ��
  ��뿹 : �л����̺� ������ �ε����� ��ȸ�Ͽ��� */
SELECT index_name, uniqueness
FROM user_indexes
WHERE table_name = 'STUDENT';
/*�ε��� ���� 
  - DROP INDEX�� ���*/

/*�ε��� �籸��
  - �ε��� �籸���� �ε����� ������ ���̺��� Į������ ���� ���� �۾��� ���� �߻��Ͽ�,
    ���ʿ��ϰ� ������ �ε��� ���� ��带 �����ϴ� �۾�*/
    
/*��(view)
  - �ϳ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� ���� ���̺�
  - ��ü�� �������߿��� �Ϻθ� ������ �� �ֵ��� ����*/
/*�ܼ� ��(simple view)
  - �ϳ��� �⺻ ���̺� ���� ������ ��
  - �ܼ� �信 DML��ɹ��� ���� ��� �⺻ ���̺� �ݿ�
  ���� ��(comples view)
  - �ΰ� �̻��� �⺻ ���̺�� ������ ��
  - ���Ἲ ��������, ǥ����*/

/*�� ����
  - CREATE VIEW ��ɹ� ���
  
  ��뿹 : �л� ���̺��� 101�� �а� �л����� �й�, �̸�, �а� ��ȣ�� ���ǵǴ� �ܼ� �並 �����϶�*/
CREATE VIEW v_stud_dept101 as
SELECT studno, name, deptno
FROM student
WHERE deptno = 101;

SELECT * FROM v_stud_dept101;
/*���պ� ������ : �л����̺�� �μ����̺��� �����Ͽ� 102�� �а� �л����� �й�,�̸�,�г�,�а��̸����� ���ǵǴ� ���� �並 �����϶� */
CREATE VIEW v_stud_dept102 AS
SELECT s.studno, s.name, s.grade, d.dname
FROM student s, department d
WHERE s.deptno = d.deptno 
AND s.deptno = 102;

SELECT * FROM v_stud_dept102;
/*�Լ� ��� ������� : �������̺��� �а��� ��ձ޿��� �Ѱ�� ���ǵǴ� �並 �����Ͽ���*/
CREATE VIEW v_prof_avg_sal AS
SELECT deptno, sum(sal) sum_sal, avg(sal) avg_sal /*�Լ����� �� �÷������� ����ؾ� ������ �߻����� �ʴ´�*/
FROM professor
GROUP BY deptno;

SELECT * FROM v_prof_avg_sal;
/*�ζ��� ��(inline view)
  - FROM ������ �����ϴ� ���̺��� ũ�Ⱑ Ŭ ���, �ʿ��� ��� �÷������� ������ ������ �������Ͽ� ���ǹ��� ȿ���� ����
  - FROM ������ ���������� ����Ͽ� ������ �ӽ� ��
  ��뿹 : �ζ��κ並 ����Ͽ� �а����� �л����� ��� Ű�� ������, �а��̸��� ����϶�*/
SELECT dname, avg_height, avg_weight
FROM(SELECT deptno, avg(height) avg_height, avg(weight) avg_weight
     FROM student
     GROUP BY deptno) s, department d
WHERE s.deptno = d.deptno;
/*����: �а��� �ִ�Ű�� ���ϰ� �ִ�Ű�� ���� �л��� �а���, �ִ�Ű, �̸�, Ű�� ����ϼ���*/
SELECT dname, max_height, s.name, s.height
FROM(SELECT deptno, max(height) max_height
     FROM student
     GROUP BY deptno) a, student s, department d
WHERE s.deptno = a.deptno
AND s.height = a.max_height
AND s.deptno = d.deptno;

/*���� ����ó������*/
/*����ȸ
  USER_VIEWS
  - ����ڰ� ������ ���信 ���� ���Ǹ� ����*/
SELECT view_name, text
FROM user_views;
/*���� ����
  - ���� ������ �����信 ���� ���Ǹ� ������ �� �����
  - CREATE ��ɹ����� OR REPLACE �ɼ��� �̿��Ͽ� �����*/
/*�信 ���� ������ ����
 �ܼ���
  - �ܼ� ��� �⺻ ���̺�� �����ϰ� DML ��ɹ� ���
 ���պ�
  - DML��ɾ� ��� ����*/  
/*���� ����*/
DROP VIEW v_stud_dept101;

/*����� ���� ����*/
/*�����ͺ��̽� ����
  ���� ����� ȯ��(multi-user environment)
   - �ҹ����� ���� �� ���� ������ ���� ���� ��å �ʿ�
  �߾� �������� ������ ����
   - �л������� �����Ǵ� ������ ���� �ý��ۺ��� ������ ����� �� �����Ƿ� ö���� ���� ��å �ʿ�*/
/*����(Privilege)
  - ������ ����ڰ� �����ͺ��̽� �ý����� �����ϰų� ��ü�� �̿��� �� �ִ� �Ǹ�
  ������ ����
  1. �ý��� ����
  2. ��ü ����*/
/*�ý��� ���� �ο�
conn system/manager
grant query rewrite to scott;*/
/*���� ���ǿ� �ο��� �ý��� ���� ��ȸ
 SESSION_PRIVS
  - ���� ���ǿ��� ����ڿ� �ѿ� �ο��� �ý��� ������ ��ȸ ����*/
SELECT * FROM session_privs;
/*�ý��� ���� öȸ (REVOKE ��ɹ� ���)
��뿹 : REVOKE query rewrite FROM scott;*/

/*��ü ���� �ο�
  - �����ͺ��̽� �����ڳ� ��ü �����ڰ� ����ڿ� �ѿ��� �ο�
  - GRANT ��ɹ��� ����� ���� �ο�*/

/*����*/
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
/*��(role)
  - �ټ� ����ڿ� �پ��� ������ ȿ�������� �����ϱ� ���Ͽ� ���� ���õ� ������ �׷�ȭ�� ����
  �� ����
   - CONNECT : ����ڰ� �����ͺ��̽��� �����Ͽ� ������ ������ �� �ִ� ���� ���̺� �Ǵ� ��� ���� ��ü�� ������ �� �ִ� ����
   - RESOURCE : ����ڿ��� �ڽ��� ���̺�, ������, ���ν���, Ʈ���� ��ü ������ �� �ִ� ����
   - DBA : �ý��� �ڿ��� ���������� ����̳� �ý��� ������ �ʿ��� ��� ���� 
  �� ����
   - CREATE ROLE ��ɹ����� ����
   - �ѿ� ��ȣ�ο� ����
   - �� �̸��� ����ڳ� �ٸ� �Ѱ� �ߺ��� �� ����
��뿹 : ��ȣ�� ������ �Ѱ� �������� ���� ���� �����϶�*/
CONN system/manager
CREATE ROLE hr_clerk;
CREATE ROLE hr_mgr
IDENTIFIED BY manager;
/*�ѿ� ���� �Ǵ� �� �ο�
  - �ѿ� �ý��� �����̳� ��ü ���� �Ǵ� �ٸ� ���� �ο� ����
  - GRANT ��ɹ� ���*/
/*�ѿ� �ý��� ���Ѻο� : DBA �Ǵ� GRANT ANY PRIVILEGE �������� ���� ����ڴ� �ѿ� �ý��� ������ �ο�����
  �ѿ� ��ü ���� �ο� : ����ڰ� �ѿ� ��ü�� �ο��� �� �ִ� ���*/
/*�Ѻο�
  - ���� ����� �Ǵ� �ٸ� �ѿ��� �� �ο�
  - WITH ADMIN OPTION*/  
/*�� ��ȸ
  - role_sys_privs : �ѿ� �ο��� �ý��� ���� ��ȸ
  - user_role_privs : ����ڰ� �ο����� �� ��ȸ*/  
  
/*���Ǿ� : �ϳ��� ��ü�� ���� �ٸ� �̸��� �����ϴ� ���
 ���뵿�Ǿ�
   - ��ü�� ���� ���� ������ �ο� ���� ����ڰ� ������ ���Ǿ�� �ش� ����ڸ� ���
 ���뵿�Ǿ�
   - ������ �ִ� ����ڰ� ������ ���Ǿ�� ������ ���
   - DBA ������ ���� ����ڸ� ����*/

/*������ ���ǹ�
  - ������ �����ͺ��̽����� �����Ͱ��� �θ� ���踦 ǥ���� �� �ִ� Į���� �����Ͽ� �������� ���踦 ǥ��
  ����
   - SELECT ��ɹ����� START WITH�� CONNECT BY ���� �̿�
   - ������ ���ǹ������� �������� ��� ���İ� ���� ��ġ ����*/
   
/*top-down ��뿹 : ������ ���ǹ��� ����Ͽ� �μ����̺��� �а�,�к�,�ܰ������� �˻��Ͽ�
�ܴ�,�к�,�а������� top-down ������ ���� ������ ��� ��, ���۵����ʹ� 10������*/
SELECT deptno, dname, college
FROM department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college;
/*bottom-up ��뿹 : ������ ���ǹ��� ����Ͽ� �μ����̺��� �а�,�к�,�ܰ������� �˻��Ͽ�
�ܴ�,�к�,�а������� bottom-up ������ ���������� ���, �� ���۵����ʹ� 102�� ����*/
SELECT deptno, dname, college
FROM department
START WITH deptno = 102
CONNECT BY PRIOR college = deptno;
/*������ ���� ��뿹 : ������ ���ǹ��� ����Ͽ� �μ����̺��� �а�,�к�,�ܰ������� �˻��Ͽ�
  �ܴ�,�к�,�а������� top-down ������ ���� ������ ��� ��, ���۵����ʹ� 10������*/
SELECT LEVEL, LPAD(' ', (LEVEL-1)*2) || dname ������
FROM department
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college;

/*������������ �������� ���*/
/*�������� ��뿹 : �μ����̺��� dnameĮ���� �ܴ�,�к�,�а������� top-down ������ ���� ������ ��� ��, '�����̵���к�'�� �����ϰ� ���*/
SELECT deptno, college, dname, loc
FROM department
WHERE dname != '�����̵���к�'
START WITH college is null
CONNECT BY PRIOR deptno = college;

/*CONNECT_BY_ISLEAF ��뿹 : ������ ���ǹ��� ����Ͽ� LEVEL 1�� �ֻ����ο��� ������ ���� �� �ִ�*/
SELECT LPAD(' ', 4*(LEVEL-1)) || ename �����
    , empno ���
    , CONNECT_BY_ISLEAF leaf_YN
    , LEVEL
FROM emp
START WITH job = UPPER('President')
CONNECT BY NOCYCLE PRIOR empno = mgr;

/*SYS_CONNECT_BY_PATH ��뿹 : ������ ���ǹ��� ����Ͽ� ���� ROW������ PATH ������ ���� ���� �� �ִ�*/
SELECT LPAD(' ', 4*(LEVEL-1)) || ename �����
    , empno ���
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

/*ORDER SIBLINGS BY ��뿹*/
SELECT LPAD(' ', 4*(LEVEL-1)) || ename �����
    , ename ename2, empno ���, level
FROM emp
START WITH job = UPPER('President')
CONNECT BY NOCYCLE PRIOR empno = mgr
ORDER SIBLINGS BY ename;

/*���� Ǯ�� �ð�*/
/*1. emp, dept ���̺��� ��ȸ�Ͽ� �μ���ȣ�� �μ��� �ִ� �޿�, �μ����� ����� ������.(�ζ��� �並 ���)
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
/*2. EMPNO, ENAME �׸��� DEPTNO ������ �����ϴ� EMP ���̺��� ������ ���ʷ�EMP1 ���̺��� �����ϼ���.
   �� ���̺��� ID, LAST_NAME�� DEPT_ID�� �� �̸��� �����ϼ���.*/
CREATE TABLE EMP1 AS
SELECT EMPNO ID, ENAME LAST_NAME, DEPTNO DEPT_ID
FROM emp;

SELECT * FROM emp1;
/*3. 2.���� ������ EMP1 ���̺��� LAST_NAME �ʵ带 10-->30���� �����ϼ���.*/
ALTER TABLE emp1
MODIFY LAST_NAME VARCHAR2(30);
DESC emp1;
/*4. system�̳� sys ������  ���̺��� �����ϰ�, �����͸� �ϳ� �Է��϶�.
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
/*5.system�� employee���̺� ���� pub_employee��� ���� ���Ǿ �����Ͽ���.*/
create public synonym pub_employee for employee;
/*6. 5���� ������ ���� ���Ǿ ���� system������ employee ���̺��� hr ������ ��ȸ�ϵ��� �Ͽ���.*/
grant select on pub_employee to hr;
/*7. ���뵿�Ǿ� pub_employee�� ���� �ϼ���.*/
drop public synonym pub_employee;