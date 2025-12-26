


# ECON485 – Homework 2 (terminal output)

```
MariaDB [(none)]> CREATE DATABASE econ485;
Query OK, 1 row affected (0.006 sec)

MariaDB [(none)]> USE econ485;
Database changed

MariaDB [econ485]> CREATE TABLE Learners (
    LearnerID   INT PRIMARY KEY,
    StudentNo   VARCHAR(20) NOT NULL,
    GivenName   VARCHAR(50) NOT NULL,
    FamilyName  VARCHAR(50) NOT NULL,
    ProgramName VARCHAR(50),
    StartYear   INT
);
Query OK, 0 rows affected (0.045 sec)

MariaDB [econ485]> CREATE TABLE CourseCatalog (
    CourseKey   INT PRIMARY KEY,
    Code        VARCHAR(20) NOT NULL,
    Title       VARCHAR(100) NOT NULL,
    LocalCredit INT,
    EctsCredit  INT
);
Query OK, 0 rows affected (0.023 sec)

MariaDB [econ485]> CREATE TABLE ClassSections (
    SectionKey     INT PRIMARY KEY,
    CourseKey      INT NOT NULL,
    TermName       VARCHAR(10) NOT NULL,
    AcademicYear   INT NOT NULL,
    SectionCode    VARCHAR(10) NOT NULL,
    MaxSeats       INT,
    LeadInstructor VARCHAR(100),
    CONSTRAINT fk_sections_course
      FOREIGN KEY (CourseKey) REFERENCES CourseCatalog(CourseKey)
);
Query OK, 0 rows affected (0.025 sec)

MariaDB [econ485]> CREATE TABLE Enrollments (
    EnrollmentID   INT PRIMARY KEY,
    LearnerID      INT NOT NULL,
    SectionKey     INT NOT NULL,
    DateRegistered DATE,
    CONSTRAINT fk_enroll_learner
      FOREIGN KEY (LearnerID) REFERENCES Learners(LearnerID),
    CONSTRAINT fk_enroll_section
      FOREIGN KEY (SectionKey) REFERENCES ClassSections(SectionKey)
);
Query OK, 0 rows affected (0.022 sec)

MariaDB [econ485]> INSERT INTO CourseCatalog (CourseKey, Code, Title, LocalCredit, EctsCredit) VALUES
    (101, 'ECON110', 'Principles of Economics', 3, 6),
    (102, 'ECON220', 'Microeconomics II',       3, 6),
    (103, 'STAT130', 'Introduction to Statistics', 4, 7);
Query OK, 3 rows affected (0.007 sec)
Records: 3  Duplicates: 0  Warnings: 0

MariaDB [econ485]> INSERT INTO ClassSections (SectionKey, CourseKey, TermName, AcademicYear, SectionCode, MaxSeats, LeadInstructor) VALUES
    (1001, 101, 'Fall', 2025, 'A1', 60, 'Dr. Erdem'),
    (1002, 101, 'Fall', 2025, 'B1', 60, 'Dr. Simsek'),
    (1003, 102, 'Fall', 2025, 'A1', 45, 'Dr. Karaca'),
    (1004, 103, 'Fall', 2025, 'A1', 50, 'Dr. Polat');
Query OK, 4 rows affected (0.046 sec)
Records: 4  Duplicates: 0  Warnings: 0

MariaDB [econ485]> INSERT INTO Learners (LearnerID, StudentNo, GivenName, FamilyName, ProgramName, StartYear) VALUES
    (1,  '20251001', 'Berk',  'Yildirim', 'Economics',    2025),
    (2,  '20251002', 'Ceren', 'Kara',     'Economics',    2025),
    (3,  '20251003', 'Onur',  'Sahin',    'Business',     2024),
    (4,  '20251004', 'Naz',   'Yuce',     'Economics',    2023),
    (5,  '20251005', 'Okan',  'Tuna',     'Statistics',   2025),
    (6,  '20251006', 'Ipek',  'Demirtas', 'Economics',    2024),
    (7,  '20251007', 'Umut',  'Kilic',    'Computer Sci', 2023),
    (8,  '20251008', 'Melis', 'Arslan',   'Economics',    2022),
    (9,  '20251009', 'Arda',  'Kurt',     'Business',     2024),
    (10, '20251010', 'Selin', 'Acar',     'Economics',    2025);
Query OK, 10 rows affected (0.005 sec)
Records: 10  Duplicates: 0  Warnings: 0

MariaDB [econ485]> INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered) VALUES
    (1,  1, 1001, '2025-09-01'),
    (2,  1, 1004, '2025-09-01'),
    (3,  2, 1001, '2025-09-01'),
    (4,  2, 1003, '2025-09-01'),
    (5,  3, 1001, '2025-09-02'),
    (6,  3, 1004, '2025-09-02'),
    (7,  4, 1002, '2025-09-02'),
    (8,  4, 1003, '2025-09-02'),
    (9,  5, 1004, '2025-09-02'),
    (10, 6, 1001, '2025-09-03'),
    (11, 7, 1002, '2025-09-03'),
    (12, 8, 1003, '2025-09-03'),
    (13, 9, 1004, '2025-09-03'),
    (14,10, 1001, '2025-09-03'),
    (15,10, 1003, '2025-09-03');
Query OK, 15 rows affected (0.002 sec)
Records: 15  Duplicates: 0  Warnings: 0

-- Berk (LearnerID = 1) ECON220 (Section 1003) ekliyor
MariaDB [econ485]> INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered)
VALUES (16, 1, 1003, '2025-09-04');
Query OK, 1 row affected (0.002 sec)

-- Ceren (LearnerID = 2) STAT130 (Section 1004) ekliyor
MariaDB [econ485]> INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered)
VALUES (17, 2, 1004, '2025-09-04');
Query OK, 1 row affected (0.001 sec)

-- Onur (LearnerID = 3) ECON110 ikinci section (1002) ekliyor
MariaDB [econ485]> INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered)
VALUES (18, 3, 1002, '2025-09-04');
Query OK, 1 row affected (0.000 sec)

-- Berk STAT130 (EnrollmentID = 2) bırakıyor
MariaDB [econ485]> DELETE FROM Enrollments
WHERE EnrollmentID = 2;
Query OK, 1 row affected (0.004 sec)

-- Ceren ECON220 (EnrollmentID = 4) bırakıyor
MariaDB [econ485]> DELETE FROM Enrollments
WHERE EnrollmentID = 4;
Query OK, 1 row affected (0.000 sec)

-- Onur STAT130 (EnrollmentID = 6) bırakıyor
MariaDB [econ485]> DELETE FROM Enrollments
WHERE EnrollmentID = 6;
Query OK, 1 row affected (0.000 sec)

MariaDB [econ485]> SELECT * FROM Enrollments ORDER BY EnrollmentID;
+--------------+-----------+------------+----------------+
| EnrollmentID | LearnerID | SectionKey | DateRegistered |
+--------------+-----------+------------+----------------+
| 1            | 1         | 1001       | 2025-09-01     |
| 3            | 2         | 1001       | 2025-09-01     |
| 5            | 3         | 1001       | 2025-09-02     |
| 7            | 4         | 1002       | 2025-09-02     |
| 8            | 4         | 1003       | 2025-09-02     |
| 9            | 5         | 1004       | 2025-09-02     |
| 10           | 6         | 1001       | 2025-09-03     |
| 11           | 7         | 1002       | 2025-09-03     |
| 12           | 8         | 1003       | 2025-09-03     |
| 13           | 9         | 1004       | 2025-09-03     |
| 14           | 10        | 1001       | 2025-09-03     |
| 15           | 10        | 1003       | 2025-09-03     |
| 16           | 1         | 1003       | 2025-09-04     |
| 17           | 2         | 1004       | 2025-09-04     |
| 18           | 3         | 1002       | 2025-09-04     |
+--------------+-----------+------------+----------------+
15 rows in set (0.001 sec)

MariaDB [econ485]> CREATE TABLE PrereqRules (
    RuleID         INT PRIMARY KEY,
    CourseKey      INT NOT NULL,
    RequiredCourse INT NOT NULL,
    MinimumGrade   CHAR(2) NOT NULL,
    CONSTRAINT fk_prereq_target
      FOREIGN KEY (CourseKey)      REFERENCES CourseCatalog(CourseKey),
    CONSTRAINT fk_prereq_required
      FOREIGN KEY (RequiredCourse) REFERENCES CourseCatalog(CourseKey)
);
Query OK, 0 rows affected (0.019 sec)

MariaDB [econ485]> CREATE TABLE CompletedModules (
    RecordID  INT PRIMARY KEY,
    LearnerID INT NOT NULL,
    CourseKey INT NOT NULL,
    GradeCode CHAR(2) NOT NULL,
    CONSTRAINT fk_completed_learner
      FOREIGN KEY (LearnerID) REFERENCES Learners(LearnerID),
    CONSTRAINT fk_completed_course
      FOREIGN KEY (CourseKey) REFERENCES CourseCatalog(CourseKey)
);
Query OK, 0 rows affected (0.020 sec)

MariaDB [econ485]> INSERT INTO PrereqRules (RuleID, CourseKey, RequiredCourse, MinimumGrade) VALUES
    (1, 102, 101, 'C'),
    (2, 102, 103, 'D');
Query OK, 2 rows affected (0.002 sec)
Records: 2  Duplicates: 0  Warnings: 0

MariaDB [econ485]> INSERT INTO CompletedModules (RecordID, LearnerID, CourseKey, GradeCode) VALUES
    (1, 1, 101, 'B'),
    (2, 1, 103, 'C'),
    (3, 2, 101, 'D'),
    (4, 2, 103, 'B'),
    (5, 3, 101, 'C'),
    (6, 4, 101, 'A'),
    (7, 4, 103, 'B');
Query OK, 7 rows affected (0.001 sec)
Records: 7  Duplicates: 0  Warnings: 0

MariaDB [econ485]> -- ECON220 için bütün prerequisites
MariaDB [econ485]> SELECT
    c_target.Code AS TargetCourse,
    c_req.Code    AS RequiredCourse,
    c_req.Title   AS RequiredTitle,
    p.MinimumGrade
FROM PrereqRules p
JOIN CourseCatalog c_target ON p.CourseKey      = c_target.CourseKey
JOIN CourseCatalog c_req    ON p.RequiredCourse = c_req.CourseKey
WHERE p.CourseKey = 102;
+--------------+----------------+---------------------------+--------------+
| TargetCourse | RequiredCourse | RequiredTitle             | MinimumGrade |
+--------------+----------------+---------------------------+--------------+
| ECON220      | ECON110        | Principles of Economics   | C            |
| ECON220      | STAT130        | Introduction to Statistics| D            |
+--------------+----------------+---------------------------+--------------+
2 rows in set (0.001 sec)

MariaDB [econ485]> -- LearnerID = 1, CourseKey = 102 için prerequisite kontrolü
MariaDB [econ485]> SELECT
    l.LearnerID,
    l.GivenName,
    l.FamilyName,
    c_target.Code AS TargetCourse,
    c_req.Code    AS RequiredCourse,
    c_req.Title   AS RequiredTitle,
    p.MinimumGrade,
    cm.GradeCode  AS LearnerGrade,
    CASE
        WHEN cm.GradeCode IS NULL THEN 'NOT COMPLETED'
        WHEN cm.GradeCode >= p.MinimumGrade THEN 'OK'
        ELSE 'BELOW MINIMUM'
    END AS PrereqStatus
FROM PrereqRules p
JOIN CourseCatalog c_target ON p.CourseKey      = c_target.CourseKey
JOIN CourseCatalog c_req    ON p.RequiredCourse = c_req.CourseKey
LEFT JOIN CompletedModules cm
       ON cm.CourseKey = p.RequiredCourse
      AND cm.LearnerID = 1
JOIN Learners l
       ON l.LearnerID = 1
WHERE p.CourseKey = 102;
+-----------+-----------+-----------+--------------+----------------+---------------------------+--------------+------------+---------------+
| LearnerID | GivenName | FamilyName| TargetCourse | RequiredCourse | RequiredTitle             | MinimumGrade | LearnerGrade| PrereqStatus  |
+-----------+-----------+-----------+--------------+----------------+---------------------------+--------------+------------+---------------+
| 1         | Berk      | Yildirim  | ECON220      | ECON110        | Principles of Economics   | C            | B          | BELOW MINIMUM |
| 1         | Berk      | Yildirim  | ECON220      | STAT130        | Introduction to Statistics| D            | C          | BELOW MINIMUM |
+-----------+-----------+-----------+--------------+----------------+---------------------------+--------------+------------+---------------+
2 rows in set (0.003 sec)
```
```

