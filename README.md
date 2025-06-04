This is an ETL workflow on OLTP Adventureworks database to a warehouse database.  This is only the sales data (finance data is not included) and one-time only.

I'm using the 2022 version of the database sample: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms

![image](https://github.com/user-attachments/assets/412ab68b-9456-431d-b369-60cdc8fe64af)

Here are the changes:
  - For the OLTP AdventureWorks2022 database, this is the script file: AdventureWorks2022_Updates.sql
    * Added the following new integration tables.  These are mostly extra tables used for types such as country, day of week, education and etc:
        Integration.CountryRegion
        Integration.DayOfWeekType
        Integration.EducationType
        Integration.MonthOfYearType
        Integration.OccupationType
        Integration.ProductCategoryType
        Integration.ProductDescriptionType
        Integration.ProductNameType
        Integration.ProductSubcategoryType
        Integration.PromotionCategoryType
        Integration.PromotionNameType
        Integration.PromotionType
        Integration.SizeRangeType
        Integration.StoreBusinessType
    * Added the following stored procedures to retrieve data:
        Integration.GetCurrencyInserts
        Integration.GetCustomerInserts
        Integration.GetEmployeeInserts
        Integration.GetFactCurrencyRateInserts
        Integration.GetFactInternetSalesInserts
        Integration.GetFactInternetSalesReasonInserts
        Integration.GetFactResellerSalesInserts
        Integration.GetGeographyInserts
        Integration.GetProductCategoryInserts
        Integration.GetProductInserts
        Integration.GetProductSubcategoryInserts
        Integration.GetPromotionInserts
        Integration.GetResellerInserts
        Integration.GetSalesReasonInserts
        Integration.GetSalesTerritoryInserts
    * Update on this view:
        Sales.vPersonDemographics
    * Added the Integration schema
  - For DW AdventureWorksDW2022 database, this is the script file for the database including the integration changes:  AdventureWorksDW2022_Database
    * Added the following staging and type tables:
        Integration.CurrencyStaging
        Integration.CustomerStaging
        Integration.DayOfWeekType
        Integration.EmployeeStaging
        Integration.FactCurrencyRateStaging
        Integration.FactInternetSalesReasonStaging
        Integration.FactInternetSalesStaging
        Integration.FactResellerSalesStaging
        Integration.GeographyStaging
        Integration.MonthOfYearType
        Integration.ProductCategoryStaging
        Integration.ProductStaging
        Integration.ProductSubcategoryStaging
        Integration.PromotionStaging
        Integration.ResellerStaging
        Integration.SalesReasonStaging
        Integration.SalesTerritoryStaging
    * Added the staging stored procedures:
        Integration.CreateIntegrationTableType
        Integration.MigrateCurrencyStagingData
        Integration.MigrateCustomerStagingData
        Integration.MigrateEmployeeStagingData
        Integration.MigrateFactCurrencyRateStagingData
        Integration.MigrateFactInternetSalesReasonStagingData
        Integration.MigrateFactInternetSalesStagingData
        Integration.MigrateFactResellerSalesStagingData
        Integration.MigrateGeographyStagingData
        Integration.MigrateProductCategoryStagingData
        Integration.MigrateProductStagingData
        Integration.MigrateProductSubcategoryStagingData
        Integration.MigratePromotionStagingData
        Integration.MigrateResellerStagingData
        Integration.MigrateSalesReasonStagingData
        Integration.MigrateSalesTerritoryStagingData
        Integration.PopulateDimDateByYearRange
    * There may be some other databases not included
  - Created an SSIS integration package, see included project: AdventureworksDW2022.sln
