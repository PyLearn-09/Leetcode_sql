-- Steps followed to compare the point_description between old and new table. 

-- Created 2 new tables old_table and new_table with fewer rows (5000 each)
	Create table old_table (column_name type, ......) 
--  did not create a unique index since we cannot guarantee the uniqueness for a row. 
-- Imported the csv files to the newly created tables: 
	COPY employees (id, name, age, email)
	FROM '/path/to/data.csv'
	WITH CSV HEADER;
-- Checked the UTF encoding for the database 

	SELECT datname, encoding, pg_encoding_to_char(encoding) 
	FROM pg_database 
	WHERE datname = current_database();
	
--	UTF8 encoding for a specific column 

	SELECT point_description
	FROM old_table
	WHERE point_description !~ '^[\u0000-\u007F]*$'; 

--this shows if the column has any non utf8 values. 

-- If there are non-utf encoded values,convert them 
	UPDATE old_table
	SET point_descr = convert_from(convert_to(point_descr, 'UTF8'), 'UTF8')
	WHERE point_descr <> convert_from(convert_to(point_descr, 'UTF8'), 'UTF8');


-- If there are non-utf encoded values, convert them to UTF8 first. 

	UPDATE old_table
	WHERE point_descr <> convert_from(convert_to(point_descr, 'UTF8'), 'UTF8');
	SET point_descr = convert_from(convert_to(point_descr, 'UTF8'), 'UTF8')
	
-- Actual conversion script 
	
	CREATE EXTENSION IF NOT EXISTS pg_trgm;
	CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

	CREATE TABLE matched_table AS
	WITH ranked_matches AS (
		SELECT 
			o.point_descr AS old_point_descr, 
			n.point_descr AS new_point_descr,
			levenshtein(o.point_descr, n.point_descr) AS lev_distance,
			similarity(o.point_descr, n.point_descr) AS trigram_sim,
			ROW_NUMBER() OVER (
				PARTITION BY o.point_descr 
				ORDER BY similarity(o.point_descr, n.point_descr) DESC, levenshtein(o.point_descr, n.point_descr) ASC
			) AS rank,
			o.*, 
			n.*
		FROM old_table o
		CROSS JOIN new_table n
		WHERE similarity(o.point_descr, n.point_descr) > 0.4  -- Adjust this threshold for better matching
		OR levenshtein(o.point_descr, n.point_descr) < 5   -- Allow minor differences
	)
	SELECT * FROM ranked_matches WHERE rank = 1;  -- Pick best match per row
	
	
-- method that works best	(Threshold was reduced to 0.1 for best results)
	CREATE TABLE matched_table AS
	WITH ranked_matches AS (
		SELECT 
			o.point_descr AS old_point_descr, 
			n.point_descr AS new_point_descr,
			similarity(o.point_descr, n.point_descr) AS trigram_sim,
			ROW_NUMBER() OVER (
				PARTITION BY o.point_descr 
				ORDER BY similarity(o.point_descr, n.point_descr) DESC
			) AS rank,
			o.*, 
			n.*
		FROM old_table o
		LEFT JOIN new_table n  -- Only match existing values in new_table
		ON similarity(o.point_descr, n.point_descr) > 0.4  -- Adjust threshold
	)
	SELECT * FROM ranked_matches WHERE rank = 1;
	
	
-- Shell script to automate this process. 


	
	


