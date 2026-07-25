/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    DECLARE @starttime DATETIME, @endtime DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
    BEGIN TRY

        SET @batch_start_time = GETDATE()
        PRINT '========================================='
        PRINT '         Loading Bronze Layer'
        PRINT '========================================='
        PRINT '-----------------------------------------'
        PRINT '       1. Loading CRM Table'
        PRINT '-----------------------------------------'

        SET @starttime = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info.....'
        TRUNCATE TABLE bronze.crm_cust_info
        PRINT '>> Inserting data into: bronze.crm_cust_info'
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\Nambhi\Course\Master Sql (Data with Baraa)\Course_Projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @endtime = GETDATE()
        PRINT ''
        PRINT '--------------------------------------------------'
        PRINT ''
        PRINT '        Load Duration: ' + CAST(DATEDIFF(second, @starttime, @endtime) as NVARCHAR) + ' seconds'
        PRINT ''
        PRINT '--------------------------------------------------'


        PRINT 'Truncate Table: bronze.crm_prd_info'
        TRUNCATE TABLE bronze.crm_prd_info
        PRINT 'Inserting data into: bronze.crm.prd.info'
        BULK INSERT bronze.crm_prd_info
        FROM 'D:\Nambhi\Course\Master Sql (Data with Baraa)\Course_Projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @endtime = GETDATE()
        PRINT ''
        PRINT '--------------------------------------------------'
        PRINT ''
        PRINT '        Load Duration: ' + CAST(DATEDIFF(second, @starttime, @endtime) as NVARCHAR) + ' seconds'
        PRINT ''
        PRINT '--------------------------------------------------'


        PRINT 'Truncate Table: bronze.crm_sales_details'
        TRUNCATE TABLE bronze.crm_sales_details
        PRINT 'Inserting data into: bronze.crm_sales_details'
        BULK INSERT bronze.crm_sales_details
        FROM 'D:\Nambhi\Course\Master Sql (Data with Baraa)\Course_Projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @endtime = GETDATE()
        PRINT ''
        PRINT '--------------------------------------------------'
        PRINT ''
        PRINT '        Load Duration: ' + CAST(DATEDIFF(second, @starttime, @endtime) as NVARCHAR) + ' seconds'
        PRINT ''
        PRINT '--------------------------------------------------'


        PRINT '-----------------------------------------'
        PRINT '       2. Loading ERP Table'
        PRINT '-----------------------------------------'

        PRINT 'Truncate Table: bronze.erp_cust_az12'
        TRUNCATE TABLE bronze.erp_cust_az12
        PRINT 'Inserting Data into: bronze.erp_cust_az12'
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\Nambhi\Course\Master Sql (Data with Baraa)\Course_Projects\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @endtime = GETDATE()
        PRINT ''
        PRINT '--------------------------------------------------'
        PRINT ''
        PRINT '        Load Duration: ' + CAST(DATEDIFF(second, @starttime, @endtime) as NVARCHAR) + ' seconds'
        PRINT ''
        PRINT '--------------------------------------------------'


        PRINT 'Truncate Table: bronze.erp_loc_a101'
        TRUNCATE TABLE bronze.erp_loc_a101
        PRINT 'Inserting Data into: bronze.erp_loc_a101'
        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\Nambhi\Course\Master Sql (Data with Baraa)\Course_Projects\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @endtime = GETDATE()
        PRINT ''
        PRINT '--------------------------------------------------'
        PRINT ''
        PRINT '        Load Duration: ' + CAST(DATEDIFF(second, @starttime, @endtime) as NVARCHAR) + ' seconds'
        PRINT ''
        PRINT '--------------------------------------------------'


        PRINT 'Truncate Table: bronze.erp_px_cat_g1v2'
        TRUNCATE TABLE bronze.erp_px_cat_g1v2
        PRINT 'Inserting Data Into: bronze.exp_px_cat_g1v2'
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\Nambhi\Course\Master Sql (Data with Baraa)\Course_Projects\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @endtime = GETDATE()
        PRINT ''
        PRINT '--------------------------------------------------'
        PRINT ''
        PRINT '        Load Duration: ' + CAST(DATEDIFF(second, @starttime, @endtime) as NVARCHAR) + ' seconds'
        PRINT ''
        PRINT '--------------------------------------------------'


        SET @batch_end_time = GETDATE()
        PRINT '=================================================='
        PRINT ' Loading Bronze Layer is Complete!'
        PRINT '     - Total Load Duration: '+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' Seconds'
        PRINT '=================================================='

    END TRY

    BEGIN CATCH

        PRINT '=========================================='
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE()
        PRINT 'Error Number: ' + CAST( ERROR_NUMBER() AS NVARCHAR)
        PRINT 'Error State: ' + CAST( ERROR_STATE() AS NVARCHAR)
        PRINT '========================================='

    END CATCH

END
