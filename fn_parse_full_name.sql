drop function parse_full_name
truncate table parse_full_name

CREATE OR REPLACE FUNCTION fn_parse_full_name(full_name_str VARCHAR(100))
RETURNS VOID AS $$
DECLARE
  last_name_str VARCHAR(60);
  suffix_str VARCHAR(60) := NULL;
  first_name_str VARCHAR(60);
  mi_str VARCHAR(60) := NULL;
  section_1 VARCHAR(60);
  section_2 VARCHAR(60);
  offset_1 int;
BEGIN
  -- Separate full name into two sections
  section_1 := trim(SPLIT_PART(trim(full_name_str), ',', 1));
  section_2 := trim(SPLIT_PART(trim(full_name_str), ',', 2));

-- Parse last name and suffix from section 1
  last_name_str := TRIM(section_1);
  
  IF POSITION(' ' in trim(section_1)) > 0 THEN
    last_name_str := trim(SPLIT_PART(trim(section_1), ' ', 1));
	
	offset_1 = POSITION(' ' in trim(section_1));
	suffix_str = trim(substring(trim(section_1) from offset_1));
	
    IF upper(trim(suffix_str)) IN ('JR', 'SR', 'II', 'III', 'IV') THEN
      suffix_str := trim(suffix_str);
    ELSE
	  last_name_str = trim(section_1);
      suffix_str := NULL;
    END IF;
  END IF;

  
  IF POSITION(' ' in trim(section_2)) > 0 THEN
  	first_name_str 	:= trim(SPLIT_PART(trim(section_2),' ', 1));
	mi_str 			:= trim(SPLIT_PART(trim(section_2),' ', 2));
  ELSE
	first_name_str := section_2;
  END IF;

  -- Insert parsed values into the table
  INSERT INTO parse_full_name (full_name, last_name, suffix, first_name, mi)
  VALUES (full_name_str, last_name_str, suffix_str, first_name_str, mi_str);
  
  /*  
	  RAISE NOTICE 'Full Name: %', full_name_str;
	  RAISE NOTICE 'Last Name: %', last_name_str;
	  RAISE NOTICE 'Suffix: %', suffix_str;
	  RAISE NOTICE 'First Name: %', first_name_str;
	  RAISE NOTICE 'Middle Initial: %', mi_str;
  */
END;
$$ LANGUAGE plpgsql;




SELECT fn_parse_full_name('Doe, John');
SELECT fn_parse_full_name('Doe, John M.');
SELECT fn_parse_full_name('Doe Sr, John');
SELECT fn_parse_full_name('Doe Sr, John M.');
select fn_parse_full_name('Garcia Lopez, Hector C')


select *
from parse_full_name

