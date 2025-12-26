
-- Simple registration system using Learners / CourseCatalog / ClassSections / Enrollments

CREATE DATABASE IF NOT EXISTS econ485;
USE econ485;

-- Part 1a – Create base tables (from HW1 alternate design)

CREATE TABLE IF NOT EXISTS Learners (
  LearnerID    INT PRIMARY KEY,
  StudentNo    VARCHAR(20) NOT NULL,
  GivenName    VARCHAR(50) NOT NULL,
  FamilyName   VARCHAR(50) NOT NULL,
  ProgramName  VARCHAR(50),
  StartYear    INT
);

CREATE TABLE IF NOT EXISTS CourseCatalog (
  CourseKey   INT PRIMARY KEY,
  Code        VARCHAR(20) NOT NULL,
  Title       VARCHAR(100) NOT NULL,
  LocalCredit INT,
  EctsCredit  INT
);

CREATE TABLE IF NOT EXISTS ClassSections (
  SectionKey    INT PRIMARY KEY,
  CourseKey     INT NOT NULL,
  TermName      VARCHAR(10) NOT NULL,
  AcademicYear  INT NOT NULL,
  SectionCode   VARCHAR(10) NOT NULL,
  MaxSeats      INT,
  LeadInstructor VARCHAR(100),
  CONSTRAINT fk_sections_course
    FOREIGN KEY (CourseKey) REFERENCES CourseCatalog(CourseKey)
);

CREATE TABLE IF NOT EXISTS Enrollments (
  EnrollmentID   INT PRIMARY KEY,
  LearnerID      INT NOT NULL,
  SectionKey     INT NOT NULL,
  DateRegistered DATE,
  CONSTRAINT fk_enroll_learner
    FOREIGN KEY (LearnerID) REFERENCES Learners(LearnerID),
  CONSTRAINT fk_enroll_section
    FOREIGN KEY (SectionKey) REFERENCES ClassSections(SectionKey)
);

-- Part 1b – Insert example data (different courses / names)

INSERT INTO CourseCatalog (CourseKey, Code, Title, LocalCredit, EctsCredit) VALUES
  (101, 'ECON110', 'Principles of Economics', 3, 6),
  (102, 'ECON220', 'Microeconomics II',       3, 6),
  (103, 'STAT130', 'Introduction to Statistics', 4, 7);

INSERT INTO ClassSections (SectionKey, CourseKey, TermName, AcademicYear, SectionCode, MaxSeats, LeadInstructor) VALUES
  (1001, 101, 'Fall',  2025, 'A1', 60, 'Dr. Erdem'),
  (1002, 101, 'Fall',  2025, 'B1', 60, 'Dr. Simsek'),
  (1003, 102, 'Fall',  2025, 'A1', 45, 'Dr. Karaca'),
  (1004, 103, 'Fall',  2025, 'A1', 50, 'Dr. Polat');

INSERT INTO Learners (LearnerID, StudentNo, GivenName, FamilyName, ProgramName, StartYear) VALUES
  (1,  '20251001', 'Berk',   'Yildirim', 'Economics',   2025),
  (2,  '20251002', 'Ceren',  'Kara',     'Economics',   2025),
  (3,  '20251003', 'Onur',   'Sahin',    'Business',    2024),
  (4,  '20251004', 'Naz',    'Yuce',     'Economics',   2023),
  (5,  '20251005', 'Okan',   'Tuna',     'Statistics',  2025),
  (6,  '20251006', 'Ipek',   'Demirtas', 'Economics',   2024),
  (7,  '20251007', 'Umut',   'Kilic',    'Computer Sci',2023),
  (8,  '20251008', 'Melis',  'Arslan',   'Economics',   2022),
  (9,  '20251009', 'Arda',   'Kurt',     'Business',    2024),
  (10, '20251010', 'Selin',  'Acar',     'Economics',   2025);

INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered) VALUES
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
  (14, 10,1001, '2025-09-03'),
  (15, 10,1003, '2025-09-03');

-- Part 1c – Add and drop actions (different EnrollmentIDs from your own work)

-- Adds
INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered)
VALUES (16, 1, 1003, '2025-09-04');  -- Berk adds ECON220

INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered)
VALUES (17, 2, 1004, '2025-09-04');  -- Ceren adds STAT130

INSERT INTO Enrollments (EnrollmentID, LearnerID, SectionKey, DateRegistered)
VALUES (18, 3, 1002, '2025-09-04');  -- Onur adds second ECON110 section

