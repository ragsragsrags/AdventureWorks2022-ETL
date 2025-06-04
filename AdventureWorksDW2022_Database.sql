USE [master]
GO
/****** Object:  Database [AdventureWorksDW2022]    Script Date: 6/4/2025 10:26:23 PM ******/
CREATE DATABASE [AdventureWorksDW2022]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AdventureWorksDW2022', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER03\MSSQL\DATA\AdventureWorksDW2022.mdf' , SIZE = 139264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AdventureWorksDW2022_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER03\MSSQL\DATA\AdventureWorksDW2022_log.ldf' , SIZE = 204800KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AdventureWorksDW2022] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AdventureWorksDW2022].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AdventureWorksDW2022] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET ANSI_NULLS ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET ANSI_PADDING ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET ARITHABORT ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AdventureWorksDW2022] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [AdventureWorksDW2022] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AdventureWorksDW2022] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AdventureWorksDW2022] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AdventureWorksDW2022] SET  MULTI_USER 
GO
ALTER DATABASE [AdventureWorksDW2022] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AdventureWorksDW2022] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AdventureWorksDW2022] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AdventureWorksDW2022] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AdventureWorksDW2022] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AdventureWorksDW2022] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'AdventureWorksDW2022', N'ON'
GO
ALTER DATABASE [AdventureWorksDW2022] SET QUERY_STORE = OFF
GO
USE [AdventureWorksDW2022]
GO
/****** Object:  Schema [Integration]    Script Date: 6/4/2025 10:26:23 PM ******/
CREATE SCHEMA [Integration]
GO
/****** Object:  UserDefinedFunction [dbo].[udfBuildISO8601Date]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ******************************************************
-- Create User Defined Functions
-- ******************************************************
-- Builds an ISO 8601 format date from a year, month, and day specified as integers.
-- This format of date should parse correctly regardless of SET DATEFORMAT and SET LANGUAGE.
-- See SQL Server Books Online for more details.
CREATE FUNCTION [dbo].[udfBuildISO8601Date] (@year int, @month int, @day int)
RETURNS datetime
AS 
BEGIN
	RETURN cast(convert(varchar, @year) + '-' + [dbo].[udfTwoDigitZeroFill](@month) 
	    + '-' + [dbo].[udfTwoDigitZeroFill](@day) + 'T00:00:00' 
	    as datetime);
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udfMinimumDate]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[udfMinimumDate] (
    @x DATETIME, 
    @y DATETIME
) RETURNS DATETIME
AS
BEGIN
    DECLARE @z DATETIME

    IF @x <= @y 
        SET @z = @x 
    ELSE 
        SET @z = @y

    RETURN(@z)
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udfTwoDigitZeroFill]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Converts the specified integer (which should be < 100 and > -1)
-- into a two character string, zero filling from the left 
-- if the number is < 10.
CREATE FUNCTION [dbo].[udfTwoDigitZeroFill] (@number int) 
RETURNS char(2)
AS
BEGIN
	DECLARE @result char(2);
	IF @number > 9 
		SET @result = convert(char(2), @number);
	ELSE
		SET @result = convert(char(2), '0' + convert(varchar, @number));
	RETURN @result;
END;
GO
/****** Object:  Table [dbo].[DimCustomer]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCustomer](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[GeographyKey] [int] NULL,
	[CustomerAlternateKey] [nvarchar](15) NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[NameStyle] [bit] NULL,
	[BirthDate] [date] NULL,
	[MaritalStatus] [nchar](1) NULL,
	[Suffix] [nvarchar](10) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[YearlyIncome] [money] NULL,
	[TotalChildren] [tinyint] NULL,
	[NumberChildrenAtHome] [tinyint] NULL,
	[EnglishEducation] [nvarchar](40) NULL,
	[SpanishEducation] [nvarchar](40) NULL,
	[FrenchEducation] [nvarchar](40) NULL,
	[EnglishOccupation] [nvarchar](100) NULL,
	[SpanishOccupation] [nvarchar](100) NULL,
	[FrenchOccupation] [nvarchar](100) NULL,
	[HouseOwnerFlag] [nchar](1) NULL,
	[NumberCarsOwned] [tinyint] NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[Phone] [nvarchar](20) NULL,
	[DateFirstPurchase] [date] NULL,
	[CommuteDistance] [nvarchar](15) NULL,
 CONSTRAINT [PK_DimCustomer_CustomerKey] PRIMARY KEY CLUSTERED 
(
	[CustomerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimDate]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDate](
	[DateKey] [int] NOT NULL,
	[FullDateAlternateKey] [date] NOT NULL,
	[DayNumberOfWeek] [tinyint] NOT NULL,
	[EnglishDayNameOfWeek] [nvarchar](10) NOT NULL,
	[SpanishDayNameOfWeek] [nvarchar](10) NOT NULL,
	[FrenchDayNameOfWeek] [nvarchar](10) NOT NULL,
	[DayNumberOfMonth] [tinyint] NOT NULL,
	[DayNumberOfYear] [smallint] NOT NULL,
	[WeekNumberOfYear] [tinyint] NOT NULL,
	[EnglishMonthName] [nvarchar](10) NOT NULL,
	[SpanishMonthName] [nvarchar](10) NOT NULL,
	[FrenchMonthName] [nvarchar](10) NOT NULL,
	[MonthNumberOfYear] [tinyint] NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarSemester] [tinyint] NOT NULL,
	[FiscalQuarter] [tinyint] NOT NULL,
	[FiscalYear] [smallint] NOT NULL,
	[FiscalSemester] [tinyint] NOT NULL,
 CONSTRAINT [PK_DimDate_DateKey] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimGeography]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimGeography](
	[GeographyKey] [int] IDENTITY(1,1) NOT NULL,
	[City] [nvarchar](30) NULL,
	[StateProvinceCode] [nvarchar](3) NULL,
	[StateProvinceName] [nvarchar](50) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[EnglishCountryRegionName] [nvarchar](50) NULL,
	[SpanishCountryRegionName] [nvarchar](50) NULL,
	[FrenchCountryRegionName] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[SalesTerritoryKey] [int] NULL,
	[IpAddressLocator] [nvarchar](15) NULL,
 CONSTRAINT [PK_DimGeography_GeographyKey] PRIMARY KEY CLUSTERED 
(
	[GeographyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimProduct]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProduct](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductAlternateKey] [nvarchar](25) NULL,
	[ProductSubcategoryKey] [int] NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[EnglishProductName] [nvarchar](50) NOT NULL,
	[SpanishProductName] [nvarchar](50) NOT NULL,
	[FrenchProductName] [nvarchar](50) NOT NULL,
	[StandardCost] [money] NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NOT NULL,
	[SafetyStockLevel] [smallint] NULL,
	[ReorderPoint] [smallint] NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](50) NULL,
	[SizeRange] [nvarchar](50) NULL,
	[Weight] [float] NULL,
	[DaysToManufacture] [int] NULL,
	[ProductLine] [nchar](2) NULL,
	[DealerPrice] [money] NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ModelName] [nvarchar](50) NULL,
	[LargePhoto] [varbinary](max) NULL,
	[EnglishDescription] [nvarchar](400) NULL,
	[FrenchDescription] [nvarchar](400) NULL,
	[ChineseDescription] [nvarchar](400) NULL,
	[ArabicDescription] [nvarchar](400) NULL,
	[HebrewDescription] [nvarchar](400) NULL,
	[ThaiDescription] [nvarchar](400) NULL,
	[GermanDescription] [nvarchar](400) NULL,
	[JapaneseDescription] [nvarchar](400) NULL,
	[TurkishDescription] [nvarchar](400) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](7) NULL,
 CONSTRAINT [PK_DimProduct_ProductKey] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimProduct_ProductAlternateKey_StartDate] UNIQUE NONCLUSTERED 
(
	[ProductAlternateKey] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimProductCategory]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProductCategory](
	[ProductCategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryAlternateKey] [int] NULL,
	[EnglishProductCategoryName] [nvarchar](50) NOT NULL,
	[SpanishProductCategoryName] [nvarchar](50) NOT NULL,
	[FrenchProductCategoryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DimProductCategory_ProductCategoryKey] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimProductCategory_ProductCategoryAlternateKey] UNIQUE NONCLUSTERED 
(
	[ProductCategoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimProductSubcategory]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProductSubcategory](
	[ProductSubcategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductSubcategoryAlternateKey] [int] NULL,
	[EnglishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[SpanishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[FrenchProductSubcategoryName] [nvarchar](50) NOT NULL,
	[ProductCategoryKey] [int] NULL,
 CONSTRAINT [PK_DimProductSubcategory_ProductSubcategoryKey] PRIMARY KEY CLUSTERED 
(
	[ProductSubcategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimProductSubcategory_ProductSubcategoryAlternateKey] UNIQUE NONCLUSTERED 
(
	[ProductSubcategoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimSalesTerritory]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesTerritory](
	[SalesTerritoryKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesTerritoryAlternateKey] [int] NULL,
	[SalesTerritoryRegion] [nvarchar](50) NOT NULL,
	[SalesTerritoryCountry] [nvarchar](50) NOT NULL,
	[SalesTerritoryGroup] [nvarchar](50) NULL,
	[SalesTerritoryImage] [varbinary](max) NULL,
 CONSTRAINT [PK_DimSalesTerritory_SalesTerritoryKey] PRIMARY KEY CLUSTERED 
(
	[SalesTerritoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimSalesTerritory_SalesTerritoryAlternateKey] UNIQUE NONCLUSTERED 
(
	[SalesTerritoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactInternetSales]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactInternetSales](
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
 CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vDMPrep]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- vDMPrep will be used as a data source by the other data mining views.  
-- Uses DW data at customer, product, day, etc. granularity and
-- gets region, model, year, month, etc.
CREATE VIEW [dbo].[vDMPrep]
AS
    SELECT
        pc.[EnglishProductCategoryName]
        ,Coalesce(p.[ModelName], p.[EnglishProductName]) AS [Model]
        ,c.[CustomerKey]
        ,s.[SalesTerritoryGroup] AS [Region]
        ,CASE
            WHEN Month(GetDate()) < Month(c.[BirthDate])
                THEN DateDiff(yy,c.[BirthDate],GetDate()) - 1
            WHEN Month(GetDate()) = Month(c.[BirthDate])
            AND Day(GetDate()) < Day(c.[BirthDate])
                THEN DateDiff(yy,c.[BirthDate],GetDate()) - 1
            ELSE DateDiff(yy,c.[BirthDate],GetDate())
        END AS [Age]
        ,CASE
            WHEN c.[YearlyIncome] < 40000 THEN 'Low'
            WHEN c.[YearlyIncome] > 60000 THEN 'High'
            ELSE 'Moderate'
        END AS [IncomeGroup]
        ,d.[CalendarYear]
        ,d.[FiscalYear]
        ,d.[MonthNumberOfYear] AS [Month]
        ,f.[SalesOrderNumber] AS [OrderNumber]
        ,f.SalesOrderLineNumber AS LineNumber
        ,f.OrderQuantity AS Quantity
        ,f.ExtendedAmount AS Amount  
    FROM
        [dbo].[FactInternetSales] f
    INNER JOIN [dbo].[DimDate] d
        ON f.[OrderDateKey] = d.[DateKey]
    INNER JOIN [dbo].[DimProduct] p
        ON f.[ProductKey] = p.[ProductKey]
    INNER JOIN [dbo].[DimProductSubcategory] psc
        ON p.[ProductSubcategoryKey] = psc.[ProductSubcategoryKey]
    INNER JOIN [dbo].[DimProductCategory] pc
        ON psc.[ProductCategoryKey] = pc.[ProductCategoryKey]
    INNER JOIN [dbo].[DimCustomer] c
        ON f.[CustomerKey] = c.[CustomerKey]
    INNER JOIN [dbo].[DimGeography] g
        ON c.[GeographyKey] = g.[GeographyKey]
    INNER JOIN [dbo].[DimSalesTerritory] s
        ON g.[SalesTerritoryKey] = s.[SalesTerritoryKey] 
;

GO
/****** Object:  View [dbo].[vTimeSeries]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- vTimeSeries view supports the creation of time series data mining models.
--      - Replaces earlier bike models with successor models.
--      - Abbreviates model names to improve readability in mining model viewer
--      - Concatenates model and region so that table only has one input.
--      - Creates a date field indexed to monthly reporting date for use in prediction.
CREATE VIEW [dbo].[vTimeSeries] 
AS
    SELECT 
        CASE [Model] 
            WHEN 'Mountain-100' THEN 'M200' 
            WHEN 'Road-150' THEN 'R250' 
            WHEN 'Road-650' THEN 'R750' 
            WHEN 'Touring-1000' THEN 'T1000' 
            ELSE Left([Model], 1) + Right([Model], 3) 
        END + ' ' + [Region] AS [ModelRegion] 
        ,(Convert(Integer, [CalendarYear]) * 100) + Convert(Integer, [Month]) AS [TimeIndex] 
        ,Sum([Quantity]) AS [Quantity] 
        ,Sum([Amount]) AS [Amount]
		,CalendarYear
		,[Month]
		,[dbo].[udfBuildISO8601Date] ([CalendarYear], [Month], 25)
		as ReportingDate
    FROM 
        [dbo].[vDMPrep] 
    WHERE 
        [Model] IN ('Mountain-100', 'Mountain-200', 'Road-150', 'Road-250', 
            'Road-650', 'Road-750', 'Touring-1000') 
    GROUP BY 
        CASE [Model] 
            WHEN 'Mountain-100' THEN 'M200' 
            WHEN 'Road-150' THEN 'R250' 
            WHEN 'Road-650' THEN 'R750' 
            WHEN 'Touring-1000' THEN 'T1000' 
            ELSE Left(Model,1) + Right(Model,3) 
        END + ' ' + [Region] 
        ,(Convert(Integer, [CalendarYear]) * 100) + Convert(Integer, [Month])
		,CalendarYear
		,[Month]
		,[dbo].[udfBuildISO8601Date] ([CalendarYear], [Month], 25);

GO
/****** Object:  View [dbo].[vTargetMail]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- vTargetMail supports targeted mailing data model
-- Uses vDMPrep to determine if a customer buys a bike and joins to DimCustomer
CREATE VIEW [dbo].[vTargetMail] 
AS
    SELECT
        c.[CustomerKey], 
        c.[GeographyKey], 
        c.[CustomerAlternateKey], 
        c.[Title], 
        c.[FirstName], 
        c.[MiddleName], 
        c.[LastName], 
        c.[NameStyle], 
        c.[BirthDate], 
        c.[MaritalStatus], 
        c.[Suffix], 
        c.[Gender], 
        c.[EmailAddress], 
        c.[YearlyIncome], 
        c.[TotalChildren], 
        c.[NumberChildrenAtHome], 
        c.[EnglishEducation], 
        c.[SpanishEducation], 
        c.[FrenchEducation], 
        c.[EnglishOccupation], 
        c.[SpanishOccupation], 
        c.[FrenchOccupation], 
        c.[HouseOwnerFlag], 
        c.[NumberCarsOwned], 
        c.[AddressLine1], 
        c.[AddressLine2], 
        c.[Phone], 
        c.[DateFirstPurchase], 
        c.[CommuteDistance], 
        x.[Region], 
        x.[Age], 
        CASE x.[Bikes] 
            WHEN 0 THEN 0 
            ELSE 1 
        END AS [BikeBuyer]
    FROM
        [dbo].[DimCustomer] c INNER JOIN (
            SELECT
                [CustomerKey]
                ,[Region]
                ,[Age]
                ,Sum(
                    CASE [EnglishProductCategoryName] 
                        WHEN 'Bikes' THEN 1 
                        ELSE 0 
                    END) AS [Bikes]
            FROM
                [dbo].[vDMPrep] 
            GROUP BY
                [CustomerKey]
                ,[Region]
                ,[Age]
            ) AS [x]
        ON c.[CustomerKey] = x.[CustomerKey]
;

GO
/****** Object:  View [dbo].[vAssocSeqOrders]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* vAssocSeqOrders supports assocation and sequence clustering data mmining models.
      - Limits data to FY2004.
      - Creates order case table and line item nested table.*/
