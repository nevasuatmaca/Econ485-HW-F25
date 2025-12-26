
# ECON485 – Homework 3 (terminal output)

```
MariaDB [econ485]> USE econ485;
Database changed

-- Task 1: List learners and their registered sections
MariaDB [econ485]> SELECT
    l.GivenName,
    l.FamilyName,
    c.Code AS CourseCode,
    s.SectionCode
FROM Enrollments e
JOIN Learners      l ON e.LearnerID  = l.LearnerID
JOIN ClassSections s ON e.SectionKey = s.SectionKey
JOIN CourseCatalog c ON s.CourseKey  = c.CourseKey
ORDER BY l.FamilyName, l.GivenName, c.Code, s.SectionCode;
+-----------+-----------+------------+-------------+
| GivenName | FamilyName| CourseCode | SectionCode |
+-----------+-----------+------------+-------------+
| Selin     | Acar      | ECON110    | A1          |
| Selin     | Acar      | ECON220    | A1          |
| Melis     | Arslan    | ECON220    | A1          |
| Ipek      | Demirtas  | ECON110    | A1          |
| Ceren     | Kara      | ECON110    | A1          |
| Ceren     | Kara      | STAT130    | A1          |
| Umut      | Kilic     | ECON110    | B1          |
| Arda      | Kurt      | STAT130    | A1          |
| Onur      | Sahin     | ECON110    | A1          |
| Onur      | Sahin     | ECON110    | B1          |
| Okan      | Tuna      | STAT130    | A1          |
| Berk      | Yildirim  | ECON110    | A1          |
| Berk      | Yildirim  | ECON220    | A1          |
| Naz       | Yuce      | ECON110    | B1          |
| Naz       | Yuce      | ECON220    | A1          |
+-----------+-----------+------------+-------------+
15 rows in set (0.001 sec)

-- Task 2: Show courses with total student counts
MariaDB [econ485]> SELECT
    c.Code  AS CourseCode,
    c.Title AS CourseTitle,
    COUNT(e.LearnerID) AS TotalStudents
FROM CourseCatalog c
LEFT JOIN ClassSections s
       ON s.CourseKey = c.CourseKey
LEFT JOIN Enrollments e
       ON e.SectionKey = s.SectionKey
GROUP BY
    c.CourseKey,
    c.Code,
    c.Title
ORDER BY c.Code;
+------------+----------------------------+--------------+
| CourseCode | CourseTitle                | TotalStudents|
+------------+----------------------------+--------------+
| ECON110    | Principles of Economics    | 8            |
| ECON220    | Microeconomics II          | 4            |
| STAT130    | Introduction to Statistics | 3            |
+------------+----------------------------+--------------+
3 rows in set (0.003 sec)

-- Task 3: List all prerequisites for each course
MariaDB [econ485]> SELECT
    c_target.Code  AS TargetCourseCode,
    c_target.Title AS TargetCourseTitle,
    c_req.Code     AS RequiredCourseCode,
    c_req.Title    AS RequiredCourseTitle,
    p.MinimumGrade
FROM CourseCatalog c_target
LEFT JOIN PrereqRules p
       ON p.CourseKey = c_target.CourseKey
LEFT JOIN CourseCatalog c_req
       ON p.RequiredCourse = c_req.CourseKey
ORDER BY
    c_target.Code,
    c_req.Code;
+------------------+----------------------------+--------------------+----------------------------+--------------+
| TargetCourseCode | TargetCourseTitle          | RequiredCourseCode | RequiredCourseTitle        | MinimumGrade |
+------------------+----------------------------+--------------------+----------------------------+--------------+
| ECON110          | Principles of Economics    | NULL               | NULL                       | NULL         |
| ECON220          | Microeconomics II          | ECON110            | Principles of Economics    | C            |
| ECON220          | Microeconomics II          | STAT130            | Introduction to Statistics | D            |
| STAT130          | Introduction to Statistics | NULL               | NULL                       | NULL         |
+------------------+----------------------------+--------------------+----------------------------+--------------+
4 rows in set (0.001 sec)

-- Task 4: Identify learners eligible to take ECON220 (CourseKey = 102)
MariaDB [econ485]> SELECT
    l.LearnerID,
    l.GivenName,
    l.FamilyName,
    c_target.Code AS TargetCourseCode,
    c_req.Code    AS RequiredCourseCode,
    c_req.Title   AS RequiredCourseTitle,
    p.MinimumGrade,
    cm.GradeCode  AS LearnerGrade,
    CASE
        WHEN cm.GradeCode IS NULL THEN 'NOT COMPLETED'
        WHEN cm.GradeCode >= p.MinimumGrade THEN 'OK'
        ELSE 'BELOW MINIMUM'
    END AS PrereqStatus
FROM Learners l
JOIN PrereqRules p
      ON p.CourseKey = 102
JOIN CourseCatalog c_target
      ON c_target.CourseKey = p.CourseKey
JOIN CourseCatalog c_req
      ON c_req.CourseKey = p.RequiredCourse
LEFT JOIN CompletedModules cm
      ON cm.LearnerID = l.LearnerID
     AND cm.CourseKey  = p.RequiredCourse
WHERE
    NOT EXISTS (
        SELECT 1
        FROM PrereqRules p2
        LEFT JOIN CompletedModules cm2
               ON cm2.LearnerID = l.LearnerID
              AND cm2.CourseKey  = p2.RequiredCourse
        WHERE p2.CourseKey = 102
          AND (cm2.GradeCode IS NULL OR cm2.GradeCode < p2.MinimumGrade)
    )
  AND NOT EXISTS (
        SELECT 1
        FROM Enrollments e
        JOIN ClassSections s ON e.SectionKey = s.SectionKey
        WHERE e.LearnerID = l.LearnerID
          AND s.CourseKey = 102
    )
ORDER BY l.FamilyName, l.GivenName, c_req.Code;
Empty set (0.005 sec)

-- Task 5: Detect learners who registered without meeting prerequisites
MariaDB [econ485]> SELECT
    l.GivenName,
    l.FamilyName,
    c_target.Code AS TargetCourseCode,
    c_req.Code    AS MissingOrFailedPrereqCode,
    c_req.Title   AS MissingOrFailedPrereqTitle,
    cm.GradeCode  AS LearnerGrade,
    p.MinimumGrade
FROM Enrollments e
JOIN ClassSections s
      ON e.SectionKey = s.SectionKey
JOIN CourseCatalog c_target
      ON s.CourseKey = c_target.CourseKey
JOIN Learners l
      ON e.LearnerID = l.LearnerID
JOIN PrereqRules p
      ON p.CourseKey = c_target.CourseKey
LEFT JOIN CompletedModules cm
      ON cm.LearnerID = l.LearnerID
     AND cm.CourseKey  = p.RequiredCourse
JOIN CourseCatalog c_req
      ON c_req.CourseKey = p.RequiredCourse
WHERE
      cm.GradeCode IS NULL          -- prerequisite not completed
   OR cm.GradeCode < p.MinimumGrade -- or grade below minimum
ORDER BY l.FamilyName, l.GivenName, c_target.Code, c_req.Code;
+-----------+-----------+------------------+----------------------------+----------------------------+-------------+--------------+
| GivenName | FamilyName| TargetCourseCode | MissingOrFailedPrereqCode  | MissingOrFailedPrereqTitle | LearnerGrade| MinimumGrade |
+-----------+-----------+------------------+----------------------------+----------------------------+-------------+--------------+
| Selin     | Acar      | ECON220          | ECON110                    | Principles of Economics    | NULL        | C            |
| Selin     | Acar      | ECON220          | STAT130                    | Introduction to Statistics | NULL        | D            |
| Melis     | Arslan    | ECON220          | ECON110                    | Principles of Economics    | NULL        | C            |
| Melis     | Arslan    | ECON220          | STAT130                    | Introduction to Statistics | NULL        | D            |
| Berk      | Yildirim  | ECON220          | ECON110                    | Principles of Economics    | B           | C            |
| Berk      | Yildirim  | ECON220          | STAT130                    | Introduction to Statistics | C           | D            |
| Naz       | Yuce      | ECON220          | ECON110                    | Principles of Economics    | A           | C            |
| Naz       | Yuce      | ECON220          | STAT130                    | Introduction to Statistics | B           | D            |
+-----------+-----------+------------------+----------------------------+----------------------------+-------------+--------------+
8 rows in set (0.002 sec)
```
```
