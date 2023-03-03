--drop 		table parse_full_name
--truncate 	table parse_full_name

CREATE TABLE parse_full_name (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100),
  last_name VARCHAR(60),
  suffix VARCHAR(60),
  first_name VARCHAR(60),
  mi VARCHAR(60)
);