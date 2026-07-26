/*
  ===============================================================================
Load Data Into: silver.crm_cust_info
===============================================================================

This is an example code for how each and every table transform into final version before insertion into silver layer

Table inserting date is 'silver.crm_cust_info'

You can try transforming other table too.

*/

-- Explore table
SELECT * FROM bronze.crm_cust_info;

/*
Result:
	Issues to fixed
		1.Check for Nulls and Duplicate in Primary key and remove it
		2.Remove Leading and Trailing Spaces from String Columns
		3.Transform data into Standardize form.
*/

-- Problem 1: Check for Nulls and Duplicate in Primary key and remove it

-- Begin cleansing with primary key 'cst_id'
-- Check Null rows
SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IS NULL

/*
RESULT:
cst_id  cst_key	cst_firstname cst_lastname cst_marital_status   cst-gndr cst_create_date
NULL	SF566		NULL		NULL		NULL				NULL		NULL
NULL	PO25		NULL		NULL		NULL				NULL		NULL
NULL	13451235	NULL		NULL		NULL				NULL		NULL

	It seems that this rows doesn't have any usefull information so it's going to be excluded from the "silver.cst_cust_info"
*/

-- Identity duplicates
SELECT cst_id,
	COUNT(*) no_time_appear
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
GROUP BY cst_id
HAVING COUNT(*) > 1 
;

/* 
RESULT:

cst_id  no_time_appeared
29449	2
29473	2
29433	2
29483	2
29466	3

Mentioned cst_id's have duplicate furthur examination required.
*/

-- Examine this (29449, 29473, 29433, 29483, 29466) cst_id to find a way to remove duplicate

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IN (29449, 29473, 29433, 29483, 29466)
Order by cst_id;

/*
RESULT:

cst_id  cst_key		cst_firstname cst_lastname cst_marital_status   cst-gndr cst_create_date
29433	AW00029433	NULL			NULL		M					M			2026-01-25
29433	AW00029433	Thomas			King		M					M			2026-01-27    <- Target
29449	AW00029449	NULL			Chen		S					NULL		2026-01-25
29449	AW00029449	Laura			Chen		S					F			2026-01-26	  <- Target
.....................................
..........................
.................
more row here! only few for explaination

It seem that the duplicated rows are only a historical record of customer so we pick only lastly updated records of the customers
like I mentioned above as 'Target'
 */

 -- Exclude duplicates and Null rows from cst_id
 -- By creating flags represent more 1 are duplicates and filter null cst_id from final records

 SELECT 
 * 
 FROM 
 (
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) Flag
 FROM bronze.crm_cust_info
 WHERE cst_id IS NOT NULL 
 )t 
 WHERE Flag = 1


 -- Check for duplicate again
 WITH Clean_Data AS
 ( SELECT 
 * 
 FROM 
 (
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) Flag
 FROM bronze.crm_cust_info
 WHERE cst_id IS NOT NULL 
 )t 
 WHERE Flag = 1
 )
 SELECT cst_id, Count(*) as no_row_appeared
 FROM Clean_Data
 GROUP BY cst_id
 HAVING COUNT(*) > 1;

 /*
 Result:

 Now we have clean set of cst_id without duplicates but we still need to cleanse the data furthur.
 */

 /* ===================================  ========================== ========================== */

 -- Problem 2:Remove Leading and Trailing Spaces from String Columns

 -- Check all String column(cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr) for Leading and Trailing space
 

 SELECT 
	'cst_key' AS [Columns],
	COUNT(cst_key) AS No_unmatch
 FROM bronze.crm_cust_info
 WHERE cst_key != TRIM(cst_key)

 UNION
  
 SELECT 
	'cst_firstname',
	COUNT(cst_firstname) 
 FROM bronze.crm_cust_info
 WHERE cst_firstname != TRIM(cst_firstname)

 UNION

 SELECT
	'cst_lastname',
	COUNT(cst_lastname) 
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

UNION

 SELECT
	'cst_marital_status',
	COUNT(cst_marital_status) 
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status)

UNION

 SELECT
	'cst_gndr',
	COUNT(cst_gndr) 
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

