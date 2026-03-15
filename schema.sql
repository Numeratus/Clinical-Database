-- Represent nursing students on the ward
CREATE TABLE "students" (
    "id" INTEGER PRIMARY KEY,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "year_level" INTEGER NOT NULL CHECK("year_level" BETWEEN 1 AND 3),
    "start_date" NUMERIC NOT NULL DEFAULT CURRENT_DATE
);

-- Represent the learning items (objectives AND procedures)
CREATE TABLE "learning_items" (
    "id" INTEGER PRIMARY KEY,
    "item_type" TEXT NOT NULL CHECK("item_type" IN ('objective', 'procedure')),
    "year_level" INTEGER NOT NULL CHECK("year_level" BETWEEN 1 AND 3),
    "title" TEXT NOT NULL,
    "description" TEXT,
    "category" TEXT,
    CHECK(
        (item_type = 'objective' AND category IS NOT NULL) OR
        (item_type = 'procedure')
    )
);

-- Track student progress on learning items
CREATE TABLE "student_progress" (
    "id" INTEGER PRIMARY KEY,
    "student_id" INTEGER NOT NULL,
    "learning_item_id" INTEGER NOT NULL,
    "completed" INTEGER NOT NULL DEFAULT 0 CHECK("completed" IN (0, 1)),
    "completed_date" NUMERIC,
    FOREIGN KEY("student_id") REFERENCES "students"("id"),
    FOREIGN KEY("learning_item_id") REFERENCES "learning_items"("id"),
    UNIQUE("student_id", "learning_item_id")
);

-- Represent appointments (shifts, meetings, evaluation dates, etc.)
CREATE TABLE "appointments" (
    "id" INTEGER PRIMARY KEY,
    "student_id" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "date_time" NUMERIC NOT NULL,
    "notes" TEXT,
    FOREIGN KEY("student_id") REFERENCES "students"("id")
);

-- Represent student evaluations
CREATE TABLE "evaluations" (
    "id" INTEGER PRIMARY KEY,
    "student_id" INTEGER NOT NULL,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_DATE,
    "score" INTEGER NOT NULL CHECK("score" BETWEEN 1 AND 5),
    "feedback" TEXT,
    FOREIGN KEY("student_id") REFERENCES "students"("id")
);

-- Create indexes to speed common searches
CREATE INDEX "appointment_date_search" ON "appointments" ("date_time");
CREATE INDEX "appointment_student_search" ON "appointments" ("student_id");
CREATE INDEX "evaluation_student_search" ON "evaluations" ("student_id");
CREATE INDEX "learning_items_year_search" ON "learning_items" ("year_level");
CREATE INDEX "student_progress_student" ON "student_progress" ("student_id");
CREATE INDEX "student_progress_item" ON "student_progress" ("learning_item_id");
CREATE INDEX "student_year_search" ON "students" ("year_level");
