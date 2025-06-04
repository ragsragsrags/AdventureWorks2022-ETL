USE [AdventureWorks2022]
GO
/****** Object:  Schema [Integration]    Script Date: 6/4/2025 10:46:59 PM ******/
CREATE SCHEMA [Integration]
GO
/****** Object:  View [Sales].[vPersonDemographics]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [Sales].[vPersonDemographics] 
AS 
SELECT 
    p.[BusinessEntityID] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        TotalPurchaseYTD[1]', 'money') AS [TotalPurchaseYTD] 
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        DateFirstPurchase[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [DateFirstPurchase] 
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        BirthDate[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [BirthDate] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        MaritalStatus[1]', 'nvarchar(1)') AS [MaritalStatus] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        YearlyIncome[1]', 'nvarchar(30)') AS [YearlyIncome] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Gender[1]', 'nvarchar(1)') AS [Gender] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        TotalChildren[1]', 'integer') AS [TotalChildren] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        NumberChildrenAtHome[1]', 'integer') AS [NumberChildrenAtHome] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Education[1]', 'nvarchar(30)') AS [Education] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Occupation[1]', 'nvarchar(30)') AS [Occupation] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        HomeOwnerFlag[1]', 'bit') AS [HomeOwnerFlag] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        NumberCarsOwned[1]', 'integer') AS [NumberCarsOwned]
	,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        CommuteDistance[1]', 'nvarchar(30)') AS [CommuteDistance]
FROM [Person].[Person] p 
CROSS APPLY p.[Demographics].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
    /IndividualSurvey') AS [IndividualSurvey](ref) 
WHERE [Demographics] IS NOT NULL;
GO
/****** Object:  Table [Integration].[CountryRegion]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[CountryRegion](
	[CountryRegionName] [nvarchar](50) NOT NULL,
	[SpanishCountryRegionName] [nvarchar](50) NOT NULL,
	[FrenchCountryRegionName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CountryRegion_CountryRegionName] PRIMARY KEY CLUSTERED 
(
	[CountryRegionName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[DayOfWeekType]    Script Date: 6/4/2025 10:46:59 PM ******/
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
/****** Object:  Table [Integration].[EducationType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[EducationType](
	[Name] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EducationType] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[MonthOfYearType]    Script Date: 6/4/2025 10:46:59 PM ******/
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
/****** Object:  Table [Integration].[OccupationType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[OccupationType](
	[Name] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OccupationType] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductCategoryType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductCategoryType](
	[Name] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ProductCategoryType] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductDescriptionType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductDescriptionType](
	[Description] [nvarchar](400) NOT NULL,
	[GermanDescription] [nvarchar](400) NOT NULL,
	[JapaneseDescription] [nvarchar](400) NOT NULL,
	[TurkishDescription] [nvarchar](400) NOT NULL,
 CONSTRAINT [PK_ProductDescriptionType] PRIMARY KEY CLUSTERED 
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductNameType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductNameType](
	[Name] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ProductNameType] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[ProductSubcategoryType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ProductSubcategoryType](
	[Name] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ProductSubcategoryType] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[PromotionCategoryType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[PromotionCategoryType](
	[Name] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PromotionCategoryType_Name] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[PromotionNameType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[PromotionNameType](
	[Name] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PromotionNameType_Name] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[PromotionType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[PromotionType](
	[Name] [nvarchar](50) NOT NULL,
	[SpanishName] [nvarchar](50) NOT NULL,
	[FrenchName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PromotionType_Name] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[SizeRangeType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[SizeRangeType](
	[Size] [nvarchar](50) NOT NULL,
	[SizeRange] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SizeRangeType_Size] PRIMARY KEY CLUSTERED 
(
	[Size] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Integration].[StoreBusinessType]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[StoreBusinessType](
	[StoreBusinessTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_StoreBusinessType_StoreBusinessTypeID] PRIMARY KEY CLUSTERED 
(
	[StoreBusinessTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [Integration].[CountryRegion] ([CountryRegionName], [SpanishCountryRegionName], [FrenchCountryRegionName]) VALUES (N'Australia', N'Australia', N'Australie')
GO
INSERT [Integration].[CountryRegion] ([CountryRegionName], [SpanishCountryRegionName], [FrenchCountryRegionName]) VALUES (N'Canada', N'Canada', N'Canada')
GO
INSERT [Integration].[CountryRegion] ([CountryRegionName], [SpanishCountryRegionName], [FrenchCountryRegionName]) VALUES (N'France', N'Francia', N'France')
GO
INSERT [Integration].[CountryRegion] ([CountryRegionName], [SpanishCountryRegionName], [FrenchCountryRegionName]) VALUES (N'Germany', N'Alemania', N'Allemagne')
GO
INSERT [Integration].[CountryRegion] ([CountryRegionName], [SpanishCountryRegionName], [FrenchCountryRegionName]) VALUES (N'United Kingdom', N'Reino Unido', N'Royaume-Uni')
GO
INSERT [Integration].[CountryRegion] ([CountryRegionName], [SpanishCountryRegionName], [FrenchCountryRegionName]) VALUES (N'United States', N'Estados Unidos', N'États-Unis')
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
INSERT [Integration].[EducationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bachelors', N'Bac + 4', N'Licenciatura')
GO
INSERT [Integration].[EducationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Graduate Degree', N'Bac + 3', N'Estudios de postgrado')
GO
INSERT [Integration].[EducationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'High School', N'Bac + 2', N'Educación secundaria')
GO
INSERT [Integration].[EducationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Partial College', N'Baccalauréat', N'Estudios universitarios (en curso)')
GO
INSERT [Integration].[EducationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Partial High School', N'Niveau bac', N'Educación secundaria (en curso)')
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
INSERT [Integration].[OccupationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Clerical', N'Employé', N'Administrativo')
GO
INSERT [Integration].[OccupationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Management', N'Direction', N'Gestión')
GO
INSERT [Integration].[OccupationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Manual', N'Ouvrier', N'Obrero')
GO
INSERT [Integration].[OccupationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Professional', N'Cadre', N'Profesional')
GO
INSERT [Integration].[OccupationType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Skilled Manual', N'Technicien', N'Obrero especializado')
GO
INSERT [Integration].[ProductCategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Accessories', N'Accessoire', N'Accesorio')
GO
INSERT [Integration].[ProductCategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bikes', N'Vélo', N'Bicicleta')
GO
INSERT [Integration].[ProductCategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Clothing', N'Vêtements', N'Prenda')
GO
INSERT [Integration].[ProductCategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Components', N'Composant', N'Componente')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'A light yet stiff aluminum bar for long distance riding.', N'Leichtes und stabiles Aluminium für Langstrecken.', N'長距離ライディングに対応する軽量かつ高剛性のアルミニウム バー。', N'Uzun mesafe sürüş için hafif ancak sert alüminyum boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'A stable pedal for all-day riding.', N'Ein stabiles Tretwerk für Fahrvergnügen den ganzen Tag.', N'長時間走行をサポートする安定したペダル。', N'Tüm gün sürüş için sağlam pedal.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'A true multi-sport bike that offers streamlined riding and a revolutionary design. Aerodynamic design lets you ride with the pros, and the gearing will conquer hilly roads.', N'Ein vielseitiges und windschnittiges Sportfahrrad mit einem revolutionären Design. Fahren Sie wie ein Profi mit dem aerodynamischen Design und der erstklassigen Gangschaltung für hügelige Strecken.', N'滑らかな乗り心地と革命的なデザインを提供する真のマルチスポーツ バイク。空気力学的なデザインにより、プロの乗り心地と、起伏の激しい道も克服するギアを提供します。', N'Akıcı sürüş ve çığır açıcı bir tasarım sunan gerçek bir çok amaçlı spor bisikleti. Aerodinamik tasarımı profesyonellerle sürmenize olanak verir ve vitesleri tepeleri fetheder.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Aerodynamic rims for smooth riding.', N'Aerodynamische Felgen für ein geschmeidiges Fahrerlebnis.', N'滑らかな乗り心地を約束する空気力学的なリム。', N'Akıcı sürüş için aerodinamik jantlar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Affordable light for safe night riding - uses 3 AAA batteries', N'Kostengünstiges Licht für sicheres Fahren bei Nacht - mit 3 AAA-Batterien', N'安全な夜間走行をサポートする低価格のライト (単 4 電池を 3 つ使用)。', N'"Güvenli gece sürüşü için ekonomik far, 3 adet AAA pil kullanır"')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'All-occasion value bike with our basic comfort and safety features. Offers wider, more stable tires for a ride around town or weekend trip.', N'"Ein günstiges Allzweckfahrrad mit Basiskomfort und -sicherheit. Die breiten, stabilen Reifen sind ideal für die Stadt und Wochenendausflüge."', N'ベーシックな快適性と安全性を備えた、多目的で手軽な自転車。街中での走行および週末の小旅行用に幅の広い安定したタイヤを提供します。', N'Temel konfor ve güvenlik özellikleriyle her yerde kullanabileceğiniz değerli bir bisiklet. Şehirde sürüş veya hafta sonu yolculukları için daha geniş ve sağlam tekerlekler.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'All-purpose bar for on or off-road.', N'Allzweckrad für Straße und Gelände.', N'オンロードおよびオフロード用の多目的バー。', N'Yol ve arazi kullanımı için çok amaçlı boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Alluminum-alloy frame provides a light, stiff ride, whether you are racing in the velodrome or on a demanding club ride on country roads.', N'Der Rahmen aus Aluminiumlegierung bietet leichtes und stabiles Fahrvergnügen - ob im Velodrom oder auf Landstraßen.', N'レース トラックの走行でもオフロードのツーリングでも、アルミニウム合金のフレームにより、軽さと剛性を備えた乗り心地を提供します。', N'"Alüminyum alaşımı kadro, ister velodromda yarış yapın, ister köy yollarında zorlu takım sürüşlerine katılın hafif ve sağlam bir sürüş deneyimi sunar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'All-weather brake pads; provides superior stopping by applying more surface to the rim.', N'Allwetter-Bremsbeläge für erstklassiges Bremsen durch mehr Reibung auf der Felge.', N'全天候型ブレーキ パッドを採用し、リムに広い表面積を適用することにより優れた制動力を提供します。', N'"Tüm hava durumlarına uygun fren pedleri, jantın daha büyük bir yüzeyine uygulanarak çok güçlü durdurma sağlar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Aluminum alloy cups and a hollow axle.', N'Außenringe aus Aluminiumlegierung und hohle Achse.', N'アルミニウム合金カップとホロー アクスル。', N'Alüminyum alaşımı orta göbekler ve içi boş aks.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Aluminum alloy cups; large diameter spindle.', N'Außenringe aus Aluminiumlegierung; Radachse mit großem Durchmesser.', N'アルミニウム合金カップ、大径スピンドル。', N'Alüminyum alaşımı orta göbekler; geniş çaplı mil.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Aluminum alloy rim with stainless steel spokes; built for speed.', N'Felge aus Aluminiumlegierung mit Speichen aus Edelstahl für ultimative Geschwindigkeit.', N'高速走行用のステンレス製スポークを備えたアルミニウム合金リム。', N'Paslanmaz çelik telli alüminyum alaşımı jantlar hız için üretildi.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Aluminum cage is lighter than our mountain version; perfect for long distance trips.', N'Aluminiumrahmen ist leichter als unsere Mountain-Version; perfekt für Langstrecken.', N'アルミニウム ケージは、当社のマウンテン バージョンより軽量で、ツーリングに最適です。', N'Alüminyum kafes dağ modelimizdekinden daha hafiftir ve uzun mesafeli yolculuklar için idealdir.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Anatomic design for a full-day of riding in comfort. Durable leather.', N'Anatomisches Design für komfortables Fahrvergnügen den ganzen Tag. Widerstandsfähiges Leder.', N'1 日中乗っても快適なアナトミック デザインで、耐久性のある皮製。', N'Tüm gün konforlu sürüş için anatomik tasarım. Dayanıklı deri.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Anatomically shaped aluminum tube bar will suit all riders.', N'Die anatomisch geformte Rohrstange ist für jeden Fahrer geeignet.', N'アナトミック形状のアルミニウム チューブ バーで、どのような乗り手にも適合します。', N'Anatomik biçimli alüminyum boru tüm sürücüler için uygundur.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'AWC logo water bottle - holds 30 oz; leak-proof.', N'Wasserflasche mit AWC-Logo - 880 ml; auslaufsicher.', N'AWC ロゴ入りの水筒 - 容量 30 オンス、漏れ防止。', N'"AWC logolu matara - 0,9 litre; sızdırmaz."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Carries 4 bikes securely; steel construction, fits 2" receiver hitch.', N'"Sicherer Transport von 4 Fahrrädern; Stahlkonstruktion, passt in 2-Zoll-Kupplung."', N'4 台の自転車を安全に積載、スチール構造、2 インチ レシーバ ヒッチ用。', N'"4 bisikleti güvenli bir şekilde taşır, çelik konstrüksiyon, 2'''' çekiye sabitlenebilir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Chromoly steel.', N'Chromstahl.', N'クロム鋼。', N'Kromoli çelik.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Clipless pedals - aluminum.', N'Pedale ohne Pedalhaken - Aluminium.', N'クリップレス ペダル (アルミニウム)。', N'Klipssiz pedallar - alüminyum.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Clip-on fenders fit most mountain bikes.', N'Schutzbleche zum Aufstecken passen auf fast alle Mountainbikes.', N'クリップオン式フェンダーは、ほとんどのマウンテン バイクに適合します。', N'Klipsli çamurluklar çoğu dağ bisikletine uyar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Combination of natural and synthetic fibers stays dry and provides just the right cushioning.', N'Die Kombination aus natürlichen und synthetischen Fasern bleibt trocken und bietet genau die richtige Federung.', N'天然および合成繊維の組み合わせにより、湿気を防ぎ、適切な緩衝材を提供します。', N'Doğal ve sentetik fiber karışımı kuru kalır ve tam istenen yumuşaklığı sağlar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Comfortable, ergonomically shaped gel saddle.', N'Komfortabler Gelsattel mit ergonomischer Form.', N'快適なエルゴノミック形状のジェル製サドル。', N'"Konforlu, ergonomik biçimli jel sele."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Comparible traction, less expensive wire bead casing.', N'"Vergleichbare Beschleunigung, günstigerer Mantel."', N'優れたトラクション、低価格ワイヤ ビード ケーシング。', N'"Benzer yol tutuşu, daha ucuz tel başları."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Composite road fork with an aluminum steerer tube.', N'Gabel für die Straße mit Aluminium-Lenkerrohr.', N'アルミニウム製ステアリング チューブを備えたコンポジット ロード フォーク。', N'Alüminyum gidon boğazlı kompozit maşa.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Conventional all-purpose tube.', N'Gängiger Allzweckschlauch.', N'従来型の多目的チューブ。', N'Klasik çok amaçlı boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Cross-train, race, or just socialize on a sleek, aerodynamic bike designed for a woman.  Advanced seat technology provides comfort all day.', N'"Ein schlankes, aerodynamisches Fahrrad für die Frau für Crosstraining, Touren und Stadt. Komfort den ganzen Tag durch ergonomischen Sattel."', N'空気力学に基づいて設計された優美な女性用自転車で、クロス トレーニングや競技にも、街乗りにもお使いいただけます。高度なシート技術で 1 日中快適さを保証します。', N'"Kadınlar için tasarlanan bu şık ve aerodinamik bisikletle kros yapın, yarışın veya yalnızca sosyalleşin.  Gelişmiş sele teknolojisi tüm gün konfor sağlar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Cut-out shell for a more comfortable ride.', N'Ausgeschnittene Form für komfortableres Fahren.', N'より快適な乗り心地のためのカット アウト シェル。', N'Daha konforlu bir sürüş için özel sele kaplaması.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Designed for convenience. Fits in your pocket. Aluminum barrel. 160psi rated.', N'Komfortables Design. Passt in Ihre Tasche. Aluminiumrohr. 11 Bar.', N'便利さを追求したデザインで、ポケットに入るアルミバレル (最大 160 psi)。 ', N'Rahatlık için tasarlandı. Cebinize sığar. Alüminyum varil. 160 psi basınç.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Designed for racers; high-end anatomically shaped bar from aluminum alloy.', N'Konzipiert für Rennfahrer; anatomisch geformte Stange aus Aluminiumlegierung.', N'レーサー用に設計された、高性能なアナトミック形状のアルミニウム合金バー。', N'Yarışçılar için tasarlanmış alüminyum alaşımı anatomik biçimli boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Designed for the AWC team with stay-put straps, moisture-control, chamois padding, and leg grippers.', N'"Konzipiert für das AWC-Team mit Gummizug, atmungsaktiv, Lederpolsterung, Beinabschluss ohne Verrutschen."', N'AWC チーム用に設計され、外れにくいストラップ、湿度調整機能、シャモア パッド、レッグ グリッパーを備えています。', N'"Yerinden oynamayan askıları, nem kontrolü, pedi ve bacak tutucularıyla AWC takımı için tasarlandı."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Designed to absorb shock.', N'Konzipiert zur Stoßdämpfung.', N'ショック吸収用に設計。', N'Şok emici olarak tasarlandı.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Durable, water-proof nylon construction with easy access. Large enough for weekend trips.', N'"Robustes, wasserfestes Nylon und einfacher Zugang. Groß genug für Wochenendfahrten."', N'耐久性と防水性に優れた使いやすいナイロン製。週末旅行に最適です。', N'"Kolay erişilebilen sağlam, su geçirmez naylon. Hafta sonu yolculukları için yeterince geniş."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Each frame is hand-crafted in our Bothell facility to the optimum diameter and wall-thickness required of a premium mountain frame. The heat-treated welded aluminum frame has a larger diameter tube that absorbs the bumps.', N'"Jeder Rahmen wird in unserem Werk in Braunsfeld von Hand gefertigt und auf den optimalen Durchmesser und die optimale Dicke gebracht, die von einem erstklassigen Rahmen für Mountainbikes erwartet werden. Der hitzebehandelte und geschweißte Aluminiumrahmen hat ein Rohr mit größerem Durchmesser, das stoßdämpfend wirkt."', N'各フレームは、Bothell 工場で最高級のマウンテン バイクのフレームに必要な最適径および壁厚で手作りされます。熱処理された溶接アルミニウムのフレームは、衝撃を吸収する大径のチューブを備えています。', N'"Her bir kadro Bothell tesisimizde, birinci sınıf dağ bisikleti kadrosu için gereken optimum çapta ve kalınlıkta elde hazırlandı. Tavlanan ve kaynaklanan alüminyum kadronun geniş çaplı borusu çarpma şiddetini emer."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Entry level adult bike; offers a comfortable ride cross-country or down the block. Quick-release hubs and rims.', N'Ein Erwachsenenrad für Einsteiger; bietet Komfort über Land und in der Stadt. Schnellspann-Naben und Felgen.', N'エントリー レベルに対応する、クロスカントリーにも街への買い物にも快適な、大人の自転車。ハブおよびリムの取りはずしが容易です。', N'"Başlangıç seviyesinde yetişkin bisikleti, kırda veya sokağınızda konforlu sürüş sunar. Kolay çıkarılan göbekler ve jantlar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Excellent aerodynamic rims guarantee a smooth ride.', N'Hochwertige aerodynamische Felgen für ein komfortables Fahrerlebnis.', N'空気力学的に優れ、滑らかな乗り心地を保証するリム。', N'Mükemmel aerodinamik jantlar rahat bir sürüşü garanti eder.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Expanded platform so you can ride in any shoes; great for all-around riding.', N'Größere Fläche für Komfort in allen Schuhen.', N'靴を選ばない拡張プラットフォームなので、オールラウンド ライディングに最適です。', N'"Geniş pedalı sayesinde her tür ayakkabıyla sürebilirsiniz, günlük kullanım için çok uygundur."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Flat bar strong enough for the pro circuit.', N'Die breite Stange ist stark genug für Profis.', N'プロ サーキットにも十分な強度を持つフラット バー。', N'Profesyoneller için yeterince güçlü düz boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'For true trail addicts.  An extremely durable bike that will go anywhere and keep you in control on challenging terrain - without breaking your budget.', N'"Für echte Waldprofis. Ein extrem robustes Rad, mit dem Sie auf allen Pfaden sicher unterwegs sind - und dazu noch kostengünstig."', N'トレイルを愛するライダーのためのバイク。卓越した耐久性でどんな場所にも対応。難しい地形でもコントロールが効き、しかも価格はリーズナブルです。', N'Gerçek kros tutkunlarına.  Her yere gidebilen ve zorlu arazilerde kontrolü kaybetmemenizi sağlayan son derece dayanıklı bir bisiklet ve cebinizi de yakmıyor.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Full padding, improved finger flex, durable palm, adjustable closure.', N'"Vollständig gepolstert, verbesserte Flexibilität für die Finger, robuster Ballenschutz, anpassbarer Verschluss."', N'フル パディング、改良された指部分の伸縮性、耐久性のある手のひら部分、調整可能なはめ口。', N'"Ful pedli, geliştirilmiş parmak esnekliği, dayanıklı avuç içi, ayarlanabilir kopça."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'General purpose tube.', N'Allzweckschlauch.', N'一般用途チューブ。', N'Genel amaçlı boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Great traction, high-density rubber.', N'"Hohe Beschleunigung, Gummi mit hoher Dichte."', N'優れたトラクション、高密度ラバー。', N'"Çok iyi yol tutuşu, yüksek yoğunluklu lastik."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Heavy duty, abrasion-resistant shorts feature seamless, lycra inner shorts with anti-bacterial chamois for comfort.', N'"Robuste, abnutzungsresistente Radlerhose mit nahtloser Innenhose aus Lycra mit antibakteriellem Gemsleder für höchsten Komfort."', N'丈夫で耐摩耗性に優れたショーツは、抗菌シャモアで快適さを追求するシームレス ライクラ インナー付き。', N'"Ağır işe ve aşınmaya dayanıklı şortlar, konfor için anti bakteriyel pedli dikişsiz likra astar şort."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'High-density rubber.', N'Gummi mit hoher Dichte.', N'高密度ラバー。', N'Yüksek yoğunluklu lastik.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Higher density rubber.', N'Gummi mit hoher Dichte.', N'超高密度ラバー。', N'Daha yüksek yoğunluklu lastik.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'High-performance carbon road fork with curved legs.', N'Hochwertige Carbon-Gabel mit geschwungenen Seiten.', N'湾曲したレッグを持つ高性能のカーボン ロード フォーク。', N'Yüksek performanslı eğik ayaklı karbon maşa.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'High-performance mountain replacement wheel.', N'Hochwertiges Ersatzrad für Mountainbikes.', N'高性能のマウンテン バイク用交換ホイール。', N'Yüksek performanslı yedek dağ bisikleti tekerleği.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'High-quality 1" threadless headset with a grease port for quick lubrication.', N'Hochwertiger Lenkkopf 1 Zoll mit Schmierfettdurchlauf.', N'迅速な注油のための注油ポートを備えた高品質の 1 インチ スレッドレス ヘッドセット。', N'"Yüksek kaliteli 1"" furş takımı, hızlı yağlama için yağ kapaklı."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'High-strength crank arm.', N'Robuster Pedalarm.', N'高強度クランク アーム。', N'Çok güçlü krank kolu.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Includes 8 different size patches, glue and sandpaper.', N'"Enthält Flicken in 8 verschiedenen Größen, Klebstoff und Sandpapier."', N'8 種類の異なるサイズのパッチ、糊、およびサンド ペーパーが含まれます。', N'"8 farklı boyda yama, yapışkan ve zımpara kağıdı  içerir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Incredible traction, lightweight carbon reinforced.', N'"Unvergleichliche Beschleunigung, leicht und carbonverstärkt."', N'優れたトラクションで、強化された軽量カーボン。', N'"İnanılmaz yol tutuşu, güçlendirilmiş hafif karbon."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Lightweight aluminum alloy construction.', N'Leichte Aluminiumlegierung.', N'軽量アルミニウム合金構造。', N'Hafif alüminyum alaşımı konstrüksiyon.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Lightweight butted aluminum frame provides a more upright riding position for a trip around town.  Our ground-breaking design provides optimum comfort.', N'Leichter Aluminiumrahmen für aufrechte Sitzhaltung bei Stadtfahrten. Unser bahnbrechendes Design bietet höchsten Komfort.', N'軽量接合アルミニウム フレームにより、街乗りに適したアップライトなライディング ポジションを実現します。当社の画期的なデザインより、最高の快適性を提供します。', N'"Hafif alüminyum kadrosu, şehirde yaptığınız yolculuklarda daha dik bir sürüş konumu sunuyor.  Çığır açıcı tasarımımız optimum konfor sağlıyor."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Lightweight carbon reinforced  for an unrivaled ride at an un-compromised weight.', N'Leicht und carbonverstärkt für ein unvergessliches Fahrerlebnis.', N'妥協のない重量での最高の乗り心地を提供するために強化された軽量カーボン。', N'Ağırlıktan taviz vermeden benzersiz bir sürüş için güçlendirilmiş hafif karbon.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Lightweight foam-padded saddle.', N'Leichter Sattel mit Schaumstoff.', N'フォーム パディングの軽量サドル。', N'Hafif köpük pedli sele.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Lightweight kevlar racing saddle. Leather.', N'Leichter Kevlar-Rennsattel. Leder.', N'競技用軽量ケブラー レザー サドル。', N'Hafif kevlar yarış selesi. Deri.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Lightweight, durable, clipless pedal with adjustable tension.', N'Leichte Pedale ohne Pedalhaken mit anpassbarer Spannung.', N'軽量で耐久性に優れ、テンション調整が可能なクリップレス ペダル。', N'"Hafif, dayanıklı klipssiz pedal, gerginliği ayarlanabilir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Light-weight, wind-resistant, packs to fit into a pocket.', N'"Leicht, windabweisend, passt in kleine Tasche."', N'ポケットに収まる軽量耐風性パック。', N'"Hafif, rüzgar geçirmez, katlandığında cebe sığar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Made from the same aluminum alloy as our top-of-the line HL frame, the ML features a lightweight down-tube milled to the perfect diameter for optimal strength. Men''s version.', N'Der ML-Rahmen ist aus der gleichen Aluminiumlegierung wie der Top-HL-Rahmen und verfügt über ein leichtes Rohr mit dem perfekten Durchmesser für optimale Stabilität. Version für Herren.', N'当社の最高級 HL フレームと同じアルミニウム合金で作られた ML は、完璧なダウンチューブ径で最高の強度を実現する男性用フレームです。', N'"HL kadroyla aynı alüminyum alaşımından imal edilen ML kadro, optimum kuvvet için en uygun çapta dövülmüş hafif alt boru içerir. Erkek modeli."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Made from the same aluminum alloy as our top-of-the line HL frame, the ML features a lightweight down-tube milled to the perfect diameter for optimal strength. Women''s version.', N'Der ML-Rahmen ist aus der gleichen Aluminiumlegierung wie der Top-HL-Rahmen und verfügt über ein leichtes Rohr mit dem perfekten Durchmesser für optimale Stabilität. Version für Frauen.', N'当社の最高級 HL フレームと同じアルミニウム合金で作られた ML は、完璧なダウンチューブ径で最高の強度を実現する女性用フレームです。', N'"HL kadroyla aynı alüminyum alaşımından imal edilen ML kadro, optimum kuvvet için en uygun çapta dövülmüş hafif alt boru içerir. Kadın modeli."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Men''s 8-panel racing shorts - lycra with an elastic waistband and leg grippers.', N'Rennradhose für Herren - Lycra mit elastischem Bund und Beinabschluss ohne Verrutschen.', N'男性用 8 枚剥ぎの競技用ショーツ - 伸縮性のあるウエスト バンドとレッグ グリッパー付きのライクラ製です。', N'Erkekler için 8 parçalı yarış şortu - elastik kemer parçalı ve bacak tutuculu likra.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'New design relieves pressure for long rides.', N'Neues Design bietet Komfort auch auf langen Strecken.', N'ロング ライドのストレスを軽減する新デザイン。', N'Yeni tasarım uzun sürüşlerde basıncı azaltır.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Our best value utilizing the same, ground-breaking frame technology as the ML aluminum frame.', N'Unser Topmodell mit derselben bahnbrechenden Rahmentechnologie wie beim ML-Aluminiumrahmen.', N'ML アルミニウム フレームと同じ画期的なフレーム技術を利用した最高の製品。', N'ML alüminyum kadroyla aynı çığır açıcı kadro teknolojisini kullanan en değerli ürünümüz.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Our lightest and best quality aluminum frame made from the newest alloy; it is welded and heat-treated for strength. Our innovative design results in maximum comfort and performance.', N'Unser leichtester und hochwertigster Aluminiumrahmen aus der neuesten Legierung; geschweißt und hitzebehandelt für noch mehr Stabilität. Unser innovatives Design bietet maximalen Komfort und maximale Leistung.', N'最新の合金で作られた最軽量/最高品質のアルミニウム フレームで、強度を得るために溶接および熱処理されています。革新的なデザインにより、最高の快適さと性能がもたらされます。', N'"En yeni alaşımdan imal edilme, en hafif ve en kaliteli alüminyum kadromuz, daha güçlü olması için kaynaklandı ve tavlandı. Yenilikçi tasarımımız maksimum konfor ve performans sunar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Perfect all-purpose bike stand for working on your bike at home. Quick-adjusting clamps and steel construction.', N'"Optimaler Allzweck-Fahrradständer für die Wartung des Rads zu Hause. Leicht anpassbare Klemmen, Stahlkonstruktion."', N'自宅での作業にも完璧な多目的スタンドで、迅速な調整が可能なクランプと鋼構造を備えています。', N'Evinizde bisikletiniz üzerinde çalışmanız için mükemmel çok amaçlı bisiklet standı. Hızlı ayarlanabilen klempler ve çelik konstrüksiyon.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Rechargeable dual-beam headlight.', N'Wiederaufladbares Vorderlicht mit zwei Strahlen.', N'充電式のデュアルビームのヘッドライト。', N'Şarj edilebilen çift ışıklı far.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Replacement mountain wheel for entry-level rider.', N'Ersatzrad für Mountainbike-Einsteiger.', N'初心者向けの交換用マウンテン ホイール。', N'Başlangıç seviyesinde sürücüler için yedek dağ bisikleti tekerleği.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Replacement mountain wheel for the casual to serious rider.', N'Mountainbike-Ersatzrad für Fortgeschrittene und Profis.', N'中級者から上級者向けの交換用マウンテン ホイール。', N'Orta ve ileri seviyedeki sürücüler için yedek dağ bisikleti tekerleği.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Replacement road front wheel for entry-level cyclist.', N'Ersatzvorderrad für Einsteiger.', N'初心者向けの交換用フロント ロード ホイール。', N'Başlangıç seviyesindeki sürücüler için yedek ön yol tekerleği.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Replacement road rear wheel for entry-level cyclist.', N'Ersatzhinterrad für Einsteiger.', N'初心者向けの交換用リア ロード ホイール。', N'Başlangıç seviyesinde sürücüler için yedek arka yol tekerleği.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Rubber bumpers absorb bumps.', N'Stoßleisten aus Gummi zur Stoßdämpfung.', N'ラバー バンパーが衝撃を吸収します。', N'Lastik tamponlar çarpma şiddetini emer.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Rugged weatherproof headlight.', N'Wetterfestes Vorderlicht.', N'頑丈な全天候型ヘッドライト。', N'Sağlam her hava durumuna uygun far.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Same great treads as more expensive tire with a less expensive wire bead casing.', N'Dasselbe Profil wie ein teurerer Reifen mit kostengünstigerem Mantel.', N'低価格のワイヤ ビード ケーシングでハイエンド タイヤに匹敵する優れたトレッドを実現。', N'"Daha pahalı tekerleklerle aynı lastik sırtı, daha ucuz tel başları."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Same technology as all of our Road series bikes, but the frame is sized for a woman.  Perfect all-around bike for road or racing.', N'Dieselbe Technologie wie bei allen Rädern unserer Road-Produktreihe mit Frauenrahmen. Perfektes Allzweckrad zum Trainieren und für den Alltag.', N'ロード シリーズの自転車と同じ技術を使用した女性用サイズのフレームで、ロードにも競技にも適した汎用自転車です。', N'"Yol serisi bisikletlerimizle aynı teknoloji, ancak kadro boyutu kadınlar için ayarlandı.  Yol ve yarış için mükemmel çok yönlü bisiklet."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Sealed cartridge keeps dirt out.', N'Versiegeltes Ventil vermeidet das Eindringen von Schmutz.', N'密閉されたカートリッジが埃を防ぎます。', N'Mühürlü kartuş kirden korur.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Self-sealing tube.', N'Selbstdichtender Schlauch.', N'セルフシーリング チューブ。', N'Kendinden mühürlü boru.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Serious back-country riding. Perfect for all levels of competition. Uses the same HL Frame as the Mountain-100.', N'Mountainbike für Profis. Perfekt für alle Schwierigkeitsgrade geeignet. Mit dem gleichen HL-Rahmen wie das Mountain-100.', N'バック カントリーまたは全レベルの競技用で、Mountain-100 と同じ HL フレームを採用しています。', N'Gerçek arazi sürüşü. Tüm yarışma seviyeleri için mükemmel. Mountain-100 ile aynı HL kadro kullanılmıştır.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Short sleeve classic breathable jersey with superior moisture control, front zipper, and 3 back pockets.', N'"Klassisches, atmungsaktives Trikot mit hochwertiger Feuchtigkeitsableitung, Reißverschluss und drei Rückentaschen."', N'優れた湿度調整機能、前面ジッパー、および後ろポケット 3 つが付いた、通気性に富むクラシックな半袖ジャージ。', N'"Üstün nem kontrollü, önden fermuarlı ve üç arka cepli kısa kollu hava alan mayo."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Simple and light-weight. Emergency patches stored in handle.', N'Einfach und leicht. Flickzeug im Griff.', N'シンプルで軽量。緊急用パッチがハンドルに格納されています。', N'Kolay ve hafif. Acil durum yamaları kolda saklanır.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Stainless steel; designed to shed mud easily.', N'Edelstahl; schmutzabweisendes Design.', N'ステンレス製で、泥を簡単に払い落せるデザインです。', N'"Paslanmaz çelik, çamuru üzerinden kolayca atacak şekilde tasarlandı."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Stout design absorbs shock and offers more precise steering.', N'Das robuste Design dämpft Stöße und ermöglicht eine präzisere Steuerung.', N'頑丈なデザインにより衝撃が吸収され、より正確なハンドル操作が可能です。', N'Şoku emen ve daha hassas yönlendirilebilen güçlü tasarım.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Strong rear wheel with double-walled rim.', N'Starkes Hinterrad mit doppelt beschichteter Felge.', N'ダブルウォール リムを持つ頑丈なリア ホイール。', N'İki duvarlı jantlı güçlü arka tekerlek.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Strong wheel with double-walled rim.', N'Starkes Rad mit doppelt beschichteter Felge.', N'ダブルウォール リムを持つ頑丈なホイール。', N'İki duvarlı jantlı güçlü tekerlek.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Sturdy alloy features a quick-release hub.', N'Robustes Design mit Schnellspann-Nabe.', N'頑丈な合金による、クイックリリース ハブ。', N'"Dayanıklı alaşım, kolay sökülebilen göbek içerir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Suitable for any type of riding, on or off-road. Fits any budget. Smooth-shifting with a comfortable ride.', N'Geeignet für Straße und Gelände. Für jedes Budget. Komfortable Gangschaltung.', N'オンロードにもオフロードにも対応しながら、予算を選ばず、スムーズなシフトで快適な乗り心地です。', N'Yolda veya arazide her tür sürüşe uygundur. Her bütçeye uyar. Yumuşak vites geçişi ve konforlu sürüş.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Super rigid spindle.', N'Extrem robuste Achse.', N'最強の剛性を誇るスピンドル。', N'Çok sağlam mil.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Superior shifting performance.', N'Extrem leistungsstarke Gangschaltung.', N'優れたシフト性能。', N'Üstün vites geçişi performansı.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Synthetic leather. Features gel for increased comfort.', N'Synthetisches Leder. Mit Gel für höheren Komfort.', N'シンセティック レザーを採用し、ジェルで快適性を高めました。', N'Sentetik deri. Daha fazla için jel içerir.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Synthetic palm, flexible knuckles, breathable mesh upper. Worn by the AWC team riders.', N'"Ballenschutz Synthetik, flexible Fingerpartie, atmungsaktives Netz am Handrücken. Wird von den Fahrern des AWC-Teams getragen."', N'シンセティック レザーの手のひら部分、柔軟性のある関節部分、通気性のあるメッシュの甲部分。AWC チームのライダーも愛用しています。', N'"Sentetik avuç içi, esnek parmaklar, üst tarafı hava alan ağdan imal edilmiştir. AWC takımı sürücüleri tarafından takılmaktadır."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'The HL aluminum frame is custom-shaped for both good looks and strength; it will withstand the most rigorous challenges of daily riding. Men''s version.', N'Der robuste und formschöne HL-Aluminiumrahmen ist extrem strapazierbar. Version für Herren.', N'HL アルミニウム フレームは、スタイリッシュでありながら強度に優れた独自の形状で、日々の過酷な使用に耐えることができます。男性用。', N'"HL alüminyum kadro güzellik ve sağlamlık için özel olarak şekillendirildi, günlük kullanımın en zorlu koşullarına dayanır. Erkek modeli."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'The LL Frame provides a safe comfortable ride, while offering superior bump absorption in a value-priced aluminum frame.', N'Mit dem LL-Rahmen fahren Sie sicher und komfortabel und profitieren von erstklassiger Stoßdämpfung in einem kostengünstigen Aluminiumrahmen.', N'LL フレームは、安全で快適に乗ることができ、値打ち価格のアルミニウム フレームで優れた衝撃吸収性を備えています。', N'"LL Kadro güvenli ve konforlu sürüş sunar, değerine uygun olarak fiyatlandırılan alüminyum kadrosu üstün çarpma şiddeti emişi sağlar."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'The ML frame is a heat-treated aluminum frame made with the same detail and quality as our HL frame. It offers superior performance. Men''s version.', N'Der ML-Rahmen ist ein hitzebehandelter Aluminiumrahmen mit dem gleichen Zubehör und der gleichen Qualität wie unser HL-Rahmen. Er bietet höchste Leistung. Version für Herren.', N'ML フレームは、HL フレームと同等の細部および品質を持つ熱処理アルミニウム フレームであり、卓越した性能を発揮します。男性用。', N'HL kadroyla aynı detaylara ve kaliteye sahip olan ML kadro tavlanmış alüminyumdur. Üstün performans sunar. Erkek modeli.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'The ML frame is a heat-treated aluminum frame made with the same detail and quality as our HL frame. It offers superior performance. Women''s version.', N'Der ML-Rahmen ist ein hitzebehandelter Aluminiumrahmen mit dem gleichen Zubehör und der gleichen Qualität wie unser HL-Rahmen. Er bietet höchste Leistung. Version für Frauen.', N'ML フレームは、HL フレームと同等の細部および品質を持つ熱処理アルミニウム フレームであり、卓越した性能を発揮します。女性用。', N'HL kadroyla aynı detaylara ve kaliteye sahip olan ML kadro tavlanmış alüminyumdur. Üstün performans sunar. Kadın modeli.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'The plush custom saddle keeps you riding all day,  and there''s plenty of space to add panniers and bike bags to the newly-redesigned carrier.  This bike has stability when fully-loaded.', N'"Der Polstersattel bietet Fahrkomfort für den ganzen Tag, und der Gepäckträger mit neuem Design bietet viel Platz für Fahrradtaschen und Körbe. Dieses Fahrrad behält seine Stabilität auch im voll beladenen Zustand."', N'プラッシュ カスタム サドルは 1 日中乗っていたくなる快適さです。新設計の荷台には、パニエやバイク バッグを追加するのに十分なスペースがあります。荷物を満載しても安定する自転車です。', N'"Özel yapım konforlu sele ile tüm gün bisiklet sürebilirsiniz, ayrıca kısa süre önce yeniden tasarlanan taşıyıcıda sepet ve bisiklet çantası eklenebilecek bol yer vardır.  Bu bisiklet tam olarak yüklendiğinde dengelidir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Thin, lightweight and durable with cuffs that stay up.', N'"Dünn, leicht und robust mit Bündchen, die nicht verrutschen."', N'上部のカフスにより、薄くて軽量で耐久性があります。', N'"İnce, hafif ve dayanıklı kelepçeler."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'This bike delivers a high-level of performance on a budget. It is responsive and maneuverable, and offers peace-of-mind when you decide to go off-road.', N'Dieses Fahrrad bietet ein erstklassiges Preis-/Leistungsverhältnis. Auf seine Reaktionsschnelligkeit und leichte Steuerung können Sie sich im Gelände voll verlassen.', N'この自転車は予算内で高性能を提供します。応答性と操作性に優れ、オフロードでもゆったりした気分で乗ることができます。', N'"Bu bisiklet hem hesaplıdır, hem de yüksek seviyede performans gösterir. Duyarlıdır ve manevra kabiliyeti yüksektir, araziye çıkmak istediğinizde güven verir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'This bike is ridden by race winners. Developed with the Adventure Works Cycles professional race team, it has a extremely light heat-treated aluminum frame, and steering that allows precision control.', N'"Dieses Fahrrad wird von Rennprofis gefahren. Es wurde gemeinsam mit dem Profirennteam von Adventure Works Cycles entwickelt und hat einen extrem leichten, hitzebehandelten Aluminiumrahmen und eine hochpräzise Steuerung."', N'レース ウィナーも愛用する機種です。Adventure Works Cycles プロフェッショナル レーシング チームと共に開発されたものであり、非常に軽量な熱処理アルミニウム フレームと、精密な制御が可能なステアリングを備えています。', N'"Bu bisiklet yarışçılar tarafından kullanılmaktadır. Adventure Works Cycles profesyonel yarış takımıyla birlikte geliştirilen bu bisiklet, son derece hafif, tavlanmış alüminyum kadroya ve hassas kontrol sağlayan bir gidona sahiptir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Threadless headset provides quality at an economical price.', N'Hochwertiger Lenkkopf zu einem guten Preis.', N'スレッドレスのヘッドセットは、手ごろな価格で高品質を提供します。', N'Furş takımı kaliteyi ekonomik bir fiyata sunar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Top-of-the-line clipless pedals with adjustable tension.', N'Top-Pedale ohne Pedalhaken mit anpassbarer Spannung.', N'テンション調整が可能な最高級クリップレス ペダル。', N'Gerginliği ayarlanabilen gerginlikli en üst sınıf klipssiz pedallar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Top-of-the-line competition mountain bike. Performance-enhancing options include the innovative HL Frame, super-smooth front suspension, and traction for all terrain.', N'"Top-Mountainbike für Profis. Mit innovativem HL-Rahmen, Vorderradaufhängung mit extrem guter Federung und Beschleunigung für alle Geländearten."', N'最高級の競技用マウンテン バイクです。性能強化オプションとしては、革新的な HL フレーム、スーパー スムーズなフロント サスペンション、地形を選ばないトラクションなどがあります。', N'"En üst model rekabetçi dağ bisikleti. Performans yükselten opsiyonları arasında yenilikçi HL kadro, aşırı hassas ön süspansiyon ve her çeşit toprakta yol tutuşu bulunmaktadır."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Tough aluminum alloy bars for downhill.', N'Robustes Gestänge aus Aluminiumlegierung für Abfahrtsrennen.', N'ダウンヒル用の頑丈なアルミニウム合金バー。', N'Yokuş aşağı sürüş için sağlam alüminyum alaşımı borular.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Tough aluminum cage holds bottle securly on tough terrain.', N'Robuster Aluminiumrahmen hält die Flasche sicher auf schwierigem Gelände.', N'走行の困難な地形でもボトルをしっかりホールドする頑丈なアルミニウム ケージ。', N'Sağlam alüminyum kafes şişeyi zorlu yol koşullarında sıkıca tutar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Traditional style with a flip-up brim; one-size fits all.', N'"Traditionelles Design mit Klapprand, Einheitsgröße."', N'跳ね上げ式のつばを持つトラディショナルなスタイルで、フリーサイズです。', N'"Klasik stil, herkese uygun tek bir boyda."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Travel in style and comfort. Designed for maximum comfort and safety. Wide gear range takes on all hills. High-tech aluminum alloy construction provides durability without added weight.', N'Fahren Sie mit Stil und Komfort. Design für maximalen Komfort und maximale Sicherheit. Viele Gänge für jede Steigung. Der hochwertige Rahmen aus Aluminiumlegierung ist robust und leicht.', N'スタイルと乗り心地を同時に実現。最大限の快適性と安全性を目標に設計され、ワイドなギア レンジでどんな丘陵地形もこなせます。ハイテク アルミニウム合金構造により、重量を増加させることなく耐久性を提供します。', N'"Tarz ve konforlu yolculuk. Maksimum konfor ve güvenlik için tasarlandı. Tüm tepelere çıkacak kadar çok vitesli. Yüksek teknoloji alüminyum alaşımı yapısı, dayanıklılık sağlarken hafiflikten de taviz vermiyor."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Triple crankset; alumunim crank arm; flawless shifting.', N'Dreifach-Kurbelsatz; Aluminium-Pedalarm; tadellose Gangschaltung.', N'トリプル クランクセット、アルミニウム クランク アーム、完璧なシフト。', N'"Üçlü ruble, alüminyum krank kolu, takılmadan vites geçişi."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Unique shape provides easier reach to the levers.', N'Einzigartige Form für komfortablere Bedienung der Schalthebel.', N'レバーに手が届きやすいユニークな形状。', N'Eşsiz biçimi kollara daha kolay erişim sağlar.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Unique shape reduces fatigue for entry level riders.', N'Mehr Komfort für Einsteiger durch einzigartige Form.', N'エントリー レベルのライダーにも疲労を感じさせないユニークな形状。', N'"Eşsiz biçimi, başlangıç seviyesindeki sürücülerde yorgunluğunu azaltır."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Unisex long-sleeve AWC logo microfiber cycling jersey', N'Langärmliges Unisex-Microfiber-Trikot mit AWC-Logo', N'男女共用の、AWC ロゴ入り長袖マイクロファイバー サイクリング ジャージ。', N'"Üniseks uzun kollu, AWC logolu, mikro fiber bisiklet mayosu"')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Universal fit, well-vented, lightweight , snap-on visor.', N'"Einheitsgröße, atmungsaktiv, leicht, aufsetzbarer Blendschutz."', N'軽量で通気性に優れたユニバーサル フィットのスナップ オン バイザー。', N'"Her bisiklete kolayca takılabilen, aerodinamik, hafif dikiz aynası."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Value-priced bike with many features of our top-of-the-line models. Has the same light, stiff frame, and the quick acceleration we''re famous for.', N'"Kostengünstiges Rad mit vielen Funktionen unserer Topmodelle. Verfügt über denselben leichten, robusten Rahmen und die schnelle Beschleunigung, die uns bekannt gemacht hat."', N'最高級モデルの特色の多くを備えた値打ち価格の自転車です。ハイエンド クラスに匹敵する軽量高剛性フレームと、当社製品の特色である優れた加速性能を備えています。', N'Değerine uygun olarak fiyatlandırılan bisikletin bir çok özelliği en üst sınıf modellerinkilerle aynıdır. Aynı hafif sağlam kadroya ve herkesin takdir ettiği çabuk hızlanma özelliğimize sahiptir.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Versatile 70 oz hydration pack offers extra storage, easy-fill access, and a waist belt.', N'"Vielseitiger Behälter für 2 Liter Flüssigkeit, einfach aufzufüllen und mit Gürtel."', N'多目的の 70 オンスのハイドレーション パックは、収納に余裕があり、詰め替えが容易でウエスト ベルト付きです。', N'"Çok yönlü 2 litre su torbası fazladan saklama alanı sağlar, kolay doldurulabilir ve kemerlidir."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Warm spandex tights for winter riding; seamless chamois construction eliminates pressure points.', N'Warme Spandex-Radlerhose für den Winter; mit nahtloser Lederpolsterung zur Vermeidung von Druckstellen.', N'冬用の暖かいスパンデックス タイツで、縫い目ストレスのないシームレスのシャモア構造です。', N'"Kış sürüşleri için sıcak spandeks taytlar, basınç yapan noktaları etkisiz hale getiren dikişsiz ped."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Washes off the toughest road grime; dissolves grease, environmentally safe. 1-liter bottle.', N'Entfernt den hartnäckigsten Schmutz und Fett; umweltfreundlich. 1-Liter-Flasche.', N'落ちにくい汚れを落とし、油を分解し、環境にも安全な 1 リットル入りボトル。', N'"En katı yol kirini yıkar, yağı akıtır, çevre dostudur. 1-litrelik şişede."')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Wide-link design.', N'Wide-Link-Design.', N'ワイドリンク デザイン。', N'Geniş bağlantılı tasarım.')
GO
INSERT [Integration].[ProductDescriptionType] ([Description], [GermanDescription], [JapaneseDescription], [TurkishDescription]) VALUES (N'Wraps to fit front and rear tires, carrier and 2 keys included.', N'"Passt für Vorder- und Hinterrad, mit Halterung und 2 Schlüsseln."', N'フロント タイヤとリア タイヤを収納でき、キャリアと鍵 2 つが付属しています。', N'"Ön ve arka tekerleklere uyacak şekilde sarılabilir, taşıyıcı ve iki anahtar dahildir."')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Adjustable Race', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'All-Purpose Bike Stand', N'Range-vélo pour tous modèles', N'Soporte multiusos para bicicletas')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'AWC Logo Cap', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'BB Ball Bearing', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bearing Ball', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bike Wash - Dissolver', N'Entretien du vélo - dissolvant', N'Lavado de bicicletas: disolvente')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Blade', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Cable Lock', N'Antivol câble', N'Cable antirrobo')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Chain', N'Chaîne', N'Cadena')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Chain Stays', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Chainring', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Chainring Bolts', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Chainring Nut', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Classic Vest, L', N'Veste classique, taille L', N'Camiseta clásica, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Classic Vest, M', N'Veste classique, taille M', N'Camiseta clásica, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Classic Vest, S', N'Veste classique, taille S', N'Camiseta clásica, P')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Cone-Shaped Race', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Crown Race', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Cup-Shaped Race', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Decal 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Decal 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Down Tube', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'External Lock Washer 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Fender Set - Mountain', N'Jeu de garde-boue - VTT', N'Conjunto de guardabarros: montaña')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Flat Washer 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Fork Crown', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Fork End', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Freewheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Front Brakes', N'Freins avant', N'Frenos delanteros')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Front Derailleur', N'Dérailleur avant', N'Desviador delantero')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Front Derailleur Cage', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Front Derailleur Linkage', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Full-Finger Gloves, L', N'Gants longs, taille L', N'Guantes completos, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Full-Finger Gloves, M', N'Gants longs, taille M', N'Guantes completos, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Full-Finger Gloves, S', N'Gants longs, taille S', N'Guantes completos, P')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Guide Pulley', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Half-Finger Gloves, L', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Half-Finger Gloves, M', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Half-Finger Gloves, S', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Handlebar Tube', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Head Tube', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Headlights - Dual-Beam', N'Feu avant - double faisceau', N'Luces: doble haz')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Headlights - Weatherproof', N'Feu avant étanche', N'Luces: resistentes al agua')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Headset Ball Bearings', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 10', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 11', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 12', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 13', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 14', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 15', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 16', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 17', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 18', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 19', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 20', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 21', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 22', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 23', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hex Nut 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hitch Rack - 4-Bike', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Bottom Bracket', N'Axe de pédalier HL', N'Eje de pedalier GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Crankarm', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Crankset', N'Pédalier HL', N'Bielas GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Fork', N'Fourche HL', N'Horquilla GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Grip Tape', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Headset', N'Jeu de direction HL', N'Dirección GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Hub', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Black, 38', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Black, 42', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Black, 44', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Black, 46', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Black, 48', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Silver, 38', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Silver, 42', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Silver, 44', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Silver, 46', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Frame - Silver, 48', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Front Wheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Handlebars', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Pedal', N'Pédale de VTT HL', N'Pedal de montaña GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Rear Wheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Seat/Saddle', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Mountain Tire', N'Pneu de VTT HL', N'Cubierta de montaña GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Nipple', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Black, 44', N'Cadre de vélo de route HL - noir, 44', N'Cuadro de carretera GA: negro, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Black, 48', N'Cadre de vélo de route HL - noir, 48', N'Cuadro de carretera GA: negro, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Black, 52', N'Cadre de vélo de route HL - noir, 52', N'Cuadro de carretera GA: negro, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Black, 58', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Black, 62', N'Cadre de vélo de route HL - noir, 62', N'Cuadro de carretera GA: negro, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Red, 44', N'Cadre de vélo de route HL - rouge, 44', N'Cuadro de carretera GA: rojo, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Red, 48', N'Cadre de vélo de route HL - rouge, 48', N'Cuadro de carretera GA: rojo, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Red, 52', N'Cadre de vélo de route HL - rouge, 52', N'Cuadro de carretera GA: rojo, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Red, 56', N'Cadre de vélo de route HL - rouge, 56', N'Cuadro de carretera GA: rojo, 56')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Red, 58', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Frame - Red, 62', N'Cadre de vélo de route HL - rouge, 62', N'Cuadro de carretera GA: rojo, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Front Wheel', N'Roue avant de vélo de route HL', N'Rueda de carretera delantera GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Handlebars', N'Poignées de vélo de route HL', N'Manillar de carretera GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Pedal', N'Pédale de vélo de route HL', N'Pedal de carretera GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Rear Wheel', N'Roue arrière de vélo de route HL', N'Rueda de carretera trasera GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Seat/Saddle', N'Selle de vélo de route HL', N'Sillín/asiento de carretera GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Road Tire', N'Pneu de vélo de route HL', N'Cubierta de carretera GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Shell', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Spindle/Axle', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Blue, 46', N'Cadre de vélo de randonnée HL - bleu, 46', N'Cuadro de paseo GA: azul, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Blue, 50', N'Cadre de vélo de randonnée HL - bleu, 50', N'Cuadro de paseo GA: azul, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Blue, 54', N'Cadre de vélo de randonnée HL - bleu, 54', N'Cuadro de paseo GA: azul, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Blue, 60', N'Cadre de vélo de randonnée HL - bleu, 60', N'Cuadro de paseo GA: azul, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Yellow, 46', N'Cadre de vélo de randonnée HL - jaune, 46', N'Cuadro de paseo GA: amarillo, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Yellow, 50', N'Cadre de vélo de randonnée HL - jaune, 50', N'Cuadro de paseo GA: amarillo, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Yellow, 54', N'Cadre de vélo de randonnée HL - jaune, 54', N'Cuadro de paseo GA: amarillo, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Frame - Yellow, 60', N'Cadre de vélo de randonnée HL - jaune, 60', N'Cuadro de paseo GA: amarillo, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Handlebars', N'Poignées de vélo de randonnée HL', N'Manillar de paseo GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'HL Touring Seat/Saddle', N'Selle de vélo de randonnée HL', N'Sillín/asiento de paseo GA')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hydration Pack - 70 oz.', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 10', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Internal Lock Washer 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Keyed Washer', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Bottom Bracket', N'Axe de pédalier LL', N'Eje de pedalier GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Crankarm', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Crankset', N'Pédalier LL', N'Bielas GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Fork', N'Fourche LL', N'Horquilla GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Grip Tape', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Headset', N'Jeu de direction LL', N'Dirección GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Hub', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Black, 40', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Black, 42', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Black, 44', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Black, 48', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Black, 52', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Silver, 40', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Silver, 42', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Silver, 44', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Silver, 48', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Frame - Silver, 52', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Front Wheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Handlebars', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Pedal', N'Pédale de VTT LL', N'Pedal de montaña GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Rear Wheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Seat/Saddle', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Mountain Tire', N'Pneu de VTT LL', N'Cubierta de montaña GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Nipple', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Black, 44', N'Cadre de vélo de route LL - noir, 44', N'Cuadro de carretera GB: negro, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Black, 48', N'Cadre de vélo de route LL - noir, 48', N'Cuadro de carretera GB: negro, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Black, 52', N'Cadre de vélo de route LL - noir, 52', N'Cuadro de carretera GB: negro, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Black, 58', N'Cadre de vélo de route LL - noir, 58', N'Cuadro de carretera GB: negro, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Black, 60', N'Cadre de vélo de route LL - noir, 60', N'Cuadro de carretera GB: negro, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Black, 62', N'Cadre de vélo de route LL - noir, 62', N'Cuadro de carretera GB: negro, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Red, 44', N'Cadre de vélo de route LL - rouge, 44', N'Cuadro de carretera GB: rojo, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Red, 48', N'Cadre de vélo de route LL - rouge, 48', N'Cuadro de carretera GB: rojo, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Red, 52', N'Cadre de vélo de route LL - rouge, 52', N'Cuadro de carretera GB: rojo, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Red, 58', N'Cadre de vélo de route LL - rouge, 58', N'Cuadro de carretera GB: rojo, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Red, 60', N'Cadre de vélo de route LL - rouge, 60', N'Cuadro de carretera GB: rojo, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Frame - Red, 62', N'Cadre de vélo de route LL - rouge, 62', N'Cuadro de carretera GB: rojo, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Front Wheel', N'Roue avant de vélo de route LL', N'Rueda de carretera delantera GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Handlebars', N'Poignées de vélo de route LL', N'Manillar de carretera GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Pedal', N'Pédale de vélo de route LL', N'Pedal de carretera GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Rear Wheel', N'Roue arrière de vélo de route LL', N'Rueda de carretera trasera GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Seat/Saddle', N'Selle de vélo de route LL', N'Sillín/asiento de carretera GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Road Tire', N'Pneu de vélo de route LL', N'Cubierta de carretera GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Shell', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Spindle/Axle', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Blue, 44', N'Cadre de vélo de randonnée LL - bleu, 44', N'Cuadro de paseo GB: azul, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Blue, 50', N'Cadre de vélo de randonnée LL - bleu, 50', N'Cuadro de paseo GB: azul, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Blue, 54', N'Cadre de vélo de randonnée LL - bleu, 54', N'Cuadro de paseo GB: azul, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Blue, 58', N'Cadre de vélo de randonnée LL - bleu, 58', N'Cuadro de paseo GB: azul, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Blue, 62', N'Cadre de vélo de randonnée LL - bleu, 62', N'Cuadro de paseo GB: azul, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Yellow, 44', N'Cadre de vélo de randonnée LL - jaune, 44', N'Cuadro de paseo GB: amarillo, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Yellow, 50', N'Cadre de vélo de randonnée LL - jaune, 50', N'Cuadro de paseo GB: amarillo, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Yellow, 54', N'Cadre de vélo de randonnée LL - jaune, 54', N'Cuadro de paseo GB: amarillo, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Yellow, 58', N'Cadre de vélo de randonnée LL - jaune, 58', N'Cuadro de paseo GB: amarillo, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Frame - Yellow, 62', N'Cadre de vélo de randonnée LL - jaune, 62', N'Cuadro de paseo GB: amarillo, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Handlebars', N'Poignées de vélo de randonnée LL', N'Manillar de paseo GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'LL Touring Seat/Saddle', N'Selle de vélo de randonnée LL', N'Sillín/asiento de paseo GB')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 10', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 11', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 12', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 13', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 14', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 15', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 16', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 17', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 18', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 19', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 20', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 21', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 22', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 23', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Nut 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Ring', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 10', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 11', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 12', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 13', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lock Washer 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Long-Sleeve Logo Jersey, L', N'Maillot manches longues avec logo, taille L', N'Jersey con logotipo de manga larga, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Long-Sleeve Logo Jersey, M', N'Maillot manches longues avec logo, taille M', N'Jersey con logotipo de manga larga, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Long-Sleeve Logo Jersey, S', N'Maillot manches longues avec logo, taille S', N'Jersey con logotipo de manga larga, P')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Long-Sleeve Logo Jersey, XL', N'Maillot manches longues avec logo, taille XL', N'Jersey con logotipo de manga larga, SG')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lower Head Race', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Bib-Shorts, L', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Bib-Shorts, M', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Bib-Shorts, S', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Sports Shorts, L', N'Cuissards de route pour hommes, taille L', N'Pantalones cortos de deporte para hombre, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Sports Shorts, M', N'Cuissards de route pour hommes, taille M', N'Pantalones cortos de deporte para hombre, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Sports Shorts, S', N'Cuissards de route pour hommes, taille S', N'Pantalones cortos de deporte para hombre, P')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Men''s Sports Shorts, XL', N'Cuissards de route pour hommes, taille XL', N'Pantalones cortos de deporte para hombre, SG')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Angle', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Bar 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Bar 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Plate 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Plate 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Plate 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Sheet 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Metal Tread Plate', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Minipump', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Bottom Bracket', N'Axe de pédalier ML', N'Eje de pedalier GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Crankarm', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Crankset', N'Pédalier ML', N'Bielas GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Fork', N'Fourche ML', N'Horquilla GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Grip Tape', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Headset', N'Jeu de direction ML', N'Dirección GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame - Black, 38', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame - Black, 40', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame - Black, 44', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame - Black, 48', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame-W - Silver, 38', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame-W - Silver, 40', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame-W - Silver, 42', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Frame-W - Silver, 46', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Front Wheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Handlebars', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Pedal', N'Pédale de VTT ML', N'Pedal de montaña GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Rear Wheel', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Seat/Saddle', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Mountain Tire', N'Pneu de VTT ML', N'Cubierta de montaña GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame - Red, 44', N'Cadre de vélo de route ML - rouge, 44', N'Cuadro de carretera GM: rojo, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame - Red, 48', N'Cadre de vélo de route ML - rouge, 48', N'Cuadro de carretera GM: rojo, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame - Red, 52', N'Cadre de vélo de route ML - rouge, 52', N'Cuadro de carretera GM: rojo, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame - Red, 58', N'Cadre de vélo de route ML - rouge, 58', N'Cuadro de carretera GM: rojo, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame - Red, 60', N'Cadre de vélo de route ML - rouge, 60', N'Cuadro de carretera GM: rojo, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame-W - Yellow, 38', N'Cadre de route ML -W - jaune, 38', N'Cuadro de carretera para mujer GM: amarillo, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame-W - Yellow, 40', N'Cadre de route ML -W - jaune, 40', N'Cuadro de carretera para mujer GM: amarillo, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame-W - Yellow, 42', N'Cadre de route ML -W - jaune, 42', N'Cuadro de carretera para mujer GM: amarillo, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame-W - Yellow, 44', N'Cadre de route ML -W - jaune, 44', N'Cuadro de carretera para mujer GM: amarillo, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Frame-W - Yellow, 48', N'Cadre de route ML -W - jaune, 48', N'Cuadro de carretera para mujer GM: amarillo, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Front Wheel', N'Roue avant de vélo de route ML', N'Rueda de carretera delantera GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Handlebars', N'Poignées de vélo de route ML', N'Manillar de carretera GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Pedal', N'Pédale de vélo de route ML', N'Pedal de carretera GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Rear Wheel', N'Roue arrière de vélo de route ML', N'Rueda de carretera trasera GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Seat/Saddle', N'Selle de vélo de route ML', N'Sillín/asiento de carretera GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Road Tire', N'Pneu de vélo de route ML', N'Cubierta de carretera GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Touring Seat Assembly', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'ML Touring Seat/Saddle', N'Selle de vélo de randonnée ML', N'Sillín/asiento de paseo GM')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Bike Socks, L', N'Chaussettes de VTT, taille L', N'Calcetines para bicicleta de montaña, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Bike Socks, M', N'Chaussettes de VTT, taille M', N'Calcetines para bicicleta de montaña, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Bottle Cage', N'Porte-bidon de VTT', N'Portabotellas de montaña')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain End Caps', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Pump', N'Pompe de VTT', N'Bomba de montaña')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Tire Tube', N'Chambre à air de VTT', N'Cubierta para cámara de montaña')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Black, 38', N'VTT 100 noir, 38', N'Montaña: 100, negra, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Black, 42', N'VTT 100 noir, 42', N'Montaña: 100, negra, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Black, 44', N'VTT 100 noir, 44', N'Montaña: 100, negra, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Black, 48', N'VTT 100 noir, 48', N'Montaña: 100, negra, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Silver, 38', N'VTT 100 argent, 38', N'Montaña: 100, plateada, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Silver, 42', N'VTT 100 argent, 42', N'Montaña: 100, plateada, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Silver, 44', N'VTT 100 argent, 44', N'Montaña: 100, plateada, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-100 Silver, 48', N'VTT 100 argent, 48', N'Montaña: 100, plateada, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-200 Black, 38', N'VTT 200 noir, 38', N'Montaña: 200, negra, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-200 Black, 42', N'VTT 200 noir, 42', N'Montaña: 200, negra, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-200 Black, 46', N'VTT 200 noir, 46', N'Montaña: 200, negra, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-200 Silver, 38', N'VTT 200 argent, 38', N'Montaña: 200, plateada, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-200 Silver, 42', N'VTT 200 argent, 42', N'Montaña: 200, plateada, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-200 Silver, 46', N'VTT 200 argent, 46', N'Montaña: 200, plateada, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-300 Black, 38', N'VTT 300 noir, 38', N'Montaña: 300, negra, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-300 Black, 40', N'VTT 300 noir, 40', N'Montaña: 300, negra, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-300 Black, 44', N'VTT 300 noir, 44', N'Montaña: 300, negra, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-300 Black, 48', N'VTT 300 noir, 48', N'Montaña: 300, negra, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-400-W Silver, 38', N'VTT 400 -W argent, 38', N'Montaña: 400 para mujer, plateada, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-400-W Silver, 40', N'VTT 400 -W argent, 40', N'Montaña: 400 para mujer, plateada, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-400-W Silver, 42', N'VTT 400 -W argent, 42', N'Montaña: 400 para mujer, plateada, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-400-W Silver, 46', N'VTT 400 -W argent, 46', N'Montaña: 400 para mujer, plateada, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Black, 40', N'VTT 500 noir, 40', N'Montaña: 500, negra, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Black, 42', N'VTT 500 noir, 42', N'Montaña: 500, negra, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Black, 44', N'VTT 500 noir, 44', N'Montaña: 500, negra, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Black, 48', N'VTT 500 noir, 48', N'Montaña: 500, negra, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Black, 52', N'VTT 500 noir, 52', N'Montaña: 500, negra, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Silver, 40', N'VTT 500 argent, 40', N'Montaña: 500, plateada, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Silver, 42', N'VTT 500 argent, 42', N'Montaña: 500, plateada, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Silver, 44', N'VTT 500 argent, 44', N'Montaña: 500, plateada, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Silver, 48', N'VTT 500 argent, 48', N'Montaña: 500, plateada, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain-500 Silver, 52', N'VTT 500 argent, 52', N'Montaña: 500, plateada, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Paint - Black', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Paint - Blue', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Paint - Red', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Paint - Silver', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Paint - Yellow', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Patch Kit/8 Patches', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Pinch Bolt', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Racing Socks, L', N'Chaussettes de course, taille L', N'Calcetines para carreras, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Racing Socks, M', N'Chaussettes de course, taille M', N'Calcetines para carreras, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Rear Brakes', N'Freins arrière', N'Frenos traseros')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Rear Derailleur', N'Dérailleur arrière', N'Desviador trasero')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Rear Derailleur Cage', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Reflector', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road Bottle Cage', N'Porte-bidon de vélo de route', N'Portabotellas de carretera')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road End Caps', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road Tire Tube', N'Chambre à air de vélo de route', N'Cubierta para cámara de carretera')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-150 Red, 44', N'Vélo de route 150 rouge, 44', N'Carretera: 150, roja, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-150 Red, 48', N'Vélo de route 150 rouge, 48', N'Carretera: 150, roja, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-150 Red, 52', N'Vélo de route 150 rouge, 52', N'Carretera: 150, roja, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-150 Red, 56', N'Vélo de route 150 rouge, 56', N'Carretera: 150, roja, 56')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-150 Red, 62', N'Vélo de route 150 rouge, 62', N'Carretera: 150, roja, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Black, 44', N'Vélo de route 250 noir, 44', N'Carretera: 250, negra, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Black, 48', N'Vélo de route 250 noir, 48', N'Carretera: 250, negra, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Black, 52', N'Vélo de route 250 noir, 52', N'Carretera: 250, negra, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Black, 58', N'Vélo de route 250 noir, 58', N'Carretera: 250, negra, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Red, 44', N'Vélo de route 250 rouge, 44', N'Carretera: 250, roja, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Red, 48', N'Vélo de route 250 rouge, 48', N'Carretera: 250, roja, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Red, 52', N'Vélo de route 250 rouge, 52', N'Carretera: 250, roja, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-250 Red, 58', N'Vélo de route 250 rouge, 58', N'Carretera: 250, roja, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-350-W Yellow, 40', N'Vélo de route 350 -W - jaune, 40', N'Carretera: 350 para mujer, amarilla, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-350-W Yellow, 42', N'Vélo de route 350 -W - jaune, 42', N'Carretera: 350 para mujer, amarilla, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-350-W Yellow, 44', N'Vélo de route 350 -W - jaune, 44', N'Carretera: 350 para mujer, amarilla, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-350-W Yellow, 48', N'Vélo de route 350 -W - jaune, 48', N'Carretera: 350 para mujer, amarilla, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-450 Red, 44', N'Vélo de route 450 rouge, 44', N'Carretera: 450, roja, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-450 Red, 48', N'Vélo de route 450 rouge, 48', N'Carretera: 450, roja, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-450 Red, 52', N'Vélo de route 450 rouge, 52', N'Carretera: 450, roja, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-450 Red, 58', N'Vélo de route 450 rouge, 58', N'Carretera: 450, roja, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-450 Red, 60', N'Vélo de route 450 rouge, 60', N'Carretera: 450, roja, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-550-W Yellow, 38', N'Vélo de route 550 -W - jaune, 38', N'Carretera: 550 para mujer, amarilla, 38')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-550-W Yellow, 40', N'Vélo de route 550 -W - jaune, 40', N'Carretera: 550 para mujer, amarilla, 40')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-550-W Yellow, 42', N'Vélo de route 550 -W - jaune, 42', N'Carretera: 550 para mujer, amarilla, 42')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-550-W Yellow, 44', N'Vélo de route 550 -W - jaune, 44', N'Carretera: 550 para mujer, amarilla, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-550-W Yellow, 48', N'Vélo de route 550 -W - jaune, 48', N'Carretera: 550 para mujer, amarilla, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Black, 44', N'Vélo de route 650 noir, 44', N'Carretera: 650, negra, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Black, 48', N'Vélo de route 650 noir, 48', N'Carretera: 650, negra, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Black, 52', N'Vélo de route 650 noir, 52', N'Carretera: 650, negra, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Black, 58', N'Vélo de route 650 noir, 58', N'Carretera: 650, negra, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Black, 60', N'Vélo de route 650 noir, 60', N'Carretera: 650, negra, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Black, 62', N'Vélo de route 650 noir, 62', N'Carretera: 650, negra, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Red, 44', N'Vélo de route 650 rouge, 44', N'Carretera: 650, roja, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Red, 48', N'Vélo de route 650 rouge, 48', N'Carretera: 650, roja, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Red, 52', N'Vélo de route 650 rouge, 52', N'Carretera: 650, roja, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Red, 58', N'Vélo de route 650 rouge, 58', N'Carretera: 650, roja, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Red, 60', N'Vélo de route 650 rouge, 60', N'Carretera: 650, roja, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-650 Red, 62', N'Vélo de route 650 rouge, 62', N'Carretera: 650, roja, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-750 Black, 44', N'Vélo de route 750 noir, 44', N'Carretera: 750, negra, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-750 Black, 48', N'Vélo de route 750 noir, 48', N'Carretera: 750, negra, 48')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-750 Black, 52', N'Vélo de route 750 noir, 52', N'Carretera: 750, negra, 52')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road-750 Black, 58', N'Vélo de route 750 noir, 58', N'Carretera: 750, negra, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Seat Lug', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Seat Post', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Seat Stays', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Seat Tube', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Short-Sleeve Classic Jersey, L', N'Maillot manches courtes classique, taille L', N'Jersey clásico de manga corta, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Short-Sleeve Classic Jersey, M', N'Maillot manches courtes classique, taille M', N'Jersey clásico de manga corta, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Short-Sleeve Classic Jersey, S', N'Maillot manches courtes classique, taille S', N'Jersey clásico de manga corta, P')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Short-Sleeve Classic Jersey, XL', N'Maillot manches courtes classique, taille XL', N'Jersey clásico de manga corta, SG')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Spokes', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Sport-100 Helmet, Black', N'Casque sport 100, noir', N'Casco deportivo: 100, negro')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Sport-100 Helmet, Blue', N'Casque sport 100, bleu', N'Casco deportivo: 100, azul')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Sport-100 Helmet, Red', N'Casque sport 100, rouge', N'Casco deportivo: 100, rojo')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Steerer', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Stem', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Taillights - Battery-Powered', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Tension Pulley', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 10', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 11', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 12', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 13', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 14', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 15', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 16', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Hex Nut 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 1', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 10', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 11', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 12', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 13', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 14', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 15', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 16', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 2', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 3', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 4', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 5', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 6', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 7', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 8', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Thin-Jam Lock Nut 9', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Top Tube', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring End Caps', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Front Wheel', N'Roue avant de vélo de randonnée', N'Rueda de paseo delantera')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Pedal', N'Pédale de vélo de randonnée', N'Pedal de paseo')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Rear Wheel', N'Roue arrière de vélo de randonnée', N'Rueda de paseo trasera')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Rim', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Tire', N'Pneu de vélo de randonnée', N'Cubierta de paseo')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Tire Tube', N'Chambre à air de vélo de randonnée', N'Cubierta para cámara de paseo')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Blue, 46', N'Vélo de randonnée 1000 bleu, 46', N'Paseo: 1000, azul, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Blue, 50', N'Vélo de randonnée 1000 bleu, 50', N'Paseo: 1000, azul, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Blue, 54', N'Vélo de randonnée 1000 bleu, 54', N'Paseo: 1000, azul, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Blue, 60', N'Vélo de randonnée 1000 bleu, 60', N'Paseo: 1000, azul, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Yellow, 46', N'Vélo de randonnée 1000 jaune, 46', N'Paseo: 1000, amarilla, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Yellow, 50', N'Vélo de randonnée 1000 jaune, 50', N'Paseo: 1000, amarilla, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Yellow, 54', N'Vélo de randonnée 1000 jaune, 54', N'Paseo: 1000, amarilla, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-1000 Yellow, 60', N'Vélo de randonnée 1000 jaune, 60', N'Paseo: 1000, amarilla, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-2000 Blue, 46', N'Vélo de randonnée 2000 bleu, 46', N'Paseo: 2000, azul, 46')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-2000 Blue, 50', N'Vélo de randonnée 2000 bleu, 50', N'Paseo: 2000, azul, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-2000 Blue, 54', N'Vélo de randonnée 2000 bleu, 54', N'Paseo: 2000, azul, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-2000 Blue, 60', N'Vélo de randonnée 2000 bleu, 60', N'Paseo: 2000, azul, 60')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Blue, 44', N'Vélo de randonnée 3000 bleu, 44', N'Paseo: 3000, azul, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Blue, 50', N'Vélo de randonnée 3000 bleu, 50', N'Paseo: 3000, azul, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Blue, 54', N'Vélo de randonnée 3000 bleu, 54', N'Paseo: 3000, azul, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Blue, 58', N'Vélo de randonnée 3000 bleu, 58', N'Paseo: 3000, azul, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Blue, 62', N'Vélo de randonnée 3000 bleu, 62', N'Paseo: 3000, azul, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Yellow, 44', N'Vélo de randonnée 3000 jaune, 44', N'Paseo: 3000, amarilla, 44')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Yellow, 50', N'Vélo de randonnée 3000 jaune, 50', N'Paseo: 3000, amarilla, 50')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Yellow, 54', N'Vélo de randonnée 3000 jaune, 54', N'Paseo: 3000, amarilla, 54')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Yellow, 58', N'Vélo de randonnée 3000 jaune, 58', N'Paseo: 3000, amarilla, 58')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-3000 Yellow, 62', N'Vélo de randonnée 3000 jaune, 62', N'Paseo: 3000, amarilla, 62')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring-Panniers, Large', N'Sacoches de vélo de randonnée, grande capacité', N'Cesta de paseo, grande')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Water Bottle - 30 oz.', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Women''s Mountain Shorts, L', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Women''s Mountain Shorts, M', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Women''s Mountain Shorts, S', N'', N'')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Women''s Tights, L', N'Collants pour femmes, taille L', N'Mallas para mujer, G')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Women''s Tights, M', N'Collants pour femmes, taille M', N'Mallas para mujer, M')
GO
INSERT [Integration].[ProductNameType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Women''s Tights, S', N'Collants pour femmes, taille S', N'Mallas para mujer, P')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bib-Shorts', N'Cuissards avec bretelles', N'Culote corto')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bike Racks', N'Porte-vélo', N'Portabicicletas')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bike Stands', N'Range-vélo', N'Soporte para bicicletas')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bottles and Cages', N'Bidon et porte-bidon', N'Portabotellas y botella')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Bottom Brackets', N'Axe de pédalier', N'Eje de pedalier')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Brakes', N'Freins', N'Frenos')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Caps', N'Casquette', N'Gorra')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Chains', N'Chaîne', N'Cadena')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Cleaners', N'Nettoyant', N'Limpiador')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Cranksets', N'Pédalier', N'Bielas')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Derailleurs', N'Dérailleur', N'Desviador')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Fenders', N'Garde-boue', N'Guardabarros')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Forks', N'Fourche', N'Horquilla')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Gloves', N'Gants', N'Guantes')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Handlebars', N'Barre d''appui', N'Barra')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Headsets', N'Jeu de direction', N'Dirección')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Helmets', N'Casque', N'Casco')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Hydration Packs', N'Sac d''hydratation', N'Sistema de hidratación')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Jerseys', N'Maillot', N'Jersey')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Lights', N'Éclairage', N'Luz')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Locks', N'Antivol', N'Candado')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Bikes', N'VTT', N'Bicicleta de montaña')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Mountain Frames', N'Cadre de VTT', N'Cuadro de montaña')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Panniers', N'Sacoche', N'Cesta')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Pedals', N'Pédale', N'Pedal')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Pumps', N'Pompe', N'Bomba')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road Bikes', N'Vélo de route', N'Bicicleta de carretera')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Road Frames', N'Cadre de vélo de route', N'Cuadro de carretera')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Saddles', N'Selle', N'Sillín')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Shorts', N'Cuissards', N'Pantalones cortos')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Socks', N'Chaussettes', N'Calcetines')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Tights', N'Collants', N'Mallas')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Tires and Tubes', N'Pneu et chambre à air', N'Cubierta y cámara')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Bikes', N'Vélo de randonnée', N'Bicicleta de paseo')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Touring Frames', N'Cadre de vélo de randonnée', N'Cuadro de paseo')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Vests', N'Veste', N'Camiseta')
GO
INSERT [Integration].[ProductSubcategoryType] ([Name], [FrenchName], [SpanishName]) VALUES (N'Wheels', N'Roue', N'Rueda')
GO
INSERT [Integration].[PromotionCategoryType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Customer', N'Cliente', N'Client')
GO
INSERT [Integration].[PromotionCategoryType] ([Name], [SpanishName], [FrenchName]) VALUES (N'No Discount', N'Sin descuento', N'Aucune remise')
GO
INSERT [Integration].[PromotionCategoryType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Reseller', N'Distribuidor', N'Revendeur')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Half-Price Pedal Sale', N'Venta de pedales a mitad de precio', N'Pédales à moitié prix')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'LL Road Frame Sale', N'Oferta de cuadro de carretera GB', N'Vente de cadres de vélo de route LL')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Mountain Tire Sale', N'Oferta de cubierta de montaña', N'Vente de pneus de VTT')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Mountain-100 Clearance Sale', N'Liquidación de bicicleta de montaña, 100', N'Liquidation VTT 100')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Mountain-500 Silver Clearance Sale', N'Liquidación de bicicleta de montaña, 500, plateada', N'Liquidation VTT 500 argent')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'No Discount', N'Sin descuento', N'Aucune remise')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Road-650 Overstock', N'Bicicleta de carretera: 650, oferta especial', N'Déstockage Vélo de route 650')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Sport Helmet Discount-2002', N'Casco deportivo, descuento: 2002', N'Remise sur les casques sport - 2002')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Sport Helmet Discount-2003', N'Casco deportivo, descuento: 2003', N'Remise sur les casques sport - 2003')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Touring-1000 Promotion', N'Promoción ‘Touring-1000’', N'Promotion “Touring-1000”')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Touring-3000 Promotion', N'Promoción ‘Touring-3000’', N'Promotion “Touring-3000”')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Volume Discount 11 to 14', N'Descuento por volumen (entre 11 y 14)', N'Remise sur quantité (de 11 à 14)')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Volume Discount 15 to 24', N'Descuento por volumen (entre 15 y 24)', N'Remise sur quantité (de 15 à 24)')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Volume Discount 25 to 40', N'Descuento por volumen (entre 25 y 40)', N'Remise sur quantité (de 25 à 40)')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Volume Discount 41 to 60', N'Descuento por volumen (entre 41 y 60)', N'Remise sur quantité (de 41 à 60)')
GO
INSERT [Integration].[PromotionNameType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Volume Discount over 60', N'Descuento por volumen (más de 60)', N'Remise sur quantité (au-delà de 60)')
GO
INSERT [Integration].[PromotionType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Discontinued Product', N'Descatalogado', N'Ce produit n''est plus commercialisé')
GO
INSERT [Integration].[PromotionType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Excess Inventory', N'Inventario excedente', N'Déstockage')
GO
INSERT [Integration].[PromotionType] ([Name], [SpanishName], [FrenchName]) VALUES (N'New Product', N'Producto Nuevo', N'Nouveau produit')
GO
INSERT [Integration].[PromotionType] ([Name], [SpanishName], [FrenchName]) VALUES (N'No Discount', N'Sin descuento', N'Aucune remise')
GO
INSERT [Integration].[PromotionType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Seasonal Discount', N'Descuento de temporada', N'Remise saisonnière')
GO
INSERT [Integration].[PromotionType] ([Name], [SpanishName], [FrenchName]) VALUES (N'Volume Discount', N'Descuento por volumen', N'Remise sur quantité')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'38', N'38-40 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'40', N'38-40 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'42', N'42-46 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'44', N'42-46 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'46', N'42-46 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'48', N'48-52 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'50', N'48-52 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'52', N'48-52 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'54', N'54-58 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'56', N'54-58 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'58', N'54-58 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'60', N'60-62 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'62', N'60-62 CM')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'70', N'70')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'L', N'L')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'M', N'M')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'S', N'S')
GO
INSERT [Integration].[SizeRangeType] ([Size], [SizeRange]) VALUES (N'XL', N'XL')
GO
SET IDENTITY_INSERT [Integration].[StoreBusinessType] ON 
GO
INSERT [Integration].[StoreBusinessType] ([StoreBusinessTypeID], [Code], [Name], [rowguid], [ModifiedDate]) VALUES (1, N'BM', N'Value Added Reseller', N'c5bfda0b-39a4-462a-bd84-1b63762c5d52', CAST(N'2025-05-12T15:15:00.647' AS DateTime))
GO
INSERT [Integration].[StoreBusinessType] ([StoreBusinessTypeID], [Code], [Name], [rowguid], [ModifiedDate]) VALUES (2, N'BS', N'Specialty Bike Shop', N'8e25987d-1491-4897-bc6e-766593c3f4a4', CAST(N'2025-05-12T15:15:00.647' AS DateTime))
GO
INSERT [Integration].[StoreBusinessType] ([StoreBusinessTypeID], [Code], [Name], [rowguid], [ModifiedDate]) VALUES (3, N'OS', N'Warehouse', N'7946c9f1-cd13-4f86-9bf6-bdc3be32d8fe', CAST(N'2025-05-12T15:15:00.647' AS DateTime))
GO
SET IDENTITY_INSERT [Integration].[StoreBusinessType] OFF
GO
ALTER TABLE [Integration].[StoreBusinessType] ADD  CONSTRAINT [DF_StoreBusinessType_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [Integration].[StoreBusinessType] ADD  CONSTRAINT [DF_StoreBusinessType_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
/****** Object:  StoredProcedure [Integration].[GetCurrencyInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Integration].[GetCurrencyInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[CurrencyAlternateKey] = C.CurrencyCode,
		[CurrencyName] = C.[Name]
	FROM
		Sales.Currency C
	ORDER BY
		C.[Name]
	
END
GO
/****** Object:  StoredProcedure [Integration].[GetCustomerInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--select * from AdventureWorksDW2022.dbo.DimCustomer
--exec [Integration].[GetCustomerInserts]


CREATE PROCEDURE [Integration].[GetCustomerInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[CustomerAlternateKey] = CAST(C.AccountNumber AS NVARCHAR(15)),
		[GeographyCity] = A.City,
		[GeographyPostalCode] = A.PostalCode,
		[GeographyStateProvinceCode] = CAST(SP.StateProvinceCode AS NVARCHAR(3)),
		[GeographyCountryRegionCode] = SP.CountryRegionCode,
		[Title] = P.Title,
		[FirstName] = P.FirstName,
		[MiddleName] = P.MiddleName,
		[LastName] = P.LastName,
		[NameStyle] = P.NameStyle,
		[BirthDate] = PD.BirthDate,
		[MaritalStatus] = PD.MaritalStatus,
		[Suffix] = P.Suffix,
		[Gender] = PD.Gender,
		[EmailAddress] = E.EmailAddress,
		[YearlyIncome] = 
			CASE
				WHEN CHARINDEX('-', PD.YearlyIncome, 0) > 0 THEN SUBSTRING(PD.YearlyIncome, CHARINDEX('-', PD.YearlyIncome, 0) + 1, LEN(PD.YearlyIncome) - CHARINDEX('-', PD.YearlyIncome, 0))
				WHEN CHARINDEX('greater than', PD.YearlyIncome, 0) > 0 THEN REPLACE(PD.YearlyIncome, 'greater than', '')
				ELSE PD.YearlyIncome
			END,
			--PD.YearlyIncome,
		[TotalChildren] = PD.TotalChildren,
		[NumberChildrenAtHome] = PD.NumberChildrenAtHome,
		[EnglishEducation] = CAST(PD.Education AS NVARCHAR(40)),
		[SpanishEducation] = CAST(ET.SpanishName AS NVARCHAR(40)),
		[FrenchEducation] = CAST(ET.FrenchName AS NVARCHAR(40)),
		[EnglishOccupation] = PD.Occupation,
		[SpanishOccupation] = OT.SpanishName,
		[FrenchOccupation] = OT.FrenchName,
		[HouseOwnerFlag] = PD.HomeOwnerFlag,
		[NumberCarsOwned] = PD.NumberCarsOwned,
		[AddressLine1] = A.AddressLine1,
		[AddressLine2] = A.AddressLine2,
		[Phone] = CASt(PP.PhoneNumber AS NVARCHAR(20)),
		[DateFirstPurchase] = PD.DateFirstPurchase,
		[CommuteDistance] = CAST(PD.CommuteDistance AS NVARCHAR(15))
	FROM 
		Sales.Customer C LEFT JOIN
		Person.Person P ON
			P.BusinessEntityID = C.PersonID LEFT JOIN
		Sales.vPersonDemographics PD ON
			PD.BusinessEntityID = P.BusinessEntityID LEFT JOIN
		Person.EmailAddress E ON
			E.BusinessEntityID = P.BusinessEntityID LEFT JOIN
		Person.BusinessEntityAddress BEA ON
			BEA.BusinessEntityID = P.BusinessEntityID AND
			BEA.AddressTypeID = 2 LEFT JOIN
		Person.Address A ON
			A.AddressID = BEA.AddressID 
		CROSS APPLY
		(
			SELECT TOP 1
				PP.PhoneNumber
			FROM
				Person.PersonPhone PP 
			WHERE
				PP.BusinessEntityID = P.BusinessEntityID 
			ORDER BY
				PhoneNumberTypeID
		) PP LEFT JOIN
		Person.StateProvince SP ON
			SP.StateProvinceID = A.StateProvinceID LEFT JOIN
		Integration.EducationType ET ON 
			ET.Name = PD.Education LEFT JOIN
		Integration.OccupationType OT ON 
			OT.Name = PD.Occupation
	WHERE
		C.PersonID IS NOT NULL AND 
		C.StoreID IS NULL
	ORDER BY
		C.AccountNumber

END
GO
/****** Object:  StoredProcedure [Integration].[GetEmployeeInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Integration].[GetEmployeeInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT  
		[EmployeeNationalIDAlternateKey] = E.NationalIDNumber,
		[ParentEmployeeNationalIDAlternateKey] = E2.NationalIDNumber,
		[SalesTerritoryAlternateKey] = SP.TerritoryID,
		[FirstName] = P.FirstName,
		[LastName] = P.LastName,
		[MiddleName] = P.MiddleName,
		[NameStyle] = P.NameStyle,
		[Title] = E.JobTitle,
		[HireDate] = E.HireDate,
		[BirthDate] = E.BirthDate,
		[LoginID] = E.LoginID,
		[EmailAddress] = EA.EmailAddress,
		[Phone] = PP.PhoneNumber,
		[MaritalStatus] = E.MaritalStatus,
		[EmergencyContactName] = CAST(P.FirstName + ' ' + P.LastName AS NVARCHAR(50)),
		[EmergencyContactPhone] = PP.PhoneNumber,
		[SalariedFlag] = E.SalariedFlag,
		[Gender] = E.Gender,
		[PayFrequency] = EPH.PayFrequency,
		[BaseRate] = EPH.Rate,
		[VacationHours] = E.VacationHours,
		[SickLeaveHours] = E.SickLeaveHours,
		[CurrentFlag] = E.CurrentFlag,
		[SalesPersonFlag] = 
			CASE 
				WHEN SP.BusinessEntityID IS NULL THEN 0
				ELSE 1
			END,
		[DepartmentName] = D.Name,
		[StartDate] = EDH.StartDate,
		[EndDate] = EDH.EndDate,
		[Status] = CAST(
			CASE
				WHEN EDH.EndDate IS NULL THEN 'Current' 
				ELSE NULL
			END AS NVARCHAR(50)
		)
	FROM
		HumanResources.Employee E left join
		HumanResources.Employee E2 ON 
			E2.OrganizationNode = e.OrganizationNode.GetAncestor(1) OR
			(
				E.OrganizationNode.GetAncestor(1) = cast('/' AS hierarchyid) AND
				E2.OrganizationNode IS NULL
			) LEFT JOIN
		Person.Person P ON
			P.BusinessEntityID = E.BusinessEntityID LEFT JOIN
		Person.EmailAddress EA ON 
			EA.BusinessEntityID = P.BusinessEntityID 
		CROSS APPLY
		(
			SELECT TOP 1
				PP.PhoneNumber
			FROM
				Person.PersonPhone PP 
			WHERE
				PP.BusinessEntityID = P.BusinessEntityID 
			ORDER BY
				PP.PhoneNumberTypeID
		) PP LEFT JOIN
		Sales.SalesPerson SP ON 
			SP.BusinessEntityID = P.BusinessEntityID LEFT JOIN
		HumanResources.EmployeeDepartmentHistory EDH ON
			EDH.BusinessEntityID = E.BusinessEntityID LEFT JOIN
		HumanResources.Department D ON
			D.DepartmentID = EDH.DepartmentID 
		CROSS APPLY
		(
			SELECT TOP 1
				*
			FROM
				HumanResources.EmployeePayHistory EPH
			WHERE
				EPH.BusinessEntityID = E.BusinessEntityID
			ORDER BY
				EPH.RateChangeDate DESC
		) EPH
	ORDER BY 
		E.HireDate

END
GO
/****** Object:  StoredProcedure [Integration].[GetFactCurrencyRateInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--select * from AdventureWorksDW2022.dbo.FactInternetSales
--exec [Integration].[GetFactInternetSalesInserts]



CREATE PROCEDURE [Integration].[GetFactCurrencyRateInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT 
		[CurrencyAlternateKey] = CR.ToCurrencyCode,
		[DateKey] = (
			(YEAR(CR.CurrencyRateDate) * 10000) +
			(MONTH(CR.CurrencyRateDate) * 100) + 
			DAY(CR.CurrencyRateDate)
		),
		[AverageRate] = 1 / CR.AverageRate,
		[EndOfDayRate] = 1 / CR.EndOfDayRate,
		[Date] = CR.CurrencyRateDate
	FROM 
		Sales.CurrencyRate CR 
	ORDER BY
		CR.CurrencyRateDate,
		CR.ToCurrencyCode

END
GO
/****** Object:  StoredProcedure [Integration].[GetFactInternetSalesInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--select * from AdventureWorksDW2022.dbo.FactInternetSales
--exec [Integration].[GetFactInternetSalesInserts]



CREATE PROCEDURE [Integration].[GetFactInternetSalesInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT 
		[ProductAlternateKey] = P.ProductNumber,
		[OrderDateKey] = (
			(YEAR(SOH.OrderDate) * 10000) +
			(MONTH(SOH.OrderDate) * 100) + 
			DAY(SOH.OrderDate)
		),
		[DueDateKey] = (
			(YEAR(SOH.DueDate) * 10000) +
			(MONTH(SOH.DueDate) * 100) + 
			DAY(SOH.DueDate)
		),
		[ShipDateKey] = (
			(YEAR(SOH.ShipDate) * 10000) +
			(MONTH(SOH.ShipDate) * 100) + 
			DAY(SOH.ShipDate)
		),
		[CustomerAlternateKey] = CAST(C.AccountNumber AS NVARCHAR(50)),
		[PromotionAlternateKey] = SOD.SpecialOfferID,
		[CurrencyAlternateKey] = ISNULL(CR.ToCurrencyCode, 'USD'),
		[SalesTerritoryAlternateKey] = SOH.TerritoryID,
		[SalesOrderNumber] = CAST(SOH.SalesOrderNumber AS NVARCHAR(20)),
		[SalesOrderLineNumber] = (
			ROW_NUMBER() OVER(
				PARTITION BY 
					SOD.SalesOrderID 
				ORDER BY 
					SOD.SalesOrderDetailID ASC
			)
		),
		[RevisionNumber] = SOH.RevisionNumber,
		[OrderQuantity] = SOD.OrderQty,
		[UnitPrice] = SOD.UnitPrice,
		[ExtendedAmount] = SOD.UnitPrice * SOD.OrderQty,
		[UnitPriceDiscountPct] = SOD.UnitPriceDiscount,
		[DiscountAmount] = (
			SOD.UnitPrice * 
			SOD.OrderQty *
			SOD.UnitPriceDiscount
		),
		[ProductStandardCost] = COALESCE(PCH.StandardCost, P.StandardCost),
		[TotalProductCost] = (
			COALESCE(PCH.StandardCost, P.StandardCost) *
			SOD.OrderQty
		),
		[SalesAmount] = SOD.LineTotal,
		[TaxAmt] = ROUND(
			(
				(SOD.LineTotal / SOH.SubTotal) * 
				SOH.TaxAmt
			),
			4
		),
		[Freight] = ROUND(
			(
				(SOD.LineTotal / SOH.SubTotal) * 
				SOH.Freight
			),
			4
		),
		[CarrierrTrackingNumber] = SOD.CarrierTrackingNumber,
		[CustomerPONumber] = SOH.PurchaseOrderNumber,
		[OrderDate] = SOH.OrderDate,
		[DueDate] = SOH.DueDate,
		[ShipDate] = SOH.ShipDate
	FROM 
		Sales.Customer C LEFT JOIN
		Sales.SalesOrderHeader SOH ON 
			SOH.CustomerID = C.CustomerID LEFT JOIN
		Sales.SalesOrderDetail SOD ON
			SOD.SalesOrderID = SOH.SalesOrderID LEFT JOIN
		Production.[Product] P ON
			P.ProductID = SOD.ProductID LEFT JOIN
		Production.ProductCostHistory PCH ON 
			PCH.ProductID = SOD.ProductID 
			AND
			SOH.OrderDate >= PCH.StartDate AND 
			(
				SOH.OrderDate <= PCH.EndDate OR 
				PCH.EndDate IS NULL
			) 
			LEFT JOIN
		Sales.CurrencyRate CR ON
			CR.CurrencyRateID = SOH.CurrencyRateID 
	WHERE
		C.PersonID IS NOT NULL AND
		C.StoreID IS NULL 
	ORDER BY
		SOH.SalesOrderNumber,
		(
			ROW_NUMBER() OVER(
				PARTITION BY 
					SOD.SalesOrderID 
				ORDER BY 
					SOD.SalesOrderDetailID ASC
			)
		)

END
GO
/****** Object:  StoredProcedure [Integration].[GetFactInternetSalesReasonInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Integration].[GetFactInternetSalesReasonInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[SalesOrderNumber] = CAST(SOH.SalesOrderNumber AS NVARCHAR(20)),
		[SalesOrderLineNumber] = SOH.SalesOrderLineNumber,
		[SalesReasonAlternateKey] = SOHSR.SalesReasonID
	FROM
		Sales.SalesOrderHeaderSalesReason SOHSR 
		CROSS APPLY
		(
			SELECT
				[SalesOrderNumber] = SOH.SalesOrderNumber,
				[SalesOrderLineNumber] = (
					ROW_NUMBER() OVER(
						PARTITION BY 
							SOD.SalesOrderID 
						ORDER BY 
							SOD.SalesOrderDetailID ASC
					)
				)
			FROM
				Sales.SalesOrderHeader SOH JOIN
				Sales.SalesOrderDetail SOD ON
					SOD.SalesOrderID = SOH.SalesOrderID 
			WHERE
				SOH.SalesOrderID = SOHSR.SalesOrderID
		) SOH
	ORDER BY
		SOH.SalesOrderNumber,
		SOH.salesOrderLineNumber,
		SOHSR.SalesReasonID

END
GO
/****** Object:  StoredProcedure [Integration].[GetFactResellerSalesInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Integration].[GetFactResellerSalesInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT 
		[ProductAlternateKey] = P.ProductNumber,
		[OrderDateKey] = (
			(YEAR(SOH.OrderDate) * 10000) +
			(MONTH(SOH.OrderDate) * 100) + 
			DAY(SOH.OrderDate)
		),
		[DueDateKey] = (
			(YEAR(SOH.DueDate) * 10000) +
			(MONTH(SOH.DueDate) * 100) + 
			DAY(SOH.DueDate)
		),
		[ShipDateKey] = (
			(YEAR(SOH.ShipDate) * 10000) +
			(MONTH(SOH.ShipDate) * 100) + 
			DAY(SOH.ShipDate)
		),
		[ResellerAlternateKey] = CAST(C2.AccountNumber AS NVARCHAR(50)),
		[EmployeeNationalIDAlternateKey] = E.NationalIDNumber,
		[PromotionAlternateKey] = SOD.SpecialOfferID,
		[CurrencyAlternateKey] = ISNULL(CR.ToCurrencyCode, 'USD'),
		[SalesTerritoryAlternateKey] = SOH.TerritoryID,
		[SalesOrderNumber] = CAST(SOH.SalesOrderNumber AS NVARCHAR(20)),
		[SalesOrderLineNumber] = (
			ROW_NUMBER() OVER(
				PARTITION BY 
					SOD.SalesOrderID 
				ORDER BY 
					SOD.SalesOrderDetailID ASC
			) 
		),
		[RevisionNumber] = SOH.RevisionNumber,
		[OrderQuantity] = SOD.OrderQty,
		[UnitPrice] = SOD.UnitPrice,
		[ExtendedAmount] = SOD.UnitPrice * SOD.OrderQty,
		[UnitPriceDiscountPct] = SOD.UnitPriceDiscount,
		[DiscountAmount] = (
			SOD.UnitPrice * 
			SOD.OrderQty *
			SOD.UnitPriceDiscount
		),
		[ProductStandardCost] = COALESCE(PCH.StandardCost, P.StandardCost),
		[TotalProductCost] = (
			COALESCE(PCH.StandardCost, P.StandardCost) *
			SOD.OrderQty
		),
		[SalesAmount] = SOD.LineTotal,
		[TaxAmt] = ROUND(
			(
				(SOD.LineTotal / SOH.SubTotal) * 
				SOH.TaxAmt
			),
			4
		),
		[Freight] = ROUND(
			(
				(SOD.LineTotal / SOH.SubTotal) * 
				SOH.Freight
			),
			4
		),
		[CarrierTrackingNumber] = SOD.CarrierTrackingNumber,
		[CustomerPONumber] = SOH.PurchaseOrderNumber,
		[OrderDate] = SOH.OrderDate,
		[DueDate] = SOH.DueDate,
		[ShipDate] = SOH.ShipDate
	FROM
		Sales.SalesOrderHeader SOH LEFT JOIN
		Sales.SalesOrderDetail SOD ON
			SOD.SalesOrderID = SOH.SalesOrderID LEFT JOIN
		Sales.Customer C ON 
			C.CustomerID = SOH.CustomerID LEFT JOIN
		Sales.Customer C2 ON
			C2.StoreID = C.StoreID AND
			C2.PersonID IS NULL LEFT JOIN
		Production.[Product] P ON
			P.ProductID = SOD.ProductID LEFT JOIN
		Production.ProductCostHistory PCH ON 
			PCH.ProductID = SOD.ProductID 
			AND
			SOH.OrderDate >= PCH.StartDate AND 
			(
				SOH.OrderDate <= PCH.EndDate OR 
				PCH.EndDate IS NULL
			) 
			LEFT JOIN
		Sales.CurrencyRate CR ON
			CR.CurrencyRateID = SOH.CurrencyRateID LEFT JOIN
		Sales.SalesPerson SP ON
			SP.BusinessEntityID = SOH.SalesPersonID LEFT JOIN
		HumanResources.Employee E ON
			E.BusinessEntityID = SP.BusinessEntityID
	WHERE
		C.StoreID IS NOT NULL AND
		SOH.SalesOrderID IS NOT NULL
	ORDER BY
		SOH.SalesOrderID,
		SOD.SalesOrderDetailID

END
GO
/****** Object:  StoredProcedure [Integration].[GetGeographyInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Integration].[GetGeographyInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT DISTINCT
		[City] = AD.City, 
		[StateProvinceCode] = SP.StateProvinceCode, 
		[StateProvinceName] = SP.Name,
		[CountryRegionCode] = SP.CountryRegionCode,
		[EnglishCountryRegionName] = CR.Name,
		[SpanishCountryRegionName] = ICR.SpanishCountryRegionName,
		[FrenchCountryRegionName] = ICR.FrenchCountryRegionName,
		[PostalCode] = AD.PostalCode,
		[SalesTerritoryAlternateKey] = SP.TerritoryID
	FROM
		Person.Address AD LEFT JOIN
		Person.StateProvince SP ON
			SP.StateProvinceID = AD.StateProvinceID LEFT JOIN
		Person.CountryRegion CR ON
			CR.CountryRegionCode = SP.CountryRegionCode LEFT JOIN
		Integration.CountryRegion ICR ON
			ICR.CountryRegionName = CR.Name
	ORDER BY
		CR.Name,
		SP.Name,
		AD.City,
		AD.PostalCode

END
GO
/****** Object:  StoredProcedure [Integration].[GetProductCategoryInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Integration].[GetProductCategoryInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[ProductCategoryAlternateKey] = PC.ProductCategoryID,
		[EnglishProductCategoryName] = PC.Name,
		[SpanishProductCategoryName] = PCT.SpanishName,
		[FrenchProductCategoryName] = PCT.FrenchName
	FROM
		Production.ProductCategory PC LEFT JOIN
		Integration.ProductCategoryType PCT ON
			PCT.Name = PC.Name
	ORDER BY
		PC.ProductCategoryID 


END
GO
/****** Object:  StoredProcedure [Integration].[GetProductInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from AdventureWorksDW2022.dbo.DimProduct
--exec [Integration].[GetProductInserts]

--select * from Production.ProductSubcategory


CREATE PROCEDURE [Integration].[GetProductInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT 
		[ProductAlternateKey] = P.ProductNumber,
		[ProductSubcategoryAlternateKey] = P.ProductSubcategoryID,
		[WeightUnitMeasureCode] = P.WeightUnitMeasureCode,
		[SizeUnitMeasureCode] = P.SizeUnitMeasureCode,
		[EnglishProductName] = P.[Name],
		[SpanishProductName] = PNT.SpanishName,
		[FrenchProductName] = PNT.FrenchName,
		[StandardCost] = 
			CASE 
				WHEN PCH.StartDate IS NOT NULL THEN PCH.StandardCost
				ELSE P.StandardCost
			END,
		[FinishedGoodsFlag] = P.FinishedGoodsFlag,
		[Color] = ISNULL(P.Color, 'NA'),
		[SafetyStockLevel] = P.SafetyStockLevel,
		[ReorderPoint] = P.ReorderPoint,
		[ListPrice] = 
			CASE
				WHEN PLPH.StartDate IS NOT NULL THEN PLPH.ListPrice
				ELSE P.ListPrice
			END,
		[Size] = P.Size,
		[SizeRange] = ISNULL(SRT.SizeRange, 'NA'),
		[Weight] = P.[Weight],
		[DaysToManufacture] = P.DaysToManufacture,
		[ProductLine] = P.ProductLine,
		[DealerPrice] = NULL,
		[Class] = P.Class,
		[Style] = P.Style,
		[ModelName] = PM.Name,
		[LargePhoto] = PP.LargePhoto,
		[EnglishDescription] = PD.Description,
		[FrenchDescription] = PD2.Description,
		[ChineseDescription] = PD3.Description,
		[ArabicDescription] = PD4.Description,
		[HebrewDescription] = PD5.Description,
		[ThaiDescription] = PD6.Description,
		[GermanDescription] = PDT.GermanDescription,
		[JapaneseDescription] = PDT.JapaneseDescription,
		[TurkishDescription] = PDT.TurkishDescription,
		[StartDate] = PCH.StartDate,
		[EndDate] = PCH.EndDate,
		[Status] = CAST(
			CASE 
				WHEN PLPH.EndDate IS NULL THEN 'Current'
				ELSE NULL
			END AS NVARCHAR(7)
		)
	FROM 
		Production.[Product] P LEFT JOIN
		Production.ProductListPriceHistory PLPH ON
			PLPH.ProductID = P.ProductID LEFT JOIN
		Production.ProductCostHistory PCH ON
			PCH.ProductID = P.ProductID AND
			PLPH.StartDate = PCH.StartDate LEFT JOIN
		Production.ProductModel PM ON
			PM.ProductModelID = P.ProductModelID LEFT JOIN
		Production.ProductProductPhoto PPP ON
			PPP.ProductID = P.ProductID LEFT JOIN
		Production.ProductPhoto PP ON
			PP.ProductPhotoID = PPP.ProductPhotoID LEFT JOIN
		Production.ProductModelProductDescriptionCulture PMDC ON
			PMDC.ProductModelID = PM.ProductModelID AND
			PMDC.CultureID = 'en' LEFT JOIN
		Production.ProductDescription PD ON
			PD.ProductDescriptionID = PMDC.ProductDescriptionID LEFT JOIN
		Production.ProductModelProductDescriptionCulture PMDC2 ON
			PMDC2.ProductModelID = PM.ProductModelID AND
			PMDC2.CultureID = 'fr' LEFT JOIN
		Production.ProductDescription PD2 ON
			PD2.ProductDescriptionID = PMDC2.ProductDescriptionID LEFT JOIN 
		Production.ProductModelProductDescriptionCulture PMDC3 ON
			PMDC3.ProductModelID = PM.ProductModelID AND
			PMDC3.CultureID = 'zh-cht' LEFT JOIN
		Production.ProductDescription PD3 ON
			PD3.ProductDescriptionID = PMDC3.ProductDescriptionID LEFT JOIN
		Production.ProductModelProductDescriptionCulture PMDC4 ON
			PMDC4.ProductModelID = PM.ProductModelID AND
			PMDC4.CultureID = 'ar' LEFT JOIN
		Production.ProductDescription PD4 ON
			PD4.ProductDescriptionID = PMDC4.ProductDescriptionID LEFT JOIN
		Production.ProductModelProductDescriptionCulture PMDC5 ON
			PMDC5.ProductModelID = PM.ProductModelID AND
			PMDC5.CultureID = 'he' LEFT JOIN
		Production.ProductDescription PD5 ON
			PD5.ProductDescriptionID = PMDC5.ProductDescriptionID LEFT JOIN
		Production.ProductModelProductDescriptionCulture PMDC6 ON
			PMDC6.ProductModelID = PM.ProductModelID AND
			PMDC6.CultureID = 'th' LEFT JOIN
		Production.ProductDescription PD6 ON
			PD6.ProductDescriptionID = PMDC6.ProductDescriptionID LEFT JOIN
		Integration.ProductDescriptionType PDT ON
			PDT.Description = PD.Description LEFT JOIN
		Integration.ProductNameType PNT ON
			PNT.Name = P.Name LEFT JOIN
		Integration.SizeRangeType SRT ON 
			SRT.Size = P.Size
	ORDER BY
		P.ProductID

END
GO
/****** Object:  StoredProcedure [Integration].[GetProductSubcategoryInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Integration].[GetProductSubcategoryInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[ProductSubcategoryAlternateKey] = PSC.ProductSubcategoryID,
		[EnglishProductSubcategoryName] = PSC.Name,
		[SpanishProductSubcategoryName] = PSCT.SpanishName,
		[FrenchProductSubcategoryName] = PSCT.FrenchName,
		[ProductCategoryAlternateKey] = PSC.ProductCategoryID
	FROM
		Production.ProductSubcategory PSC LEFT JOIN
		Integration.ProductSubcategoryType PSCT ON
			PSCT.Name = PSC.Name
	ORDER BY
		PSC.ProductSubcategoryID

END
GO
/****** Object:  StoredProcedure [Integration].[GetPromotionInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from AdventureWorksDW2022.dbo.DimPromotion
--exec [Integration].[GetPromotionInserts]

CREATE PROCEDURE [Integration].[GetPromotionInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[PromotionAlternateKey] = SO.SpecialOfferID,
		[EnglishPromotionName] = SO.[Description],
		[SpanishPromotionName] = PNT.[SpanishName],
		[FrenchPromotionName] = PNT.[FrenchName],
		[DiscountPct] = SO.DiscountPct,
		[EnglishPromotionType] = SO.[Type],
		[SpanishPromotionType] = PT.[SpanishName],
		[FrenchPromotionType] = PT.[FrenchName],
		[EnglishPromotionCategory] = SO.Category,
		[SpanishPromotionCategory] = PCT.SpanishName,
		[FrenchPromotionCategory] = PCT.FrenchName,
		[StartDate] = SO.StartDate,
		[EndDate] = SO.EndDate,
		[MinQty] = SO.MinQty,
		[MaxQty] = SO.MaxQty
	FROM
		Sales.SpecialOffer SO LEFT JOIN
		Integration.PromotionNameType PNT ON
			PNT.Name = SO.Description LEFT JOIN
		Integration.PromotionType PT ON
			PT.Name = SO.Type LEFT JOIN
		Integration.PromotionCategoryType PCT ON
			PCT.Name = SO.Category
	ORDER BY
		SO.SpecialOfferID
	
END
GO
/****** Object:  StoredProcedure [Integration].[GetResellerInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Integration].[GetResellerInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT
		[GeographyCity] = AD.City,
		[GeographyPostalCode] = AD.PostalCode,
		[GeographyStateProvinceCode] = CAST(SP.StateProvinceCode AS NVARCHAR(3)),
		[GeographyCountryRegionCode] = SP.CountryRegionCode,
		[ResellerAlternateKey] = CAST(C.AccountNumber AS NVARCHAR(15)),
		[Phone] = PP.PhoneNumber,
		[BusinessType] = CAST(SBT.[Name] AS VARCHAR(20)),
		[ResellerName] = S.[Name],
		[NumberEmployees] = S.NumberEmployees,
		[OrderFrequency] = NULL,
		[OrderMonth] = NULL,
		[FirstOrderYear] = COALESCE(
			MIN(YEAR(SO.orderdate)), 
			MIN(YEAR(SO2.orderdate))
		),
		[LastOrderYear] = COALESCE(
			MAX(YEAR(SO.orderdate)), MAX(YEAR(SO2.orderdate))
		),
		[ProductLine] = S.Specialty,
		[AddressLine1] = AD.AddressLine1,
		[AddressLine2] = AD.AddressLine2,
		[AnnualSales] = S.AnnualSales,
		[BankName] = S.BankName,
		[MinPaymentType] = NULL,
		[MinPaymentAmount] = NULL,
		[AnnualRevenue] = S.AnnualRevenue,
		[YearOpened] = S.YearOpened
	FROM 
		Sales.Customer C LEFT JOIN 
		Sales.Customer C2 on
			C2.StoreID = C.StoreID LEFT JOIN
		Sales.vStoreWithDemographics S ON
			S.BusinessEntityID = C.StoreID LEFT JOIN
		Sales.SalesOrderHeader SO ON
			SO.CustomerID = C.CustomerID LEFT JOIN
		Sales.SalesOrderHeader SO2 ON
			SO2.CustomerID = C2.CustomerID LEFT JOIN
		Integration.StoreBusinessType SBT ON
			SBT.Code = S.BusinessType
		CROSS APPLY
		(
			SELECT TOP 1
				BEC.PersonID,
				BEC.ContactTypeID
			FROM	
				Person.BusinessEntityContact BEC LEFT JOIN
				Person.ContactType CT ON
					CT.ContactTypeID = BEC.ContactTypeID
			WHERE
				BEC.BusinessEntityID = S.BusinessEntityID 
			ORDER BY
				CASE
					WHEN CT.Name = 'Owner' THEN 1
					WHEN CHARINDEX('Manager', CT.Name) > 0 THEN 2
					ELSE 3
				END
		) CT 
		CROSS APPLY
		(
			SELECT TOP 1
				PP.PhoneNumber
			FROM
				Person.PersonPhone PP 
			WHERE
				PP.BusinessEntityID = CT.PersonID
			ORDER BY
				CASE 
					WHEN PP.PhoneNumberTypeID = 3 THEN 1
					WHEN PP.PhoneNumberTypeID = 1 THEN 2
					ELSE 3
				END
		) PP 
		CROSS APPLY
		(
			SELECT TOP 1
				BEA.AddressID
			FROM
				Person.BusinessEntityAddress BEA LEFT JOIN
				Person.AddressType A ON
					A.AddressTypeID = BEA.AddressTypeID
			WHERE
				BEA.BusinessEntityID = S.BusinessEntityID
			ORDER BY
				CASE
					WHEN A.[Name] = 'Main Office' THEN 1
					WHEN A.[Name] = 'Primary' THEN 2
					WHEN A.[Name] = 'Billing' THEN 3
					WHEN A.[Name] = 'Shipping' THEN 4
					ELSE 5
				END
		) A LEFT JOIN
		Person.Address AD ON
			AD.AddressID = A.AddressID LEFT JOIN
		Person.StateProvince SP ON
			SP.StateProvinceID = AD.StateProvinceID
	WHERE 
		C.StoreID IS NOT NULL AND
		C.PersonID IS NULL
	GROUP BY
		C.StoreID,
		C.AccountNumber,
		C.CustomerID,
		SBT.[Name],
		S.[Name],
		S.NumberEmployees,
		PP.PhoneNumber,
		AD.AddressLine1,
		AD.AddressLine2,
		S.Specialty,
		S.AnnualSales,
		S.BankName,
		S.AnnualRevenue,
		S.YearOpened,	
		AD.City,
		AD.PostalCode,
		SP.StateProvinceCode,
		SP.CountryRegionCode,
		C.AccountNumber
	ORDER BY
		C.AccountNumber
	
END
GO
/****** Object:  StoredProcedure [Integration].[GetSalesReasonInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Integration].[GetSalesReasonInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

	SELECT 
		[SalesReasonAlternateKey] = SR.SalesReasonID,
		[SalesReasonName] = SR.[Name],
		[SalesReasonReasonType] = SR.ReasonType
	FROM 
		Sales.SalesReason SR
	ORDER BY
		SR.SalesReasonID
	
END
GO
/****** Object:  StoredProcedure [Integration].[GetSalesTerritoryInserts]    Script Date: 6/4/2025 10:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Integration].[GetSalesTerritoryInserts]
AS
BEGIN
    
	SET NOCOUNT ON;

    SELECT
		[SalesTerritoryAlternateKey] = ST.TerritoryID,
		[SalesTerrirtoryRegion] = ST.Name,
		[SalesTerritoryCountry] = CR.Name,
		[SalesTerritoryGroup] = ST.[Group]
	FROM
		Sales.SalesTerritory ST LEFT JOIN
		Person.CountryRegion CR ON
			CR.CountryRegionCode = ST.CountryRegionCode
	ORDER BY
		ST.TerritoryID
	
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains objects related to integration to datawarehouse.' , @level0type=N'SCHEMA',@level0name=N'Integration'
GO
