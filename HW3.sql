-- ECON485 – Homework 3 
-- Uses econ485 database with Learners / CourseCatalog / ClassSections / Enrollments / PrereqRules / CompletedModules

USE econ485;

-- Task 1 – List learners and their registered sections

SELECT
    l.GivenName,
    l.FamilyName,
    c.Code       AS CourseCode,
    s.SectionCode
FROM Enrollments e
JOIN Learners      l ON e.LearnerID  = l.LearnerID
JOIN ClassSections s ON e.SectionKey = s.SectionKey
JOIN CourseCatalog c ON s.CourseKey  = c.CourseKey
ORDER BY l.FamilyName, l.GivenName, c.Code, s.SectionCode;


-- Task 2 – Show courses with total student counts

SELECT
    c.Code       AS CourseCode,
    c.Title      AS CourseTitle,
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


-- Task 3 – List all prerequisites for each course

SELECT
    c_target.Code   AS TargetCourseCode,
    c_target.Title  AS TargetCourseTitle,
    c_req.Code      AS RequiredCourseCode,
    c_req.Title     AS RequiredCourseTitle,
    p.MinimumGrade
FROM CourseCatalog c_target
LEFT JOIN PrereqRules p
       ON p.CourseKey = c_target.CourseKey
LEFT JOIN CourseCatalog c_req
       ON p.RequiredCourse = c_req.CourseKey
ORDER BY
    c_target.Code,
    c_req.Code;


-- Task 4 – Identify learners eligible to take ECON220 (CourseKey = 102)

SELECT
    l.LearnerID,
    l.GivenName,
    l.FamilyName,
    c_target.Code    AS TargetCourseCode,
    c_req.Code       AS RequiredCourseCode,
    c_req.Title      AS RequiredCourseTitle,
    p.MinimumGrade,
    cm.GradeCode     AS LearnerGrade,
    CASE
        WHEN cm.GradeCode IS NULL THEN 'NOT COMPLETED'
        WHEN cm.GradeCode >= p.MinimumGrade THEN 'OK'
        ELSE 'BELOW MINIMUM'
    END AS PrereqStatus
FROM Learners l
JOIN PrereqRules p
      ON p.CourseKey = 102                      -- target course
JOIN CourseCatalog c_target
      ON c_target.CourseKey = p.CourseKey
JOIN CourseCatalog c_req
      ON c_req.CourseKey = p.RequiredCourse
LEFT JOIN CompletedModules cm
      ON cm.LearnerID = l.LearnerID
     AND cm.CourseKey = p.RequiredCourse
WHERE
    -- tüm prerequisite'leri geçmeyenler elenir
    NOT EXISTS (
        SELECT 1
        FROM PrereqRules p2
        LEFT JOIN CompletedModules cm2
               ON cm2.LearnerID = l.LearnerID
              AND cm2.CourseKey  = p2.RequiredCourse
        WHERE p2.CourseKey = 102
          AND (cm2.GradeCode IS NULL OR cm2.GradeCode < p2.MinimumGrade)
    )
    -- zaten ECON220'ye kayıtlı olanlar elenir
    AND NOT EXISTS (
        SELECT 1
        FROM Enrollments e
        JOIN ClassSections s ON e.SectionKey = s.SectionKey
        WHERE e.LearnerID = l.LearnerID
          AND s.CourseKey = 102
    )
ORDER BY l.FamilyName, l.GivenName, c_req.Code;


-- Task 5 – Detect learners who registered without meeting prerequisites

SELECT
    l.GivenName,
    l.FamilyName,
    c_target.Code      AS TargetCourseCode,
    c_req.Code         AS MissingOrFailedPrereqCode,
    c_req.Title        AS MissingOrFailedPrereqTitle,
    cm.GradeCode       AS LearnerGrade,
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
      cm.GradeCode IS NULL              -- prerequisite never completed
   OR cm.GradeCode < p.MinimumGrade      -- or grade below required
ORDER BY l.FamilyName, l.GivenName, c_target.Code, c_req.Code;