CREATE VIEW [dbo].[vAssocSeqOrders]
AS
SELECT DISTINCT OrderNumber, CustomerKey, Region, IncomeGroup
FROM         dbo.vDMPrep
WHERE     (FiscalYear = '2013')

GO
/****** Object:  View [dbo].[vAssocSeqLineItems]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vAssocSeqLineItems]
AS
SELECT     OrderNumber, LineNumber, Model
FROM         dbo.vDMPrep
WHERE     (FiscalYear = '2013')
GO
/****** Object:  Table [dbo].[FactResellerSales]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactResellerSales](
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[ResellerKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NULL,
	[OrderQuantity] [smallint] NULL,
	[UnitPrice] [money] NULL,
	[ExtendedAmount] [money] NULL,
	[UnitPriceDiscountPct] [float] NULL,
	[DiscountAmount] [float] NULL,
	[ProductStandardCost] [money] NULL,
	[TotalProductCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[TaxAmt] [money] NULL,
	[Freight] [money] NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
 CONSTRAINT [PK_FactResellerSales_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vFactSales]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vFactSales]
AS
	SELECT
		CAST(N'Reseller' AS NVARCHAR(10)) AS [Channel]
		,CAST(RIGHT([SalesOrderNumber], (LEN([SalesOrderNumber]) - 2)) AS INT) AS [SalesOrderKey]
		,((CAST(RIGHT([SalesOrderNumber], (LEN([SalesOrderNumber]) - 2)) AS INT) * 1000) + [SalesOrderLineNumber]) AS [SalesOrderLineKey]
		,[SalesOrderNumber]
		,[SalesOrderLineNumber]
		,FRS.[ResellerKey]
		,CAST(-1 AS INT) AS [CustomerKey]
		,[ProductKey]
		,[OrderDateKey]
		,[DueDateKey]
		,[ShipDateKey]
		,[PromotionKey]
		,[CurrencyKey]
		,[SalesTerritoryKey]
		,[EmployeeKey]
		,[OrderQuantity]
		,[UnitPrice]
		,[ExtendedAmount]
		,[UnitPriceDiscountPct]
		,[DiscountAmount]
		,[ProductStandardCost]
		,[TotalProductCost]
		,[SalesAmount]
		,[TaxAmount] = FRS.TaxAmt
		,[FreightAmount] = FRS.Freight
		,[CarrierTrackingNumber]
		,[CustomerPONumber]
		,[RevisionNumber]
	FROM
		[dbo].[FactResellerSales] FRS 
	UNION ALL
	SELECT
		CAST(N'Internet' AS NVARCHAR(10)) AS [Channel]
		,CAST(RIGHT([SalesOrderNumber], (LEN([SalesOrderNumber]) - 2)) AS INT) AS [SalesOrderKey]
		,((CAST(RIGHT([SalesOrderNumber], (LEN([SalesOrderNumber]) - 2)) AS INT) * 1000) + [SalesOrderLineNumber]) AS [SalesOrderLineKey]
		,[SalesOrderNumber]
		,[SalesOrderLineNumber]
		,CAST(-1 AS INT) AS [ResellerKey]
		,FIS.[CustomerKey]
		,[ProductKey]
		,[OrderDateKey]
		,[DueDateKey]
		,[ShipDateKey]
		,[PromotionKey]
		,[CurrencyKey]
		,[SalesTerritoryKey]
		,CAST(-1 AS INT) AS [EmployeeKey]
		,[OrderQuantity]
		,[UnitPrice]
		,[ExtendedAmount]
		,[UnitPriceDiscountPct]
		,[DiscountAmount]
		,[ProductStandardCost]
		,[TotalProductCost]
		,[SalesAmount]
		,[TaxAmount] = FIS.TaxAmt
		,[FreightAmount] = FIS.Freight
		,[CarrierTrackingNumber]
		,[CustomerPONumber]
		,[RevisionNumber]
	FROM
		[dbo].[FactInternetSales] FIS 
GO
/****** Object:  Table [dbo].[DimCurrency]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCurrency](
	[CurrencyKey] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyAlternateKey] [nchar](3) NOT NULL,
	[CurrencyName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DimCurrency_CurrencyKey] PRIMARY KEY CLUSTERED 
(
	[CurrencyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactCurrencyRate]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCurrencyRate](
	[CurrencyKey] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[AverageRate] [float] NOT NULL,
	[EndOfDayRate] [float] NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_FactCurrencyRate_CurrencyKey_DateKey] PRIMARY KEY CLUSTERED 
(
	[CurrencyKey] ASC,
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vCurrencyFilter]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vCurrencyFilter]
AS
	SELECT DISTINCT
		S.CurrencyKey,
		C.CurrencyAlternateKey
	FROM 
		vFactSales S JOIN
		FactCurrencyRate FCR ON
			FCR.CurrencyKey = S.CurrencyKey AND
			FCR.DateKey = S.OrderDateKey JOIN
		DimCurrency C ON
			C.CurrencyKey = S.CurrencyKey
GO
/****** Object:  View [dbo].[vChannels]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vChannels]
AS
	SELECT
		[Channel] = 'Internet'
	UNION ALL
	SELECT
		[Channel] = 'Reseller'
GO
/****** Object:  Table [dbo].[AdventureWorksDWBuildVersion]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdventureWorksDWBuildVersion](
	[DBVersion] [nvarchar](50) NULL,
	[VersionDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatabaseLog]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseLog](
	[DatabaseLogID] [int] IDENTITY(1,1) NOT NULL,
	[PostTime] [datetime] NOT NULL,
	[DatabaseUser] [sysname] NOT NULL,
	[Event] [sysname] NOT NULL,
	[Schema] [sysname] NULL,
	[Object] [sysname] NULL,
	[TSQL] [nvarchar](max) NOT NULL,
	[XmlEvent] [xml] NOT NULL,
 CONSTRAINT [PK_DatabaseLog_DatabaseLogID] PRIMARY KEY NONCLUSTERED 
(
	[DatabaseLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimAccount]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAccount](
	[AccountKey] [int] IDENTITY(1,1) NOT NULL,
	[ParentAccountKey] [int] NULL,
	[AccountCodeAlternateKey] [int] NULL,
	[ParentAccountCodeAlternateKey] [int] NULL,
	[AccountDescription] [nvarchar](50) NULL,
	[AccountType] [nvarchar](50) NULL,
	[Operator] [nvarchar](50) NULL,
	[CustomMembers] [nvarchar](300) NULL,
	[ValueType] [nvarchar](50) NULL,
	[CustomMemberOptions] [nvarchar](200) NULL,
 CONSTRAINT [PK_DimAccount] PRIMARY KEY CLUSTERED 
(
	[AccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimDate2]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDate2](
	[DateKey] [int] NOT NULL,
	[FullDateAlternateKey] [date] NOT NULL,
 CONSTRAINT [PK_DimDate2_DateKey] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimDepartmentGroup]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDepartmentGroup](
	[DepartmentGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[ParentDepartmentGroupKey] [int] NULL,
	[DepartmentGroupName] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimDepartmentGroup] PRIMARY KEY CLUSTERED 
(
	[DepartmentGroupKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimEmployee]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimEmployee](
	[EmployeeKey] [int] IDENTITY(1,1) NOT NULL,
	[ParentEmployeeKey] [int] NULL,
	[EmployeeNationalIDAlternateKey] [nvarchar](15) NULL,
	[ParentEmployeeNationalIDAlternateKey] [nvarchar](15) NULL,
	[SalesTerritoryKey] [int] NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](50) NULL,
	[HireDate] [date] NULL,
	[BirthDate] [date] NULL,
	[LoginID] [nvarchar](256) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Phone] [nvarchar](25) NULL,
	[MaritalStatus] [nchar](1) NULL,
	[EmergencyContactName] [nvarchar](50) NULL,
	[EmergencyContactPhone] [nvarchar](25) NULL,
	[SalariedFlag] [bit] NULL,
	[Gender] [nchar](1) NULL,
	[PayFrequency] [tinyint] NULL,
	[BaseRate] [money] NULL,
	[VacationHours] [smallint] NULL,
	[SickLeaveHours] [smallint] NULL,
	[CurrentFlag] [bit] NOT NULL,
	[SalesPersonFlag] [bit] NOT NULL,
	[DepartmentName] [nvarchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Status] [nvarchar](50) NULL,
	[EmployeePhoto] [varbinary](max) NULL,
 CONSTRAINT [PK_DimEmployee_EmployeeKey] PRIMARY KEY CLUSTERED 
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimHolidaySeason]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimHolidaySeason](
	[HolidaySeasonID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimOrganization]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimOrganization](
	[OrganizationKey] [int] IDENTITY(1,1) NOT NULL,
	[ParentOrganizationKey] [int] NULL,
	[PercentageOfOwnership] [nvarchar](16) NULL,
	[OrganizationName] [nvarchar](50) NULL,
	[CurrencyKey] [int] NULL,
 CONSTRAINT [PK_DimOrganization] PRIMARY KEY CLUSTERED 
(
	[OrganizationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimPromotion]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPromotion](
	[PromotionKey] [int] IDENTITY(1,1) NOT NULL,
	[PromotionAlternateKey] [int] NULL,
	[EnglishPromotionName] [nvarchar](255) NULL,
	[SpanishPromotionName] [nvarchar](255) NULL,
	[FrenchPromotionName] [nvarchar](255) NULL,
	[DiscountPct] [float] NULL,
	[EnglishPromotionType] [nvarchar](50) NULL,
	[SpanishPromotionType] [nvarchar](50) NULL,
	[FrenchPromotionType] [nvarchar](50) NULL,
	[EnglishPromotionCategory] [nvarchar](50) NULL,
	[SpanishPromotionCategory] [nvarchar](50) NULL,
	[FrenchPromotionCategory] [nvarchar](50) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL,
 CONSTRAINT [PK_DimPromotion_PromotionKey] PRIMARY KEY CLUSTERED 
(
	[PromotionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimPromotion_PromotionAlternateKey] UNIQUE NONCLUSTERED 
(
	[PromotionAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimReseller]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimReseller](
	[ResellerKey] [int] IDENTITY(1,1) NOT NULL,
	[GeographyKey] [int] NULL,
	[ResellerAlternateKey] [nvarchar](15) NULL,
	[Phone] [nvarchar](25) NULL,
	[BusinessType] [varchar](20) NOT NULL,
	[ResellerName] [nvarchar](50) NOT NULL,
	[NumberEmployees] [int] NULL,
	[OrderFrequency] [char](1) NULL,
	[OrderMonth] [tinyint] NULL,
	[FirstOrderYear] [int] NULL,
	[LastOrderYear] [int] NULL,
	[ProductLine] [nvarchar](50) NULL,
	[AddressLine1] [nvarchar](60) NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[AnnualSales] [money] NULL,
	[BankName] [nvarchar](50) NULL,
	[MinPaymentType] [tinyint] NULL,
	[MinPaymentAmount] [money] NULL,
	[AnnualRevenue] [money] NULL,
	[YearOpened] [int] NULL,
 CONSTRAINT [PK_DimReseller_ResellerKey] PRIMARY KEY CLUSTERED 
(
	[ResellerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_DimReseller_ResellerAlternateKey] UNIQUE NONCLUSTERED 
(
	[ResellerAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimSalesReason]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesReason](
	[SalesReasonKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesReasonAlternateKey] [int] NOT NULL,
	[SalesReasonName] [nvarchar](50) NOT NULL,
	[SalesReasonReasonType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DimSalesReason_SalesReasonKey] PRIMARY KEY CLUSTERED 
(
	[SalesReasonKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimScenario]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimScenario](
	[ScenarioKey] [int] IDENTITY(1,1) NOT NULL,
	[ScenarioName] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimScenario] PRIMARY KEY CLUSTERED 
(
	[ScenarioKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimSegment]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSegment](
	[SegmentID] [int] NOT NULL,
	[SegmentName] [nvarchar](50) NOT NULL,
	[R] [bit] NOT NULL,
	[F] [bit] NOT NULL,
	[M] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactAdditionalInternationalProductDescription]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactAdditionalInternationalProductDescription](
	[ProductKey] [int] NOT NULL,
	[CultureName] [nvarchar](50) NOT NULL,
	[ProductDescription] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_FactAdditionalInternationalProductDescription_ProductKey_CultureName] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC,
	[CultureName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactCallCenter]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCallCenter](
	[FactCallCenterID] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [int] NOT NULL,
	[WageType] [nvarchar](15) NOT NULL,
	[Shift] [nvarchar](20) NOT NULL,
	[LevelOneOperators] [smallint] NOT NULL,
	[LevelTwoOperators] [smallint] NOT NULL,
	[TotalOperators] [smallint] NOT NULL,
	[Calls] [int] NOT NULL,
	[AutomaticResponses] [int] NOT NULL,
	[Orders] [int] NOT NULL,
	[IssuesRaised] [smallint] NOT NULL,
	[AverageTimePerIssue] [smallint] NOT NULL,
	[ServiceGrade] [float] NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_FactCallCenter_FactCallCenterID] PRIMARY KEY CLUSTERED 
(
	[FactCallCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_FactCallCenter_DateKey_Shift] UNIQUE NONCLUSTERED 
(
	[DateKey] ASC,
	[Shift] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactFinance]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactFinance](
	[FinanceKey] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [int] NOT NULL,
	[OrganizationKey] [int] NOT NULL,
	[DepartmentGroupKey] [int] NOT NULL,
	[ScenarioKey] [int] NOT NULL,
	[AccountKey] [int] NOT NULL,
	[Amount] [float] NOT NULL,
	[Date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactInternetSalesReason]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactInternetSalesReason](
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[SalesReasonKey] [int] NOT NULL,
 CONSTRAINT [PK_FactInternetSalesReason_SalesOrderNumber_SalesOrderLineNumber_SalesReasonKey] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC,
	[SalesReasonKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactProductInventory]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactProductInventory](
	[ProductKey] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[MovementDate] [date] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[UnitsIn] [int] NOT NULL,
	[UnitsOut] [int] NOT NULL,
	[UnitsBalance] [int] NOT NULL,
 CONSTRAINT [PK_FactProductInventory] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC,
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactResellerSalesStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactResellerSalesStaging](
	[ProductAlternateKey] [nvarchar](50) NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[ResellerAlternateKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyAlternateKey] [nvarchar](50) NOT NULL,
	[SalesTerritoryAlternateKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NULL,
	[OrderQuantity] [smallint] NULL,
	[UnitPrice] [money] NULL,
	[ExtendedAmount] [money] NULL,
	[UnitPriceDiscountPct] [float] NULL,
	[DiscountAmount] [float] NULL,
	[ProductStandardCost] [money] NULL,
	[TotalProductCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[TaxAmt] [money] NULL,
	[Freight] [money] NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
 CONSTRAINT [PK_FactResellerSalesStating_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactSalesQuota]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactSalesQuota](
	[SalesQuotaKey] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[SalesAmountQuota] [money] NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_FactSalesQuota_SalesQuotaKey] PRIMARY KEY CLUSTERED 
(
	[SalesQuotaKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactSurveyResponse]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactSurveyResponse](
	[SurveyResponseKey] [int] IDENTITY(1,1) NOT NULL,
	[DateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[ProductCategoryKey] [int] NOT NULL,
	[EnglishProductCategoryName] [nvarchar](50) NOT NULL,
	[ProductSubcategoryKey] [int] NOT NULL,
	[EnglishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_FactSurveyResponse_SurveyResponseKey] PRIMARY KEY CLUSTERED 
(
	[SurveyResponseKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewFactCurrencyRate]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewFactCurrencyRate](
	[AverageRate] [real] NULL,
	[CurrencyID] [nvarchar](3) NULL,
	[CurrencyDate] [date] NULL,
	[EndOfDayRate] [real] NULL,
	[CurrencyKey] [int] NULL,
	[DateKey] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProspectiveBuyer]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProspectiveBuyer](
	[ProspectiveBuyerKey] [int] IDENTITY(1,1) NOT NULL,
	[ProspectAlternateKey] [nvarchar](15) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[BirthDate] [datetime] NULL,
	[MaritalStatus] [nchar](1) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[YearlyIncome] [money] NULL,
	[TotalChildren] [tinyint] NULL,
	[NumberChildrenAtHome] [tinyint] NULL,
	[Education] [nvarchar](40) NULL,
	[Occupation] [nvarchar](100) NULL,
	[HouseOwnerFlag] [nchar](1) NULL,
	[NumberCarsOwned] [tinyint] NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[City] [nvarchar](30) NULL,
	[StateProvinceCode] [nvarchar](3) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[Phone] [nvarchar](20) NULL,
	[Salutation] [nvarchar](8) NULL,
	[Unknown] [int] NULL,
 CONSTRAINT [PK_ProspectiveBuyer_ProspectiveBuyerKey] PRIMARY KEY CLUSTERED 
(
	[ProspectiveBuyerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[CurrencyStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[CurrencyStaging](
	[CurrencyAlternateKey] [nvarchar](3) NOT NULL,
	[CurrencyName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[CustomerStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[CustomerStaging](
	[CustomerAlternateKey] [nvarchar](15) NOT NULL,
	[GeographyCity] [nvarchar](30) NULL,
	[GeographyPostalCode] [nvarchar](15) NULL,
	[GeographyStateProvinceCode] [nvarchar](3) NULL,
	[GeographyCountryRegionCode] [nvarchar](3) NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[NameStyle] [bit] NULL,
	[BirthDate] [date] NULL,
	[MaritalStatus] [nchar](1) NULL,
	[Suffix] [nvarchar](10) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[YearlyIncome] [money] NULL,
	[TotalChildren] [tinyint] NULL,
	[NumberChildrenAtHome] [tinyint] NULL,
	[EnglishEducation] [nvarchar](40) NULL,
	[SpanishEducation] [nvarchar](40) NULL,
	[FrenchEducation] [nvarchar](40) NULL,
	[EnglishOccupation] [nvarchar](100) NULL,
	[SpanishOccupation] [nvarchar](100) NULL,
	[FrenchOccupation] [nvarchar](100) NULL,
	[HouseOwnerFlag] [nchar](1) NULL,
	[NumberCarsOwned] [tinyint] NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[Phone] [nvarchar](20) NULL,
	[DateFirstPurchase] [date] NULL,
	[CommuteDistance] [nvarchar](15) NULL,
 CONSTRAINT [PK_CustomerStaging_CustomerAlternateKey] PRIMARY KEY CLUSTERED 
(
	[CustomerAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[DayOfWeekType]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[DayOfWeekType](
	[DayNumberOfWeek] [int] NOT NULL,
	[EnglishDayNameOfWeek] [nvarchar](50) NOT NULL,
	[SpanishDayNameOfWeek] [nvarchar](50) NOT NULL,
	[FrenchDayNameOfWeek] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DayOfWeekType_DayNumberOfWeek] PRIMARY KEY CLUSTERED 
(
	[DayNumberOfWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[EmployeeStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[EmployeeStaging](
	[EmployeeNationalIDAlternateKey] [nvarchar](15) NOT NULL,
	[ParentEmployeeNationalIDAlternateKey] [nvarchar](15) NULL,
	[SalesTerritoryAlternateKey] [int] NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](50) NULL,
	[HireDate] [date] NULL,
	[BirthDate] [date] NULL,
	[LoginID] [nvarchar](256) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Phone] [nvarchar](25) NULL,
	[MaritalStatus] [nchar](1) NULL,
	[EmergencyContactName] [nvarchar](50) NULL,
	[EmergencyContactPhone] [nvarchar](25) NULL,
	[SalariedFlag] [bit] NULL,
	[Gender] [nchar](1) NULL,
	[PayFrequency] [tinyint] NULL,
	[BaseRate] [money] NULL,
	[VacationHours] [smallint] NULL,
	[SickLeaveHours] [smallint] NULL,
	[CurrentFlag] [bit] NOT NULL,
	[SalesPersonFlag] [bit] NOT NULL,
	[DepartmentName] [nvarchar](50) NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_EmployeeStaging_EmployeeNationalIDAlternateKey] PRIMARY KEY CLUSTERED 
(
	[EmployeeNationalIDAlternateKey] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[FactCurrencyRateStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[FactCurrencyRateStaging](
	[CurrencyAlternateKey] [nvarchar](3) NOT NULL,
	[DateKey] [int] NOT NULL,
	[AverageRate] [float] NOT NULL,
	[EndOfDayRate] [float] NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_FactCurrencyRateStaging_CurrencyAlternateKey_DateKey] PRIMARY KEY CLUSTERED 
(
	[CurrencyAlternateKey] ASC,
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[FactInternetSalesReasonStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[FactInternetSalesReasonStaging](
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[SalesReasonAlternateKey] [int] NOT NULL,
 CONSTRAINT [PK_FactInternetSalesReason_SalesOrderNumber_SalesOrderLineNumber_SalesReasonKey] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC,
	[SalesReasonAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[FactInternetSalesStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[FactInternetSalesStaging](
	[ProductAlternateKey] [nvarchar](50) NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerAlternateKey] [nvarchar](50) NOT NULL,
	[PromotionAlternateKey] [int] NOT NULL,
	[CurrencyAlternateKey] [nvarchar](50) NOT NULL,
	[SalesTerritoryAlternateKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
 CONSTRAINT [PK_FactInternetSalesStaging_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[FactResellerSalesStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[FactResellerSalesStaging](
	[ProductAlternateKey] [nvarchar](50) NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[ResellerAlternateKey] [nvarchar](50) NOT NULL,
	[EmployeeNationalIDAlternateKey] [nvarchar](50) NOT NULL,
	[PromotionAlternateKey] [int] NOT NULL,
	[CurrencyAlternateKey] [nvarchar](50) NOT NULL,
	[SalesTerritoryAlternateKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NULL,
	[OrderQuantity] [smallint] NULL,
	[UnitPrice] [money] NULL,
	[ExtendedAmount] [money] NULL,
	[UnitPriceDiscountPct] [float] NULL,
	[DiscountAmount] [float] NULL,
	[ProductStandardCost] [money] NULL,
	[TotalProductCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[TaxAmt] [money] NULL,
	[Freight] [money] NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
 CONSTRAINT [PK_FactResellerSalesStating_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED 
(
	[SalesOrderNumber] ASC,
	[SalesOrderLineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[GeographyStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[GeographyStaging](
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceCode] [nvarchar](3) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[EnglishCountryRegionName] [nvarchar](50) NOT NULL,
	[SpanishCountryRegionName] [nvarchar](50) NULL,
	[FrenchCountryRegionName] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[SalesTerritoryAlternateKey] [int] NULL,
 CONSTRAINT [PK_GeographyStaging_GeographyKey] PRIMARY KEY CLUSTERED 
(
	[EnglishCountryRegionName] ASC,
	[StateProvinceName] ASC,
	[City] ASC,
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[MonthOfYearType]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[MonthOfYearType](
	[MonthNumberOfYear] [int] NOT NULL,
	[EnglishMonthName] [nvarchar](50) NOT NULL,
	[SpanishMonthName] [nvarchar](50) NOT NULL,
	[FrenchMonthName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MonthOfYearType_MonthNumberOfYear] PRIMARY KEY CLUSTERED 
(
	[MonthNumberOfYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductCategoryStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductCategoryStaging](
	[ProductCategoryAlternateKey] [int] NOT NULL,
	[EnglishProductCategoryName] [nvarchar](50) NOT NULL,
	[SpanishProductCategoryName] [nvarchar](50) NOT NULL,
	[FrenchProductCategoryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ProductCategoryStaging_ProductCategoryAlternateKey] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductStaging](
	[ProductAlternateKey] [nvarchar](25) NOT NULL,
	[ProductSubcategoryAlternateKey] [int] NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[EnglishProductName] [nvarchar](50) NOT NULL,
	[SpanishProductName] [nvarchar](50) NOT NULL,
	[FrenchProductName] [nvarchar](50) NOT NULL,
	[StandardCost] [money] NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NOT NULL,
	[SafetyStockLevel] [smallint] NULL,
	[ReorderPoint] [smallint] NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](50) NULL,
	[SizeRange] [nvarchar](50) NULL,
	[Weight] [float] NULL,
	[DaysToManufacture] [int] NULL,
	[ProductLine] [nchar](2) NULL,
	[DealerPrice] [money] NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ModelName] [nvarchar](50) NULL,
	[LargePhoto] [varbinary](max) NULL,
	[EnglishDescription] [nvarchar](400) NULL,
	[FrenchDescription] [nvarchar](400) NULL,
	[ChineseDescription] [nvarchar](400) NULL,
	[ArabicDescription] [nvarchar](400) NULL,
	[HebrewDescription] [nvarchar](400) NULL,
	[ThaiDescription] [nvarchar](400) NULL,
	[GermanDescription] [nvarchar](400) NULL,
	[JapaneseDescription] [nvarchar](400) NULL,
	[TurkishDescription] [nvarchar](400) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductSubcategoryStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductSubcategoryStaging](
	[ProductSubcategoryAlternateKey] [int] NOT NULL,
	[EnglishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[SpanishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[FrenchProductSubcategoryName] [nvarchar](50) NOT NULL,
	[ProductCategoryAlternateKey] [int] NULL,
 CONSTRAINT [PK_ProductSubcategoryStaging_ProductSubcategoryStaging] PRIMARY KEY CLUSTERED 
(
	[ProductSubcategoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[PromotionStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[PromotionStaging](
	[PromotionAlternateKey] [int] NOT NULL,
	[EnglishPromotionName] [nvarchar](255) NULL,
	[SpanishPromotionName] [nvarchar](255) NULL,
	[FrenchPromotionName] [nvarchar](255) NULL,
	[DiscountPct] [float] NULL,
	[EnglishPromotionType] [nvarchar](50) NULL,
	[SpanishPromotionType] [nvarchar](50) NULL,
	[FrenchPromotionType] [nvarchar](50) NULL,
	[EnglishPromotionCategory] [nvarchar](50) NULL,
	[SpanishPromotionCategory] [nvarchar](50) NULL,
	[FrenchPromotionCategory] [nvarchar](50) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL,
 CONSTRAINT [PK_PromotionStaging_PromotionAlternateKey] PRIMARY KEY CLUSTERED 
(
	[PromotionAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ResellerStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ResellerStaging](
	[GeographyCity] [nvarchar](30) NULL,
	[GeographyPostalCode] [nvarchar](15) NULL,
	[GeographyStateProvinceCode] [nvarchar](3) NULL,
	[GeographyCountryRegionCode] [nvarchar](3) NULL,
	[ResellerAlternateKey] [nvarchar](15) NOT NULL,
	[Phone] [nvarchar](25) NULL,
	[BusinessType] [varchar](20) NOT NULL,
	[ResellerName] [nvarchar](50) NOT NULL,
	[NumberEmployees] [int] NULL,
	[OrderFrequency] [char](1) NULL,
	[OrderMonth] [tinyint] NULL,
	[FirstOrderYear] [int] NULL,
	[LastOrderYear] [int] NULL,
	[ProductLine] [nvarchar](50) NULL,
	[AddressLine1] [nvarchar](60) NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[AnnualSales] [money] NULL,
	[BankName] [nvarchar](50) NULL,
	[MinPaymentType] [tinyint] NULL,
	[MinPaymentAmount] [money] NULL,
	[AnnualRevenue] [money] NULL,
	[YearOpened] [int] NULL,
 CONSTRAINT [PK_ResellerStaging_ResellerAlternateKey] PRIMARY KEY CLUSTERED 
(
	[ResellerAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[SalesReasonStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[SalesReasonStaging](
	[SalesReasonAlternateKey] [int] NOT NULL,
	[SalesReasonName] [nvarchar](50) NOT NULL,
	[SalesReasonReasonType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SalesReasonStaging_SalesReasonAlternateKey] PRIMARY KEY CLUSTERED 
(
	[SalesReasonAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[SalesTerritoryStaging]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[SalesTerritoryStaging](
	[SalesTerritoryAlternateKey] [int] NOT NULL,
	[SalesTerritoryRegion] [nvarchar](50) NOT NULL,
	[SalesTerritoryCountry] [nvarchar](50) NOT NULL,
	[SalesTerritoryGroup] [nvarchar](50) NULL,
 CONSTRAINT [PK_SalesTerritoryStaging_SalesTerritoryAlternateKey] PRIMARY KEY CLUSTERED 
(
	[SalesTerritoryAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [AK_DimCurrency_CurrencyAlternateKey]    Script Date: 6/4/2025 10:26:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [AK_DimCurrency_CurrencyAlternateKey] ON [dbo].[DimCurrency]
(
	[CurrencyAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_DimCustomer_CustomerAlternateKey]    Script Date: 6/4/2025 10:26:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_DimCustomer_CustomerAlternateKey] ON [dbo].[DimCustomer]
(
	[CustomerAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [AK_DimDate_FullDateAlternateKey]    Script Date: 6/4/2025 10:26:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [AK_DimDate_FullDateAlternateKey] ON [dbo].[DimDate]
(
	[FullDateAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimAccount]  WITH CHECK ADD  CONSTRAINT [FK_DimAccount_DimAccount] FOREIGN KEY([ParentAccountKey])
REFERENCES [dbo].[DimAccount] ([AccountKey])
GO
ALTER TABLE [dbo].[DimAccount] CHECK CONSTRAINT [FK_DimAccount_DimAccount]
GO
ALTER TABLE [dbo].[DimCustomer]  WITH CHECK ADD  CONSTRAINT [FK_DimCustomer_DimGeography] FOREIGN KEY([GeographyKey])
REFERENCES [dbo].[DimGeography] ([GeographyKey])
GO
ALTER TABLE [dbo].[DimCustomer] CHECK CONSTRAINT [FK_DimCustomer_DimGeography]
GO
ALTER TABLE [dbo].[DimDepartmentGroup]  WITH CHECK ADD  CONSTRAINT [FK_DimDepartmentGroup_DimDepartmentGroup] FOREIGN KEY([ParentDepartmentGroupKey])
REFERENCES [dbo].[DimDepartmentGroup] ([DepartmentGroupKey])
GO
ALTER TABLE [dbo].[DimDepartmentGroup] CHECK CONSTRAINT [FK_DimDepartmentGroup_DimDepartmentGroup]
GO
ALTER TABLE [dbo].[DimEmployee]  WITH CHECK ADD  CONSTRAINT [FK_DimEmployee_DimEmployee] FOREIGN KEY([ParentEmployeeKey])
REFERENCES [dbo].[DimEmployee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[DimEmployee] CHECK CONSTRAINT [FK_DimEmployee_DimEmployee]
GO
ALTER TABLE [dbo].[DimEmployee]  WITH CHECK ADD  CONSTRAINT [FK_DimEmployee_DimSalesTerritory] FOREIGN KEY([SalesTerritoryKey])
REFERENCES [dbo].[DimSalesTerritory] ([SalesTerritoryKey])
GO
ALTER TABLE [dbo].[DimEmployee] CHECK CONSTRAINT [FK_DimEmployee_DimSalesTerritory]
GO
ALTER TABLE [dbo].[DimGeography]  WITH CHECK ADD  CONSTRAINT [FK_DimGeography_DimSalesTerritory] FOREIGN KEY([SalesTerritoryKey])
REFERENCES [dbo].[DimSalesTerritory] ([SalesTerritoryKey])
GO
ALTER TABLE [dbo].[DimGeography] CHECK CONSTRAINT [FK_DimGeography_DimSalesTerritory]
GO
ALTER TABLE [dbo].[DimOrganization]  WITH CHECK ADD  CONSTRAINT [FK_DimOrganization_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO
ALTER TABLE [dbo].[DimOrganization] CHECK CONSTRAINT [FK_DimOrganization_DimCurrency]
GO
ALTER TABLE [dbo].[DimOrganization]  WITH CHECK ADD  CONSTRAINT [FK_DimOrganization_DimOrganization] FOREIGN KEY([ParentOrganizationKey])
REFERENCES [dbo].[DimOrganization] ([OrganizationKey])
GO
ALTER TABLE [dbo].[DimOrganization] CHECK CONSTRAINT [FK_DimOrganization_DimOrganization]
GO
ALTER TABLE [dbo].[DimProduct]  WITH CHECK ADD  CONSTRAINT [FK_DimProduct_DimProductSubcategory] FOREIGN KEY([ProductSubcategoryKey])
REFERENCES [dbo].[DimProductSubcategory] ([ProductSubcategoryKey])
GO
ALTER TABLE [dbo].[DimProduct] CHECK CONSTRAINT [FK_DimProduct_DimProductSubcategory]
GO
ALTER TABLE [dbo].[DimProductSubcategory]  WITH CHECK ADD  CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY([ProductCategoryKey])
REFERENCES [dbo].[DimProductCategory] ([ProductCategoryKey])
GO
ALTER TABLE [dbo].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory]
GO
ALTER TABLE [dbo].[DimReseller]  WITH CHECK ADD  CONSTRAINT [FK_DimReseller_DimGeography] FOREIGN KEY([GeographyKey])
REFERENCES [dbo].[DimGeography] ([GeographyKey])
GO
ALTER TABLE [dbo].[DimReseller] CHECK CONSTRAINT [FK_DimReseller_DimGeography]
GO
ALTER TABLE [dbo].[FactCallCenter]  WITH CHECK ADD  CONSTRAINT [FK_FactCallCenter_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactCallCenter] CHECK CONSTRAINT [FK_FactCallCenter_DimDate]
GO
ALTER TABLE [dbo].[FactCurrencyRate]  WITH CHECK ADD  CONSTRAINT [FK_FactCurrencyRate_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO
ALTER TABLE [dbo].[FactCurrencyRate] CHECK CONSTRAINT [FK_FactCurrencyRate_DimCurrency]
GO
ALTER TABLE [dbo].[FactCurrencyRate]  WITH CHECK ADD  CONSTRAINT [FK_FactCurrencyRate_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactCurrencyRate] CHECK CONSTRAINT [FK_FactCurrencyRate_DimDate]
GO
ALTER TABLE [dbo].[FactFinance]  WITH CHECK ADD  CONSTRAINT [FK_FactFinance_DimAccount] FOREIGN KEY([AccountKey])
REFERENCES [dbo].[DimAccount] ([AccountKey])
GO
ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimAccount]
GO
ALTER TABLE [dbo].[FactFinance]  WITH CHECK ADD  CONSTRAINT [FK_FactFinance_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimDate]
GO
ALTER TABLE [dbo].[FactFinance]  WITH CHECK ADD  CONSTRAINT [FK_FactFinance_DimDepartmentGroup] FOREIGN KEY([DepartmentGroupKey])
REFERENCES [dbo].[DimDepartmentGroup] ([DepartmentGroupKey])
GO
ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimDepartmentGroup]
GO
ALTER TABLE [dbo].[FactFinance]  WITH CHECK ADD  CONSTRAINT [FK_FactFinance_DimOrganization] FOREIGN KEY([OrganizationKey])
REFERENCES [dbo].[DimOrganization] ([OrganizationKey])
GO
ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimOrganization]
GO
ALTER TABLE [dbo].[FactFinance]  WITH CHECK ADD  CONSTRAINT [FK_FactFinance_DimScenario] FOREIGN KEY([ScenarioKey])
REFERENCES [dbo].[DimScenario] ([ScenarioKey])
GO
ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimScenario]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimCurrency]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimCustomer] FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DimCustomer] ([CustomerKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimCustomer]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimDate] FOREIGN KEY([OrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimDate1] FOREIGN KEY([DueDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate1]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimDate2] FOREIGN KEY([ShipDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate2]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimProduct]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimPromotion] FOREIGN KEY([PromotionKey])
REFERENCES [dbo].[DimPromotion] ([PromotionKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimPromotion]
GO
ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimSalesTerritory] FOREIGN KEY([SalesTerritoryKey])
REFERENCES [dbo].[DimSalesTerritory] ([SalesTerritoryKey])
GO
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimSalesTerritory]
GO
ALTER TABLE [dbo].[FactInternetSalesReason]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSalesReason_DimSalesReason] FOREIGN KEY([SalesReasonKey])
REFERENCES [dbo].[DimSalesReason] ([SalesReasonKey])
GO
ALTER TABLE [dbo].[FactInternetSalesReason] CHECK CONSTRAINT [FK_FactInternetSalesReason_DimSalesReason]
GO
ALTER TABLE [dbo].[FactInternetSalesReason]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales] FOREIGN KEY([SalesOrderNumber], [SalesOrderLineNumber])
REFERENCES [dbo].[FactInternetSales] ([SalesOrderNumber], [SalesOrderLineNumber])
GO
ALTER TABLE [dbo].[FactInternetSalesReason] CHECK CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
GO
ALTER TABLE [dbo].[FactProductInventory]  WITH CHECK ADD  CONSTRAINT [FK_FactProductInventory_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactProductInventory] CHECK CONSTRAINT [FK_FactProductInventory_DimDate]
GO
ALTER TABLE [dbo].[FactProductInventory]  WITH CHECK ADD  CONSTRAINT [FK_FactProductInventory_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO
ALTER TABLE [dbo].[FactProductInventory] CHECK CONSTRAINT [FK_FactProductInventory_DimProduct]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimCurrency]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimDate] FOREIGN KEY([OrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimDate1] FOREIGN KEY([DueDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate1]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimDate2] FOREIGN KEY([ShipDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate2]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimEmployee] FOREIGN KEY([EmployeeKey])
REFERENCES [dbo].[DimEmployee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimEmployee]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimProduct]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimPromotion] FOREIGN KEY([PromotionKey])
REFERENCES [dbo].[DimPromotion] ([PromotionKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimPromotion]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimReseller] FOREIGN KEY([ResellerKey])
REFERENCES [dbo].[DimReseller] ([ResellerKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimReseller]
GO
ALTER TABLE [dbo].[FactResellerSales]  WITH CHECK ADD  CONSTRAINT [FK_FactResellerSales_DimSalesTerritory] FOREIGN KEY([SalesTerritoryKey])
REFERENCES [dbo].[DimSalesTerritory] ([SalesTerritoryKey])
GO
ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimSalesTerritory]
GO
ALTER TABLE [dbo].[FactSalesQuota]  WITH CHECK ADD  CONSTRAINT [FK_FactSalesQuota_DimDate] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSalesQuota] CHECK CONSTRAINT [FK_FactSalesQuota_DimDate]
GO
ALTER TABLE [dbo].[FactSalesQuota]  WITH CHECK ADD  CONSTRAINT [FK_FactSalesQuota_DimEmployee] FOREIGN KEY([EmployeeKey])
REFERENCES [dbo].[DimEmployee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[FactSalesQuota] CHECK CONSTRAINT [FK_FactSalesQuota_DimEmployee]
GO
ALTER TABLE [dbo].[FactSurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_FactSurveyResponse_CustomerKey] FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DimCustomer] ([CustomerKey])
GO
ALTER TABLE [dbo].[FactSurveyResponse] CHECK CONSTRAINT [FK_FactSurveyResponse_CustomerKey]
GO
ALTER TABLE [dbo].[FactSurveyResponse]  WITH CHECK ADD  CONSTRAINT [FK_FactSurveyResponse_DateKey] FOREIGN KEY([DateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSurveyResponse] CHECK CONSTRAINT [FK_FactSurveyResponse_DateKey]
GO
/****** Object:  StoredProcedure [Integration].[CreateIntegrationTableType]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*

EXEC [Integration].[PopulateDimDateByYearRange] 2005, 2014

*/