-- Drops
DELETE FROM Enrollments WHERE EnrollmentID = 2;   -- Berk drops STAT130
DELETE FROM Enrollments WHERE EnrollmentID = 4;   -- Ceren drops ECON220
DELETE FROM Enrollments WHERE EnrollmentID = 6;   -- Onur drops STAT130

-- Part 1d – Final enrollment report

SELECT
  l.GivenName,
  l.FamilyName,
  c.Code       AS CourseCode,
  s.SectionCode,
  s.TermName,
  s.AcademicYear,
  e.DateRegistered
FROM Enrollments e
JOIN Learners      l ON e.LearnerID   = l.LearnerID
JOIN ClassSections s ON e.SectionKey  = s.SectionKey
JOIN CourseCatalog c ON s.CourseKey   = c.CourseKey
ORDER BY l.FamilyName, l.GivenName, c.Code, s.SectionCode;

-- Part 2a – Prerequisite-related tables (renamed/changed)

CREATE TABLE IF NOT EXISTS PrereqRules (
  RuleID          INT PRIMARY KEY,
  CourseKey       INT NOT NULL,
  RequiredCourse  INT NOT NULL,
  MinimumGrade    CHAR(2) NOT NULL,
  CONSTRAINT fk_prereq_target
    FOREIGN KEY (CourseKey)      REFERENCES CourseCatalog(CourseKey),
  CONSTRAINT fk_prereq_required
    FOREIGN KEY (RequiredCourse) REFERENCES CourseCatalog(CourseKey)
);

CREATE TABLE IF NOT EXISTS CompletedModules (
  RecordID   INT PRIMARY KEY,
  LearnerID  INT NOT NULL,
  CourseKey  INT NOT NULL,
  GradeCode  CHAR(2) NOT NULL,
  CONSTRAINT fk_completed_learner
    FOREIGN KEY (LearnerID) REFERENCES Learners(LearnerID),
  CONSTRAINT fk_completed_course
    FOREIGN KEY (CourseKey) REFERENCES CourseCatalog(CourseKey)
);

-- Example prerequisite rules: ECON220 requires ECON110 and STAT130

INSERT INTO PrereqRules (RuleID, CourseKey, RequiredCourse, MinimumGrade) VALUES
  (1, 102, 101, 'C'),   -- ECON220 requires ECON110 with at least C
  (2, 102, 103, 'D');   -- ECON220 requires STAT130 with at least D

-- Example completed courses / grades for some learners (different pattern)

INSERT INTO CompletedModules (RecordID, LearnerID, CourseKey, GradeCode) VALUES
  (1, 1, 101, 'B'),   -- Berk: ECON110 B
  (2, 1, 103, 'C'),   -- Berk: STAT130 C

  (3, 2, 101, 'D'),   -- Ceren: ECON110 D (below C)
  (4, 2, 103, 'B'),   -- Ceren: STAT130 B

  (5, 3, 101, 'C'),   -- Onur: ECON110 C
  -- Onur has not taken STAT130 at all

  (6, 4, 101, 'A'),   -- Naz: ECON110 A
  (7, 4, 103, 'B');   -- Naz: STAT130 B

-- Part 2c – Assistive SQL: list prerequisites for a course (ECON220)

SELECT
  c_target.Code      AS TargetCourse,
  c_req.Code         AS RequiredCourse,
  c_req.Title        AS RequiredTitle,
  p.MinimumGrade
FROM PrereqRules p
JOIN CourseCatalog c_target ON p.CourseKey      = c_target.CourseKey
JOIN CourseCatalog c_req    ON p.RequiredCourse = c_req.CourseKey
WHERE p.CourseKey = 102;

-- Part 2c – Assistive SQL: check whether a learner passed prerequisites (example: LearnerID = 1, CourseKey = 102)

SELECT
  l.LearnerID,
  l.GivenName,
  l.FamilyName,
  c_target.Code        AS TargetCourse,
  c_req.Code           AS RequiredCourse,
  c_req.Title          AS RequiredTitle,
  p.MinimumGrade,
  cm.GradeCode         AS LearnerGrade,
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
      AND cm.LearnerID = 1  -- parameter: LearnerID
JOIN Learners l
       ON l.LearnerID = 1   -- same LearnerID
WHERE p.CourseKey = 102;    -- parameter: target CourseKey
