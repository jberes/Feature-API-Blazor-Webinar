USE [master]
GO
/****** Object:  Database [Features]    Script Date: 8/31/2022 8:43:00 AM ******/
CREATE DATABASE [Features]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Features', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Features.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Features_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Features_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Features] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Features].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Features] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Features] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Features] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Features] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Features] SET ARITHABORT OFF 
GO
ALTER DATABASE [Features] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Features] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Features] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Features] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Features] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Features] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Features] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Features] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Features] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Features] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Features] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Features] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Features] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Features] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Features] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Features] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Features] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Features] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Features] SET  MULTI_USER 
GO
ALTER DATABASE [Features] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Features] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Features] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Features] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Features] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Features] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Features] SET QUERY_STORE = OFF
GO
USE [Features]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 8/31/2022 8:43:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Product] [varchar](75) NOT NULL,
 CONSTRAINT [PK_Productss] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Features]    Script Date: 8/31/2022 8:43:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Features](
	[FeatureId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Description] [varchar](500) NULL,
	[RequestorEmail] [varchar](75) NOT NULL,
	[DateAdded] [date] NOT NULL,
 CONSTRAINT [PK_Features] PRIMARY KEY CLUSTERED 
(
	[FeatureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_FeatureProducts]    Script Date: 8/31/2022 8:43:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_FeatureProducts]
AS
SELECT dbo.Features.FeatureId, dbo.Features.ProductId, dbo.Features.Title, dbo.Features.Description, dbo.Features.RequestorEmail, dbo.Features.DateAdded, dbo.Products.Product
FROM  dbo.Features INNER JOIN
         dbo.Products ON dbo.Features.ProductId = dbo.Products.ProductId
GO
SET IDENTITY_INSERT [dbo].[Features] ON 
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (1, 2, N'Update Feature One', N'Updated Feature One Description', N'one@email.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (4, 5, N'Feature Four', N'Feature Four Description', N'email@email.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (5, 1, N'Feature Five', N'Feature Five Description', N'email@email.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (6, 2, N'Title Six', N'Feature Six', N'six@email.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (8, 3, N'New 11', N'Description Eleven', N'11@email.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (10, 2, N'Title Twelve', N'Description Twelve', N'twelve@email.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (11, 2, N'Product New Two', N'Product Description', N'email@newrecord.com', CAST(N'2022-08-29' AS Date))
GO
INSERT [dbo].[Features] ([FeatureId], [ProductId], [Title], [Description], [RequestorEmail], [DateAdded]) VALUES (15, 0, N'string', N'string', N'string', CAST(N'2022-08-30' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Features] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 
GO
INSERT [dbo].[Products] ([ProductId], [Product]) VALUES (1, N'Product One')
GO
INSERT [dbo].[Products] ([ProductId], [Product]) VALUES (2, N'Product Two')
GO
INSERT [dbo].[Products] ([ProductId], [Product]) VALUES (3, N'Product Three')
GO
INSERT [dbo].[Products] ([ProductId], [Product]) VALUES (4, N'Product Four')
GO
INSERT [dbo].[Products] ([ProductId], [Product]) VALUES (5, N'Product Five')
GO
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
ALTER TABLE [dbo].[Features] ADD  CONSTRAINT [DF_Features_ProductId]  DEFAULT ((1)) FOR [ProductId]
GO
ALTER TABLE [dbo].[Features] ADD  CONSTRAINT [DF_Features_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFeatures]    Script Date: 8/31/2022 8:43:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetFeatures]
AS
SELECT *
FROM vw_FeatureProductss
Order By DateAdded
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFeaturesByProduct]    Script Date: 8/31/2022 8:43:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetFeaturesByProduct] @FeatureID int
AS
SELECT *
FROM vw_FeatureProductss
WHERE FeatureId = @FeatureID
GO

USE [master]
GO
ALTER DATABASE [Features] SET  READ_WRITE 
GO