CREATE PROCEDURE [Integration].[CreateIntegrationTableType]
AS
BEGIN
    
	SET NOCOUNT ON;

	CREATE TABLE [Integration].[DayOfWeekType2](
		[DayNumberOfWeek] [int] NOT NULL,
		[EnglishDayNameOfWeek] [nvarchar](50) NOT NULL,
		[SpanishDayNameOfWeek] [nvarchar](50) NOT NULL,
		[FrenchDayNameOfWeek] [nvarchar](50) NOT NULL,
	 CONSTRAINT [PK_DayOfWeekType2_DayNumberOfWeek] PRIMARY KEY CLUSTERED 
	(
		[DayNumberOfWeek] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	

	CREATE TABLE [Integration].[EducationType2](
		[EducationTypeID] [int] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](50) NOT NULL,
		[FrenchName] [nvarchar](50) NOT NULL,
		[SpanishName] [nvarchar](50) NOT NULL,
	 CONSTRAINT [PK_EducationType2_EducationTypeID] PRIMARY KEY CLUSTERED 
	(
		[EducationTypeID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateCurrencyStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateCurrencyStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimCurrency
	(
		CurrencyAlternateKey,
		CurrencyName
	)
	SELECT
		[CurrencyAlternateKey] = CS.CurrencyAlternateKey,
		[CurrencyName] = CS.CurrencyName
	FROM
		Integration.CurrencyStaging CS LEFT JOIN
		dbo.DimCurrency C ON
			C.CurrencyAlternateKey = CS.CurrencyAlternateKey
	WHERE 
		C.CurrencyKey IS NULL
	ORDER BY
		CS.CurrencyName

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateCustomerStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Integration].[MigrateCustomerStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimCustomer
	(
		GeographyKey,
		CustomerAlternateKey,
		Title,
		FirstName,
		MiddleName,
		LastName,
		NameStyle,
		BirthDate,
		MaritalStatus,
		Suffix,
		Gender,
		EmailAddress,
		YearlyIncome,
		TotalChildren,
		NumberChildrenAtHome,
		EnglishEducation,
		SpanishEducation,
		FrenchEducation,
		EnglishOccupation,
		SpanishOccupation,
		FrenchOccupation,
		HouseOwnerFlag,
		NumberCarsOwned,
		AddressLine1,
		AddressLine2,
		Phone,
		DateFirstPurchase,
		CommuteDistance
	)
	SELECT
		[GeographyKey] = G.GeographyKey,
		[CustomerAlternateKey] = CS.CustomerAlternateKey,
		[Title] = CS.Title,
		[FirstName] = CS.FirstName,
		[MiddleName] = CS.MiddleName,
		[LastName] = CS.LastName,
		[NameStyle] = CS.NameStyle,
		[BirthDate] = CS.BirthDate,
		[MaritalStatus] = CS.MaritalStatus,
		[Suffix] = CS.Suffix,
		[Gender] = CS.Gender,
		[EmailAddress] = CS.EmailAddress,
		[YearlyIncome] = CS.YearlyIncome,
		[TotalChildren] = CS.TotalChildren,
		[NumberChildrenAtHome] = CS.NumberChildrenAtHome,
		[EnglishEducation] = CS.EnglishEducation,
		[SpanishEducation] = CS.SpanishEducation,
		[FrenchEducation] = CS.FrenchEducation,
		[EnglishOccupation] = CS.EnglishOccupation,
		[SpanishOccupation] = CS.SpanishOccupation,
		[FrenchOccupation] = CS.FrenchOccupation,
		[HouseOwnerFlag] = CS.HouseOwnerFlag,
		[NumberCarsOwned] = CS.NumberCarsOwned,
		[AddressLine1] = CS.AddressLine1,
		[AddressLine2] = CS.AddressLine2,
		[Phone] = CS.Phone,
		[DateFirstPurchase] = CS.DateFirstPurchase,
		[CommuteDistance] = CS.CommuteDistance
	FROM
		Integration.CustomerStaging CS LEFT JOIN
		dbo.DimGeography G ON
			G.City = CS.GeographyCity AND
			G.PostalCode = CS.GeographyPostalCode AND
			G.StateProvinceCode = CS.GeographyStateProvinceCode AND
			G.CountryRegionCode = CS.GeographyCountryRegionCode LEFT JOIN
		dbo.DimCustomer C ON
			C.CustomerAlternateKey = CS.CustomerAlternateKey 
	WHERE 
		C.CustomerKey IS NULL
	ORDER BY
		CS.CustomerAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateEmployeeStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Integration].[MigrateEmployeeStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	BEGIN TRAN

	INSERT INTO dbo.DimEmployee
	(
		EmployeeNationalIDAlternateKey,
		ParentEmployeeNationalIDAlternateKey,
		SalesTerritoryKey,
		FirstName,
		LastName,
		MiddleName,
		NameStyle,
		Title,
		HireDate,
		BirthDate,
		LoginID,
		EmailAddress,
		Phone,
		MaritalStatus,
		EmergencyContactName,
		EmergencyContactPhone,
		SalariedFlag,
		Gender,
		PayFrequency,
		BaseRate,
		VacationHours,
		SickLeaveHours,
		CurrentFlag,
		SalesPersonFlag,
		DepartmentName,
		StartDate,
		EndDate,
		Status
	)
	SELECT
		[EmployeeNationalIDAlternateKey] = ES.EmployeeNationalIDAlternateKey,
		[ParentEmployeeNationalIDAlternateKey] = ES.ParentEmployeeNationalIDAlternateKey,
		[SalesTerritoryKey] = ST.SalesTerritoryKey,
		FirstName = ES.FirstName,
		[LastName] = ES.LastName,
		[MiddleName] = ES.MiddleName,
		[NameStyle] = ES.NameStyle,
		[Title] = ES.Title,
		[HireDate] = ES.HireDate,
		[BirthDate] = ES.BirthDate,
		[LoginID] = ES.LoginID,
		[EmailAddress] = ES.EmailAddress,
		[Phone] = ES.Phone,
		[MaritalStatus] = ES.MaritalStatus,
		[EmergencyContactName] = ES.EmergencyContactName,
		[EmergencyContactPhone] = ES.EmergencyContactPhone,
		[SalariedFlag] = ES.SalariedFlag,
		[Gender] = ES.Gender,
		[PayFrequency] = ES.PayFrequency,
		[BaseRate] = ES.BaseRate,
		[VacationHours] = ES.VacationHours,
		[SickLeaveHours] = ES.SickLeaveHours,
		[CurrentFlag] = ES.CurrentFlag,
		[SalesPersonFlag] = ES.SalesPersonFlag,
		[DepartmentName] = ES.DepartmentName,
		[StartDate] = ES.StartDate,
		[EndDate] = ES.EndDate,
		[Status] = ES.Status
	FROM
		Integration.EmployeeStaging ES LEFT JOIN
		dbo.DimSalesTerritory ST ON
			ST.SalesTerritoryAlternateKey = ISNULL(ES.SalesTerritoryAlternateKey, 0) LEFT JOIN
		dbo.DimEmployee E ON
			E.EmployeeNationalIDAlternateKey = ES.EmployeeNationalIDAlternateKey
	WHERE 
		E.EmployeeKey IS NULL
	ORDER BY 
		ES.HireDate

	UPDATE 
		E
	SET
		E.ParentEmployeeKey = E2.EmployeeKey
	FROM
		dbo.DimEmployee E LEFT JOIN 
		dbo.DimEmployee E2 ON
			E2.ParentEmployeeNationalIDAlternateKey = E.EmployeeNationalIDAlternateKey

	COMMIT TRAN

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateFactCurrencyRateStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Integration].[MigrateFactCurrencyRateStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.FactCurrencyRate
	(
		CurrencyKey,
		DateKey,
		AverageRate,
		EndOfDayRate,
		Date
	)
	SELECT
		[CurrencyKey] = C.CurrencyKey,
		[DateKey] = FCRS.DateKey,
		[AverageRate] = FCRS.AverageRate,
		[EndOfDayRate] = FCRS.EndOfDayRate,
		[Date] = FCRS.Date	
	FROM
		Integration.FactCurrencyRateStaging FCRS LEFT JOIN
		dbo.DimCurrency C ON
			C.CurrencyAlternateKey = FCRS.CurrencyAlternateKey LEFT JOIN
		dbo.FactCurrencyRate FCR ON
			FCR.DateKey = FCRS.DateKey AND
			FCR.CurrencyKey = C.CurrencyKey
	WHERE 
		FCR.CurrencyKey IS NULL
	ORDER BY
		FCRS.Date,
		FCRS.CurrencyAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateFactInternetSalesReasonStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateFactInternetSalesReasonStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.FactInternetSalesReason
	(
		SalesOrderNumber,
		SalesOrderLineNumber,
		SalesReasonKey
	)
	SELECT
		[SalesOrderNumber] = FISRS.SalesOrderNumber,
		[SalesOrderLineNumber] = FISRS.SalesOrderLineNumber,
		[SalesReasonKey] = SR.SalesReasonKey	
	FROM
		Integration.FactInternetSalesReasonStaging FISRS LEFT JOIN
		dbo.DimSalesReason SR ON
			SR.SalesReasonAlternateKey = FISRS.SalesReasonAlternateKey LEFT JOIN
		dbo.FactInternetSalesReason FISR ON
			FISR.SalesOrderNumber = FISRS.SalesOrderNumber AND
			FISR.SalesOrderLineNumber = FISRS.SalesOrderLineNumber
	WHERE 
		FISR.SalesOrderNumber IS NULL
	ORDER BY
		FISRS.SalesOrderNumber,
		FISRS.salesOrderLineNumber,
		FISRS.SalesReasonAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateFactInternetSalesStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Integration].[MigrateFactInternetSalesStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.FactInternetSales
	(
		ProductKey,
		OrderDateKey,
		DueDateKey,
		ShipDateKey,
		CustomerKey,
		PromotionKey,
		CurrencyKey,
		SalesTerritoryKey,
		SalesOrderNumber,
		SalesOrderLineNumber,
		RevisionNumber,
		OrderQuantity,
		UnitPrice,
		ExtendedAmount,
		UnitPriceDiscountPct,
		DiscountAmount,
		ProductStandardCost,
		TotalProductCost,
		SalesAmount,
		TaxAmt,
		Freight,
		CarrierTrackingNumber,
		CustomerPONumber,
		OrderDate,
		DueDate,
		ShipDate
	)
	SELECT DISTINCT
		[ProductKey] = P.ProductKey,
		[OrderDateKey] = FISS.OrderDateKey,
		[DueDateKey] = FISS.DueDateKey,
		[ShipDateKey] = FISS.ShipDateKey,
		[CustomerKey] = C.CustomerKey,
		[PromotionKey] = PR.PromotionKey,
		[CurrencyKey] = CR.CurrencyKey,
		[SalesTerritoryKey] = ST.SalesTerritoryKey,
		[SalesOrderNumber] = FISS.SalesOrderNumber,
		[SalesOrderLineNumber] = FISS.SalesOrderLineNumber,
		[RevisionNumber] = FISS.RevisionNumber,
		[OrderQuantity] = FISS.OrderQuantity,
		[UnitPrice] = FISS.UnitPrice,
		[ExtendedAmount] = FISS.ExtendedAmount,
		[UnitPriceDiscountPct] = FISS.UnitPriceDiscountPct,
		[DiscountAmount] = FISS.DiscountAmount,
		[ProductStandardCost] = FISS.ProductStandardCost,
		[TotalProductCost] = FISS.TotalProductCost,
		[SalesAmount] = FISS.SalesAmount,
		[TaxAmt] = FISS.TaxAmt,
		[Freight] = FISS.Freight,
		[CarrierTrackingNumber] = FISS.CarrierTrackingNumber,
		[CustomerPONumber] = FISS.CustomerPONumber,
		[OrderDate] = FISS.OrderDate,
		[DueDate] = FISS.DueDate,
		[ShipDate] = FISS.ShipDate
	FROM
		Integration.FactInternetSalesStaging FISS 
		CROSS APPLY
		(
			SELECT TOP 1
				P.ProductKey
			FROM	
				dbo.DimProduct P 
			WHERE
				P.ProductAlternateKey = FISS.ProductAlternateKey 
			ORDER BY
				P.Status DESC,
				P.StartDate DESC
		) P LEFT JOIN
		dbo.DimCustomer C ON
			C.CustomerAlternateKey = FISS.CustomerAlternateKey LEFT JOIN
		dbo.DimPromotion PR ON
			PR.PromotionAlternateKey = FISS.PromotionAlternateKey LEFT JOIN
		dbo.DimCurrency CR ON
			CR.CurrencyAlternateKey = FISS.CurrencyAlternateKey LEFT JOIN
		dbo.DimSalesTerritory ST ON
			ST.SalesTerritoryAlternateKey = FISS.SalesTerritoryAlternateKey LEFT JOIN
		dbo.FactInternetSales FIS ON
			FIS.SalesOrderNumber = FISS.SalesOrderNumber AND
			FIS.SalesOrderLineNumber = FISS.SalesOrderLineNumber
	WHERE 
		FIS.SalesOrderNumber IS NULL
	ORDER BY
		FISS.SalesOrderNumber,
		FISS.SalesOrderLineNumber

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateFactResellerSalesStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Integration].[MigrateFactResellerSalesStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.FactResellerSales
	(
		ProductKey,
		OrderDateKey,
		DueDateKey,
		ShipDateKey,
		ResellerKey,
		EmployeeKey,
		PromotionKey,
		CurrencyKey,
		SalesTerritoryKey,
		SalesOrderNumber,
		SalesOrderLineNumber,
		RevisionNumber,
		OrderQuantity,
		UnitPrice,
		ExtendedAmount,
		UnitPriceDiscountPct,
		DiscountAmount,
		ProductStandardCost,
		TotalProductCost,
		SalesAmount,
		TaxAmt,
		Freight,
		CarrierTrackingNumber,
		CustomerPONumber,
		OrderDate,
		DueDate,
		ShipDate
	)
	SELECT
		[ProductKey] = P.ProductKey,
		[OrderDateKey] = FRSS.OrderDateKey,
		[DueDateKey] = FRSS.DueDateKey,
		[ShipDateKey] = FRSS.ShipDateKey,
		[ResellerKey] = R.ResellerKey,
		[EmployeeKey] = E.EmployeeKey,
		[PromotionKey] = PR.PromotionKey,
		[CurrencyKey] = C.CurrencyKey,
		[SalesTerritoryKey] = ST.SalesTerritoryKey,
		[SalesOrderNumber] = FRSS.SalesOrderNumber,
		[SalesOrderLineNumber] = FRSS.SalesOrderLineNumber,
		[RevisionNumber] = FRSS.RevisionNumber,
		[OrderQuantity] = FRSS.OrderQuantity,
		[UnitPrice] = FRSS.UnitPrice,
		[ExtendedAmount] = FRSS.ExtendedAmount,
		[UnitPriceDiscountPct] = FRSS.UnitPriceDiscountPct,
		[DiscountAmount] = FRSS.DiscountAmount,
		[ProductStandardCost] = FRSS.ProductStandardCost,
		[TotalProductCost] = FRSS.TotalProductCost,
		[SalesAmount] = FRSS.SalesAmount,
		[TaxAmt] = FRSS.TaxAmt,
		[Freight] = FRSS.Freight,
		[CarrierTrackingNumber] = FRSS.CarrierTrackingNumber,
		[CustomerPONumber] = FRSS.CustomerPONumber,
		[OrderDate] = FRSS.OrderDate,
		[DueDate] = FRSS.DueDate,
		[ShipDate] = FRSS.ShipDate
	FROM
		Integration.FactResellerSalesStaging FRSS 
		CROSS APPLY
		(
			SELECT TOP 1
				P.ProductKey
			FROM	
				dbo.DimProduct P 
			WHERE
				P.ProductAlternateKey = FRSS.ProductAlternateKey 
			ORDER BY
				P.Status DESC,
				P.StartDate DESC
		) P LEFT JOIN
		dbo.DimReseller R ON
			R.ResellerAlternateKey = FRSS.ResellerAlternateKey
		CROSS APPLY
		(
			SELECT TOP 1
				E.EmployeeKey
			FROM
				dbo.DimEmployee E
			WHERE
				E.EmployeeNationalIDAlternateKey = FRSS.EmployeeNationalIDAlternateKey
			ORDER BY
				E.Status DESC,
				E.StartDate DESC
		) E LEFT JOIN
		dbo.DimPromotion PR ON
			PR.PromotionAlternateKey = FRSS.PromotionAlternateKey LEFT JOIN
		dbo.DimCurrency C ON
			C.CurrencyAlternateKey = FRSS.CurrencyAlternateKey LEFT JOIN
		dbo.DimSalesTerritory ST ON
			ST.SalesTerritoryAlternateKey = FRSS.SalesTerritoryAlternateKey LEFT JOIN
		dbo.FactResellerSales FRS ON
			FRS.SalesOrderNumber = FRSS.SalesOrderNumber AND
			FRS.SalesOrderLineNumber = FRSS.SalesOrderLineNumber
	WHERE 
		FRS.SalesOrderNumber IS NULL
	ORDER BY 
		FRSS.SalesOrderNumber,
		FRSS.SalesOrderLineNumber

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateGeographyStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateGeographyStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimGeography
	(
		City,
		StateProvinceCode,
		StateProvinceName,
		CountryRegionCode,
		EnglishCountryRegionName,
		SpanishCountryRegionName,
		FrenchCountryRegionName,
		PostalCode,
		SalesTerritoryKey
	)
	SELECT
		[City] = GS.City,
		[StateProvinceCode] = GS.StateProvinceCode,
		[StateProvinceName] = GS.StateProvinceName,
		[CountryRegionCode] = GS.CountryRegionCode,
		[EnglishCountryRegionName] = GS.EnglishCountryRegionName,
		[SpanishCountryRegionName] = GS.SpanishCountryRegionName,
		[FrenchCountryRegionName] = GS.FrenchCountryRegionName,
		[PostalCode] = GS.PostalCode,
		[SalesTerritoryKey] = ST.SalesTerritoryKey
	FROM
		Integration.GeographyStaging GS LEFT JOIN
		dbo.DimSalesTerritory ST ON
			ST.SalesTerritoryAlternateKey = GS.SalesTerritoryAlternateKey LEFT JOIN
		dbo.DimGeography G ON
			G.City = GS.City AND
			G.PostalCode = GS.PostalCode AND
			G.StateProvinceCode = GS.StateProvinceCode AND
			G.CountryRegionCode = GS.CountryRegionCode 
	WHERE 
		G.GeographyKey IS NULL
	ORDER BY
		GS.EnglishCountryRegionName,
		GS.StateProvinceName,
		GS.City,
		GS.PostalCode

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateProductCategoryStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Integration].[MigrateProductCategoryStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimProductCategory
	(
		ProductCategoryAlternateKey,
		EnglishProductCategoryName,
		SpanishProductCategoryName,
		FrenchProductCategoryName
	)
	SELECT 
		PSD.ProductCategoryAlternateKey,
		PSD.EnglishProductCategoryName,
		PSD.SpanishProductCategoryName,
		PSD.FrenchProductCategoryName
	FROM 
		Integration.ProductCategoryStaging PSD LEFT JOIN
		dbo.DimProductCategory PD ON 
			PD.ProductCategoryAlternateKey = PSD.ProductCategoryAlternateKey
	WHERE
		PD.ProductCategoryAlternateKey IS NULL
	ORDER BY
		PSD.ProductCategoryAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateProductStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateProductStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimProduct
	(
		ProductAlternateKey,
		ProductSubcategoryKey,
		WeightUnitMeasureCode,
		SizeUnitMeasureCode,
		EnglishProductName,
		SpanishProductName,
		FrenchProductName,
		StandardCost,
		FinishedGoodsFlag,
		Color,
		SafetyStockLevel,
		ReorderPoint,
		ListPrice,
		Size,
		SizeRange,
		Weight,
		DaysToManufacture,
		ProductLine,
		DealerPrice,
		Class,
		Style,
		ModelName,
		LargePhoto,
		EnglishDescription,
		FrenchDescription,
		ChineseDescription,
		ArabicDescription,
		HebrewDescription,
		ThaiDescription,
		GermanDescription,
		JapaneseDescription,
		TurkishDescription,
		StartDate,
		EndDate,
		Status
	)
	SELECT
		[ProductAlternateKey] = PS.ProductAlternateKey,
		[ProductSubcategoryKey] = PSC.ProductSubcategoryKey,
		[WeightUnitMeasureCode] = PS.WeightUnitMeasureCode,
		[SizeUnitMeasureCode] = PS.SizeUnitMeasureCode,
		[EnglishProductName] = PS.EnglishProductName,
		[SpanishProductName] = PS.SpanishProductName,
		[FrenchProductName] = PS.FrenchProductName,
		[StandardCost] = PS.StandardCost,
		[FinishedGoodsFlag] = PS.FinishedGoodsFlag,
		[Color] = PS.Color,
		[SafetyStockLevel] = PS.SafetyStockLevel,
		[ReorderPoint] = PS.ReorderPoint,
		[ListPrice] = PS.ListPrice,
		[Size] = PS.Size,
		[SizeRange] = PS.SizeRange,
		[Weight] = PS.Weight,
		[DaysToManufacture] = PS.DaysToManufacture,
		[ProductLine] = PS.ProductLine,
		[DealerPrice] = PS.DealerPrice,
		[Class] = PS.Class,
		[Style] = PS.Style,
		[ModelName] = PS.ModelName,
		[LargePhoto] = PS.LargePhoto,
		[EnglishDescription] = PS.EnglishDescription,
		[FrenchDescription] = PS.FrenchDescription,
		[ChineseDescription] = PS.ChineseDescription,
		[ArabicDescription] = PS.ArabicDescription,
		[HebrewDescription] = PS.HebrewDescription,
		[ThaiDescription] = PS.ThaiDescription,
		[GermanDescription] = PS.GermanDescription,
		[JapaneseDescription] = PS.JapaneseDescription,
		[TurkishDescription] = PS.TurkishDescription,
		[StartDate] = PS.StartDate,
		[EndDate] = PS.EndDate,
		[Status] = PS.Status
	FROM
		Integration.ProductStaging PS LEFT JOIN
		dbo.DimProductSubcategory PSC ON
			PSC.ProductSubcategoryAlternateKey = PS.ProductSubcategoryAlternateKey LEFT JOIN
		dbo.DimProduct P ON
			P.ProductAlternateKey = PS.ProductAlternateKey
	WHERE 
		P.ProductKey IS NULL

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateProductSubcategoryStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateProductSubcategoryStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimProductSubcategory
	(
		ProductSubcategoryAlternateKey,
		EnglishProductSubcategoryName,
		SpanishProductSubcategoryName,
		FrenchProductSubcategoryName,
		ProductCategoryKey
	)
	SELECT
		[ProductSubcategoryAlternateKey] = PST.ProductSubcategoryAlternateKey,
		[EnglishProductSubcategoryName] = PST.EnglishProductSubcategoryName,
		[SpanishProductSubcategoryName] = PST.SpanishProductSubcategoryName,
		[FrenchProductSubcategoryName] = PST.FrenchProductSubcategoryName,
		[ProductCategoryKey] = PC.ProductCategoryKey
	FROM
		Integration.ProductSubcategoryStaging PST LEFT JOIN
		dbo.DimProductCategory PC ON
			PC.ProductCategoryAlternateKey = PST.ProductCategoryAlternateKey LEFT JOIN
		dbo.DimProductSubcategory PS ON
			PS.ProductSubcategoryAlternateKey = PST.ProductSubcategoryAlternateKey
	WHERE
		PS.ProductSubcategoryKey IS NULL

END
GO
/****** Object:  StoredProcedure [Integration].[MigratePromotionStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigratePromotionStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimPromotion
	(
		PromotionAlternateKey,
		EnglishPromotionName,
		SpanishPromotionName,
		FrenchPromotionName,
		DiscountPct,
		EnglishPromotionType,
		SpanishPromotionType,
		FrenchPromotionType,
		EnglishPromotionCategory,
		SpanishPromotionCategory,
		FrenchPromotionCategory,
		StartDate,
		EndDate,
		MinQty,
		MaxQty
	)
	SELECT
		[PromotionAlternateKey] = PS.PromotionAlternateKey,
		[EnglishPromotionName] = PS.EnglishPromotionName,
		[SpanishPromotionName] = PS.SpanishPromotionName,
		[FrenchPromotionName] = PS.FrenchPromotionName,
		[DiscountPct] = PS.DiscountPct,
		[EnglishPromotionType] = PS.EnglishPromotionType,
		[SpanishPromotionType] = PS.SpanishPromotionType,
		[FrenchPromotionType] = PS.FrenchPromotionType,
		[EnglishPromotionCategory] = PS.EnglishPromotionCategory,
		[SpanishPromotionCategory] = PS.SpanishPromotionCategory,
		[FrenchPromotionCategory] = PS.FrenchPromotionCategory,
		[StartDate] = PS.StartDate,
		[EndDate] = PS.EndDate,
		[MinQty] = PS.MinQty,
		[MaxQty] = PS.MaxQty
	FROM
		Integration.PromotionStaging PS LEFT JOIN
		dbo.DimPromotion P ON
			P.PromotionAlternateKey = PS.PromotionAlternateKey
	WHERE 
		P.PromotionKey IS NULL
	ORDER BY
		PS.PromotionAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateResellerStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Integration].[MigrateResellerStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimReseller
	(
		GeographyKey,
		ResellerAlternateKey,
		Phone,
		BusinessType,
		ResellerName,
		NumberEmployees,
		OrderFrequency,
		OrderMonth,
		FirstOrderYear,
		LastOrderYear,
		ProductLine,
		AddressLine1,
		AddressLine2,
		AnnualSales,
		BankName,
		MinPaymentType,
		MinPaymentAmount,
		AnnualRevenue,
		YearOpened
	)
	SELECT
		[GeographyKey] = G.GeographyKey,
		[ResellerAlternateKey] = RS.ResellerAlternateKey,
		[Phone] = RS.Phone,
		[BusinessType] = RS.BusinessType,
		[ResellerName] = RS.ResellerName,
		[NumberEmployees] = RS.NumberEmployees,
		[OrderFrequency] = RS.OrderFrequency,
		[OrderMonth] = RS.OrderMonth,
		[FirstOrderYear] = RS.FirstOrderYear,
		[LastOrderYear] = RS.LastOrderYear,
		[ProductLine] = RS.ProductLine,
		[AddressLine1] = RS.AddressLine1,
		[AddressLine2] = RS.AddressLine2,
		[AnnualSales] = RS.AnnualSales,
		[BankName] = RS.BankName,
		[MinPaymentType] = RS.MinPaymentType,
		[MinPaymentAmount] = RS.MinPaymentAmount,
		[AnnualRevenue] = RS.AnnualRevenue,
		[YearOpened] = RS.YearOpened
	FROM
		Integration.ResellerStaging RS LEFT JOIN
		dbo.DimGeography G ON
			G.City = RS.GeographyCity AND
			G.PostalCode = RS.GeographyPostalCode AND
			G.StateProvinceCode = RS.GeographyStateProvinceCode AND
			G.CountryRegionCode = RS.GeographyCountryRegionCode LEFT JOIN
		dbo.DimReseller R ON
			R.ResellerAlternateKey = RS.ResellerAlternateKey
	WHERE 
		R.ResellerKey IS NULL
	ORDER BY 
		RS.ResellerAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateSalesReasonStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateSalesReasonStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;

	INSERT INTO dbo.DimSalesReason
	(
		SalesReasonAlternateKey,
		SalesReasonName,
		SalesReasonReasonType
	)
	SELECT
		[SalesReasonAlternateKey] = SRS.SalesReasonAlternateKey,
		[SalesReasonName] = SRS.SalesReasonName,
		[SalesReasonReasonType] = SRS.SalesReasonReasonType
	FROM
		Integration.SalesReasonStaging SRS LEFT JOIN
		dbo.DimSalesReason SR ON
			SR.SalesReasonAlternateKey = SRS.SalesReasonAlternateKey
	WHERE 
		SR.SalesReasonKey IS NULL
	ORDER BY
		SRS.SalesReasonAlternateKey

END
GO
/****** Object:  StoredProcedure [Integration].[MigrateSalesTerritoryStagingData]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[MigrateSalesTerritoryStagingData]
AS
BEGIN
    
	SET NOCOUNT ON;
	
	INSERT INTO dbo.DimSalesTerritory
	(
		[SalesTerritoryAlternateKey],
		[SalesTerritoryRegion],
		[SalesTerritoryCountry],
		[SalesTerritoryGroup]
	)
	SELECT
		[SalesTerritoryAlternateKey] = STS.SalesTerritoryAlternateKey,
		[SalesTerritoryRegion] = STS.SalesTerritoryRegion,
		[SalesTerritoryCountry] = STS.SalesTerritoryCountry,
		[SalesTerritoryGroup] = STS.SalesTerritoryGroup
	FROM
		Integration.SalesTerritoryStaging STS LEFT JOIN
		dbo.DimSalesTerritory ST ON
			ST.SalesTerritoryAlternateKey = STS.SalesTerritoryAlternateKey
	WHERE 
		ST.SalesTerritoryKey IS NULL

	UNION ALL

	SELECT
		ST0.SalesTerritoryAlternateKey,
		ST0.SalesTerritoryRegion,
		ST0.SalesTerritoryCountry,
		ST0.SalesTerritoryGroup
	FROM
		(
			SELECT
				[SalesTerritoryAlternateKey] = 0,
				[SalesTerritoryRegion] = 'NA',
				[SalesTerritoryCountry] = 'NA',
				[SalesTerritoryGroup] = 'NA'
		) ST0 LEFT JOIN
		dbo.DimSalesTerritory ST On
			ST.SalesTerritoryAlternateKey = ST0.SalesTerritoryAlternateKey
	WHERE
		ST.SalesTerritoryKey IS NULL

END
GO
/****** Object:  StoredProcedure [Integration].[PopulateDimDateByYearRange]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*

EXEC [Integration].[PopulateDimDateByYearRange] 2005, 2014

*/

CREATE PROCEDURE [Integration].[PopulateDimDateByYearRange]
(
	@StartYear INT,
	@EndYear INT
)
AS
BEGIN
    
	SET NOCOUNT ON;

	DECLARE @Dates TABLE
	(
		[DateKey] [int] NOT NULL,
		[FullDateAlternateKey] [date] NOT NULL
	)

	DECLARE @Date DATE = CAST('1/1/' + CAST(@StartYear AS NVARCHAR(4)) AS DATE)

	WHILE YEAR(@Date) <= @EndYear
	BEGIN
		
		INSERT INTO @Dates
		(
			DateKey,
			FullDateAlternateKey
		)
		VALUES
		(
			(
				(YEAR(@Date) * 10000) + 
				(MONTH(@Date) * 100) + 
				DAY(@Date)
			),
			@Date
		)


		SET @Date = DATEADD(DAY, 1, @Date)

	END


	INSERT INTO dbo.DimDate
	(
		[DateKey],
		[FullDateAlternateKey],
		[DayNumberOfWeek],
		[EnglishDayNameOfWeek],
		[SpanishDayNameOfWeek],
		[FrenchDayNameOfWeek],
		[DayNumberOfMonth],
		[DayNumberOfYear],
		[WeekNumberOfYear],
		[EnglishMonthName],
		[SpanishMonthName],
		[FrenchMonthName],
		[MonthNumberOfYear],
		[CalendarQuarter],
		[CalendarYear],
		[CalendarSemester],
		[FiscalQuarter],
		[FiscalYear],
		[FiscalSemester]
	)
	SELECT
		[DateKey] = D.DateKey,
		[FullDateAlternateKey] = D.FullDateAlternateKey,
		[DayNumberOfWeek] = DATEPART(WEEKDAY, D.FullDateAlternateKey),
		[EnglishDayNameOfWeek] = DWT.EnglishDayNameOfWeek,
		[SpanishDayNameOfWeek] = DWT.SpanishDayNameOfWeek,
		[FrenchDayNameOfWeek] = DWT.FrenchDayNameOfWeek,
		[DayNumberOfMonth] = DAY(D.FullDateAlternateKey),
		[DayNumberOfYear] = DATEPART(DAYOFYEAR, D.FullDateAlternateKey),
		[WeekNumberOfYear] = DATEPART(WEEK, D.FullDateAlternateKey),
		[EnglishMonthName] = MYT.EnglishMonthName,
		[SpanishMonthName] = MYT.SpanishMonthName,
		[FrenchMonthName] = MYT.FrenchMonthName,
		[MonthNumberOfYear] = MONTH(D.FullDateAlternateKey),
		[CalendarQuarter] = DATEPART(QUARTER, D.FullDateAlternateKey),
		[CalendarYear] = YEAR(D.FullDateAlternateKey),
		[CalendarSemester] = 
			CASE
				WHEN MONTH(D.FullDateAlternateKey) <= 6 THEN 1
				ELSE 2
			END,
		[FiscalQuarter] = 
			CASE 
				WHEN MONTH(D.FullDateAlternateKey) BETWEEN 1 AND 3 THEN 3
				WHEN MONTH(D.FullDateAlternateKey) BETWEEN 4 AND 5 THEN 4
				WHEN MONTH(D.FullDateAlternateKey) BETWEEN 7 AND 9 THEN 1
				ELSE 2
			END,
		[FiscalYear] = 
			CASE
				WHEN MONTH(D.FullDateAlternateKey) <= 6 THEN YEAR(D.FullDateAlternateKey)
				ELSE YEAR(D.FullDateAlternateKey) + 1
			END,
		[FiscalSemester] = 
			CASE
				WHEN MONTH(D.FullDateAlternateKey) <= 6 THEN 2
				ELSE 1
			END
	FROM 
		@Dates D LEFT JOIN
		Integration.DayOfWeekType DWT ON
			DWT.DayNumberOfWeek = DATEPART(WEEKDAY, D.FullDateAlternateKey) LEFT JOIN
		Integration.MonthOfYearType MYT ON
			MYT.MonthNumberOfYear = MONTH(D.FullDateAlternateKey) LEFT JOIN
		dbo.DimDate D2 ON
			D2.DateKey = D.DateKey
	WHERE
		D2.DateKey IS NULL

END
GO
/****** Object:  DdlTrigger [ddlDatabaseTriggerLog]    Script Date: 6/4/2025 10:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML;
    DECLARE @schema sysname;
    DECLARE @object sysname;
    DECLARE @eventType sysname;

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(nvarchar(max), @data);

    INSERT [dbo].[DatabaseLog] 
        (
        [PostTime], 
        [DatabaseUser], 
        [Event], 
        [Schema], 
        [Object], 
        [TSQL], 
        [XmlEvent]
        ) 
    VALUES 
        (
        GETDATE(), 
        CONVERT(sysname, CURRENT_USER), 
        @eventType, 
        CONVERT(sysname, @schema), 
        CONVERT(sysname, @object), 
        @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'), 
        @data
        );
END;
GO
DISABLE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (1, N'Sunday', N'Domingo', N'Dimanche')
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (2, N'Monday', N'Lunes', N'Lundi')
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (3, N'Tuesday', N'Martes', N'Mardi')
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (4, N'Wednesday', N'Miércoles', N'Mercredi')
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (5, N'Thursday', N'Jueves', N'Jeudi')
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (6, N'Friday', N'Viernes', N'Vendredi')
GO
INSERT [Integration].[DayOfWeekType] ([DayNumberOfWeek], [EnglishDayNameOfWeek], [SpanishDayNameOfWeek], [FrenchDayNameOfWeek]) VALUES (7, N'Saturday', N'Sábado', N'Samedi')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (1, N'January', N'Enero', N'Janvier')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (2, N'February', N'Febrero', N'Février')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (3, N'March', N'Marzo', N'Mars')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (4, N'April', N'Abril', N'Avril')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (5, N'May', N'Mayo', N'Mai')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (6, N'June', N'Junio', N'Juin')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (7, N'July', N'Julio', N'Juillet')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (8, N'August', N'Agosto', N'Août')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (9, N'September', N'Septiembre', N'Septembre')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (10, N'October', N'Octubre', N'Octobre')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (11, N'November', N'Noviembre', N'Novembre')
GO
INSERT [Integration].[MonthOfYearType] ([MonthNumberOfYear], [EnglishMonthName], [SpanishMonthName], [FrenchMonthName]) VALUES (12, N'December', N'Diciembre', N'Décembre')
GO
USE [master]
GO
ALTER DATABASE [AdventureWorksDW2022] SET  READ_WRITE 
GO