/* 
Result:

Columns				No_unmatch
cst_key				0
cst_firstname		15
cst_lastname		17
cst_marital_status	0
cst_gndr			0

It seems that cst_firstname and cst_lastname have leading and trailing space, Let's remove them in final version
*/

-- 


 /* ===================================  ========================== ========================== */

 -- Problem 3: Transform data into Standardize form
 /*
 cst_marital_status and cst_gndr have data Standardization issue
 so let find number of unique value in them first
 */

 SELECT 
	 DISTINCT cst_marital_status AS Unique_Values, 
	 'cst_marital_status' AS [Columns] 
 FROM bronze.crm_cust_info
 UNION
 SELECT 
	 DISTINCT cst_gndr, 
	 'cst_gndr' 
 FROM bronze.crm_cust_info;

 /*
 Result:
Unique_values	Columns
 S				cst_marital_status
NULL			cst_marital_status
M				cst_marital_status
NULL			cst_gndr
F				cst_gndr
M				cst_gndr

 For cst_gndr map:
	M - Male
	F - Female
 For cst_marital_status map:
	M - Married
	s - Single

 Both have Nulls so denote nulls with n/a
*/ 

SELECT 
	CASE cst_marital_status
		WHEN 'M' THEN 'Married'
		WHEN 'S' THEN 'Single'
		ELSE 'n/a'
	END cst_marital_status,
	CASE cst_gndr
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
		ELSE 'n/a'
	END cst_marital_status
FROM bronze.crm_cust_info

-- Combine all fixed issue into a single final table 

 SELECT 
	 cst_id,
	 cst_key,
	 TRIM(cst_firstname) as cst_firstname,
	 TRIM(cst_lastname) as cst_lastname,
 	CASE cst_marital_status
		WHEN 'M' THEN 'Married'
		WHEN 'S' THEN 'Single'
		ELSE 'n/a'
	END cst_marital_status,
	CASE cst_gndr
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
		ELSE 'n/a'
	END cst_marital_status,
	cst_create_date
 FROM 
 (
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) Flag
 FROM bronze.crm_cust_info
 WHERE cst_id IS NOT NULL 
 )t 
 WHERE Flag = 1

 /* 
 Result
 Final table's first 10 rows only

cst_id  cst_key		cst_first  cst_last cst_marital cst-gndr cst_create_date
					  name		name	_status
11000	AW00011000	Jon			Yang	Married		Male	2025-10-06
11001	AW00011001	Eugene		Huang	Single		Male	2025-10-06
11002	AW00011002	Ruben		Torres	Married		Male	2025-10-06
11003	AW00011003	Christy		Zhu		Single		Female	2025-10-06
11004	AW00011004	Elizabeth	Johnson	Single		Female	2025-10-06
11005	AW00011005	Julio		Ruiz	Single		Male	2025-10-06
11006	AW00011006	Janet		Alvarez	Single		Female	2025-10-06
11007	AW00011007	Marco		Mehta	Married		Male	2025-10-06
11008	AW00011008	Rob			Verhoff	Single		Female	2025-10-06
11009	AW00011009	Shannon		Carlson	Single		Male	2025-10-06
*/

SELECT * FROM silver.crm_cust_info;

-- Insert this cleanse records into  silver.crm_cust_info table
INSERT INTO silver.crm_cust_info (cst_id,  cst_key,	cst_firstname, 
								  cst_lastname, cst_marital_status,   
								  cst_gndr, cst_create_date)
	    
 SELECT 
	 cst_id,
	 cst_key,
	 TRIM(cst_firstname) as cst_firstname,
	 TRIM(cst_lastname) as cst_lastname,
 	CASE cst_marital_status
		WHEN 'M' THEN 'Married'
		WHEN 'S' THEN 'Single'
		ELSE 'n/a'
	END cst_marital_status,
	CASE cst_gndr
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
		ELSE 'n/a'
	END cst_marital_status,
	cst_create_date
 FROM 
 (
 SELECT 
	 *,
	 ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) Flag
 FROM bronze.crm_cust_info
 WHERE cst_id IS NOT NULL 
 )t 
 WHERE Flag = 1
 
