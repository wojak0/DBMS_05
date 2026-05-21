PRAGMA foreign_keys = ON;

-- 1. Change publisher 'dtv' to 'Deutscher Taschenbuch Verlag'
BEGIN;
UPDATE buch 
SET verlag = 'Deutscher Taschenbuch Verlag' 
WHERE verlag = 'dtv';
-- SELECT * FROM buch; (Used for testing during ROLLBACK phase)
COMMIT;

-- 2. Exemplar 3 returned today (Update loan 2)
BEGIN;
UPDATE ausleihe 
SET rueckgabe_datum = CURRENT_DATE 
WHERE ausleihe_id = 2;
-- SELECT * FROM ausleihe; (Used for testing during ROLLBACK phase)
COMMIT;

-- 3. Raise daily fee by 10 cents for books published before 1960
BEGIN;
UPDATE buch 
SET tagesgebuehr = tagesgebuehr + 0.10 
WHERE erscheinungsjahr < 1960;
-- SELECT * FROM buch; (Used for testing during ROLLBACK phase)
COMMIT;
