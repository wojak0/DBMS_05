PRAGMA foreign_keys = ON;

-- 1. Remove all loans where return date is > 30 days ago
BEGIN;
DELETE FROM ausleihe WHERE julianday(CURRENT_DATE) - julianday(rueckgabe_datum) > 30;
COMMIT;

-- 2. Attempt to delete exemplar 3 (This will throw an error!)
-- DELETE FROM exemplar WHERE exemplar_id = 3;

-- 3. Successfully delete associated loans first, then delete exemplar 3
BEGIN;
DELETE FROM ausleihe WHERE exemplar_id = 3;
DELETE FROM exemplar WHERE exemplar_id = 3;
COMMIT;
