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
	DECLARE 
	@start_whole_process DATETIME,@end_whole_process DATETIME,@start_time DATETIME, @end_time DATETIME
	
	BEGIN TRY
	SET @start_whole_process = GETDATE();
	PRINT '=============================';
	PRINT 'Loading the bronze layer';
	PRINT '=============================';

	PRINT '------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '------------------------------';
	SET @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;
	PRINT '>> Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\hp\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
	FIRSTROW = 2, 
	FIELDTERMINATOR =',',
	TABLOCK    
	);
	SET @end_time=GETDATE();
	PRINT(' >>Load Duraton: '+ CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + ' seconds');
	PRINT'----------------------------------------------------------'
	SET @start_time  = GETDATE();
	PRINT '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;
	PRINT '>> Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\hp\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
	FIRSTROW = 2,  
	FIELDTERMINATOR =',',
	TABLOCK     
	);
	SET @end_time=GETDATE();
	PRINT(' >>Load Duraton: '+ CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + ' seconds');
	PRINT'----------------------------------------------------------'

	SET @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.crm_sales_details';
	
	TRUNCATE TABLE bronze.crm_sales_details;
	PRINT '>> Inserting Data Into: bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\hp\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT(' >>Load Duraton: '+ CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + ' seconds');
	PRINT'----------------------------------------------------------'

	PRINT '------------------------------';
	PRINT('Loading ERP Tables');
	PRINT '------------------------------';
	SET @start_time  = GETDATE();
	PRINT '>> Truncating Table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;
	PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\hp\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT(' >>Load Duraton: '+ CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + ' seconds');
	PRINT'----------------------------------------------------------'
	SET @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;
	PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\hp\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT(' >>Load Duraton: '+ CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + ' seconds');
	PRINT'----------------------------------------------------------'
	SET @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\hp\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
	SET @end_time=GETDATE();
	PRINT(' >>Load Duraton: '+ CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR) + ' seconds');
	PRINT'----------------------------------------------------------'
	PRINT '===================================================================='
	SET @end_whole_process = GETDATE();
	PRINT'Loading Bronze Layer Completed................';
	PRINT 'The entire batch loading process took: '+ CAST(DATEDIFF(second,@start_whole_process,@end_whole_process)AS NVARCHAR) + ' seconds';
	PRINT '===================================================================='
	END TRY
	BEGIN CATCH
	PRINT '==============================================';
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER '
	PRINT '==============================================';
	PRINT('Error Message '+ ERROR_MESSAGE());
	PRINT('Error Message '+ CAST (ERROR_NUMBER() AS NVARCHAR));
	PRINT('Error Occured at '+ CAST(ERROR_LINE() AS NVARCHAR));

	END CATCH
	
END

