-- DATA CLEANING

SELECT *
FROM deputes_2024;

-- Create copy

CREATE TABLE deputes_staging
LIKE deputes_2024;

INSERT deputes_staging
SELECT *
FROM deputes_2024;

SELECT *
FROM deputes_staging;

-- 1. Remove duplicates 

SELECT *,
ROW_NUMBER() OVER (PARTITION BY id, nom, prenom, email) AS row_num
FROM deputes_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY id, nom, prenom, email) AS row_num
FROM deputes_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- THERE'S NO DUPLICATES


-- 2. Standardize the data

SELECT *
FROM deputes_staging;

SELECT DISTINCT commissions 
FROM deputes_staging
GROUP BY commissions;

 -- Ajouter les nouvelles colonnes pour séparer la fonction et la commission
 
ALTER TABLE deputes_staging ADD COLUMN fonction VARCHAR(255);
ALTER TABLE deputes_staging ADD COLUMN commission_2 VARCHAR(255);

-- Mettre à jour la colonne fonction

UPDATE deputes_staging
SET fonction = TRIM(SUBSTRING_INDEX(commissions, 'de la Commission', 1));

-- Mettre à jour la colonne commission
UPDATE deputes_staging
SET commission = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(commissions, 'de la Commission', -1), '.', 1));

SELECT *
FROM deputes_staging;


SELECT DISTINCT commission
FROM deputes_staging;

UPDATE deputes_staging
SET commission = CONCAT('Commission ', commission);

SELECT *
FROM deputes_staging;


-- 3. Null values or blank values


-- 4. Remove any columns or rows 

SELECT *
FROM deputes_staging;

ALTER TABLE deputes_staging
DROP COLUMN id,
DROP COLUMN commissions,
DROP COLUMN informations,
DROP COLUMN commission_2;

SELECT circonscription, COUNT(*) AS nombre_entrées
FROM deputes_staging
GROUP BY circonscription
ORDER BY 2 DESC;

SELECT commission, COUNT(*) AS nombre_entrées
FROM deputes_staging
GROUP BY commission
ORDER BY 2 DESC;

SELECT groupe_politique, COUNT(*) AS nombre_entrées
FROM deputes_staging
GROUP BY groupe_politique
ORDER BY 2 DESC;

