-- Add students across different year levels
INSERT INTO "students" ("first_name", "last_name", "year_level", "start_date") VALUES
('Anna', 'Schmidt', 1, '2026-01-10'),
('Max', 'Müller', 2, '2025-09-01'),
('Claire', 'Dupont', 3, '2024-02-15'),
('Luca', 'Rossi', 2, '2025-09-01'),
('Sofia', 'Silva', 1, '2026-01-10'),
('Thomas', 'Wagner', 3, '2024-02-15');

-- Add diverse learning items (objectives AND procedures)
INSERT INTO "learning_items" ("item_type", "year_level", "title", "description", "category") VALUES
('objective', 1, 'Vital Signs', 'Accurately measure BP, pulse, and temp', 'Clinical Skills'),
('objective', 1, 'Patient Privacy', 'Maintain confidentiality and dignity', 'Ethics'),
('procedure', 1, 'Patient Hygiene', 'Assist with washing and dressing', NULL),
('objective', 2, 'Pharmacology', 'Understand common ward medications', 'Theory'),
('procedure', 2, 'IV Cannulation', 'Insert intravenous cannula safely', NULL),
('procedure', 2, 'Wound Dressing', 'Perform aseptic technique dressing', NULL),
('objective', 3, 'Team Leadership', 'Manage a small group of junior nurses', 'Management'),
('procedure', 3, 'Emergency Response', 'Lead basic life support sequence', NULL);

-- Add appointments
INSERT INTO "appointments" ("student_id", "type", "date_time", "notes") VALUES
(1, 'Morning Shift', '2026-03-12 07:00:00', 'Shadowing senior nurse'),
(2, 'Evaluation Meeting', '2026-03-15 14:00:00', 'Mid-rotation review with mentor'),
(3, 'Night Shift', '2026-03-11 21:00:00', 'Emergency Department'),
(4, 'Training Session', '2026-03-11 10:00:00', 'New ventilator equipment training'),
(5, 'Morning Shift', '2026-03-11 07:00:00', '- Orientation');

-- Add progress tracking for Anna (Student ID 1) and Max (Student ID 2)
INSERT INTO "student_progress" ("student_id", "learning_item_id", "completed", "completed_date") VALUES
(1, 1, 1, '2026-02-15'), -- Anna completed Vital Signs
(1, 3, 1, '2026-02-20'), -- Anna completed Hygiene
(2, 4, 1, '2026-01-10'), -- Max completed Pharmacology
(2, 5, 0, NULL);        -- Max started but not finished IV

-- Add initial evaluations
INSERT INTO "evaluations" ("student_id", "date", "score", "feedback") VALUES
(1, '2026-02-28', 4, 'Excellent communication with patients.'),
(2, '2026-03-01', 3, 'Good clinical knowledge, but needs to improve time management.');

--
-- COMMON QUERIES (Searching and Managing)
--

-- Find all students in Year 2
SELECT * FROM "students" WHERE "year_level" = 2;

-- Find all appointments for today (March 11th, 2026)
SELECT s.first_name, s.last_name, a.type, a.date_time
FROM "appointments" a
JOIN "students" s ON a.student_id = s.id
WHERE DATE(a.date_time) = DATE('now');

-- Find learning items for Year 1
SELECT * FROM "learning_items" WHERE "year_level" = 1 ORDER BY "item_type", "category";

-- Find all evaluations for Anna Schmidt
SELECT s.first_name, s.last_name, e.date, e.score, e.feedback
FROM "evaluations" e
JOIN "students" s ON e.student_id = s.id
WHERE s.first_name = 'Anna' AND s.last_name = 'Schmidt';

-- Check progress for Anna Schmidt
SELECT s.first_name, s.last_name, li.title, li.item_type, sp.completed
FROM "student_progress" sp
JOIN "students" s ON sp.student_id = s.id
JOIN "learning_items" li ON sp.learning_item_id = li.id
WHERE s.first_name = 'Anna' AND s.last_name = 'Schmidt';

-- Find all upcoming appointments
SELECT s.first_name, s.last_name, a.type, a.date_time
FROM "students" s
JOIN "appointments" a ON s.id = a.student_id
WHERE a.date_time >= DATETIME('now')
ORDER BY a.date_time;

-- Update a student's year level
UPDATE "students" SET "year_level" = 2 WHERE "first_name" = 'Sofia' AND "last_name" = 'Silva';

-- Delete a specific appointment
DELETE FROM "appointments" WHERE "id" = 4;
