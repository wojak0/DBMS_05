-- ==========================================
-- Task 4a: Add a Column
-- ==========================================
ALTER TABLE mitglied ADD COLUMN telefon TEXT;

-- ==========================================
-- Task 4b: Add CHECK Constraint (The SQLite Way)
-- ==========================================
-- Note: SQLite does not support adding a CHECK constraint via ALTER TABLE. 
-- We must use the 4-step table recreation method: Create new, Copy data, Drop old, Rename.

PRAGMA foreign_keys = OFF;
BEGIN;

CREATE TABLE buch_new (
    isbn                TEXT    PRIMARY KEY,
    titel               TEXT    NOT NULL,
    erscheinungsjahr    INTEGER NOT NULL,
    verlag              TEXT    NOT NULL,
    tagesgebuehr        NUMERIC(6,2) NOT NULL CHECK (tagesgebuehr > 0),
    CONSTRAINT buch_jahr_plausibel CHECK (erscheinungsjahr BETWEEN 1450 AND 2100)
);

INSERT INTO buch_new SELECT * FROM buch;
DROP TABLE buch;
ALTER TABLE buch_new RENAME TO buch;

COMMIT;
PRAGMA foreign_keys = ON;

-- ==========================================
-- Task 4c: Change a Column Type
-- ==========================================
-- Standard SQL:
-- ALTER TABLE exemplar ALTER COLUMN standort SET DATA TYPE VARCHAR(10);

-- Limitation: SQLite does not support ALTER COLUMN to change data types.
-- Workaround (4-step method): 
-- 1. CREATE a new table with the new VARCHAR(10) data type.
-- 2. INSERT all existing data from the old table into the new table.
-- 3. DROP the old table.
-- 4. RENAME the new table to take the old table's place.

PRAGMA foreign_keys = OFF;
BEGIN;

CREATE TABLE exemplar_new (
    exemplar_id INTEGER PRIMARY KEY,
    isbn        TEXT    NOT NULL,
    standort    VARCHAR(10) NOT NULL,
    FOREIGN KEY (isbn) REFERENCES buch(isbn)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO exemplar_new SELECT * FROM exemplar;
DROP TABLE exemplar;
ALTER TABLE exemplar_new RENAME TO exemplar;

COMMIT;
PRAGMA foreign_keys = ON;
