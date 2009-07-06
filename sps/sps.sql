SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DBVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,RBP>
-- Create date: <Create Date,,20/05/2008>
-- Description:	<Description,,Return DB Version>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DBVersion]
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT max(Version) as Version from DBChanges
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_All_Images_Range]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author: Cabinet UK - Rodrigo
-- Create date: 21/11/08
-- Description:	Get the images and join the stock, paginate and then return the resultset.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_All_Images_Range]
	-- Add the parameters for the stored procedure here
	@Offset int,
	@MaxResults int,
	@UpID varchar(10) = '''',
	@ImageType varchar(50) = '''',
	@YouFinder varchar(2) = ''''
AS
BEGIN

-- test EXEC NEW_TEST_Cab_Get_Images_Range 5,1,22,''1,2,3,4,5,6''


	-- set a few vars
	declare @sql varchar(7999)
	declare @lastRow int 
	set @lastRow = (@Offset + @MaxResults)
	set @sql = ('' SELECT * FROM (
					SELECT row_number() OVER (ORDER BY ImageTypeID ASC, ModifiedDate DESC) as resultNum, *
					FROM  (
						SELECT Images.BulkImageID
									,PrintDate
									,EventID
									,ImagePaths.ImagePath
									,PreviewImage+ ''''_T.jpg'''' as Thumbnail
									,PreviewImage+ ''''_P.jpg'''' as Preview
									,PreviewImage+ ''''_L.jpg'''' as Largepreview
									,Available
									,PrintJobID
									,DfltCropW
									,DfltCropH
									,DfltCropL
									,DfltCropT
									,RawImageH
									,RawImageW
									,AssociatedParent
									,ProductID
									,SourceFlag
									,PictureStatus
									,IsGuestPhoto
									,MasterImage
									,Rotate
									,PrintQuantity
									,Images.[CreatedDate]
									,Images.[ModifiedDate]
									,ImagePathID
									,OCItem
									,FROrderIndex
									,RenderAttempts
									,ImagesToPrintFlag
									,ImageTypeID
									
						FROM Images 
						INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
						INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
						INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
						INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
						LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = ''+ @UpID +''
						INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
						WHERE Manifest.UniquePassengerID = ''+ @UpID +''
						AND Images.ImageTypeID in (''+ @ImageType +'')
						AND Images.BulkImageID not in (select HiddenImages.BulkImageID from HiddenImages where HiddenImages.UniquePassengerID = ''+ @UpID +'') 
						AND Images.Available = 1
						AND Images.EventID IS NOT NULL
						                             
						UNION ALL
						                             
						SELECT Images.BulkImageID
									,PrintDate
									,EventID
									,ImagePaths.ImagePath
									,PreviewImage+ ''''_T.jpg'''' as Thumbnail
									,PreviewImage+ ''''_P.jpg'''' as Preview
									,PreviewImage+ ''''_L.jpg'''' as Largepreview
									,Available
									,PrintJobID
									,DfltCropW
									,DfltCropH
									,DfltCropL
									,DfltCropT
									,RawImageH
									,RawImageW
									,AssociatedParent
									,ProductID
									,SourceFlag
									,PictureStatus
									,IsGuestPhoto
									,MasterImage
									,Rotate
									,PrintQuantity
									,Images.[CreatedDate]
									,Images.[ModifiedDate]
									,ImagePathID
									,OCItem
									,FROrderIndex
									,RenderAttempts
									,ImagesToPrintFlag
									,200 as ImageTypeID
									
						FROM Images
						INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
						WHERE Images.ImageTypeID = 2
						AND Images.Available = 1
						AND Images.EventID IS NOT NULL
					) tempCountTbl
				) as numberResults
				WHERE resultNum BETWEEN '' + cast(@Offset as varchar) + '' AND ''+ cast(@lastRow as varchar) +''
				'')

			-- execute 
			exec (@sql) 

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_TemplateDetails_By_ProductID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get product details depending on given criteria.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_TemplateDetails_By_ProductID]
	@ProductID varchar(50) = ''''
AS
	DECLARE @Sql varchar(2000)
	DECLARE @Criteria varchar(2000)
BEGIN
	
	SET @Sql = ''SELECT Products.*, ProductType.ProductTypeDescription, ProductImageItem.*
				FROM Products, ProductType
				INNER JOIN ProductImageItem On ProductImageItem.ProductID = ''+ @ProductID +''
				WHERE ProductType.ProductTypeKey = Products.ProductTypeID ''

	SET @Criteria = ''AND Products.ProductKey = '' + @ProductID


	EXEC(@Sql + @Criteria)
END






' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ServicesAvailability_By_Hour]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 22/07/08
-- Description:	Get Services Availability depending on given parameters.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ServicesAvailability_By_Hour]
	@CruiseID int,
	@ServiceID int,
	@KioskID int,
	@Day int,
	@Month int,
	@Year int,
	@Hour varchar(2) = '''',
	@Min varchar(2) = ''''
AS
	DECLARE @Column varchar(30)
BEGIN
	IF @Hour = ''''
		BEGIN
			SET @Column = ''Service_On''
		END
	ELSE
		BEGIN
			IF @Min >= 30
				BEGIN
					SET @Column = @Hour + ''_30''
				END
			ELSE
				BEGIN
					SET @Column = @Hour
				END
		END

	EXEC(''	SELECT ServiceAvailability_'' + @Column + ''
			FROM ServiceAvailability_CabUK 
			WHERE ServiceAvailability_CabUK.ServiceAvailability_Cruise_Id = '' + @CruiseID + ''
			AND ServiceAvailability_Service_Id = '' + @ServiceID + ''
			AND ServiceAvailability_CabUK.ServiceAvailability_Kiosk_Id = '' + @KioskID + ''
			AND DATEPART(day, ServiceAvailability_CabUK.ServiceAvailability_Date_Time) = '' + @Day + ''
			AND DATEPART(month, ServiceAvailability_CabUK.ServiceAvailability_Date_Time) = '' + @Month + ''
			AND DATEPART(year, ServiceAvailability_CabUK.ServiceAvailability_Date_Time) = '' + @Year)
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackage_By_Criteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get an order package.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_OrderPackage_By_Criteria]
	@SearchByField nvarchar(100) ,
	@SearchByValue int
AS
	SET @SearchByField = LOWER(@SearchByField)	
	
	EXEC ('' SELECT * FROM OrderPackages  WHERE '' + @SearchByField +   ''= ''  + @SearchByValue)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetails_By_Criteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get the details of an order.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_OrderDetails_By_Criteria]
	@SearchByField nvarchar(100) ,
	@SearchByValue int
AS
	SET @SearchByField = LOWER(@SearchByField)	
	
	EXEC ('' SELECT * FROM OrderDetails  WHERE '' + @SearchByField +   ''= ''  + @SearchByValue)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_OrderStatus_Lookup_By_Description]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Return the code for an order status.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_OrderStatus_Lookup_By_Description]
	@OrderStatusName nvarchar(30)='''',
	@StatusId int OUTPUT

AS

SET @OrderStatusName = LOWER(@OrderStatusName)

SELECT @StatusId = 
	Case @OrderStatusName
		When ''open'' then -1
		When ''nothing'' then 0
		When ''created'' then 1
		When ''processed'' then 2
		When ''delivered'' then 3
		When ''rejected'' then 4
		When ''uncollected'' then 5
		When ''deleted'' then 6
	END

return

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Order_By_Criteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Search an order by PassengerName, PaxID, Cabin or FolioNumber.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Order_By_Criteria] 
	@PassengerName varchar(50)	= '''', 
	@PaxID varchar(50)			= '''', 
	@CabinNumber varchar(50)	= '''', 
	@FolioNumber varchar(50)	= ''''
AS
BEGIN

-- test (exec Cab_Get_Order_By_Criteria ''a'', ''001417922'', ''6132'', ''327603'')
declare @sql varchar (1000)	
declare @ext varchar (500)
	set @ext = ''''
	-- build up the WHERE clause of the query
	if @PassengerName != ''''
		begin 
			set @ext = ('' AND PassengerName LIKE ''''%'' + @PassengerName + ''%'''''') 
		end

	if @PaxId != ''''
		begin 
			set @ext = @ext + ('' AND PaxID = '' + @PaxID + '''')
		end

	if @CabinNumber != ''''
		begin	
			set @ext = @ext + ('' AND CabinNr = '' + @CabinNumber + '''')
		end
		

	if @FolioNumber != ''''
		begin
			set @ext = @ext + ('' AND FolioNumber ='' + @FolioNumber + '''')
		end

	set @ext = SUBSTRING(@ext, 5, 50)

	set @sql = (''
	SELECT DISTINCT PaxID, PassengerName, OrderID, UniquePassengerID
	FROM Orders_MultiLine
	WHERE '' + @ext + ''
	ORDER BY PassengerName
	'')
exec (@sql)

END





' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Emails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get emails details for an order package.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Emails]
	@OrderPackageID varchar = ''''
AS
	declare @sql varchar(2000)
BEGIN
	SET @sql = ''SELECT  Email_CabUK.*,
						OrderPackages.OrderLotID, OrderPackages.OrderPackageKey
				FROM Email_CabUK
				JOIN OrderDetails ON OrderDetails.OrderDetailKey = Email_CabUK.Email_OrderDetailID
				JOIN OrderPackages ON OrderPackages.OrderPackagekey = OrderDetails.OrderPackageId''

	IF @OrderPackageID <> ''''
	BEGIN
		SET @sql = @sql + '' WHERE OrderDetails.OrderPackageId = '' + @OrderPackageID
	END

	EXEC(@sql)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Passenger_By_Criteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		Cabinet UK
-- Create date: 16/07/08
-- Description:	Return Manifest rows that match the criteria and columnName sent.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Passenger_By_Criteria] 
	@columnName nvarchar(50),
	@criteria nvarchar(50),
	@searchType nvarchar(4) = '' = '',
	@orderBy nvarchar(20) = '''',
	@orderType nvarchar(5) = '''',
	@limit varchar = ''''

AS
	-- declare the variables here. The @sql will be our main sql string
	declare @sql varchar(300)
	declare @extSql varchar(100)

BEGIN
	-- if we set a limit, then we must have a SELECT TOP @limit, if not then just SELECT on the @sql string
	IF @limit ! = ''''
		begin
			-- Join "top @limit" if the limit is set on the params
			set @sql = ''SELECT TOP ''+ @limit
		end
	ELSE
		begin
			-- set the @sql to "select" if no limit is required
			set @sql = ''SELECT''
		end
	
	-- lets construct the rest of the query and pass the basic search fields, comparisonType and values 
	SET @sql = @sql + (''
			* 
		FROM
			dbo.Manifest as m
		WHERE 
			'' + @ColumnName + '' '' + @searchType + '' '''''' + @criteria + '''''''')
	
	-- if there is NOT a param set to order the result (@orderBy) then we execute the query as is
	if @orderBy = ''''
		begin
			exec (@sql)
		end
	else
		begin
			-- if there is a @orderBy we need to adjoin it to the @sql query and then execute to have a ordered result
			set @extSql = ('' ORDER BY '' + @orderBy + '' DESC '')
			set @sql = @sql + SPACE(1) + @extSql
			-- select (@sql)
			exec (@sql)
		end
END





' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrdersMultiline_By_Criteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 28/07/08
-- Description: (TODO : Description -> Update an order?)
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_OrdersMultiline_By_Criteria]
	@FieldAndValue varchar(300),
	@OrderLotKey int
AS
BEGIN
	declare @sql varchar (1000)
	set @sql = ('' 
		UPDATE Orders_Multiline 
		SET '' + @FieldAndValue + ''
		WHERE OrderLotKey = '' + cast(@OrderLotKey as varchar) + ''
		'')
	exec (@sql)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_OrderPaymentStatus_Lookup_By_Description]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Check the status of a payment.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_OrderPaymentStatus_Lookup_By_Description]
	@PaymentStatusName nvarchar(30)='''',
	@StatusId int OUTPUT
AS
SET @PaymentStatusName = LOWER(@PaymentStatusName)

SELECT @StatusId = 
	Case @PaymentStatusName
		When ''nothing'' then 0
		When ''awaiting payment'' then 1
		When ''paid'' then 2
		When ''payment refused'' then 3
	END

return

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_PackageDetails_For_ProductKey_And_Quantity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <24/07/08>
-- Description:	<Return package details by product key and quantity >
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_PackageDetails_For_ProductKey_And_Quantity]

	@prodId varchar(2000),
	@productQty smallint,
	@lang varchar(10) = ''0''

AS

	declare @sql varchar(300)
	declare @extsql varchar(100)

BEGIN
	

	SET @sql = ''SELECT Package_CabUK.Package_Name, Package_CabUK.Package_Price
					   FROM Package_CabUK
					   JOIN PackageContents_CabUK ON PackageContents_CabUK.PackageContents_Package_Id=Package_CabUK.Package_Id
					   JOIN PackageNames_CabUK ON PackageNames_CabUK.PackageNames_Package_Id=Package_CabUK.Package_Id
					   WHERE PackageContents_CabUK.PackageContents_Product_Key='' + @prodId +
					   ''AND PackageContents_CabUK.PackageContents_Quantity='' + @productQty


	-- if language is not ''0''(= English) then also join on package names language id = @lang
	IF @lang = ''0''
		BEGIN
			EXEC (@sql)
		END
	ELSE
		BEGIN
			SET @extsql = ''AND PackageNames_CabUK.PackageNames_Language_Id='' + @lang
			SET @sql = @sql + '' '' + @extsql
			EXEC (@sql)
		END

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Product]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get product details depending on given criteria.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Product]
	@Type varchar(50) = '''',
	@Param1 varchar(50) = '''',
	@Param2 varchar(50) = '''',
	@Param3 varchar(50) = ''''
AS
	DECLARE @Sql varchar(2000)
	DECLARE @Criteria varchar(2000)
BEGIN
	SET NOCOUNT ON;
--test exec dbo.Cab_Get_Product ''ProductID'', 52

	SET @Sql = ''SELECT Products.*, ProductType.ProductTypeDescription
			    FROM Products, ProductType
				WHERE ProductType.ProductTypeKey = Products.ProductTypeID ''

	-- Return product details for a given ProductID
	-- @Param1 int = ProductID
	IF @Type = ''ProductID''
	BEGIN
		SET @Criteria = ''AND Products.ProductKey = '' + @Param1
	END

	-- Return product details for a given ProductID and a given ProductTypeID
	-- (The "AND ProductTypeID = ..." seems to be used to test sth)
	-- @Param1 int = ProductID
	-- @Param2 int = ProductTypeID
	IF @Type = ''ProductID_And_ProductTypeID''
	BEGIN
		SET @Criteria = ''AND Products.ProductKey = '' + @Param1 + '' AND Products.ProductTypeID = '' + @Param2
	END

	-- Return product details for a given LayoutName
	-- @Param1 varchar(255) = LayoutName
	IF @Type = ''LayoutName''
	BEGIN
		SET @Criteria = ''AND Products.LayoutName LIKE ''''%'' + @Param1 + ''%''''''
	END

	-- Return product details for a given LayoutName
	-- @Param1 varchar(255) = LayoutName
	IF @Type = ''WeddingProducts''
	BEGIN
		SET @Criteria = '' AND Products.ProductKey > 0 AND (Products.ProductTypeID != '' + @Param1 + '' OR ( Products.ProductTypeID = '' + @Param1 + '' AND Products.LayoutFamily LIKE ''''%Wedding%'''') ) ''
	END

	-- Return product details for a given ProductTypeID
	-- @Param1 varchar(255) = ProductTypeID
	IF @Type = ''ProductTypeID''
	BEGIN
		SET @Criteria = ''AND Products.ProductTypeID = '' + @Param1
	END

	-- Return product details for a given ProductTypeID
	-- @Param1 varchar(255) = EventTypeID
	-- @Param2 varchar(255) = LayoutFamily
	IF @Type = ''EventID_and_LayoutFamily''
	BEGIN
		SET @Criteria = ''AND Products.ProductKey IN (  SELECT ProductID
												FROM ProductEventLinks 
												WHERE EventTypeID = '' + @Param1 + '') 
						 AND Products.LayoutFamily  = '''''' + @Param2 + ''''''''
	END

	-- Return product details for a given ProductTypeID
	-- @Param1 varchar(255) = ProductTypeID
	IF @Type = ''ProductType_Description''
	BEGIN
		SET @Criteria = ''AND ProductType.ProductTypeDescription = '''''' + @Param1 + ''''''''

	END
	
	EXEC(@Sql + @Criteria)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Manifest_History_By_Criteria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[Cab_Get_Manifest_History_By_Criteria]

-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 15/07/08
-- Description:	Generic procedure to fetch results by any column name (criteria).
-- =============================================

	@searchCriteria nvarchar(100) = '''',
	@searchField nvarchar(100)='''',
	@searchType nvarchar(20)= ''=''
	 
AS

-- If a value hasn''t been specified, then we''ll RETURN TOP 10 LIKE. There is a possibility that there''s thousands of records and we don''t want that. 
IF @searchField=''''
	EXEC ('' SELECT TOP 10 * FROM Manifest WHERE '' + @searchField + ''LIKE ''+ @searchCriteria) ; 
ELSE
	EXEC ('' SELECT * FROM Manifest WHERE '' + @searchField +  '' '' + @searchType + '' "''  + @searchCriteria + ''"'')

	

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Package]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get product package details depending on given criteria.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Package]
	@Type varchar(50) = '''',
	@Param1 varchar(50) = '''',
	@Param2 varchar(50) = '''',
	@Param3 varchar(50) = ''''
AS
	DECLARE @Sql varchar(2000)
	DECLARE @Criteria varchar(2000)
BEGIN
	SET NOCOUNT ON;

	SET @Sql = ''SELECT Package_CabUK.*
				FROM Package_CabUK
				JOIN PackageContents_CabUK ON PackageContents_CabUK.PackageContents_Package_Id = Package_CabUK.Package_Id
				JOIN PackageNames_CabUK ON PackageNames_CabUK.PackageNames_Package_Id = Package_CabUK.Package_Id ''

	-- Return product package details for a given ProductID and a quantity
	-- @Param1 int = ProductID
	IF @Type = ''ProductID_And_Quantity''
	BEGIN
		SET @Criteria = ''WHERE PackageContents_CabUK.PackageContents_Product_Key = '' + @Param1 + ''
						 AND PackageContents_CabUK.PackageContents_Quantity = '' + @Param2
	END

	-- Return product package details for a given PackageContents_Product_Key, a given PackageNames_Language_Id and a quantity
	-- (The "AND ProductTypeID = ..." seems to be used to test sth)
	-- @Param1 int = PackageContents_Product_Key
	-- @Param2 int = PackageContents_Quantity
	-- @Param3 int = PackageNames_Language_Id
	IF @Type = ''ProductID_And_Quantity_And_LanguageID''
	BEGIN
		SET @Criteria = ''WHERE PackageContents_CabUK.PackageContents_Product_Key = '' + @Param1 + ''
						 AND PackageContents_CabUK.PackageContents_Quantity = '' + @Param2 + ''
						 AND PackageNames_CabUK.PackageNames_Language_Id = '' + @Param3
	END

	exec (@Sql + @Criteria)
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Parties]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 25/07/2008
-- Description:	Get parties detail for a given passenger.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Parties]
	@UniquePassengerID varchar(50),
	@PartyTypeID varchar(50) = ''''
AS
	DECLARE @Sql varchar(2000)
BEGIN
	SET @Sql = ''SELECT Parties.*
				FROM Parties
				Join PartyMembers ON Parties.PartyKey = PartyMembers.PartyID
				JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
				WHERE Manifest.UniquePassengerID = '' + @UniquePassengerID

	IF @PartyTypeID > 0
	BEGIN
		SET @Sql = @Sql + '' AND Parties.PartyTypeID = '' + @PartyTypeID
	END

	EXEC(@Sql)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetails_By_ProductTypeID_And_OrderLotID_In_Set]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		CabinetUK - Chris
-- Create date: 28/07/2008
-- Description:	Get some order details against a set of product types and the order lot id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderDetails_By_ProductTypeID_And_OrderLotID_In_Set] 
	@OrderLotID int,
	@ProductTypeIDset varchar(40), 
	@IsIn int = true 
AS
BEGIN
	IF @IsIn > 0
        EXEC(''		
			SELECT OrderDetails.ProductID, OrderPackages.OrderPackageKey, OrderPackages.OrderPackages_Package, OrderPackages.Price, OrderPackages.Quantity
			FROM OrderDetails
			JOIN Products ON Products.ProductKey=OrderDetails.ProductID
			JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID
			WHERE Products.ProductTypeID IN ('' + @ProductTypeIDset + '')
			AND OrderPackages.OrderLotID = '' + @OrderLotID)
	ELSE
        EXEC(''		
			SELECT OrderDetails.ProductID, OrderPackages.OrderPackageKey, OrderPackages.OrderPackages_Package, OrderPackages.Price, OrderPackages.Quantity
			FROM OrderDetails
			JOIN Products ON Products.ProductKey=OrderDetails.ProductID
			JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID
			WHERE Products.ProductTypeID NOT IN ('' + @ProductTypeIDset + '')
			AND OrderPackages.OrderLotID = '' + @OrderLotID)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_SlideshowKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	Get slideshow key
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_SlideshowKey]

	@type varchar(200),
	@value varchar(200)
AS

	declare @sql varchar(2000)
	
BEGIN

	SET NOCOUNT ON;
	
	IF @type = ''OrderDetailKey''
	BEGIN
		SET @sql = ''
			SELECT SlideshowKey 
			FROM Slideshow_CabUK 
			WHERE OrderDetailKey = '' + @value
	END
	
	IF @type = ''OrderLotID''
	BEGIN
		SET @sql = ''
			SELECT SlideshowKey 
			FROM Slideshow_CabUK 
			WHERE OrderLotID = '' + @value	
	END
	
	EXEC(@sql)

END

-----------------------------------------
-----------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HS_SetPartyMembers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HS_SetPartyMembers] --same as SetpartyMembers, but doesn''t set partyStatus = 0
	@PartyID int,
    	@MemberIDs varchar(8000)  OUTPUT
AS
CREATE TABLE #Members (IDs varchar(25) COLLATE database_default)
--Parsing of comma delimited string into temp #members table
    INSERT INTO #Members
    SELECT  NullIf(SubString('','' + @MemberIDs + '','' , ii ,
     CharIndex('','' , '','' + @MemberIDs + '','' , ii) - ii) , '''') AS IDs 
    FROM    Cntr
    WHERE   ii <= Len('','' + @MemberIDs + '','') AND SubString('','' + 
      @MemberIDs + '','' , ii - 1, 1) = '','' 
    AND     CharIndex('','' , '','' + @MemberIDs + '','' , ii) - ii > 0  
--DELETED PartyMembers 
if @MemberIDs = '''' set @MemberIDs = ''0''--needed for delete
exec (''Delete PartyMembers Where PartyID = '' + @PartyID + '' and MemberPaxID not in (''+ @MemberIDs +'')'')
--INSERTED PartyMembers
insert into Partymembers (PartyID, MemberPaxID)
select @partyID, IDs from #Members where IDs not in (select MemberPaxID from partymembers where PartyID = @PartyID)
and IDs in (Select PaxID from PassengerDetail)--make sure there won''t be a constraint error
-- now return  the passengerIDs that didn''t make it in.
SET @MemberIDs = ''''
SELECT	@MemberIDs = @MemberIDs + cast (IDs as varchar(10)) + '','' 
from #members where IDs not in (Select PaxID from PassengerDetail)
if len(@MemberIDs)>1 set @MemberIDs = substring(@MemberIDs,1 ,len(@MemberIDs)-1)
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cin_GetSequenceNumber]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cin_GetSequenceNumber]
AS
update Cin_Sequence set SequenceNumber = SequenceNumber + 1;
SELECT SequenceNumber from Cin_Sequence
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetPartyMembers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SetPartyMembers] 
	@PartyID int,
    	@MemberIDs varchar(8000) 
AS
CREATE TABLE #Members (IDs varchar(25) COLLATE database_default )
--Parsing of comma delimited string into temp #members table
    INSERT INTO #Members
    SELECT  NullIf(SubString('','' + @MemberIDs + '','' , ii ,
     CharIndex('','' , '','' + @MemberIDs + '','' , ii) - ii) , '''') AS IDs 
    FROM    Cntr
    WHERE   ii <= Len('','' + @MemberIDs + '','') AND SubString('','' + 
      @MemberIDs + '','' , ii - 1, 1) = '','' 
    AND     CharIndex('','' , '','' + @MemberIDs + '','' , ii) - ii > 0  
--DELETED PartyMembers 
if @MemberIDs = '''' set @memberIDs = ''0''--needed for delete
exec (''Delete PartyMembers Where PartyID = '' + @PartyID + '' and MemberPaxID not in (''+ @MemberIDs +'')'')
--INSERTED PartyMembers
insert into Partymembers (PartyID, MemberPaxID)
select @partyID, IDs from #Members where IDs not in (select MemberPaxID from partymembers where PartyID = @PartyID)
Update PrivateParty set PartyModified = 1 where PartyKey = @PartyID
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetPicturePartyLinks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SetPicturePartyLinks] 
@PartyID int,
@Picturelist varchar(8000)
AS
EXEC (''update pictures set PartyID = 0 where PartyID = '' + @PartyID)
if @Picturelist <> ''''
EXEC (''update pictures set PartyID = '' + @PartyID + '' where PictureKey in ('' + @PictureList + '')'')
Update PrivateParty set PartyModified = 1 where PartyKey = @PartyID
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Images_Delete]
(
	@IsNull_PrintDate datetime,
	@Original_PrintDate datetime,
	@Original_EventID int,
	@IsNull_IsStock bit,
	@Original_IsStock bit,
	@Original_PreviewImage nvarchar(40),
	@Original_BulkImageID int,
	@Original_Available bit,
	@Original_PrintJobID int,
	@Original_DfltCropW float,
	@Original_DfltCropH float,
	@Original_DfltCropL float,
	@Original_DfltCropT float,
	@Original_RawImageH int,
	@Original_RawImageW int,
	@Original_AssociatedParent int,
	@IsNull_ProductID int,
	@Original_ProductID int,
	@Original_SourceFlag int,
	@Original_PictureStatus int,
	@Original_IsGuestPhoto int,
	@Original_MasterImage varchar(255),
	@Original_Rotate int,
	@Original_PrintQuantity int,
	@Original_CreatedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_ImagePathID int,
	@Original_ImagePathID int,
	@Original_OCItem int,
	@Original_FROrderIndex char(20),
	@Original_RenderAttempts int,
	@Original_ImagesToPrintFlag int,
	@Original_ImageTypeID decimal(18, 0)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [Images] WHERE (((@IsNull_PrintDate = 1 AND [PrintDate] IS NULL) OR ([PrintDate] = @Original_PrintDate)) AND ([EventID] = @Original_EventID) AND ((@IsNull_IsStock = 1 AND [IsStock] IS NULL) OR ([IsStock] = @Original_IsStock)) AND ([PreviewImage] = @Original_PreviewImage) AND ([BulkImageID] = @Original_BulkImageID) AND ([Available] = @Original_Available) AND ([PrintJobID] = @Original_PrintJobID) AND ([DfltCropW] = @Original_DfltCropW) AND ([DfltCropH] = @Original_DfltCropH) AND ([DfltCropL] = @Original_DfltCropL) AND ([DfltCropT] = @Original_DfltCropT) AND ([RawImageH] = @Original_RawImageH) AND ([RawImageW] = @Original_RawImageW) AND ([AssociatedParent] = @Original_AssociatedParent) AND ((@IsNull_ProductID = 1 AND [ProductID] IS NULL) OR ([ProductID] = @Original_ProductID)) AND ([SourceFlag] = @Original_SourceFlag) AND ([PictureStatus] = @Original_PictureStatus) AND ([IsGuestPhoto] = @Original_IsGuestPhoto) AND ([MasterImage] = @Original_MasterImage) AND ([Rotate] = @Original_Rotate) AND ([PrintQuantity] = @Original_PrintQuantity) AND ([CreatedDate] = @Original_CreatedDate) AND ([ModifiedDate] = @Original_ModifiedDate) AND ((@IsNull_ImagePathID = 1 AND [ImagePathID] IS NULL) OR ([ImagePathID] = @Original_ImagePathID)) AND ([OCItem] = @Original_OCItem) AND ([FROrderIndex] = @Original_FROrderIndex) AND ([RenderAttempts] = @Original_RenderAttempts) AND ([ImagesToPrintFlag] = @Original_ImagesToPrintFlag) AND ([ImageTypeID] = @Original_ImageTypeID))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Images_Insert]
(
	@PrintDate datetime,
	@EventID int,
	@IsStock bit,
	@PreviewImage nvarchar(40),
	@BulkImageID int,
	@Available bit,
	@PrintJobID int,
	@DfltCropW float,
	@DfltCropH float,
	@DfltCropL float,
	@DfltCropT float,
	@RawImageH int,
	@RawImageW int,
	@AssociatedParent int,
	@ProductID int,
	@SourceFlag int,
	@PictureStatus int,
	@IsGuestPhoto int,
	@MasterImage varchar(255),
	@Rotate int,
	@PrintQuantity int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@ImagePathID int,
	@OCItem int,
	@FROrderIndex char(20),
	@RenderAttempts int,
	@ImagesToPrintFlag int,
	@ImageTypeID decimal(18, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [Images] ([PrintDate], [EventID], [IsStock], [PreviewImage], [BulkImageID], [Available], [PrintJobID], [DfltCropW], [DfltCropH], [DfltCropL], [DfltCropT], [RawImageH], [RawImageW], [AssociatedParent], [ProductID], [SourceFlag], [PictureStatus], [IsGuestPhoto], [MasterImage], [Rotate], [PrintQuantity], [CreatedDate], [ModifiedDate], [ImagePathID], [OCItem], [FROrderIndex], [RenderAttempts], [ImagesToPrintFlag], [ImageTypeID]) VALUES (@PrintDate, @EventID, @IsStock, @PreviewImage, @BulkImageID, @Available, @PrintJobID, @DfltCropW, @DfltCropH, @DfltCropL, @DfltCropT, @RawImageH, @RawImageW, @AssociatedParent, @ProductID, @SourceFlag, @PictureStatus, @IsGuestPhoto, @MasterImage, @Rotate, @PrintQuantity, @CreatedDate, @ModifiedDate, @ImagePathID, @OCItem, @FROrderIndex, @RenderAttempts, @ImagesToPrintFlag, @ImageTypeID);
	
SELECT PrintDate, EventID, IsStock, PreviewImage, BulkImageID, Available, PrintJobID, DfltCropW, DfltCropH, DfltCropL, DfltCropT, RawImageH, RawImageW, AssociatedParent, ProductID, SourceFlag, PictureStatus, IsGuestPhoto, MasterImage, Rotate, PrintQuantity, CreatedDate, ModifiedDate, ImagePathID, OCItem, FROrderIndex, RenderAttempts, ImagesToPrintFlag, ImageTypeID FROM Images WHERE (BulkImageID = @BulkImageID)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Images_Select]
AS
	SET NOCOUNT ON;
Select * From Images
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Images_Update]
(
	@PrintDate datetime,
	@EventID int,
	@IsStock bit,
	@PreviewImage nvarchar(40),
	@BulkImageID int,
	@Available bit,
	@PrintJobID int,
	@DfltCropW float,
	@DfltCropH float,
	@DfltCropL float,
	@DfltCropT float,
	@RawImageH int,
	@RawImageW int,
	@AssociatedParent int,
	@ProductID int,
	@SourceFlag int,
	@PictureStatus int,
	@IsGuestPhoto int,
	@MasterImage varchar(255),
	@Rotate int,
	@PrintQuantity int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@ImagePathID int,
	@OCItem int,
	@FROrderIndex char(20),
	@RenderAttempts int,
	@ImagesToPrintFlag int,
	@ImageTypeID decimal(18, 0),
	@IsNull_PrintDate datetime,
	@Original_PrintDate datetime,
	@Original_EventID int,
	@IsNull_IsStock bit,
	@Original_IsStock bit,
	@Original_PreviewImage nvarchar(40),
	@Original_BulkImageID int,
	@Original_Available bit,
	@Original_PrintJobID int,
	@Original_DfltCropW float,
	@Original_DfltCropH float,
	@Original_DfltCropL float,
	@Original_DfltCropT float,
	@Original_RawImageH int,
	@Original_RawImageW int,
	@Original_AssociatedParent int,
	@IsNull_ProductID int,
	@Original_ProductID int,
	@Original_SourceFlag int,
	@Original_PictureStatus int,
	@Original_IsGuestPhoto int,
	@Original_MasterImage varchar(255),
	@Original_Rotate int,
	@Original_PrintQuantity int,
	@Original_CreatedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_ImagePathID int,
	@Original_ImagePathID int,
	@Original_OCItem int,
	@Original_FROrderIndex char(20),
	@Original_RenderAttempts int,
	@Original_ImagesToPrintFlag int,
	@Original_ImageTypeID decimal(18, 0)
)
AS
	SET NOCOUNT OFF;
UPDATE [Images] SET [PrintDate] = @PrintDate, [EventID] = @EventID, [IsStock] = @IsStock, [PreviewImage] = @PreviewImage, [BulkImageID] = @BulkImageID, [Available] = @Available, [PrintJobID] = @PrintJobID, [DfltCropW] = @DfltCropW, [DfltCropH] = @DfltCropH, [DfltCropL] = @DfltCropL, [DfltCropT] = @DfltCropT, [RawImageH] = @RawImageH, [RawImageW] = @RawImageW, [AssociatedParent] = @AssociatedParent, [ProductID] = @ProductID, [SourceFlag] = @SourceFlag, [PictureStatus] = @PictureStatus, [IsGuestPhoto] = @IsGuestPhoto, [MasterImage] = @MasterImage, [Rotate] = @Rotate, [PrintQuantity] = @PrintQuantity, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate, [ImagePathID] = @ImagePathID, [OCItem] = @OCItem, [FROrderIndex] = @FROrderIndex, [RenderAttempts] = @RenderAttempts, [ImagesToPrintFlag] = @ImagesToPrintFlag, [ImageTypeID] = @ImageTypeID WHERE (((@IsNull_PrintDate = 1 AND [PrintDate] IS NULL) OR ([PrintDate] = @Original_PrintDate)) AND ([EventID] = @Original_EventID) AND ((@IsNull_IsStock = 1 AND [IsStock] IS NULL) OR ([IsStock] = @Original_IsStock)) AND ([PreviewImage] = @Original_PreviewImage) AND ([BulkImageID] = @Original_BulkImageID) AND ([Available] = @Original_Available) AND ([PrintJobID] = @Original_PrintJobID) AND ([DfltCropW] = @Original_DfltCropW) AND ([DfltCropH] = @Original_DfltCropH) AND ([DfltCropL] = @Original_DfltCropL) AND ([DfltCropT] = @Original_DfltCropT) AND ([RawImageH] = @Original_RawImageH) AND ([RawImageW] = @Original_RawImageW) AND ([AssociatedParent] = @Original_AssociatedParent) AND ((@IsNull_ProductID = 1 AND [ProductID] IS NULL) OR ([ProductID] = @Original_ProductID)) AND ([SourceFlag] = @Original_SourceFlag) AND ([PictureStatus] = @Original_PictureStatus) AND ([IsGuestPhoto] = @Original_IsGuestPhoto) AND ([MasterImage] = @Original_MasterImage) AND ([Rotate] = @Original_Rotate) AND ([PrintQuantity] = @Original_PrintQuantity) AND ([CreatedDate] = @Original_CreatedDate) AND ([ModifiedDate] = @Original_ModifiedDate) AND ((@IsNull_ImagePathID = 1 AND [ImagePathID] IS NULL) OR ([ImagePathID] = @Original_ImagePathID)) AND ([OCItem] = @Original_OCItem) AND ([FROrderIndex] = @Original_FROrderIndex) AND ([RenderAttempts] = @Original_RenderAttempts) AND ([ImagesToPrintFlag] = @Original_ImagesToPrintFlag) AND ([ImageTypeID] = @Original_ImageTypeID));
	
SELECT PrintDate, EventID, IsStock, PreviewImage, BulkImageID, Available, PrintJobID, DfltCropW, DfltCropH, DfltCropL, DfltCropT, RawImageH, RawImageW, AssociatedParent, ProductID, SourceFlag, PictureStatus, IsGuestPhoto, MasterImage, Rotate, PrintQuantity, CreatedDate, ModifiedDate, ImagePathID, OCItem, FROrderIndex, RenderAttempts, ImagesToPrintFlag, ImageTypeID FROM Images WHERE (BulkImageID = @BulkImageID)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GEN_ManifestLoaded]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<RBP>
-- Create date: <23/07/2008>
-- Description:	<Check if the maifest has been loaded>
-- You can test using:
--      declare @temp int
--      exec    @temp =  GEN_ManifestLoaded 
--      print   @temp
-- =============================================
CREATE PROCEDURE  [dbo].[GEN_ManifestLoaded]   
 AS
BEGIN
	SET NOCOUNT ON;
declare @Temp int
select @Temp =  count(Distinct SettingValue ) from 
Settings where Settingkey in (2020,2060)
if @temp = 1  
  return 1
ELSE
  return 0
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_RenderedImages_ProductID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 03/09/2008
-- Description:	Select RengeredImages
-- =============================================
Create PROCEDURE [dbo].[HSP_RenderedImages_ProductID]
	-- Add the parameters for the stored procedure here
	@ProductID int 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT Images.BulkImageID, ImagePath + PreviewImage + ''_T.jpg'' as ThumbName,   
    ImagePath + PreviewImage + ''_P.jpg'' as Prevname,   
    ImagePath + PreviewImage + ''_L.jpg'' as LargePrevName       
    FROM       Events 
    INNER JOIN EventTypes ON Events.EventTypeID = EventTypes.EventTypeKey 
    INNER JOIN Images ON Events.EventKey = Images.EventID 
    INNER JOIN ProductEventLinks ON EventTypes.EventTypeKey = ProductEventLinks.EventTypeID
    Left Join ImagePaths ON Images.ImagePathID = Imagepaths.ImagePathKey
    WHERE      ProductEventLinks.ProductID =  @ProductID
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Event]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get the details of an event.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Event]
	@EventID int
AS
BEGIN
	SELECT Events.*, EventTypes.EventTypeDescription
	FROM Events
	INNER JOIN EventTypes ON Events.EventTypeID = EventTypes.EventTypeKey
	WHERE Events.EventKey = @EventID
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EventTypes_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EventTypes_Select]
AS
	SET NOCOUNT ON;
SELECT EventTypeKey, EventTypeDescription, CreatedDate, ModifiedDate FROM dbo.EventTypes
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EventTypes_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EventTypes_Insert]
(
	@EventTypeKey int,
	@EventTypeDescription nvarchar(50),
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[EventTypes] ([EventTypeKey], [EventTypeDescription], [CreatedDate], [ModifiedDate]) VALUES (@EventTypeKey, @EventTypeDescription, @CreatedDate, @ModifiedDate);
	
SELECT EventTypeKey, EventTypeDescription, CreatedDate, ModifiedDate FROM EventTypes WHERE (EventTypeKey = @EventTypeKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EventTypes_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EventTypes_Update]
(
	@EventTypeKey int,
	@EventTypeDescription nvarchar(50),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_EventTypeKey int,
	@Original_EventTypeDescription nvarchar(50),
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[EventTypes] SET [EventTypeKey] = @EventTypeKey, [EventTypeDescription] = @EventTypeDescription, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([EventTypeKey] = @Original_EventTypeKey) AND ([EventTypeDescription] = @Original_EventTypeDescription) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT EventTypeKey, EventTypeDescription, CreatedDate, ModifiedDate FROM EventTypes WHERE (EventTypeKey = @EventTypeKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EventTypes_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EventTypes_Delete]
(
	@Original_EventTypeKey int,
	@Original_EventTypeDescription nvarchar(50),
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[EventTypes] WHERE (([EventTypeKey] = @Original_EventTypeKey) AND ([EventTypeDescription] = @Original_EventTypeDescription) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_MaintenanceDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 29/08/2008
-- Description:	Delete given a date
-- =============================================
CREATE PROCEDURE [dbo].[HSP_MaintenanceDelete]
	-- Add the parameters for the stored procedure here
	@DeleteBeforeDate  varchar(20)
    
 AS
BEGIN
   DECLARE @TableVariable TABLE ( Gen  INT )
  --------------------------------------------------------------------------
  -- This routine is so dangerous that
  -- before we get going let''s check the date given
  -- Typically it will be 6 weeks or 42 days old
  -- If less that 30 days ago - exit  
  if   @DeleteBeforeDate  > dateadd(day,-30,getdate()) RETURN
  --

  ------------------------------------------------------------------------- 
  ---- Step 1 --  Based on Orders & Orders_MultiLine we are Going to delete
  -------------------------------------------------------------------------
  -- Need to call HSP_MaintenanceSelectImagesToDelete
  -- And delete the image files first  
  -- Cascade delete on this
  DELETE Orders_MultiLine WHERE OrderDate < @DeleteBeforeDate  
  
  ------------------------------------------------------------------------- 
  ---- Step 2 --  Based on Images we are Going to delete
  -------------------------------------------------------------------------
  -- Temp list of Images we are going to delete
  INSERT INTO @TableVariable  
     SELECT BulkImageID FROM Images 
       WHERE CreatedDate < @DeleteBeforeDate AND ImageTypeID = 1 
  -- Remove CapturedData
  DELETE CapturedData  WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
  -- Remove ImagesToPrint
  delete ImagesToPrint  WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
   -- remove PartiesInImage
  delete PartiesInImage WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
   -- remove HiddenImages
  delete HiddenImages WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
   -- remove youFinderStatus
  delete youFinderStatus WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
   -- Remove Images
  delete Images         WHERE BulkImageID In (SELECT Gen FROM @TableVariable)

  -- Remove Events -- Linked onto Images
  DELETE Events WHERE EventKey NOT IN ( SELECT EventID FROM Images )
   AND Events.CreatedDate < @DeleteBeforeDate

  -------------------------------------------------------------------------
  -- Stage 3 -- Based around Manifest Entries
  -------------------------------------------------------------------------
  DELETE @TableVariable -- Clean it up B4 using it again
  INSERT INTO @TableVariable  
      SELECT Manifestkey from Manifest WHERE CreatedDate <  @DeleteBeforeDate
  -- Remove PartyMembers  
  delete PartyMembers          WHERE ManifestID  in (SELECT Gen FROM @TableVariable)
  -- Remove ManifestHistory  
  delete ManifestHistory       WHERE ManifestID  in (SELECT Gen FROM @TableVariable)
  -- Remove PassengerSegmentLinks  
  delete PassengerSegmentLinks WHERE ManifestID  in (SELECT Gen FROM @TableVariable)
  -- Remove Manifest 
  delete Manifest              WHERE ManifestKey in (SELECT Gen FROM @TableVariable)

  -- Remove UniquePassengerIDs
  delete UniquepassengerIDs WHERE UniquePassengerKey NOT IN (
    SELECT ManifestKey from Manifest
    UNION
    Select UniquePassengerID From Manifest
    UNION
    Select OriginalPassengerID From Manifest
    -- I do not think we should concern ourselves with ManifestHistory at this stage    
    -- But if it becomes and issue uncomment the next lines    
    --UNION    
    --SELECT ManifestID from ManifestHistory
    --UNION
    --Select UniquePassengerID From ManifestHistory
    --UNION
    --Select OriginalPassengerID From ManifestHistory
  )

  -------------------------------------------------------------------------
  -- Stage 4 -- Parties - straddles stage 1 and stage 2
  -------------------------------------------------------------------------
  -- Tidy up Parties
  Delete Parties WHERE PartyKey NOT In (
     SELECT PartyID FROM PartyMembers
     UNION
     SELECT PartyID FROM PartiesInImage
     UNION
     SELECT PartyID FROM ImagesToPrint 
  )
  -------------------------------------------------------------------------
  -- Stage 5 -- Based around VoyageSegments
  -------------------------------------------------------------------------
  DELETE @TableVariable -- Clean it up B4 using it again
  INSERT INTO @TableVariable
    select VoyageSegmentID FROM Events
    UNION
    SELECT VoyageSegmentID FROM PassengerSegmentLinks
    UNION
    SELECT VoyageSegmentID FROM CapturedData

  -------------------------------------------------------------------------
  -- Remove EndOfShifts
  delete EndOfShifts WHERE VoyageSegmentID NOT IN (SELECT Gen FROM @TableVariable)
  -- Remove VoyageSegments 
  delete VoyageSegments WHERE VoyageSegmentKey NOT IN (SELECT Gen FROM @TableVariable)
  -------------------------------------------------------------------------
  -- Phew!
  ------------------------------------------------------------------------- 
 
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_VoyageSegments_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_VoyageSegments_Update]
(
	@VoyageSegmentKey int,
	@EmbarkationDate datetime,
	@VoyageCode nvarchar(50),
	@ShipCode nvarchar(50),
	@VoyageDuration int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_VoyageSegmentKey int,
	@Original_EmbarkationDate datetime,
	@Original_VoyageCode nvarchar(50),
	@Original_ShipCode nvarchar(50),
	@Original_VoyageDuration int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[VoyageSegments] SET [VoyageSegmentKey] = @VoyageSegmentKey, [EmbarkationDate] = @EmbarkationDate, [VoyageCode] = @VoyageCode, [ShipCode] = @ShipCode, [VoyageDuration] = @VoyageDuration, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([VoyageSegmentKey] = @Original_VoyageSegmentKey) AND ([EmbarkationDate] = @Original_EmbarkationDate) AND ([VoyageCode] = @Original_VoyageCode) AND ([ShipCode] = @Original_ShipCode) AND ([VoyageDuration] = @Original_VoyageDuration) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT VoyageSegmentKey, EmbarkationDate, VoyageCode, ShipCode, VoyageDuration, CreatedDate, ModifiedDate FROM VoyageSegments WHERE (VoyageSegmentKey = @VoyageSegmentKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_VoyageSegments_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_VoyageSegments_Insert]
(
	@VoyageSegmentKey int,
	@EmbarkationDate datetime,
	@VoyageCode nvarchar(50),
	@ShipCode nvarchar(50),
	@VoyageDuration int,
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[VoyageSegments] ([VoyageSegmentKey], [EmbarkationDate], [VoyageCode], [ShipCode], [VoyageDuration], [CreatedDate], [ModifiedDate]) VALUES (@VoyageSegmentKey, @EmbarkationDate, @VoyageCode, @ShipCode, @VoyageDuration, @CreatedDate, @ModifiedDate);
	
SELECT VoyageSegmentKey, EmbarkationDate, VoyageCode, ShipCode, VoyageDuration, CreatedDate, ModifiedDate FROM VoyageSegments WHERE (VoyageSegmentKey = @VoyageSegmentKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_VoyageSegments_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_VoyageSegments_Select]
AS
	SET NOCOUNT ON;
SELECT VoyageSegmentKey, EmbarkationDate, VoyageCode, ShipCode, VoyageDuration, CreatedDate, ModifiedDate FROM dbo.VoyageSegments
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_VoyageSegments_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_VoyageSegments_Delete]
(
	@Original_VoyageSegmentKey int,
	@Original_EmbarkationDate datetime,
	@Original_VoyageCode nvarchar(50),
	@Original_ShipCode nvarchar(50),
	@Original_VoyageDuration int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[VoyageSegments] WHERE (([VoyageSegmentKey] = @Original_VoyageSegmentKey) AND ([EmbarkationDate] = @Original_EmbarkationDate) AND ([VoyageCode] = @Original_VoyageCode) AND ([ShipCode] = @Original_ShipCode) AND ([VoyageDuration] = @Original_VoyageDuration) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UpdatePartyID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<RBP>
-- Create date: <04/08/2008>
-- Description:	<Update a partyID from aon old value to a new value
--              in tables PartiesInImage, CapturedData & ImagesToPrint>
-- =============================================
CREATE PROCEDURE  [dbo].[HSP_UpdatePartyID] 
	 
	 @ExistingPartyID  int ,
	 @NewPartyID  int 
AS
BEGIN
  UPDATE PartiesInImage 
    SET PartyID =  @NewPartyID
    WHERE PartyID = @ExistingPartyID
  UPDATE CapturedData 
    SET PartyID =  @NewPartyID
    WHERE PartyID = @ExistingPartyID
 UPDATE ImagesToPrint 
   SET PartyID =  @NewPartyID
   WHERE PartyID = @ExistingPartyID

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_SelectPartiesToChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<RBP>
-- Create date: <04/08/2008>
-- Description:	<Select PartyIDs that need to be changed as a result of parties being merged>
-- =============================================
CREATE PROCEDURE  [dbo].[HSP_SelectPartiesToChange] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT PartyKey,NewPartyID FROM Parties  WHERE PartyKey IN ( 

   SELECT PartyID FROM PartiesInImage WHERE   PartyID IN ( 
      SELECT PartyKey FROM Parties WHERE NOT NewPartyID is NULL  
      )  
   UNION   
   SELECT PartyID FROM ImagesToPrint WHERE  PartyID IN ( 
      SELECT PartyKey FROM Parties WHERE NOT NewPartyID is NULL  
      )  
   UNION   
   SELECT PartyID FROM CapturedData WHERE PartyID IN ( 
     SELECT PartyKey FROM Parties WHERE NOT NewPartyID is NULL  
     )
)  
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Image_Delete_BulkImageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 29/08/2008
-- Description:	Delete an Image based upon BulkImageID
--              Delete associated child table entries
-- =============================================
CREATE PROCEDURE [dbo].[HSP_Image_Delete_BulkImageID]
	-- Add the parameters for the stored procedure here
	@BulkImageID  int
    
 AS
BEGIN
  ------------------------------------------------------------------------- 
  ----   Images we are Going to delete
  -------------------------------------------------------------------------

  DELETE CapturedData   WHERE BulkImageID =@BulkImageID
  -- Remove ImagesToPrint
  delete ImagesToPrint  WHERE BulkImageID =@BulkImageID
   -- remove PartiesInImage
  delete PartiesInImage WHERE BulkImageID =@BulkImageID
  -- remove HiddenImages
  delete HiddenImages WHERE BulkImageID =@BulkImageID
 -- remove youFinderStatus
  delete youFinderStatus WHERE BulkImageID =@BulkImageID
 -- Remove Images
  delete Images         WHERE BulkImageID =@BulkImageID
 
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_DeleteByPrintJob]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 04/09/2008
-- Description:	Return Images Filepaths for deletion
--              Call before actually deleting the records
-- =============================================
CREATE PROCEDURE [dbo].[HSP_Images_DeleteByPrintJob]
	-- Add the parameters for the stored procedure here
    @PrintJobID as varchar(20)
AS
BEGIN
  DECLARE @TableVariable TABLE ( Gen  INT )
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON
  
  ------------------------------------------------------------------------- 
  ---- Images we are Going to delete
  -------------------------------------------------------------------------
  -- Temp list of Images we are going to delete
  INSERT INTO @TableVariable  
     SELECT BulkImageID FROM Images WHERE FROrderIndex = @PrintJobID   
  -- Remove CapturedData
  DELETE CapturedData  WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
  -- Remove ImagesToPrint
  delete ImagesToPrint  WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
   -- remove PartiesInImage
  delete PartiesInImage WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
  -- remove HiddenImages
  delete HiddenImages WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
  -- remove youFinderStatus
  delete youFinderStatus WHERE BulkImageID In (SELECT Gen FROM @TableVariable)
  -- Remove Images
  delete Images         WHERE BulkImageID In (SELECT Gen FROM @TableVariable)

  -- Other table (Events, etc) will get tidied up during maintenace delete

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_SlidesPerSlideshow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	Get max slides per slideshow
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_SlidesPerSlideshow]

	@key int

AS
	
BEGIN

	SET NOCOUNT ON;
  SELECT MaxNumSlides 
  FROM Slideshow_Admin_CabUK 
  WHERE Slideshow_AdminKey = @key

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Enabled_Slide_Products]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	(TODO Description)
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Enabled_Slide_Products]
AS
	SELECT EnabledProducts
	FROM Slideshow_Admin_CabUK
	WHERE Slideshow_adminKey = ''1''

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Cruise_Is_Last_Day]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/09/08
-- Description:	Returns the remaining days to the end of the cruise or how many have past already.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Cruise_Is_Last_Day] 
AS
BEGIN
	declare @endDate datetime

	select @endDate = Cruise_CabUK.Cruise_End_Date FROM Cruise_CabUK WHERE Cruise_Active = 1
	
	IF datediff(day, getDate(), @endDate) = 0 
		begin
			select (0) as remainingDays
		end
	ELSE
		begin
			select (datediff(day, GetDate(), @endDate)) as remainingDays
		end
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_CruiseShipCode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get the code of the ship.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_CruiseShipCode]
	@cruiseId bigint,
	@cruiseShipCode  varchar (50) OUTPUT

AS
	--declare @Cruise_Ship_Code varchar (50) 

	SELECT @cruiseShipCode = Cruise_Ship_Code
	FROM Cruise_CabUK 
	WHERE Cruise_Id=@cruiseId

	--SET @cruiseShipCode = @Cruise_Ship_Code

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_CruiseDays_Left]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/09/08
-- Description:	Returns the remaining days to the end of the cruise or how many have past already.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_CruiseDays_Left] 
AS
BEGIN
	declare @endDate datetime

	select @endDate = Cruise_CabUK.Cruise_End_Date FROM Cruise_CabUK WHERE Cruise_Active = 1
	select (datediff(day,  @endDate, GetDate())) as remainingDays

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_Orders_For_Cabin_On_ActiveVoyageSegment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo & Katya
-- Create date: 19/11/08
-- Description:	Get a list of all order keys for a given cabin id but filter those that do not belong on these voyage segment.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_Orders_For_Cabin_On_ActiveVoyageSegment] 
	@cabinID int
AS
BEGIN

	SELECT * 
	FROM Orders_MultiLine
	WHERE UniquePassengerID IN (select UniquePassengerID FROM Manifest WHERE Cabin = @cabinID)
	AND UniquePassengerID IN (select UniquePassengerID FROM Manifest WHERE ManifestKey  IN
									(SELECT ManifestID FROM PassengerSegmentLinks  WHERE VoyageSegmentID IN
										(SELECT SettingValue FROM Settings WHERE SettingDescription =''ActiveSegmentkey'')
							))
	AND PaymentStatus > 0
	AND OrderStatus >= 0
	ORDER BY Orderdate DESC

	
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Orders_By_CabinID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[Cab_Get_Orders_By_CabinID]
 -- test (exec Cab_Get_Order_By_CabinID ''22'')
	@CabinID int
AS
BEGIN
	SELECT * FROM Orders_MultiLine WHERE CabinNr = @CabinID
END


SET ANSI_NULLS OFF
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackage_By_Cabin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[Cab_Get_OrderPackage_By_Cabin]
	@CabinID varchar(20),
	@SearchByField varchar(20),
	@SearchByValue varchar(20)
AS
BEGIN
	SELECT * FROM Orders_MultiLine WHERE CabinNr = @CabinID ORDER BY OrderLotKey DESC
	SET @SearchByField = LOWER(@SearchByField)	
	
	EXEC ('' SELECT * FROM OrderPackages  WHERE '' + @SearchByField +   ''= ''  + @SearchByValue)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_Orders_On_Orderdate_By_OrderLotKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 24/07/08
-- Description:	Updates the time on a given Order by now() time or by whatever is on the @date.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_Orders_On_Orderdate_By_OrderLotKey]
	@OrderLotKey int,
	@Date varchar(50) = '''' 
	
AS
-- test (exec Cab_Update_Orders_On_Orderdate_By_OrderLotKey  ''5'', ''May 15, 2004 11:25am'' )
BEGIN
	if @Date = ''''
		begin 
			UPDATE Orders_Multiline SET Orderdate = getdate() WHERE OrderLotKey = @OrderLotKey
		end
	else
		begin
			UPDATE Orders_Multiline SET Orderdate = cast(@Date as datetime) WHERE OrderLotKey = @OrderLotKey
		end
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Order_By_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Load an order into this object given an order lot id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Order_By_OrderLotID]
 -- test (exec Cab_Get_Order_By_OrderLotID ''8'')
	@OrderLotID int
AS
BEGIN
	SELECT * FROM Orders_MultiLine WHERE OrderLotKey = @OrderLotID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Order]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	(TODO Description)
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Order]
	@OrderLotKey int=''''
AS
	-- No @OrderLotKey specified. Return ALL orders.

	IF @OrderLotKey = ''''
		Begin
			SELECT *
			FROM Orders_Multiline
			ORDER BY Orderdate
		End
	
	ELSE
		Begin
			SELECT *
			FROM Orders_Multiline
			WHERE OrderLotKey = @OrderLotKey 
			ORDER BY Orderdate
		End

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_OpenOrder_For_Cabin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 09/09/08
-- Description:	Check if there is an open order for a given cabin id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_OpenOrder_For_Cabin] 
	@CabinID varchar(20)
AS
BEGIN
	SELECT * 
	FROM Orders_MultiLine
	WHERE CabinNr = @CabinID
	AND OrderedFrom = ''ISE''
	AND OrderStatus = -1
	AND PaymentStatus = 0
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Orders_For_Passenger_By_UpID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get a list of all order keys for a given pax id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Orders_For_Passenger_By_UpID] 
	@UniquePassengerID varchar(20)
AS
-- test (EXEC [Cab_Get_Orders_For_Passenger_By_UpID] 740)
BEGIN
	SELECT OrderLotKey 
	FROM Orders_MultiLine
	WHERE UniquePassengerID = @UniquePassengerID
	AND PaymentStatus > 0
	AND OrderStatus >= 0
	ORDER BY Orderdate
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderKey_Open_By_UID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 22/07/08
-- Description:	Get the order key of the open order for this passenger.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderKey_Open_By_UID]
	@UniquePassengerID varchar(20)
AS
-- test (exec Cab_Get_OrderKey_Open_By_UID ''740'')
BEGIN
	SELECT OrderLotKey 
	FROM Orders_MultiLine 
	WHERE UniquePassengerID = @UniquePassengerID 
	AND OrderStatus=''-1''
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_OrdersHoldingBulkImageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 04/11/2008 -- American Election Day!
-- Description:	Select OrderIDs that use BulkImageID
--              which are holding onto it i.e preventing it from
--              being deleted
-- =============================================
CREATE PROCEDURE  [dbo].[HSP_OrdersHoldingBulkImageID]  
	-- Add the parameters for the stored procedure here
(
	 @BulkImageID  int  
)	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT DISTINCT OrderID  FROM Orders_Multiline 
    INNER JOIN OrderPackages  on  OrderlotID     = OrderLotKey 
    INNER JOIN OrderDetails   on  OrderPackageID = OrderPackageKey 
    INNER JOIN OrderImageItem on  OrderdetailID  = OrderDetailKey 
    WHERE Orderstatus < 2 AND OrderImageItem.BulkImageID = @BulkImageID
END    
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Orders_For_Cabin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 09/09/08
-- Description:	Get a list of all order keys for a given cabin id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Orders_For_Cabin] 
	@CabinID int
AS
BEGIN
	SELECT * 
	FROM Orders_MultiLine
	WHERE UniquePassengerID IN (SELECT UniquePassengerID FROM Manifest WHERE Cabin = @CabinID)
	AND PaymentStatus > 0
	AND OrderStatus >= 0
	ORDER BY Orderdate DESC
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_FileNamesForBulkImageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 04/11/2008
-- Description:	Select Files to be deleted
-- given a BulkImageID
-- Returns Full FileName
-- A little odd way of doing it but it returns a file list I can
-- pound down so that new suffixes  can be easily added
-- without having to rewrite code - Smug B******!
-- =============================================
CREATE PROCEDURE  [dbo].[HSP_FileNamesForBulkImageID] 
   @BulkImageID   int
AS
BEGIN
  declare @UNCpath Varchar(50) 
  SET NOCOUNT ON
  select  @UNCpath =Settingvalue FROM Settings where SettingKey = 2010   
-- Nos select the image - give full filepath - make deletion straightforward in code
 SELECT @UNCpath +  ImagePath + PreviewImage + ''_T.jpg'' as FileNames 
   FROM ImagePaths 
     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
   WHERE   Images.BulkImageID = @BulkImageID
 UNION  
   SELECT @UNCpath +  ImagePath + PreviewImage + ''_P.jpg''   
   FROM ImagePaths 
     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
   WHERE   Images.BulkImageID = @BulkImageID
 UNION
   SELECT  @UNCpath +  ImagePath + PreviewImage + ''_L.jpg''   
   FROM ImagePaths 
     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
   WHERE   Images.BulkImageID = @BulkImageID
 UNION 
   SELECT  @UNCpath +  ImagePath + PreviewImage + ''_S.jpg''  
   FROM ImagePaths 
     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
   WHERE  Images.BulkImageID = @BulkImageID
-- Next suffix goes in below
-- UNION 
--   SELECT  @UNCpath +  ImagePath + PreviewImage + ''_X.jpg''  
--   FROM ImagePaths 
--     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
--   WHERE Images.BulkImageID = @BulkImageID

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Image]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



-- =============================================
-- Author:		CabinetUK
-- Create date: 26/06/2008
-- Description:	Fetch information about an image.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Image]
	-- Add the parameters for the stored procedure here
	@BulkImageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  Images.*, ImagePaths.ImagePath, Images.PreviewImage + ''_T.jpg'' as Thumbnail, Images.PreviewImage + ''_P.jpg'' as Preview, 
			Images.PreviewImage + ''_L.jpg'' as Largepreview
	FROM    Images INNER JOIN
			ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
	WHERE   (Images.BulkImageID = @BulkImageID)
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_Last_Image_For_CabinID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





-- =============================================
-- Author:		Cabinet UK
-- Create date: 05/09/08
-- Description:	Get all the images for a unique passenger ID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_Last_Image_For_CabinID]
	@CabinID varchar(20)
AS

BEGIN
	DECLARE @url nvarchar(250)
	SELECT @url=SettingValue FROM Settings WHERE SettingDescription = ''URL''

	SELECT TOP 1	Images.BulkImageID,
					Images.EventID,
					@url + REPLACE(ImagePaths.ImagePath, ''\'', ''/'') as FullURLPath,
					Images.PreviewImage,
					Images.DfltCropW,
					Images.DfltCropH,
					Images.DfltCropL,
					Images.DfltCropT
	FROM Images
	INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
	INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
	INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
	INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
	LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = Manifest.UniquePassengerID
	INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
	WHERE Manifest.UniquePassengerID IN (SELECT UniquePassengerID FROM Manifest WHERE Cabin = @CabinID)
	AND Images.ImageTypeID IN (1,4,5,6)
	ORDER BY Images.BulkImageID DESC
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_Last_FAF_Image_For_CabinID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 05/09/08
-- Description:	Get all the images for a unique passenger ID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_Last_FAF_Image_For_CabinID]
	@CabinID varchar(20)
AS
BEGIN
	DECLARE @url nvarchar(250)
	SELECT @url=SettingValue FROM Settings WHERE SettingDescription = ''URL''

	SELECT TOP 1	Images.BulkImageID,
					Images.EventID,
					@url + REPLACE(ImagePaths.ImagePath, ''\'', ''/'') as FullURLPath,
					Images.PreviewImage,
					Images.DfltCropW,
					Images.DfltCropH,
					Images.DfltCropL,
					Images.DfltCropT
	FROM Images
	INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
	INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
	INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
	INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
	LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = Manifest.UniquePassengerID
	INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
	WHERE Manifest.UniquePassengerID IN (SELECT UniquePassengerID FROM Manifest WHERE Cabin = @CabinID)
	AND PartiesInImage.AssociationType = 1
	AND Images.ImageTypeID IN (1,4,5,6)
	ORDER BY Images.BulkImageID DESC
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_FAF_Images_For_uPID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 05/09/08
-- Description:	Get all the images for a unique passenger ID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_FAF_Images_For_uPID]
	@UniquePassengerID varchar(20)
AS
BEGIN
	DECLARE @url nvarchar(250)
	SELECT @url=SettingValue FROM Settings WHERE SettingDescription = ''URL''

	SELECT DISTINCT	Images.BulkImageID,
					Images.EventID,
					@url + REPLACE(ImagePaths.ImagePath, ''\'', ''/'') as FullURLPath,
					Images.PreviewImage,
					Images.DfltCropW,
					Images.DfltCropH,
					Images.DfltCropL,
					Images.DfltCropT
	FROM Images
	INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
	INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
	INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
	INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
	LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = Manifest.UniquePassengerID
	INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
	WHERE Manifest.UniquePassengerID = @UniquePassengerID
	AND PartiesInImage.AssociationType = 1
	AND Images.ImageTypeID IN (1,4,5,6)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Images_For_FolioNumber]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get images.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Images_For_FolioNumber]
	-- Add the parameters for the stored procedure here
	@folioNumber nvarchar(30),
	@resultsPerPage int,
	@currentPageIndex int    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    WITH [Images ORDERED BY ROWID] AS
	(SELECT TOP 10
	ROW_NUMBER() OVER (ORDER BY PrintDate ASC) AS ROWID,
	Images.BulkImageID,	
	ImagePath + PreviewImage + ''_T.jpg'' as Thumbnail,
	ImagePath + PreviewImage + ''_P.jpg'' as Preview,
	ImagePath + PreviewImage + ''_L.jpg'' as Largepreview, 
	Images.PrintDate, Images.EventID, Images.IsStock,
	Images.Available, Images.PreviewImage, 	 
	DfltCropW, DfltCropH, DfltCropL, DfltCropT, RawImageH, RawImageW,
	CapturedData.FolioNumber, CapturedData.BulkImageID AS Expr1, 
	CapturedData.VoyageSegmentID, CapturedData.Cabin
	FROM  Images Left Join ImagePaths 
	ON Images.ImagePathID = Imagepaths.ImagePathKey
	 INNER JOIN   CapturedData ON Images.BulkImageID =      CapturedData.BulkImageID
	WHERE CapturedData.FolioNumber = ''309696''
	AND  CapturedData.VoyageSegmentID = 1   
	AND Images.Available = 1)
	SELECT * FROM [Images ORDERED BY ROWID] 
	--WHERE ROWID between 1 AND 10
	WHERE ROWID between 
	(@currentPageIndex - 1) * @resultsPerPage + 1 and @currentPageIndex*@resultsPerPage



END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_Stock_Images]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 29/09/08
-- Description:	Return all the stock images.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_WS_Get_Stock_Images]
AS
BEGIN
	DECLARE @url nvarchar(250)
	SELECT @url=SettingValue FROM Settings WHERE SettingDescription = ''URL''

	SELECT DISTINCT	Images.BulkImageID,
					Images.EventID,
					@url + REPLACE(ImagePaths.ImagePath, ''\'', ''/'') as FullURLPath,
					Images.PreviewImage,
					Images.DfltCropW,
					Images.DfltCropH,
					Images.DfltCropL,
					Images.DfltCropT
	FROM Images
	INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
	WHERE Images.ImageTypeID = 2
	AND Images.Available = 1
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_Passenger_Images_For_uPID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'






-- =============================================
-- Author:		Cabinet UK
-- Create date: 05/09/08
-- Description:	Get all the images for a unique passenger ID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_Passenger_Images_For_uPID]
	@UniquePassengerID varchar(20)
AS

BEGIN
	DECLARE @url nvarchar(250)
	SELECT @url=SettingValue FROM Settings WHERE SettingDescription = ''URL''

	SELECT DISTINCT	Images.BulkImageID,
					Images.EventID,
					@url + REPLACE(ImagePaths.ImagePath, ''\'', ''/'') as FullURLPath,
					Images.PreviewImage,
					Images.DfltCropW,
					Images.DfltCropH,
					Images.DfltCropL,
					Images.DfltCropT
	FROM Images
	INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
	INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
	INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
	INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
	LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = Manifest.UniquePassengerID
	INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
	WHERE Manifest.UniquePassengerID = @UniquePassengerID
	AND PartiesInImage.AssociationType <> 2
	AND Images.ImageTypeID IN (1,4,5,6)
END





' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_WS_Get_OrderImageItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		CabinetUK - (Alter)Rodrigo Dias
-- Create date: 26/06/2008
-- Description:	Get a record from the order image item table.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_WS_Get_OrderImageItem] 
	@orderDetailKey int
AS
BEGIN
	DECLARE @url nvarchar(250)
	SELECT @url=SettingValue FROM Settings WHERE SettingDescription = ''URL''

	SELECT	OrderImageItem.BulkImageID,
			OrderPackages.PackageDescription,
			Products.ProductPrice as Price,
			OrderPackages.Datestamp,
			@url + REPLACE(ImagePaths.ImagePath, ''\'', ''/'') as FullURLPath,
			Images.PreviewImage
	FROM OrderImageItem
	INNER JOIN OrderDetails ON OrderDetails.OrderDetailKey		= OrderImageItem.OrderDetailID
	INNER JOIN Products ON OrderDetails.ProductID				= Products.ProductKey
	INNER JOIN OrderPackages ON OrderPackages.OrderPackageKey	= OrderDetails.OrderPackageID
	INNER JOIN Images ON Images.BulkImageID						= OrderImageItem.BulkImageID
	INNER JOIN ImagePaths ON ImagePaths.ImagePathKey			= Images.ImagePathID
	WHERE OrderImageItem.OrderDetailID							= @orderDetailKey
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_RenderedImages_Stock]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 03/09/2008
-- Description:	Select RengeredImages
-- =============================================
Create PROCEDURE [dbo].[HSP_RenderedImages_Stock]
	-- Add the parameters for the stored procedure here
	 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT Images.BulkImageID, ImagePath + PreviewImage + ''_T.jpg'' as ThumbName,   
    ImagePath + PreviewImage + ''_P.jpg'' as Prevname,   
    ImagePath + PreviewImage + ''_L.jpg'' as LargePrevName    
    FROM Images Left Join ImagePaths    
    ON Images.ImagePathID = Imagepaths.ImagePathKey   
    WHERE ImageTypeID =2
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_RenderedImages_JobID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 03/09/2008
-- Description:	Select RengeredImages
-- =============================================
Create PROCEDURE [dbo].[HSP_RenderedImages_JobID]
	-- Add the parameters for the stored procedure here
	@JobID varchar(30) 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT Images.BulkImageID, ImagePath + PreviewImage + ''_T.jpg'' as ThumbName,   
    ImagePath + PreviewImage + ''_P.jpg'' as Prevname,   
    ImagePath + PreviewImage + ''_L.jpg'' as LargePrevName    
    FROM Images Left Join ImagePaths    
    ON Images.ImagePathID = Imagepaths.ImagePathKey   
  
    WHERE PrintJobID =    @JobID 
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_RenderedImages_BulkImageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 03/09/2008
-- Description:	Select RengeredImages
-- =============================================
CREATE PROCEDURE [dbo].[HSP_RenderedImages_BulkImageID]
	-- Add the parameters for the stored procedure here
	@BulkImageID int 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT BulkImageID,   ImagePath + PreviewImage + ''_T.jpg'' as ThumbName,  
    ImagePath + PreviewImage + ''_P.jpg'' as Prevname,   
    ImagePath + PreviewImage + ''_L.jpg'' as LargePrevName    
    FROM Images Left Join ImagePaths    
    ON Images.ImagePathID = Imagepaths.ImagePathKey  
  
    WHERE BulkImageID =  @BulkImageID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_RenderedImages_PaxID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 03/09/2008
-- Description:	Select RengeredImages
-- =============================================
Create PROCEDURE [dbo].[HSP_RenderedImages_PaxID]
	-- Add the parameters for the stored procedure here
	@PaxID varchar(20) 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT Images.BulkImageID, ImagePath + PreviewImage + ''_T.jpg'' as ThumbName,  
    ImagePath + PreviewImage + ''_P.jpg'' as Prevname,   
    ImagePath + PreviewImage + ''_L.jpg'' as LargePrevName    
    FROM Images Left Join ImagePaths    
    ON Images.ImagePathID = Imagepaths.ImagePathKey   
    INNER JOIN  PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID   
    INNER JOIN  Parties  on  PartiesInImage.PartyID = Parties.PartyKey    
    INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
    INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey   
  
    WHERE PaxID = @PaxID
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_MaintenanceSelectImagesToDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 01/09/2008
-- Description:	Select Images to be deleted
-- Need to call this and delete the image files BEFORE calling
-- HSP_MaintenanceDelete
-- =============================================
CREATE PROCEDURE  [dbo].[HSP_MaintenanceSelectImagesToDelete] 
   @DeleteBeforeDate  varchar(20)
AS
BEGIN
  -- This routine is so dangerous that
  -- before we get going let''s check the date given
  -- Typically it will be 6 weeks or 42 days old
  -- If less that 30 days ago - exit  
  if   @DeleteBeforeDate  > dateadd(day,-30,getdate()) RETURN
 
  declare @UNCpath Varchar(50) 
  SET NOCOUNT ON
  select  @UNCpath =Settingvalue FROM Settings where SettingKey = 2010   
-- Nos select the image - give full filepath - make deletion straightforward in code
 SELECT 
  @UNCpath +  ImagePath + PreviewImage + ''_T.jpg'' as Thumbnail,
  @UNCpath +  ImagePath + PreviewImage + ''_P.jpg'' as Preview,
  @UNCpath +  ImagePath + PreviewImage + ''_L.jpg'' as Largepreview,
  @UNCpath +  ImagePath + PreviewImage + ''_S.jpg'' as ScreenSaver,
  Images.BulkImageID
   FROM ImagePaths 
     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
   WHERE ImageTypeID = 1 AND Images.CreatedDate <= @DeleteBeforeDate

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ImagesOnImagesPathID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		RBP
-- Create date: 20/11/2008 --  
-- Description:	Select Images that use are on a pathID
--              Used in permitting
-- =============================================
Create PROCEDURE  [dbo].[HSP_ImagesOnImagesPathID]  
(
	 @ImagePathID  int  
)	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @UNCpath Varchar(50)    
	SELECT  @UNCpath = Settingvalue FROM Settings where SettingKey = 2010       
	-- Now select the image - give full filepath - make deletion straightforward in code    
	SELECT BulkImageID, @UNCpath +  ImagePath + PreviewImage   as FileNames   
	  FROM ImagePaths     
	  INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey    
	  WHERE ImagePathID =  @ImagePathID 
END    
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_SelectByPrintJob]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 04/09/2008
-- Description:	Return Images Filepaths for deletion
--              Call before actually deleting the records
-- =============================================
CREATE PROCEDURE [dbo].[HSP_Images_SelectByPrintJob]
	-- Add the parameters for the stored procedure here
    @PrintJobID as varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

  declare @UNCpath Varchar(50) 
  SET NOCOUNT ON
  select  @UNCpath =Settingvalue FROM Settings where SettingKey = 2010   
-- Nos select the image - give full filepath - make deletion straightforward in code
 SELECT  Images.BulkImageID,
  @UNCpath +  ImagePath + PreviewImage + ''_T.jpg'' as Thumbnail,
  @UNCpath +  ImagePath + PreviewImage + ''_P.jpg'' as Preview,
  @UNCpath +  ImagePath + PreviewImage + ''_L.jpg'' as Largepreview

   FROM ImagePaths 
     INNER JOIN Images  ON Images.ImagePathID = Imagepaths.ImagePathKey
   WHERE FROrderIndex = @PrintJobID

END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ReturnImagePathID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 21/11/2008
-- Description:	Return ImagePathID for a given path
--              Create the path entry if required
-- =============================================
CREATE PROCEDURE [dbo].[HSP_ReturnImagePathID]
	 @ImagePathWanted nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    IF NOT EXISTS ( SELECT * FROM ImagePaths WHERE ImagePath = @ImagePathWanted) 
      BEGIN      
        INSERT ImagePaths (ImagePath,CreatedDate ) 
        VALUES ( @ImagePathWanted, GetDate())

        SELECT ImagePathKey FROM ImagePaths WHERE ImagePath = @ImagePathWanted
      END 
    ELSE
      BEGIN 
        SELECT ImagePathKey FROM ImagePaths WHERE ImagePath = @ImagePathWanted
      END
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Emails_By_EmailImageName_Count]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	returns the count for emails with the corresponding imagename.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Emails_By_EmailImageName_Count]
	@EmailImageName varchar(100)
AS
-- test (exec Cab_Get_Emails_By_EmailImageName_Count ''image name'')
BEGIN
	SELECT COUNT(Email_Image_Name) FROM Email_CabUK WHERE Email_Image_Name = @EmailImageName
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Email]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get email details.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Email]
	@EmailID int
AS
BEGIN
	SELECT * FROM Email_CabUK WHERE Email_Id = @EmailID
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_Email]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Update an email.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_Email]
	@EmailID int,
	@Message varchar(2000)
AS
BEGIN
	UPDATE Email_CabUK
	SET Email_Message = @Message
	WHERE Email_Id = @EmailID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Emails_By_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 24/07/08
-- Description:	Gets emails by orderLotID.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Emails_By_OrderLotID]
	@OrderLotID int
AS
-- tes (exec Cab_Get_Emails_By_OrderLotID ''5'')
BEGIN
	SELECT Email_Id, Email_OrderDetailID, Email_Image_Name
    FROM Email_CabUK
    WHERE (
		Email_OrderDetailID IN (
			SELECT OrderDetailKey
			FROM OrderDetails
				WHERE (
					OrderPackageID IN (
						SELECT OrderPackageKey
						FROM OrderPackages
						WHERE OrderLotID = @OrderLotID
						)
			)
		)
	)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_Email]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Save an email into the database.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_Email]
	@Message varchar(2000),
	@OrderDetailID int,
	@Date varchar(50),
	@From varchar(255),
	@Subject varchar(255),
	@ImagePathID int,
	@ImageName varchar(255)
AS
BEGIN
	INSERT INTO Email_CabUK (
		Email_Message, Email_OrderDetailID, Email_Date_Created, Email_From,
		Email_Subject, Email_Image_PathID, Email_Image_Name
	) VALUES (
		@Message, @OrderDetailID, @Date, @From,
		@Subject, @ImagePathID, @ImageName
	)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Email_By_OrderPackageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get email details.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Email_By_OrderPackageID]
	@OrderPackageID int
AS
BEGIN
	SELECT *
	FROM Email_CabUK
	JOIN OrderDetails ON Email_CabUK.Email_OrderDetailID = OrderDetails.OrderDetailKey
	WHERE OrderDetails.OrderPackageID = @OrderPackageID
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_Email]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Delete an email from the database.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_Email]
	@EmailID int
AS
BEGIN
	DELETE FROM Email_CabUK WHERE Email_Id = @EmailID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_Email_Recipients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Save an email recipient into the database.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_Email_Recipients]
	@EmailID int,
	@RecipientTo varchar(255)
AS
BEGIN
	INSERT INTO Email_Recipients_CabUK (
		Email_Recipients_Email_Id, Email_Recipients_To
	) VALUES (
		@EmailID, @RecipientTo
	)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Email_Recipients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get email recipients for a given email.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Email_Recipients]
	@EmailID int
AS
BEGIN
	SELECT *
	FROM Email_Recipients_CabUK
	WHERE Email_Recipients_Email_Id = @EmailID
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_Email_Recipient]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Delete an email recipient from the database.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_Email_Recipient]
	@RecipientEmailID int
AS
BEGIN
	DELETE FROM Email_Recipients_CabUK WHERE Email_Recipients_Email_Id = @RecipientEmailID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UpdateRenderAttempts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 21/11/2008
-- Description:	Increment The number of renders attempted
-- =============================================
CREATE PROCEDURE [dbo].[HSP_UpdateRenderAttempts]
	-- Add the parameters for the stored procedure here
	 @OCitems as varchar(300)  
AS
BEGIN
 UPDATE Images 
  SET RenderAttempts = RenderAttempts + 1 
   WHERE OCItem IN 
   ( 
     select * from  dbo.HS_CsvToInt(@OCitems  ) 
   ) 
 	 
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UpdateRenderData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 21/11/2008
-- Description:	Update Rendered file imformation in Images table  
-- =============================================
CREATE PROCEDURE [dbo].[HSP_UpdateRenderData]
	-- Add the parameters for the stored procedure here
	 @ImagePathID  int ,
	 @PreviewFileName varchar(50),
     @ImageWidth int ,
     @ImageHeight int,
     @OrdersContentsItem int  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    UPDATE Images Set 
     ImagePathID  = @ImagePathID       ,
     Available    = 1                  ,  
     PreviewImage = @PreviewFileName   ,
     RawImageW    = @ImageWidth        ,
     RawImageH    = @ImageHeight          
     WHERE OCItem = @OrdersContentsItem
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Images_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author: RBP
-- Create date: 28/08/2008
-- Description: Used to Update or Insert during ImageExport
-- =============================================
CREATE PROCEDURE [dbo].[HSP_Images_InsertUpdate]
(
	@PrintDate datetime,  
	@EventID int, 
	@BulkImageID int, 
	@PrintJobID int, 
	@DfltCropW float, @DfltCropH float,
 	@DfltCropL float, @DfltCropT float, 
	@ProductID int, 
	@MasterImage varchar(255), 
	@Rotate int,
	@PrintQuantity int, 
	@OCItem int, 
	@FROrderIndex char(20),
    @ImageTypeID int
)
AS
	SET NOCOUNT OFF;
if  @EventID = 0
  begin  
    set @EventID= null
  end 
IF EXISTS (SELECT * FROM Images WHERE BulkImageID = @BulkImageID)
  BEGIN
    UPDATE [Images]set [EventID] = @EventID
    ,[PrintDate]= @PrintDate 
    ,[ModifiedDate]= getdate()
    ,[ImageTypeID] = @ImageTypeID
    ,[DfltCropT]=@DfltCropT
    ,[DfltCropL]=@DfltCropL
    ,[DfltCropW]=@DfltCropW
    ,[DfltCropH]=@DfltCropH
    ,[Available] = 0
    ,[RenderAttempts] = 0
    WHERE(BulkImageID = @BulkImageID)
  END
ELSE
  BEGIN
    INSERT INTO [Images](
    [BulkImageID]  , [PrintDate]   , [EventID], 
    [PictureStatus], [MasterImage] , [Rotate] ,
    [PrintQuantity], [ModifiedDate], [OCItem] , 
    [FROrderIndex] , [CreatedDate] , [SourceFlag],
    [AssociatedParent], [RawImageH],[RawImageW],
    [DfltCropT],[DfltCropL],[DfltCropW],[DfltCropH],
    [PrintJobID],[Available],[ImagePathID],
    [PreviewImage],[ImageTypeID] )
    VALUES(
      @BulkImageID   , @PrintDate   , @EventID   , 
      0              , @MasterImage , 0          , 
      @PrintQuantity , getdate()    , @OCItem    ,
      @FROrderIndex  , getdate()    , 1          ,
      0              , 0            , 0          ,
      @DfltCropT     , @DfltCropL   , @DfltCropW , @DfltCropH,
      @PrintJobID    , 0            , NULL       ,
      ''''             , @ImageTypeID  )
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_SelectImagesToRender]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		RBP
-- Create date: 21/11/2008
-- Description:	Select Images to Be Rendered
-- =============================================
CREATE PROCEDURE [dbo].[HSP_SelectImagesToRender]
	-- Add the parameters for the stored procedure here
	 @ImagesInThisAttempt   int  ,
	 @MaxRenderAttempts  int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT Top (@ImagesInThisAttempt)  OCItem FROM Images 
    WHERE ( PreviewImage= ''''  OR Available = 0 )
    AND    ( RenderAttempts < @MaxRenderAttempts )  
    ORDER BY RenderAttempts,BulkImageId 
	 
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gen_Get_Stock_Images]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Halse -GRH
-- Create date: October 1, 2008
-- Description:	Result set of BilkImageIDs of stock images.
--				Can be randomised, and number of results can be set
--				NB: using randomize and pagesize together will result in 
--				each page being a random result set -ie repeat images may occur, 
--				and some images may not be shown
-- =============================================
CREATE PROCEDURE [dbo].[Gen_Get_Stock_Images] 
	-- Add the parameters for the stored procedure here
 	@PageSize int = 2147483647, --Maximum int as default		
	@PageNumber int =1,
	@Randomise bit =0
AS
BEGIN
	SET NOCOUNT ON;

	if @Randomise = 1 
	begin 
		set rowcount @PageSize --no point in paging, each page will be random
		--get stock images in a pseudo random order.
		declare @ms int
		set @ms = DATEPART(millisecond, GETDATE()) 
		select BulkImageID
		from Images where ImageTypeID =2
		order by reverse (cast(rand(BulkImageID * @ms) as nvarchar(50))) 
		set rowcount 0
		return @@rowcount
	end
	else
	begin
		--employ paging
		SELECT [BulkImageID] FROM 
		(
		Select row_number() over (ORDER BY PrintDate Desc) AS resultNum,
				BulkImageID
				from Images where ImageTypeID =2
		)
		AS ImageResults
		WHERE resultNum  
		BETWEEN 
		((@PageNumber - 1) * @PageSize) + 1 and (@PageNumber * @PageSize)
		return @@rowcount
	end

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Stock_Images_Count]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author: Cabinet UK - Rodrigo
-- Create date: 21/11/08
-- Description:	Return the total count of stock images.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Stock_Images_Count]
	
AS
BEGIN

	SELECT count(distinct BulkImageID) as num
	from Images where ImageTypeID = 2 AND Images.EventID IS NOT NULL
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gen_Get_Images_For_FolioNumber]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Halse>
-- Create date: <September 30, 2008>
-- Description:	<Gets a set of BulkImageIDs for a folio number for the active segment>
--<GRH>171008 changed @ActiveSegmentKey from nvarchar(255) to int
-- =============================================
create PROCEDURE [dbo].[Gen_Get_Images_For_FolioNumber] 
	@ActiveSegmentKey int,
	@Folio nvarchar(30),
	@PageSize int = 2147483647, --Maximum for int by for default		
@PageNumber int =1
AS
BEGIN
SET NOCOUNT ON;
SELECT [BulkImageID] FROM 
(
Select row_number() over (ORDER BY PrintDate Desc) AS resultNum,
 [Images].[BulkImageID] from [Images] Left join 
[PartiesInImage] 
ON [Images].[BulkImageID] =[PartiesInImage].[BulkImageID]
left Join 
    [PartyMembers] ON [PartyMembers].[PartyID] = [PartiesInImage].[PartyID]
    Inner Join [Manifest] on [PartyMembers].[ManifestID] = [Manifest].[ManifestKey]
Inner Join [PassengerSegmentLinks] on [PassengerSegmentLinks].[ManifestID]=[Manifest].[ManifestKey]
	WHERE VoyageSegmentID = @ActiveSegmentKey
AND [Manifest].[FolioNumber] = @Folio
and [Images].Available = 1
)
AS ImageResults
WHERE resultNum  
BETWEEN 
((@PageNumber - 1) * @PageSize) + 1 and (@PageNumber * @PageSize)
return @@rowcount

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gen_Get_Images_For_StateRoom]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Halse>
-- Create date: <October 17, 2008>
-- Description:	<Gets a set of BulkImageIDs for a Stateroom for the active segment>

-- =============================================
CREATE PROCEDURE [dbo].[Gen_Get_Images_For_StateRoom] 
	@ActiveSegmentKey int,
	@StateRoom nvarchar(15),
	@PageSize int = 2147483647, --Maximum for int by for default		
	@PageNumber int =1
AS
BEGIN
SET NOCOUNT ON;
SELECT [BulkImageID] FROM 
(
Select row_number() over (ORDER BY PrintDate Desc) AS resultNum,
 [Images].[BulkImageID] from [Images] Left join 
[PartiesInImage] 
ON [Images].[BulkImageID] =[PartiesInImage].[BulkImageID]
left Join 
    [PartyMembers] ON [PartyMembers].[PartyID] = [PartiesInImage].[PartyID]
    Inner Join [Manifest] on [PartyMembers].[ManifestID] = [Manifest].[ManifestKey]
Inner Join [PassengerSegmentLinks] on [PassengerSegmentLinks].[ManifestID]=[Manifest].[ManifestKey]
	WHERE VoyageSegmentID = @ActiveSegmentKey
AND [Manifest].[Cabin] = @StateRoom
and [Images].Available = 1
)
AS ImageResults
WHERE resultNum  
BETWEEN 
((@PageNumber - 1) * @PageSize) + 1 and (@PageNumber * @PageSize)
return @@rowcount

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Stock_Images]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author: Cabinet UK - Rodrigo
-- Create date: 21/11/08
-- Description:	Return the stock images with pagination.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Stock_Images]

	@Offset INT = '''',
	@MaxResults INT = '''',
	@ImageType varchar(50) = ''2''

AS

BEGIN

	declare @sql nvarchar(2000)
	declare @lastRow int 
	set @lastRow = (@Offset + @MaxResults)-1
	IF @OffSet = ''''
		-- if we dont want it paginated
		BEGIN
			SELECT *
			FROM Images
			WHERE ImageTypeID = @ImageType
		END
	ELSE
		-- with pagination
		BEGIN
				set @sql = (''
					WITH [Images ORDERED BY ROWID] AS (
					select distinct
					Images.BulkImageID
					,[PrintDate]
					,[EventID]
					,ImagePaths.ImagePath
					,[PreviewImage]+ ''''_T.jpg'''' as Thumbnail
					,[PreviewImage]+ ''''_P.jpg'''' as Preview
					,[PreviewImage]+ ''''_L.jpg'''' as Largepreview
					,[Available]
					,[PrintJobID]
					,[DfltCropW]
					,[DfltCropH]
					,[DfltCropL]
					,[DfltCropT]
					,[RawImageH]
					,[RawImageW]
					,[AssociatedParent]
					,[ProductID]
					,[SourceFlag]
					,[PictureStatus]
					,[IsGuestPhoto]
					,[MasterImage]
					,[Rotate]
					,[PrintQuantity]
					,Images.[CreatedDate]
					,Images.[ModifiedDate]
					,[ImagePathID]
					,[OCItem]
					,[FROrderIndex]
					,[RenderAttempts]
					,[ImagesToPrintFlag]
					,ROW_NUMBER() OVER (ORDER BY Images.BulkImageID DESC) AS ROWID
					from dbo.Images
				'')
				
			set @sql = @sql + ('' INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID '')
			set @sql = @sql + ('' WHERE Images.ImageTypeID in (''+ @ImageType +'')'' ) 
			set @sql = @sql + ('' AND Images.Available = 1 AND Images.EventID IS NOT NULL'')
			set @sql = @sql + '' ) ''
			set @sql = @sql + '' SELECT * 
								FROM [Images ORDERED BY ROWID] 
								WHERE ROWID between '' + cast(@Offset as varchar) + '' and '' + cast(@lastRow as varchar)  + '' ORDER BY CreatedDate''
			exec (@sql)
	END
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Images_Count]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author: Cabinet UK - Rodrigo
-- Create date: 21/11/08
-- Description:	Return the total count of images.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Images_Count]
	-- Add the parameters for the stored procedure here
	@UpID varchar(10) = '''',
	@ImageType varchar(50) = '''',
	@YouFinder varchar(2) = ''''
AS
BEGIN

	-- set a few vars
	declare @sql nvarchar(1000)
	
	-- general case: no parameters. Return the count of total distinct available images, 
	-- from all groups, with youfinder, for all passengers
	if @UpID = '''' and @ImageType = '''' and @YouFinder = ''''
		begin
			select count (distinct BulkImageID) as allImages
			from dbo.Images as i
			where i.Available = 1
		end
	
	-- if we have a PaxID, lets check what else whe have got and do the query from there.
	if @UpID != ''''
		begin 
			
			set @sql = (''
				select count (distinct Images.BulkImageID) as allImages
				from Images
			'')
			
			--set @sql = (''select * from Images '')
			
			-- join the tables to get just those that correspond to the UpID 
			set @sql = @sql + (''
				INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
				INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
				INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
				INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
				LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = ''+@UpID+''			
				'')
		end

	-- if we are searching by UpID
	if @UpID !=''''
		begin
			set @sql = @sql + ('' WHERE Manifest.UniquePassengerID = ''+ @UpID +'' '')
		end
	
	-- if we have UpID and an ImageType
	if @UpID !='''' and @ImageType != ''''
		begin
			set @sql = @sql + ('' AND Images.ImageTypeID in (''+ @ImageType +'')'' )
			set @sql = @sql + ('' AND Images.BulkImageID not in (select HiddenImages.BulkImageID from HiddenImages where HiddenImages.UniquePassengerID = ''+ @UpID +'') '')
		end
	
	-- the images must allways be available in all cases 
	set @sql = @sql + ('' AND Images.Available = 1 AND Images.EventID IS NOT NULL'')	

-- execute 
exec (@sql)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Images_Range]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author: Cabinet UK - Rodrigo
-- Create date: 21/11/08
-- Description:	Return the images with pagination.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Images_Range]
	-- Add the parameters for the stored procedure here
	@Offset int,
	@MaxResults int,
	@UpID varchar(10) = '''',
	@ImageType varchar(50) = '''',
	@YouFinder varchar(2) = ''''
AS
BEGIN

	-- set a few vars
	declare @sql nvarchar(2000)
	declare @lastRow int 
	set @lastRow = (@Offset + @MaxResults)
	
	-- general case: no parameters. Return the count of total distinct available images, 
	-- from all groups, with youfinder, for all passengers
	if @UpID = '''' and @ImageType = '''' and @YouFinder = ''''
		BEGIN
			WITH [Images ORDERED BY ROWID] AS (
				SELECT *, ROW_NUMBER() OVER (ORDER BY BulkImageID ASC) AS ROWID
				FROM dbo.Images AS i
				WHERE i.Available = 1
			)
			SELECT * FROM [Images ORDERED BY ROWID] 
			WHERE ROWID between @Offset and (@Offset + @MaxResults)
		END
	else
		begin 
		-- if we have a GroupType, lets check what else whe have got and do the query from there.
		if @ImageType != ''''
			begin 
				set @sql = (''
					WITH [Images ORDERED BY ROWID] AS (
					select distinct
					Images.BulkImageID
					,[PrintDate]
					,[EventID]
					,[IsStock]
					,ImagePaths.ImagePath
					,[PreviewImage]+ ''''_T.jpg'''' as Thumbnail
					,[PreviewImage]+ ''''_P.jpg'''' as Preview
					,[PreviewImage]+ ''''_L.jpg'''' as Largepreview
					,[Available]
					,[PrintJobID]
					,[DfltCropW]
					,[DfltCropH]
					,[DfltCropL]
					,[DfltCropT]
					,[RawImageH]
					,[RawImageW]
					,[AssociatedParent]
					,[ProductID]
					,[SourceFlag]
					,[PictureStatus]
					,[IsGuestPhoto]
					,[MasterImage]
					,[Rotate]
					,[PrintQuantity]
					,Images.[CreatedDate]
					,Images.[ModifiedDate]
					,[ImagePathID]
					,[OCItem]
					,[FROrderIndex]
					,[RenderAttempts]
					,[ImagesToPrintFlag]
					,[ImageTypeID]
					,ROW_NUMBER() OVER (ORDER BY Images.BulkImageID DESC) AS ROWID
					from dbo.Images
				'')
				
				-- join the tables to get just those that correspond to the paxid 
				set @sql = @sql + (''
					INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
					INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey 
					INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID    
					INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
					LEFT OUTER JOIN HiddenImages ON HiddenImages.UniquePassengerID = ''+@UpID+''
					INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID
				 
					'')
			end
			
			
			-- if we are searching by UpID
			if @UpID !=''''
				begin
					set @sql = @sql + ('' WHERE Manifest.UniquePassengerID = ''+ @UpID +'' '')
				end
			
			-- if we have UpID and an ImageType
			if @UpID !='''' and @ImageType != ''''
				begin
					set @sql = @sql + ('' AND Images.ImageTypeID in (''+ @ImageType +'')'' )
					set @sql = @sql + ('' AND Images.BulkImageID not in (select HiddenImages.BulkImageID from HiddenImages where HiddenImages.UniquePassengerID = ''+ @UpID +'') '')
				end
			
			-- the images must allways be available in all cases 
			set @sql = @sql + ('' AND Images.Available = 1 AND Images.EventID IS NOT NULL'')	


			-- close the statement "with"
			set @sql = @sql + ('' ) '')
			
			set @sql = @sql + ('' SELECT * 
								FROM [Images ORDERED BY ROWID] 
								WHERE ROWID between '' + cast(@Offset as varchar) + '' and '' + cast(@lastRow as varchar)  + '' ORDER BY CreatedDate'')
			
			
			-- execute 
			exec (@sql)
		end
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gen_Get_Image_Count_For_FolioNumber]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Halse>
-- Create date: <September 30, 2008>
-- Description:	<Gets a set of BulkImageIDs for a folio number for the active segment>
-- =============================================
CREATE PROCEDURE [dbo].[Gen_Get_Image_Count_For_FolioNumber]  
@ActiveSegmentKey int,
@Folio nvarchar(30)
AS
BEGIN
Declare @Cnt as int
	SET NOCOUNT ON;
	Select @Cnt = Count ([Images].[BulkImageID]) from [Images] Left join 
	[PartiesInImage] 
	ON [Images].[BulkImageID] =[PartiesInImage].[BulkImageID]
	left Join 
		[PartyMembers] ON [PartyMembers].[PartyID] = [PartiesInImage].[PartyID]
		Inner Join [Manifest] on [PartyMembers].[ManifestID] = [Manifest].[ManifestKey]
	Inner Join [PassengerSegmentLinks] on [PassengerSegmentLinks].[ManifestID]=[Manifest].[ManifestKey]
		WHERE VoyageSegmentID = @ActiveSegmentKey
	AND [Manifest].[FolioNumber] = @Folio
	and [Images].Available = 1
return @Cnt

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gen_Get_Stock_Image_Count]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Halse GRH
-- Create date: October 10, 2008
-- Description:	Pretty much the same as Cab_Get_Stock_Images_Count
-- =============================================
CREATE PROCEDURE [dbo].[Gen_Get_Stock_Image_Count]
AS
begin
	declare @Count int
	SELECT @Count = count(distinct BulkImageID) from Images where ImageTypeID = 2
	return @Count 
end


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Images_Path]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get the images path.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Images_Path]
	@Type varchar(15)
AS
BEGIN
	SELECT SettingValue
	FROM SETTINGS
	WHERE SettingDescription = @Type
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gen_Get_Setting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Halse GRH
-- Create date: October 10, 2008
-- Description:	Pass in setting name, get back value
-- =============================================
CREATE PROC [dbo].[Gen_Get_Setting]
(
@SettingDescription nvarchar(50),
@SettingValue nvarchar(255) output 
)
AS
BEGIN
SET @SettingValue =(select SettingValue  from Settings where SettingDescription = @SettingDescription)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Settings_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Settings_Delete]
(
	@Original_SettingKey int,
	@Original_SettingDescription nvarchar(50),
	@Original_SettingValue nvarchar(50)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[Settings] WHERE (([SettingKey] = @Original_SettingKey) AND ([SettingDescription] = @Original_SettingDescription) AND ([SettingValue] = @Original_SettingValue))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Passenger_By_FolioNumber]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 16/07/2008
-- Description:	Get details of a manifest for a given folio number.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Passenger_By_FolioNumber]
	@FolioNumber nvarchar(30)=''''

AS
	SELECT Manifest.*
	FROM Manifest
	WHERE FolioNumber = @FolioNumber
	AND ManifestKey in (select ManifestID from PassengerSegmentLinks as PSL where PSL.VoyageSegmentID in 
							(select SettingValue from Settings where SettingDescription = ''ActiveSegmentkey'') 
						)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Settings_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Settings_Update]
(
	@SettingKey int,
	@SettingDescription nvarchar(50),
	@SettingValue nvarchar(50),
	@Original_SettingKey int,
	@Original_SettingDescription nvarchar(50),
	@Original_SettingValue nvarchar(50)
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[Settings] SET [SettingKey] = @SettingKey, [SettingDescription] = @SettingDescription, [SettingValue] = @SettingValue WHERE (([SettingKey] = @Original_SettingKey) AND ([SettingDescription] = @Original_SettingDescription) AND ([SettingValue] = @Original_SettingValue));
	
SELECT SettingKey, SettingDescription, SettingValue FROM Settings WHERE (SettingKey = @SettingKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Settings_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Settings_Insert]
(
	@SettingKey int,
	@SettingDescription nvarchar(50),
	@SettingValue nvarchar(50)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Settings] ([SettingKey], [SettingDescription], [SettingValue]) VALUES (@SettingKey, @SettingDescription, @SettingValue);
	
SELECT SettingKey, SettingDescription, SettingValue FROM Settings WHERE (SettingKey = @SettingKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Settings_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Settings_Select]
AS
	SET NOCOUNT ON;
SELECT SettingKey, SettingDescription, SettingValue FROM dbo.Settings
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Manifest_By_Active_VoyageSegment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		CabinetUK - Rodrigo
-- Create date: 15-11-08
-- Description:	Returns UpID if it matches against being present in ActiveSegments
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Manifest_By_Active_VoyageSegment]
		@Upid varchar(100) = ''''
AS
BEGIN
	SELECT * FROM Manifest 
	WHERE UniquePassengerID = @Upid
	AND ManifestKey IN
	(SELECT ManifestID FROM PassengerSegmentLinks  WHERE VoyageSegmentID IN
		(SELECT SettingValue FROM Settings WHERE SettingDescription =''ActiveSegmentkey'')
	)

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductType_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductType_Delete]
(
	@Original_ProductTypeKey int,
	@IsNull_ProductTypeDescription nvarchar(50),
	@Original_ProductTypeDescription nvarchar(50)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [ProductType] WHERE (([ProductTypeKey] = @Original_ProductTypeKey) AND ((@IsNull_ProductTypeDescription = 1 AND [ProductTypeDescription] IS NULL) OR ([ProductTypeDescription] = @Original_ProductTypeDescription)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductType_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductType_Update]
(
	@ProductTypeKey int,
	@ProductTypeDescription nvarchar(50),
	@Original_ProductTypeKey int,
	@IsNull_ProductTypeDescription nvarchar(50),
	@Original_ProductTypeDescription nvarchar(50)
)
AS
	SET NOCOUNT OFF;
UPDATE [ProductType] SET [ProductTypeKey] = @ProductTypeKey, [ProductTypeDescription] = @ProductTypeDescription WHERE (([ProductTypeKey] = @Original_ProductTypeKey) AND ((@IsNull_ProductTypeDescription = 1 AND [ProductTypeDescription] IS NULL) OR ([ProductTypeDescription] = @Original_ProductTypeDescription)));
	
SELECT ProductTypeKey, ProductTypeDescription FROM ProductType WHERE (ProductTypeKey = @ProductTypeKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductType_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductType_Select]
AS
	SET NOCOUNT ON;
SELECT ProductTypeKey, ProductTypeDescription FROM ProductType
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductType_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductType_Insert]
(
	@ProductTypeKey int,
	@ProductTypeDescription nvarchar(50)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [ProductType] ([ProductTypeKey], [ProductTypeDescription]) VALUES (@ProductTypeKey, @ProductTypeDescription);
	
SELECT ProductTypeKey, ProductTypeDescription FROM ProductType WHERE (ProductTypeKey = @ProductTypeKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Portrait_Images_Range]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Cabinet UK
-- Create date: 01/08/2008
-- Description:	Get a range of portrait images.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Portrait_Images_Range]
	@PaxId nvarchar(25),
	@YouFinder int,
	@Start int,
	@End int
AS
BEGIN
	SELECT * FROM (
		SELECT row_number() OVER (ORDER BY PrintDate DESC) as resultNum, Images.BulkImageID
		FROM Images 
		INNER JOIN PartiesInImage ON Images.BulkImageID = PartiesInImage.BulkImageID
		INNER JOIN Parties ON PartiesInImage.PartyID = Parties.PartyKey
		INNER JOIN PartyMembers ON Parties.PartyKey = PartyMembers.PartyID
		INNER JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
		WHERE Manifest.PaxID = @PaxId
		AND Images.Available = 1
		AND Parties.PartyTypeID = ''1''
		AND PartiesInImage.AssociationType = @YouFinder
	) as numberResults
	WHERE resultNum  BETWEEN @Start AND @End
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Is_Party_Member]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 25/07/2008
-- Description:	Is party member.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Is_Party_Member]
	@PaxID varchar(50),
	@PartyID varchar(50)
AS
BEGIN
	SELECT count(*)
    FROM PartyMembers 
    JOIN Manifest ON PartyMembers.ManifestID = Manifest.ManifestKey
    WHERE PartyID = @PartyID
    AND Manifest.PaxID = @PaxID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartyMembers_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PartyMembers_Delete]
(
	@Original_PartyID int,
	@Original_ManifestID int,
	@Original_PartyMembersKey int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [PartyMembers] WHERE (([PartyID] = @Original_PartyID) AND ([ManifestID] = @Original_ManifestID) AND ([PartyMembersKey] = @Original_PartyMembersKey) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartyMembers_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PartyMembers_Insert]
(
	@PartyID int,
	@ManifestID int,
	@PartyMembersKey int,
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [PartyMembers] ([PartyID], [ManifestID], [PartyMembersKey], [CreatedDate], [ModifiedDate]) VALUES (@PartyID, @ManifestID, @PartyMembersKey, @CreatedDate, @ModifiedDate);
	
SELECT PartyID, ManifestID, PartyMembersKey, CreatedDate, ModifiedDate FROM PartyMembers WHERE (PartyMembersKey = @PartyMembersKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartyMembers_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PartyMembers_Select]
AS
	SET NOCOUNT ON;
SELECT PartyID, ManifestID, PartyMembersKey, CreatedDate, ModifiedDate FROM PartyMembers
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartyMembers_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PartyMembers_Update]
(
	@PartyID int,
	@ManifestID int,
	@PartyMembersKey int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_PartyID int,
	@Original_ManifestID int,
	@Original_PartyMembersKey int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [PartyMembers] SET [PartyID] = @PartyID, [ManifestID] = @ManifestID, [PartyMembersKey] = @PartyMembersKey, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([PartyID] = @Original_PartyID) AND ([ManifestID] = @Original_ManifestID) AND ([PartyMembersKey] = @Original_PartyMembersKey) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT PartyID, ManifestID, PartyMembersKey, CreatedDate, ModifiedDate FROM PartyMembers WHERE (PartyMembersKey = @PartyMembersKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_HiddenImages_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 01/08/2008
-- Description:	Delete a record from HiddenImages Table by BulkImageID and UpID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_HiddenImages_Record]
	@UpID varchar(20),
	@BulkImageID int 
	
AS
BEGIN
	DELETE FROM HiddenImages
      WHERE UniquePassengerID = @UpID 
			AND BulkImageID = @BulkImageID
		
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_HiddenImages_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 15/08/2008
-- Description:	update HiddenImages Table by BulkImageID and UpID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_HiddenImages_Record]
	@uniquePassengerID varchar(20),
	@BulkImageID int
AS
BEGIN

	UPDATE HiddenImages SET UniquePassengerID = @uniquePassengerID 
	WHERE 
	BulkImageID = @BulkImageID
	
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_HiddenImages_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 15/08/2008
-- Description:	get bulk image id from HiddenImages table by BulkImageID and UpID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_HiddenImages_Record] 
	@uniquePassengerID varchar(20),
	@BulkImageID int
AS
BEGIN

SELECT BulkImageID FROM HiddenImages 
WHERE BulkImageID = @BulkImageID 
AND UniquePassengerID = @uniquePassengerID
		
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_HiddenImages_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 01/08/2008
-- Description:	Insert a new record into HiddenImages Table by BulkImageID and UpID
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Add_HiddenImages_Record] 
	@UpID varchar(20),
	@BulkImageID int
AS
BEGIN
	INSERT INTO HiddenImages
           (UniquePassengerID
           ,BulkImageID)
     VALUES
           (@UpID
           ,@BulkImageID)
		
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_DeleteCommand]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HSP_Parties_DeleteCommand]
(
	@Original_PartyKey int,
	@Original_PartyDescription nvarchar(50),
	@IsNull_PartyEmbarkDate datetime,
	@Original_PartyEmbarkDate datetime,
	@Original_PartyTypeID int,
	@Original_PartyModified bit,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_CabinNo nvarchar(15),
	@Original_CabinNo nvarchar(15),
	@IsNull_NewPartyID int,
	@Original_NewPartyID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [Parties] WHERE (([PartyKey] = @Original_PartyKey) AND ([PartyDescription] = @Original_PartyDescription) AND ((@IsNull_PartyEmbarkDate = 1 AND [PartyEmbarkDate] IS NULL) OR ([PartyEmbarkDate] = @Original_PartyEmbarkDate)) AND ([PartyTypeID] = @Original_PartyTypeID) AND ([PartyModified] = @Original_PartyModified) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ((@IsNull_CabinNo = 1 AND [CabinNo] IS NULL) OR ([CabinNo] = @Original_CabinNo)) AND ((@IsNull_NewPartyID = 1 AND [NewPartyID] IS NULL) OR ([NewPartyID] = @Original_NewPartyID)))

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_InsertCommand]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_InsertCommand]
(
	@PartyKey int,
	@PartyDescription nvarchar(50),
	@PartyEmbarkDate datetime,
	@PartyTypeID int,
	@PartyModified bit,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@CabinNo nvarchar(15),
	@NewPartyID int
)
AS
	SET NOCOUNT OFF;
INSERT INTO [Parties] ([PartyKey], [PartyDescription], [PartyEmbarkDate], [PartyTypeID], [PartyModified], [CreatedDate], [ModifiedDate], [CabinNo], [NewPartyID]) VALUES (@PartyKey, @PartyDescription, @PartyEmbarkDate, @PartyTypeID, @PartyModified, @CreatedDate, @ModifiedDate, @CabinNo, @NewPartyID);
	
SELECT PartyKey, PartyDescription, PartyEmbarkDate, PartyTypeID, PartyModified, CreatedDate, ModifiedDate, CabinNo, NewPartyID FROM Parties WHERE (PartyKey = @PartyKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_SelectCommand]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_SelectCommand]
AS
	SET NOCOUNT ON;
SELECT     PartyKey, PartyDescription, PartyEmbarkDate, PartyTypeID, PartyModified, CreatedDate, ModifiedDate, CabinNo, NewPartyID
FROM         Parties
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_UpdateCommand]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_UpdateCommand]
(
	@PartyKey int,
	@PartyDescription nvarchar(50),
	@PartyEmbarkDate datetime,
	@PartyTypeID int,
	@PartyModified bit,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@CabinNo nvarchar(15),
	@NewPartyID int,
	@Original_PartyKey int,
	@Original_PartyDescription nvarchar(50),
	@IsNull_PartyEmbarkDate datetime,
	@Original_PartyEmbarkDate datetime,
	@Original_PartyTypeID int,
	@Original_PartyModified bit,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_CabinNo nvarchar(15),
	@Original_CabinNo nvarchar(15),
	@IsNull_NewPartyID int,
	@Original_NewPartyID int
)
AS
	SET NOCOUNT OFF;
UPDATE [Parties] SET [PartyKey] = @PartyKey, [PartyDescription] = @PartyDescription, [PartyEmbarkDate] = @PartyEmbarkDate, [PartyTypeID] = @PartyTypeID, [PartyModified] = @PartyModified, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate, [CabinNo] = @CabinNo, [NewPartyID] = @NewPartyID WHERE (([PartyKey] = @Original_PartyKey) AND ([PartyDescription] = @Original_PartyDescription) AND ((@IsNull_PartyEmbarkDate = 1 AND [PartyEmbarkDate] IS NULL) OR ([PartyEmbarkDate] = @Original_PartyEmbarkDate)) AND ([PartyTypeID] = @Original_PartyTypeID) AND ([PartyModified] = @Original_PartyModified) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ((@IsNull_CabinNo = 1 AND [CabinNo] IS NULL) OR ([CabinNo] = @Original_CabinNo)) AND ((@IsNull_NewPartyID = 1 AND [NewPartyID] IS NULL) OR ([NewPartyID] = @Original_NewPartyID)));
	
SELECT PartyKey, PartyDescription, PartyEmbarkDate, PartyTypeID, PartyModified, CreatedDate, ModifiedDate, CabinNo, NewPartyID FROM Parties WHERE (PartyKey = @PartyKey)


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_Update]
(
	@PartyKey int,
	@PartyDescription nvarchar(50),
	@PartyEmbarkDate datetime,
	@PartyTypeID int,
	@PartyModified bit,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@CabinNo nvarchar(15),
	@Original_PartyKey int,
	@Original_PartyDescription nvarchar(50),
	@IsNull_PartyEmbarkDate datetime,
	@Original_PartyEmbarkDate datetime,
	@Original_PartyTypeID int,
	@Original_PartyModified bit,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_CabinNo nvarchar(15),
	@Original_CabinNo nvarchar(15)
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[Parties] SET [PartyKey] = @PartyKey, [PartyDescription] = @PartyDescription, [PartyEmbarkDate] = @PartyEmbarkDate, [PartyTypeID] = @PartyTypeID, [PartyModified] = @PartyModified, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate, [CabinNo] = @CabinNo WHERE (([PartyKey] = @Original_PartyKey) AND ([PartyDescription] = @Original_PartyDescription) AND ((@IsNull_PartyEmbarkDate = 1 AND [PartyEmbarkDate] IS NULL) OR ([PartyEmbarkDate] = @Original_PartyEmbarkDate)) AND ([PartyTypeID] = @Original_PartyTypeID) AND ([PartyModified] = @Original_PartyModified) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ((@IsNull_CabinNo = 1 AND [CabinNo] IS NULL) OR ([CabinNo] = @Original_CabinNo)));
	
SELECT PartyKey, PartyDescription, PartyEmbarkDate, PartyTypeID, PartyModified, CreatedDate, ModifiedDate, CabinNo FROM Parties WHERE (PartyKey = @PartyKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_Delete]
(
	@Original_PartyKey int,
	@Original_PartyDescription nvarchar(50),
	@IsNull_PartyEmbarkDate datetime,
	@Original_PartyEmbarkDate datetime,
	@Original_PartyTypeID int,
	@Original_PartyModified bit,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_CabinNo nvarchar(15),
	@Original_CabinNo nvarchar(15)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[Parties] WHERE (([PartyKey] = @Original_PartyKey) AND ([PartyDescription] = @Original_PartyDescription) AND ((@IsNull_PartyEmbarkDate = 1 AND [PartyEmbarkDate] IS NULL) OR ([PartyEmbarkDate] = @Original_PartyEmbarkDate)) AND ([PartyTypeID] = @Original_PartyTypeID) AND ([PartyModified] = @Original_PartyModified) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ((@IsNull_CabinNo = 1 AND [CabinNo] IS NULL) OR ([CabinNo] = @Original_CabinNo)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_Insert]
(
	@PartyKey int,
	@PartyDescription nvarchar(50),
	@PartyEmbarkDate datetime,
	@PartyTypeID int,
	@PartyModified bit,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@CabinNo nvarchar(15)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Parties] ([PartyKey], [PartyDescription], [PartyEmbarkDate], [PartyTypeID], [PartyModified], [CreatedDate], [ModifiedDate], [CabinNo]) VALUES (@PartyKey, @PartyDescription, @PartyEmbarkDate, @PartyTypeID, @PartyModified, @CreatedDate, @ModifiedDate, @CabinNo);
	
SELECT PartyKey, PartyDescription, PartyEmbarkDate, PartyTypeID, PartyModified, CreatedDate, ModifiedDate, CabinNo FROM Parties WHERE (PartyKey = @PartyKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Parties_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Parties_Select]
AS
	SET NOCOUNT ON;
SELECT PartyKey, PartyDescription, PartyEmbarkDate, PartyTypeID, PartyModified, CreatedDate, ModifiedDate, CabinNo FROM dbo.Parties
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Events_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Events_Insert]
(
	@EventKey int,
	@EventDate datetime,
	@EventName nvarchar(50),
	@EventTypeID int,
	@VoyageSegmentID int,
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Events] ([EventKey], [EventDate], [EventName], [EventTypeID], [VoyageSegmentID], [CreatedDate], [ModifiedDate]) VALUES (@EventKey, @EventDate, @EventName, @EventTypeID, @VoyageSegmentID, @CreatedDate, @ModifiedDate);
	
SELECT EventKey, EventDate, EventName, EventTypeID, VoyageSegmentID, CreatedDate, ModifiedDate FROM Events WHERE (EventKey = @EventKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Events_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Events_Select]
AS
	SET NOCOUNT ON;
SELECT EventKey, EventDate, EventName, EventTypeID, VoyageSegmentID, CreatedDate, ModifiedDate FROM dbo.Events
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Events_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Events_Update]
(
	@EventKey int,
	@EventDate datetime,
	@EventName nvarchar(50),
	@EventTypeID int,
	@VoyageSegmentID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_EventKey int,
	@Original_EventDate datetime,
	@Original_EventName nvarchar(50),
	@Original_EventTypeID int,
	@Original_VoyageSegmentID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[Events] SET [EventKey] = @EventKey, [EventDate] = @EventDate, [EventName] = @EventName, [EventTypeID] = @EventTypeID, [VoyageSegmentID] = @VoyageSegmentID, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([EventKey] = @Original_EventKey) AND ([EventDate] = @Original_EventDate) AND ([EventName] = @Original_EventName) AND ([EventTypeID] = @Original_EventTypeID) AND ([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT EventKey, EventDate, EventName, EventTypeID, VoyageSegmentID, CreatedDate, ModifiedDate FROM Events WHERE (EventKey = @EventKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Events_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Events_Delete]
(
	@Original_EventKey int,
	@Original_EventDate datetime,
	@Original_EventName nvarchar(50),
	@Original_EventTypeID int,
	@Original_VoyageSegmentID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[Events] WHERE (([EventKey] = @Original_EventKey) AND ([EventDate] = @Original_EventDate) AND ([EventName] = @Original_EventName) AND ([EventTypeID] = @Original_EventTypeID) AND ([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ProductKey_For_Image]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



-- =============================================
-- Author:		CabinetUK
-- Create date: 26/06/2008
-- Description:	Get the default layout product id for a given image.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ProductKey_For_Image]
	@bulkImageID int = '''',
	@layoutFamily varchar(50) = '''',
	@layoutName varchar(50) = ''''

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Products.ProductKey 
	FROM Images 
		JOIN Events ON Events.EventKey = Images.EventID 
		JOIN ProductEventLinks ON ProductEventLinks.EventTypeID = Events.EventTypeID 
		JOIN Products ON Products.ProductKey = ProductEventLinks.ProductID 
	WHERE Images.BulkImageID = @bulkImageID 
		AND Products.LayoutFamily = @layoutFamily 
		AND Products.LayoutName LIKE ''%'' + @layoutName + ''%''
	ORDER BY LayoutFamily
END








' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EndofShifts_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EndofShifts_Select]
AS
	SET NOCOUNT ON;
SELECT EndOfShiftKey, VoyageSegmentID, EndOfShift, DayNumber, CreatedDate, ModifiedDate FROM dbo.EndOfShifts
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EndofShifts_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EndofShifts_Insert]
(
	@VoyageSegmentID int,
	@EndOfShift datetime,
	@DayNumber int,
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[EndOfShifts] ([VoyageSegmentID], [EndOfShift], [DayNumber], [CreatedDate], [ModifiedDate]) VALUES (@VoyageSegmentID, @EndOfShift, @DayNumber, @CreatedDate, @ModifiedDate);
	
SELECT EndOfShiftKey, VoyageSegmentID, EndOfShift, DayNumber, CreatedDate, ModifiedDate FROM EndOfShifts WHERE (EndOfShiftKey = SCOPE_IDENTITY())
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EndofShifts_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EndofShifts_Delete]
(
	@Original_EndOfShiftKey numeric,
	@Original_VoyageSegmentID int,
	@Original_EndOfShift datetime,
	@Original_DayNumber int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[EndOfShifts] WHERE (([EndOfShiftKey] = @Original_EndOfShiftKey) AND ([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([EndOfShift] = @Original_EndOfShift) AND ([DayNumber] = @Original_DayNumber) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_EndofShifts_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_EndofShifts_Update]
(
	@VoyageSegmentID int,
	@EndOfShift datetime,
	@DayNumber int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_EndOfShiftKey numeric,
	@Original_VoyageSegmentID int,
	@Original_EndOfShift datetime,
	@Original_DayNumber int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@EndOfShiftKey numeric
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[EndOfShifts] SET [VoyageSegmentID] = @VoyageSegmentID, [EndOfShift] = @EndOfShift, [DayNumber] = @DayNumber, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([EndOfShiftKey] = @Original_EndOfShiftKey) AND ([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([EndOfShift] = @Original_EndOfShift) AND ([DayNumber] = @Original_DayNumber) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT EndOfShiftKey, VoyageSegmentID, EndOfShift, DayNumber, CreatedDate, ModifiedDate FROM EndOfShifts WHERE (EndOfShiftKey = @EndOfShiftKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ProductPrice_By_OrderLotKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get all packages in an order given a product key.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ProductPrice_By_OrderLotKey]
	@OrderLotKey int, 
	@ProductTypeID int = 1
AS

-- test (exec Cab_Get_ProductPrice_By_OrderLotKey ''21'')
BEGIN
	SELECT OrderDetails.ProductID, Products.ProductPrice 
	FROM OrderDetails 
	JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID 
	JOIN Products ON Products.ProductKey=OrderDetails.ProductID 
	WHERE Products.ProductTypeID= @ProductTypeID 
	AND OrderPackages.OrderLotID = @OrderLotKey 
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackageKey_By_ProductID_and_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get all packages in an order given a product key.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderPackageKey_By_ProductID_and_OrderLotID]
	@DBProductKey int, 
	@OrderLotId int
AS
-- test (exec Cab_Get_OrderPackageKey_By_ProductID_and_OrderLotID ''4'', ''5'')
BEGIN
	SELECT OrderPackageKey
	FROM OrderDetails
	INNER JOIN OrderPackages ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID
	WHERE ProductID =  @DBProductKey
	AND OrderLotID = @OrderLotId
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_OrderPackage_By_OrderPackageKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Delete a OrderPackage by given its OrderPackageKey.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_OrderPackage_By_OrderPackageKey]
	@DBOrderPackageKey int
AS
BEGIN
	DELETE FROM OrderPackages WHERE OrderPackageKey = @DBOrderPackageKey
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetails_By_ProductTypeID_And_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08.
-- Description:	Get some order details agaist the product type and the order package id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderDetails_By_ProductTypeID_And_OrderLotID]
	@ProductTypeID int, 
	@OrderLotID int
AS
-- test (exec Cab_Get_OrderDetails_By_ProductTypeID_And_OrderLotID ''6'', ''5'')
BEGIN
	SELECT OrderPackages.Price, OrderPackages.OrderPackageKey, OrderPackages.PackageDescription
	FROM OrderDetails
	JOIN Products ON Products.ProductKey=OrderDetails.ProductID
	JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID
	WHERE Products.ProductTypeID = @ProductTypeID
	AND OrderPackages.OrderLotID = @OrderLotID
END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackage_By_OrderPackageKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Get the order package details for an order package key.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_OrderPackage_By_OrderPackageKey]

@orderPackageId int

AS

BEGIN

	SELECT * FROM OrderPackages 
	WHERE OrderPackageKey = @orderPackageId

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_PackageDescription_By_OrderPackageKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <24/07/08>
-- Description:	<get the packge description for an order package key>
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_PackageDescription_By_OrderPackageKey]

@orderPackageKey int 
 

AS

BEGIN

	SELECT PackageDescription FROM OrderPackages 
	WHERE OrderPackageKey = @orderPackageKey

END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Image_OrderDetailKey_For_Order]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 10/09/08
-- Description:	Get the OrderDetailKey of an image into an order.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Image_OrderDetailKey_For_Order] 
	@OrderLotID int,
	@ProductID int,
	@BulkImageID int,
	@OrderDetailKey int = 0 OUTPUT
AS
BEGIN
		SELECT TOP 1 @OrderDetailKey = OrderDetails.OrderDetailKey
		FROM OrderDetails
		INNER JOIN OrderPackages ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID
		INNER JOIN OrderImageItem ON OrderImageItem.OrderDetailID = OrderDetails.OrderDetailKey
		WHERE OrderPackages.OrderLotID = @OrderLotID
		AND OrderDetails.ProductID = @ProductID
		AND OrderImageItem.BulkImageID = @BulkImageID

		SELECT @OrderDetailKey
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderDetailsQuantity_By_OrderLotID_And_ProductID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 25/07/08
-- Description:	update order details quantity by order detail key
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_OrderDetailsQuantity_By_OrderLotID_And_ProductID]
	@OrderLotID int,
	@ProductID int,
	@Quantity numeric(6,2)
AS
	BEGIN
		DECLARE @OrderDetailKey int

		SELECT @OrderDetailKey = OrderDetailKey
		FROM OrderDetails
		INNER JOIN OrderPackages ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID
		--INNER JOIN Orders_Multiline ON Orders_Multiline.OrderLotKey = OrderPackage.OrderLotID
		WHERE OrderPackages.OrderLotID = @OrderLotID
		AND OrderDetails.ProductID = @ProductID

		UPDATE OrderDetails SET Quantity = @Quantity WHERE OrderDetailKey = @OrderDetailKey
	END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Clear_Order]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- Author:		Cabinet UK
-- Create date: 10/09/08
-- Description:	Clear the order packages for an order
CREATE PROCEDURE [dbo].[Cab_Clear_Order]
	@OrderLotID int
AS
BEGIN
	DELETE FROM OrderPackages WHERE OrderLotID = @OrderLotID
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ProductID_By_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Returns the products for order.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ProductID_By_OrderLotID] 
	@OrderLotId varchar(100)
AS
-- test (exec Cab_Get_ProductID_By_OrderLotID ''5'')
BEGIN
	SELECT OrderDetails.ProductID 
	FROM OrderDetails 
    JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID 
    WHERE OrderPackages.OrderLotID = @OrderLotId

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderPackages_By_OrderPackageKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Update orderpackages by its orderpackagekey.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_OrderPackages_By_OrderPackageKey]
	@TotalProductPrice numeric(6,2), 
	@PackageDescription nvarchar(1000), 
	@OrderPackageQty int, 
	@SetOrderPackageFlag bit, 
	@OrderPackageKey int
AS
-- test (exec Cab_Update_OrderPackages_By_OrderPackageKey ''5.55'', ''small description about this'', ''10'', 1, null )
BEGIN
	UPDATE OrderPackages
	SET 
	Price					= @TotalProductPrice, 
	PackageDescription		= @PackageDescription, 
	Quantity				= @OrderPackageQty,
	OrderPackages_Package	= @SetOrderPackageFlag
	WHERE 
	OrderPackageKey = @OrderPackageKey
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_OrderPackage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Insert one row into OrderPackages.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Add_OrderPackage]
	@OrderLotID int,
	@Price numeric(6,2),
	@PackageDescription nvarchar(1000), 
	@OrderPackageQty int, 
	@SetOrderPackageFlag bit
AS
-- test (exec Cab_Add_OrderPackage ''5.55'', ''small description to 1000'', ''5'', ''1'', 0)
BEGIN
	INSERT INTO OrderPackages (
		Price, 
		PackageDescription, 
		OrderLotID, 
		Quantity, 
		OrderPackages_Package
	) VALUES ( 
		@Price ,
		@PackageDescription,
		@OrderLotID ,
		@OrderPackageQty , 
		@SetOrderPackageFlag
	)
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetails_By_ProductKey_And_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <30/07/08>
-- Description:	<get the order details by product key and order lot id>
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderDetails_By_ProductKey_And_OrderLotID]

	@ProductKey int,
	@OrderLotId int
AS

BEGIN
	SELECT *
	FROM OrderDetails
	INNER JOIN OrderPackages ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID
	WHERE ProductID=@ProductKey
	AND OrderLotID=@OrderLotId
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderPackages_ProductPrice_By_OrderPackageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Updates the price by PackageID.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_OrderPackages_ProductPrice_By_OrderPackageID]
	@DBProductPrice numeric(10,2),
	@PackageID int
AS
BEGIN
	UPDATE OrderPackages SET Price = @DBProductPrice WHERE OrderPackageKey = @PackageID
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetailKey_By_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Get the orderDetailKey by the OrderLotID.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderDetailKey_By_OrderLotID]
	@DBProductKey int,
	@OrderLotID int
AS
BEGIN
	SELECT OrderDetails.OrderDetailKey 
	FROM OrderPackages 
	INNER JOIN OrderDetails ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID 
	WHERE (OrderDetails.ProductID = @DBProductKey )
	AND OrderPackages.OrderLotID = @OrderLotID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_OrderPackage_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	(TODO Description)
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_OrderPackage_Record]
	@orderLotID int, 
	@packageDescription nvarchar(1000), 
 	@price smallmoney, 
	@quantity int = 1, 
	@package bit = 0,
	@OrderPackageKey int OUTPUT
AS
	-- we''re dceclaring the datestamp here so that we can use it to retrieve the newly generated orderPackage_Key
	declare @datestamp datetime
	SET @datestamp = getDate()

	INSERT INTO OrderPackages (Price, PackageDescription, OrderLotID, Quantity, OrderPackages_Package, Datestamp) 
	VALUES (@price,  @packageDescription, @orderLotID, @quantity, @package, @datestamp)

	SELECT @OrderPackageKey = MAX(OrderPackageKey) FROM OrderPackages WHERE OrderLotID=@orderLotID AND Datestamp = @datestamp

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderPackagesPrice_By_OrderPackageKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <25/07/08>
-- Description:	<update order package price by order package key>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_OrderPackagesPrice_By_OrderPackageKey]

@orderPackageKey int,
@price numeric(6,2)

AS

	
	-- update order package
	BEGIN
		UPDATE OrderPackages SET Price = @price 
		WHERE OrderPackageKey = @orderPackageKey
	END 

-- execute dbo.NOT_TESTED_Cab_Update_OrderPackagesPrice_By_OrderPackageKey @orderPackageKey=38, @price=7.99






' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_Order_Item_By_OrderPackageId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Delete an item from an order package.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Delete_Order_Item_By_OrderPackageId]
	@OrderPackageKey int 
AS
	DELETE FROM OrderPackages  WHERE OrderPackageKey=@OrderPackageKey 

	-- There are cascade deletes set up to delete the following:

	-- ALL PRODUCTS::
	-- OrderDetails record
	
	-- IMAGES::
	-- OrderImageItem
	-- OrderTextItem

	-- EMAILS::
	-- Email_CabUK
	-- Email_Recipients_CabUK

	-- SLIDESHOWS:
	-- Slideshow_CabUK
	-- Slideshow_Details_CabUK

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderImageItem_For_Package]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		CabinetUK
-- Create date: 26/06/2008
-- Description:	Get a record from the order image item table.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderImageItem_For_Package] 
	@OrderPackageKey int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT OrderImageItem.* 
	FROM OrderImageItem 
	JOIN OrderDetails ON OrderDetails.OrderDetailKey = OrderImageItem.OrderDetailID 
	JOIN OrderPackages ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID 
	WHERE OrderPackages.OrderPackageKey = @OrderPackageKey
END	



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Quantity_By_OrderLotKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get the count of PrintsInBasket.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Quantity_By_OrderLotKey]
	@OrderLotKey int
AS
-- test (exec Cab_Get_Quantity_By_OrderLotKey ''5'')
BEGIN
	SELECT * 
    FROM OrderDetails 
    JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID 
    JOIN Products ON Products.ProductKey=OrderDetails.ProductID 
    WHERE Products.ProductTypeID = ''1'' 
    AND OrderPackages.OrderPackages_Package != ''1'' 
    AND OrderPackages.OrderLotID = @OrderLotKey
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ProductKey_For_OrderPackageKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Get the product key for an order package id and layoutfamily like cards.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ProductKey_For_OrderPackageKey]

@orderPackageKey int 
 

AS

BEGIN

	SELECT Products.ProductKey 
	FROM Products 
	JOIN OrderDetails ON OrderDetails.ProductID=Products.ProductKey
	JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID
	WHERE OrderPackages.OrderPackageKey=@orderPackageKey
	AND Products.LayoutFamily LIKE ''%cards%''

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Price_By_ProductType_And_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description: Get the price of a product.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Price_By_ProductType_And_OrderLotID]
	@ProductTypeID int,
	@OrderLotID int
AS
BEGIN
	SELECT Price 
	FROM OrderPackages 
	WHERE OrderPackageKey NOT IN 
		(SELECT OrderPackages.OrderPackageKey 
		FROM OrderDetails 
		JOIN Products ON Products.ProductKey=OrderDetails.ProductID 
		JOIN OrderPackages ON OrderPackages.OrderPackageKey=OrderDetails.OrderPackageID 
		WHERE Products.ProductTypeID = @ProductTypeID
		AND OrderPackages.OrderLotID = @OrderLotID ) 
	AND OrderLotID = @OrderLotID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackagesKey_And_Qty_By_ProductKey_And_OrderLotId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Get orderPackegeKey and Quantity by Productkey and OrderLotID.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderPackagesKey_And_Qty_By_ProductKey_And_OrderLotId] 
	@DBProductKey int, 
	@OrderLotID int
AS
BEGIN
	SELECT OrderPackages.OrderPackageKey,OrderDetails.Quantity
	FROM OrderPackages 
	INNER JOIN OrderDetails ON OrderPackages.OrderPackageKey = OrderDetails.OrderPackageID
	WHERE (OrderDetails.ProductID = @DBProductKey) 
	AND OrderPackages.OrderLotID = @OrderLotID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackageKey_By_OrderLotID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get the list of packages for an order.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderPackageKey_By_OrderLotID] 
	@OrderLotId int
AS
-- test (exec Cab_Get_OrderPackageKey_By_OrderLotID ''5'')
BEGIN
	SELECT OrderPackageKey 
	FROM OrderPackages 
	WHERE OrderLotID = @OrderLotId
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_PackageQuantity_For_ProductKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <25/07/08>
-- Description:	<get package content details for a product key>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_PackageQuantity_For_ProductKey]

@productId varchar(2000)

AS

BEGIN

	SELECT PackageContents_CabUK.PackageContents_Quantity 
	FROM Package_CabUK 
	JOIN PackageContents_CabUK ON PackageContents_CabUK.PackageContents_Package_Id=Package_CabUK.Package_Id 
	WHERE Package_CabUK.Package_Cards=''1'' 
	AND PackageContents_CabUK.PackageContents_Product_Key=@productId 
	ORDER BY Package_CabUK.Package_Description

END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_PackageContentsDetails_For_ProductKey_By_WeddingType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <25/07/08>
-- Description:	<get package content details for an order product key and by wedding type>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_PackageContentsDetails_For_ProductKey_By_WeddingType]

@productId int

AS

BEGIN

	SELECT PackageContents_CabUK.PackageContents_Quantity
	FROM Package_CabUK
	JOIN PackageContents_CabUK ON PackageContents_CabUK.PackageContents_Package_Id=Package_CabUK.Package_Id
	WHERE Package_CabUK.Package_Type_Wedding=''1''
	AND Package_CabUK.Package_Cards=''1''
	AND PackageContents_CabUK.PackageContents_Product_Key=@productId
	ORDER BY Package_CabUK.Package_Description

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_PackageContentsDetails_For_ProductKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <25/07/08>
-- Description:	<get package content details for an order product key and by wedding type>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_PackageContentsDetails_For_ProductKey]

@productId varchar(2000)

AS

BEGIN

	SELECT PackageContents_CabUK.PackageContents_Quantity
	FROM Package_CabUK
	JOIN PackageContents_CabUK ON PackageContents_CabUK.PackageContents_Package_Id=Package_CabUK.Package_Id
	WHERE Package_CabUK.Package_Type_Wedding=''1''
	AND Package_CabUK.Package_Cards=''1''
	AND PackageContents_CabUK.PackageContents_Product_Key=@productId
	ORDER BY Package_CabUK.Package_Description

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ProductPrice_By_OrderPackageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Gets the product price.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ProductPrice_By_OrderPackageID] 
	@OrderPackageID int
AS
-- test (exec Cab_Get_ProductPrice_By_PackageID ''34'')
BEGIN
	SELECT Products.ProductPrice, OrderDetails.*
	FROM Products 
	INNER JOIN OrderDetails ON OrderDetails.ProductID = Products.ProductKey
	WHERE OrderDetails.OrderPackageID = @OrderPackageID
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Products_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 02/09/2008
-- Description:	Selection for Product Update
-- =============================================
CREATE PROCEDURE [dbo].[HSP_Products_Select]
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   SELECT ProductKey, ProductDescription, PriceCategory, 
    ProductWidth, ProductHeight, ProductTemplateFile, 
    ProductTypeID, ColourFlag, SKU, LayoutName, 
    ModifiedDate, LayoutFamily 
    FROM Products WHERE ProductKey > 0  
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Products_IE_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HSP_Products_IE_Update]
	-- Add the parameters for the stored procedure here
	@ProductKey int,
    @ProductDescription  varchar(80),
    @PriceCategory int,
    @SKU varchar(20),
    @ProductTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
UPDATE [Products]
  SET 
  [ProductDescription] = @ProductDescription, 
  [PriceCategory] = @PriceCategory, 
  [ProductTypeID] = @ProductTypeID, 
  [SKU] = @SKU, 
  [ModifiedDate] = getdate() 
WHERE [ProductKey] = @ProductKey
-- Perform reslect to get data table display to update
SELECT ProductKey,ProductDescription, 
  PriceCategory, ProductWidth, ProductHeight, ProductTemplateFile, 
  ProductTypeID, ColourFlag, SKU, LayoutName, ModifiedDate, LayoutFamily, 
  ProductTemplateFile_Thumb, ProductTemplateFile_Prev 
   FROM Products WHERE (ProductKey = @ProductKey)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetailsProductID_By_ProductTypeID_And_OrderDetailKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 04/07/08
-- Description:	get order details product id by product type id and order detail key
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_OrderDetailsProductID_By_ProductTypeID_And_OrderDetailKey]

@VoucherProductTypeID INT,
@OrderDetailKey INT

AS

BEGIN

	SELECT ProductID FROM OrderDetails 
    JOIN Products ON Products.ProductKey=OrderDetails.ProductID 
    WHERE Products.ProductTypeID = @VoucherProductTypeID
    AND OrderDetails.OrderDetailKey = @OrderDetailKey

END
 --exec Cab_Get_OrderDetailsProductID_By_ProductTypeID_And_OrderDetailKey 49, 51

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_TProducts_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_TProducts_Delete]
(
	@Original_ProductKey int,
	@Original_ProductDescription nvarchar(80),
	@Original_PriceCategory smallint,
	@Original_ProductWidth float,
	@Original_ProductHeight float,
	@Original_ProductTemplateFile nvarchar(255),
	@Original_ProductTypeID int,
	@Original_ColourFlag int,
	@Original_SKU nvarchar(20),
	@Original_LayoutName nvarchar(50),
	@Original_ModifiedDate datetime,
	@Original_LayoutFamily nvarchar(50),
	@IsNull_ProductTemplateFile_Thumb varchar(255),
	@Original_ProductTemplateFile_Thumb varchar(255),
	@IsNull_ProductTemplateFile_Prev varchar(255),
	@Original_ProductTemplateFile_Prev varchar(255)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [Products] WHERE (([ProductKey] = @Original_ProductKey) AND ([ProductDescription] = @Original_ProductDescription) AND ([PriceCategory] = @Original_PriceCategory) AND ([ProductWidth] = @Original_ProductWidth) AND ([ProductHeight] = @Original_ProductHeight) AND ([ProductTemplateFile] = @Original_ProductTemplateFile) AND ([ProductTypeID] = @Original_ProductTypeID) AND ([ColourFlag] = @Original_ColourFlag) AND ([SKU] = @Original_SKU) AND ([LayoutName] = @Original_LayoutName) AND ([ModifiedDate] = @Original_ModifiedDate) AND ([LayoutFamily] = @Original_LayoutFamily) AND ((@IsNull_ProductTemplateFile_Thumb = 1 AND [ProductTemplateFile_Thumb] IS NULL) OR ([ProductTemplateFile_Thumb] = @Original_ProductTemplateFile_Thumb)) AND ((@IsNull_ProductTemplateFile_Prev = 1 AND [ProductTemplateFile_Prev] IS NULL) OR ([ProductTemplateFile_Prev] = @Original_ProductTemplateFile_Prev)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_TProducts_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_TProducts_Insert]
(
	@ProductKey int,
	@ProductDescription nvarchar(80),
	@PriceCategory smallint,
	@ProductWidth float,
	@ProductHeight float,
	@ProductTemplateFile nvarchar(255),
	@ProductTypeID int,
	@ColourFlag int,
	@SKU nvarchar(20),
	@LayoutName nvarchar(50),
	@ModifiedDate datetime,
	@LayoutFamily nvarchar(50),
	@ProductTemplateFile_Thumb varchar(255),
	@ProductTemplateFile_Prev varchar(255)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [Products] ([ProductKey], [ProductDescription], [PriceCategory], [ProductWidth], [ProductHeight], [ProductTemplateFile], [ProductTypeID], [ColourFlag], [SKU], [LayoutName], [ModifiedDate], [LayoutFamily], [ProductTemplateFile_Thumb], [ProductTemplateFile_Prev]) VALUES (@ProductKey, @ProductDescription, @PriceCategory, @ProductWidth, @ProductHeight, @ProductTemplateFile, @ProductTypeID, @ColourFlag, @SKU, @LayoutName, @ModifiedDate, @LayoutFamily, @ProductTemplateFile_Thumb, @ProductTemplateFile_Prev);
	
SELECT ProductKey, ProductDescription, PriceCategory, ProductWidth, ProductHeight, ProductTemplateFile, ProductTypeID, ColourFlag, SKU, LayoutName, ModifiedDate, LayoutFamily, ProductTemplateFile_Thumb, ProductTemplateFile_Prev FROM Products WHERE (ProductKey = @ProductKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_TProducts_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_TProducts_Select]
AS
	SET NOCOUNT ON;
SELECT ProductKey, ProductDescription, PriceCategory, ProductWidth, ProductHeight, ProductTemplateFile, ProductTypeID, ColourFlag, SKU, LayoutName, ModifiedDate, LayoutFamily, ProductTemplateFile_Thumb, ProductTemplateFile_Prev FROM Products WHERE (ProductKey > 0)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_TProducts_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_TProducts_Update]
(
	@ProductKey int,
	@ProductDescription nvarchar(80),
	@PriceCategory smallint,
	@ProductWidth float,
	@ProductHeight float,
	@ProductTemplateFile nvarchar(255),
	@ProductTypeID int,
	@ColourFlag int,
	@SKU nvarchar(20),
	@LayoutName nvarchar(50),
	@ModifiedDate datetime,
	@LayoutFamily nvarchar(50),
	@ProductTemplateFile_Thumb varchar(255),
	@ProductTemplateFile_Prev varchar(255),
	@Original_ProductKey int,
	@Original_ProductDescription nvarchar(80),
	@Original_PriceCategory smallint,
	@Original_ProductWidth float,
	@Original_ProductHeight float,
	@Original_ProductTemplateFile nvarchar(255),
	@Original_ProductTypeID int,
	@Original_ColourFlag int,
	@Original_SKU nvarchar(20),
	@Original_LayoutName nvarchar(50),
	@Original_ModifiedDate datetime,
	@Original_LayoutFamily nvarchar(50),
	@IsNull_ProductTemplateFile_Thumb varchar(255),
	@Original_ProductTemplateFile_Thumb varchar(255),
	@IsNull_ProductTemplateFile_Prev varchar(255),
	@Original_ProductTemplateFile_Prev varchar(255)
)
AS
	SET NOCOUNT OFF;
UPDATE [Products] SET [ProductKey] = @ProductKey, [ProductDescription] = @ProductDescription, [PriceCategory] = @PriceCategory, [ProductWidth] = @ProductWidth, [ProductHeight] = @ProductHeight, [ProductTemplateFile] = @ProductTemplateFile, [ProductTypeID] = @ProductTypeID, [ColourFlag] = @ColourFlag, [SKU] = @SKU, [LayoutName] = @LayoutName, [ModifiedDate] = @ModifiedDate, [LayoutFamily] = @LayoutFamily, [ProductTemplateFile_Thumb] = @ProductTemplateFile_Thumb, [ProductTemplateFile_Prev] = @ProductTemplateFile_Prev WHERE (([ProductKey] = @Original_ProductKey) AND ([ProductDescription] = @Original_ProductDescription) AND ([PriceCategory] = @Original_PriceCategory) AND ([ProductWidth] = @Original_ProductWidth) AND ([ProductHeight] = @Original_ProductHeight) AND ([ProductTemplateFile] = @Original_ProductTemplateFile) AND ([ProductTypeID] = @Original_ProductTypeID) AND ([ColourFlag] = @Original_ColourFlag) AND ([SKU] = @Original_SKU) AND ([LayoutName] = @Original_LayoutName) AND ([ModifiedDate] = @Original_ModifiedDate) AND ([LayoutFamily] = @Original_LayoutFamily) AND ((@IsNull_ProductTemplateFile_Thumb = 1 AND [ProductTemplateFile_Thumb] IS NULL) OR ([ProductTemplateFile_Thumb] = @Original_ProductTemplateFile_Thumb)) AND ((@IsNull_ProductTemplateFile_Prev = 1 AND [ProductTemplateFile_Prev] IS NULL) OR ([ProductTemplateFile_Prev] = @Original_ProductTemplateFile_Prev)));
	
SELECT ProductKey, ProductDescription, PriceCategory, ProductWidth, ProductHeight, ProductTemplateFile, ProductTypeID, ColourFlag, SKU, LayoutName, ModifiedDate, LayoutFamily, ProductTemplateFile_Thumb, ProductTemplateFile_Prev FROM Products WHERE (ProductKey = @ProductKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_OrderDetails_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Add a quantity + product to an order.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_OrderDetails_Record]
	@OrderPackageID int, 
	@ProductID int,
	@Quantity smallint,
	@OrderDetailKey int OUTPUT
AS

	-- we''re declaring the datestamp here so that we can use it to retrieve the newly generated orderPackage_Key
	declare @datestamp datetime
	SET @datestamp = getDate()

	INSERT INTO OrderDetails (OrderPackageID, ProductID, Quantity) VALUES (@OrderPackageID, @ProductID, @Quantity)


	SELECT @OrderDetailKey = MAX(OrderDetailKey) FROM OrderDetails WHERE OrderPackageID=@OrderPackageID AND Datestamp = @datestamp

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetails_By_OrderDetailKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <30/07/08>
-- Description:	<get the order details by an order detail key>
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderDetails_By_OrderDetailKey]

	@OrderDetailKey int
AS
BEGIN
	SELECT * FROM OrderDetails WHERE OrderDetailKey = @OrderDetailKey
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderDetails_By_OrderDetail_Key]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Update order details on productid and qty by OrderDetaiKey.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_OrderDetails_By_OrderDetail_Key] 
	@ProductID int,
	@Quantity smallint, 
	@OrderDetailKey int
AS
BEGIN
	UPDATE 
		OrderDetails 
	SET 
		ProductID		= @ProductID, 
		Quantity		= @Quantity 
	WHERE 
		OrderDetailKey	= @OrderDetailKey
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderPackageID_By_OrderDetailKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Get only the OrderPackageID give the OrderDetailID.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderPackageID_By_OrderDetailKey] 
	@OrderDetailID varchar (100)
AS
--test (exec Cab_Get_OrderPackageID_By_OrderDetailKey ''11'')

BEGIN
	SELECT OrderPackageID FROM OrderDetails WHERE OrderDetailKey = @OrderDetailID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderDetailKey_By_OrderPackageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Get the order detail key for an order package id.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_OrderDetailKey_By_OrderPackageID]

@OrderPackageId int

AS

BEGIN
	SELECT OrderDetailKey 
	FROM OrderDetails 
	WHERE OrderPackageID = @orderPackageId

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderPackageQuantity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Updates the quantity in OrderDetails.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_OrderPackageQuantity]
	@NewQuantity int, 
	@OrderPackageId int
AS
-- test (exec Cab_Update_OrderPackageQuantity ''50'', ''34'')
BEGIN
	UPDATE OrderDetails SET Quantity = @NewQuantity WHERE OrderPackageID = @OrderPackageId
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_OrderDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Insert an order detail (Quantity of a product for a given order package).
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Add_OrderDetail] 
	@OrderPackageID int, 
	@ProductID int, 
	@Quantity int
AS
BEGIN
	INSERT INTO OrderDetails (
		OrderPackageID, 
		ProductID, 
		Quantity
		) 
	VALUES (
		@OrderPackageID, 
		@ProductID, 
		@Quantity
	)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderDetailsQuantity_By_OrderDetailKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 25/07/08
-- Description:	update order details quantity by order detail key
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_OrderDetailsQuantity_By_OrderDetailKey]
	@OrderDetailKey int,
	@Quantity numeric(6,2)
AS
	BEGIN
		UPDATE OrderDetails
		SET Quantity = @Quantity 
		WHERE OrderDetailKey = @OrderDetailKey
	END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_ProductDescription_By_ProductID_And_LanguageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 23/07/08
-- Description:	Get product description.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_ProductDescription_By_ProductID_And_LanguageID]
	@ProductKey int,
	@LanguageID int
AS
	SELECT ProductNames_Product_Description
	FROM ProductNames_CabUK
	WHERE ProductNames_Language_Id = @LanguageID
	AND ProductNames_Product_Id = @ProductKey
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductEvents_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductEvents_Select]
	-- Add the parameters for the stored procedure here
    @ProductID int
AS
	SET NOCOUNT ON;
  SELECT ProductEventLinkkey, ProductID, EventTypeID 
  FROM ProductEventLinks
  WHERE ProductID =  @ProductID

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductEvents_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductEvents_Update]
(
	@ProductID int,
	@EventTypeID int,
	@Original_ProductEventLinkkey int,
	@Original_ProductID int,
	@Original_EventTypeID int,
	@ProductEventLinkkey int
)
AS
	SET NOCOUNT OFF;
UPDATE [ProductEventLinks] SET [ProductID] = @ProductID, [EventTypeID] = @EventTypeID WHERE (([ProductEventLinkkey] = @Original_ProductEventLinkkey) AND ([ProductID] = @Original_ProductID) AND ([EventTypeID] = @Original_EventTypeID));
	
SELECT ProductEventLinkkey, ProductID, EventTypeID FROM ProductEventLinks WHERE (ProductEventLinkkey = @ProductEventLinkkey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductEvents_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductEvents_Insert]
(
	@ProductID int,
	@EventTypeID int
)
AS
	SET NOCOUNT OFF;
INSERT INTO [ProductEventLinks] ([ProductID], [EventTypeID]) VALUES (@ProductID, @EventTypeID);
	
SELECT ProductEventLinkkey, ProductID, EventTypeID FROM ProductEventLinks WHERE (ProductEventLinkkey = SCOPE_IDENTITY())
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductEvents_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductEvents_Delete]
(
	@Original_ProductEventLinkkey int,
	@Original_ProductID int,
	@Original_EventTypeID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [ProductEventLinks] WHERE (([ProductEventLinkkey] = @Original_ProductEventLinkkey) AND ([ProductID] = @Original_ProductID) AND ([EventTypeID] = @Original_EventTypeID))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductEventLinks_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 02/09/2008
-- Description:	Select  ProductEventLinks for a ProductID
-- =============================================
CREATE PROCEDURE [dbo].[HSP_ProductEventLinks_Select]
	-- Add the parameters for the stored procedure here
    @ProductID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	   SELECT ProductEventLinkkey, ProductID, EventTypeID 
       FROM ProductEventLinks WHERE ProductID = @ProductID  
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UniquePassengerIDs_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_UniquePassengerIDs_Delete]
(
	@Original_UniquePassengerKey int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[UniquePassengerIDs] WHERE (([UniquePassengerKey] = @Original_UniquePassengerKey) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UniquePassengerIDs_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_UniquePassengerIDs_Select]
AS
	SET NOCOUNT ON;
SELECT UniquePassengerKey, CreatedDate, ModifiedDate FROM dbo.UniquePassengerIDs
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UniquePassengerIDs_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_UniquePassengerIDs_Insert]
(
	@UniquePassengerKey int,
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[UniquePassengerIDs] ([UniquePassengerKey], [CreatedDate], [ModifiedDate]) VALUES (@UniquePassengerKey, @CreatedDate, @ModifiedDate);
	
SELECT UniquePassengerKey, CreatedDate, ModifiedDate FROM UniquePassengerIDs WHERE (UniquePassengerKey = @UniquePassengerKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_UniquePassengerIDs_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_UniquePassengerIDs_Update]
(
	@UniquePassengerKey int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_UniquePassengerKey int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[UniquePassengerIDs] SET [UniquePassengerKey] = @UniquePassengerKey, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([UniquePassengerKey] = @Original_UniquePassengerKey) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT UniquePassengerKey, CreatedDate, ModifiedDate FROM UniquePassengerIDs WHERE (UniquePassengerKey = @UniquePassengerKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductImageItem_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductImageItem_Insert]
(
	@ProductID int,
	@ImageItemType int,
	@ItemNumber int,
	@ImageLeft float,
	@ImageTop float,
	@ImageWidth float,
	@ImageHeight float
)
AS
	SET NOCOUNT OFF;
INSERT INTO [ProductImageItem] ([ProductID], [ImageItemType], [ItemNumber], [ImageLeft], [ImageTop], [ImageWidth], [ImageHeight]) VALUES (@ProductID, @ImageItemType, @ItemNumber, @ImageLeft, @ImageTop, @ImageWidth, @ImageHeight);
	
SELECT ImageItemKey, ProductID, ImageItemType, ItemNumber, ImageLeft, ImageTop, ImageWidth, ImageHeight FROM ProductImageItem WHERE (ImageItemKey = SCOPE_IDENTITY())
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductImageItem_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductImageItem_Delete]
(
	@Original_ImageItemKey int,
	@Original_ProductID int,
	@Original_ImageItemType int,
	@Original_ItemNumber int,
	@Original_ImageLeft float,
	@Original_ImageTop float,
	@Original_ImageWidth float,
	@Original_ImageHeight float
)
AS
	SET NOCOUNT OFF;
DELETE FROM [ProductImageItem] WHERE (([ImageItemKey] = @Original_ImageItemKey) AND ([ProductID] = @Original_ProductID) AND ([ImageItemType] = @Original_ImageItemType) AND ([ItemNumber] = @Original_ItemNumber) AND ([ImageLeft] = @Original_ImageLeft) AND ([ImageTop] = @Original_ImageTop) AND ([ImageWidth] = @Original_ImageWidth) AND ([ImageHeight] = @Original_ImageHeight))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductImageItem_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductImageItem_Update]
(
	@ProductID int,
	@ImageItemType int,
	@ItemNumber int,
	@ImageLeft float,
	@ImageTop float,
	@ImageWidth float,
	@ImageHeight float,
	@Original_ImageItemKey int,
	@Original_ProductID int,
	@Original_ImageItemType int,
	@Original_ItemNumber int,
	@Original_ImageLeft float,
	@Original_ImageTop float,
	@Original_ImageWidth float,
	@Original_ImageHeight float,
	@ImageItemKey int
)
AS
	SET NOCOUNT OFF;
UPDATE [ProductImageItem] SET [ProductID] = @ProductID, [ImageItemType] = @ImageItemType, [ItemNumber] = @ItemNumber, [ImageLeft] = @ImageLeft, [ImageTop] = @ImageTop, [ImageWidth] = @ImageWidth, [ImageHeight] = @ImageHeight WHERE (([ImageItemKey] = @Original_ImageItemKey) AND ([ProductID] = @Original_ProductID) AND ([ImageItemType] = @Original_ImageItemType) AND ([ItemNumber] = @Original_ItemNumber) AND ([ImageLeft] = @Original_ImageLeft) AND ([ImageTop] = @Original_ImageTop) AND ([ImageWidth] = @Original_ImageWidth) AND ([ImageHeight] = @Original_ImageHeight));
	
SELECT ImageItemKey, ProductID, ImageItemType, ItemNumber, ImageLeft, ImageTop, ImageWidth, ImageHeight FROM ProductImageItem WHERE (ImageItemKey = @ImageItemKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Template_Image_Details_For_ProductID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 21/07/2008
-- Description:	Get ImageItemType and ItemNumber for a product.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Template_Image_Details_For_ProductID]
	@ProductID int
AS
SELECT ImageItemType, ItemNumber
FROM ProductImageItem
WHERE ProductID = @ProductID


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductImageItems_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 02/09/2008
-- Description:	Select ProductImageItems for Update
-- =============================================
Create PROCEDURE  [dbo].[HSP_ProductImageItems_Select]
	-- Add the parameters for the stored procedure here
	@ProductID int 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT ON;

   SELECT ImageItemKey, ProductID, ImageItemType, ItemNumber, 
   ImageLeft, ImageTop, ImageWidth, ImageHeight  
   FROM ProductImageItem WHERE ProductID =  @ProductID

END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductImageItem_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductImageItem_Select]
	-- Add the parameters for the stored procedure here
    @ProductID int
AS
	SET NOCOUNT ON;
SELECT ImageItemKey, ProductID, ImageItemType, ItemNumber, 
 ImageLeft, ImageTop, ImageWidth, ImageHeight 
 FROM ProductImageItem
 WHERE ProductID =  @ProductID
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_Manifest_By_PaxId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 16/07/08
-- Description:	Update any field of the manifest table by PaxId.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_Manifest_By_PaxId]
	-- Add the parameters for the stored procedure here
	@PaxID nvarchar(25),
    @FolioNumber nvarchar(30),
    @PassengerName nvarchar(50),
    @Cabin nvarchar(15),
    @UniquePassengerID int,
    @OriginalPassengerID int,
    @GuestStatus char(1),
    @Gender char(1),
    @NativeLanguage nvarchar(3),
    @PassportNation nvarchar(3),
    @GroupID nvarchar(20),
    @GroupSubNum nvarchar(20),
    @StewardSection nvarchar(20),
    @LoyaltyTier nvarchar(10),
    @EmbarkationDate datetime,
    @EmbarkationPort nvarchar(10),
    @DebarkationDate datetime,
    @DebarkationPort nvarchar(10),
    @DiningTable nvarchar(8),
    @DiningRoom nvarchar(25),
    @Sitting nvarchar(8),
    @LoyaltyID nvarchar(20),
    @CreatedDate datetime,
    @ModifiedDate datetime
AS
BEGIN
	UPDATE dbo.Manifest
	SET	   PaxID					= @PaxID,
           FolioNumber				= @FolioNumber,
           PassengerName			= @PassengerName,
           Cabin					= @Cabin,
           UniquePassengerID		= @UniquePassengerID,
           OriginalPassengerID		= @OriginalPassengerID,
           GuestStatus				= @GuestStatus,
           Gender					= @Gender,
           NativeLanguage			= @NativeLanguage,
           PassportNation			= @PassportNation,
           GroupID					= @GroupID,
           GroupSubNum				= @GroupSubNum,
           StewardSection			= @StewardSection,
           LoyaltyTier				= @LoyaltyTier,	
           EmbarkationDate			= @EmbarkationDate,
           EmbarkationPort			= @EmbarkationPort,
           DebarkationDate			= @DebarkationDate,
           DebarkationPort			= @DebarkationPort,
           DiningTable				= @DiningTable,
           DiningRoom				= @DiningRoom,
           Sitting					= @Sitting,
           LoyaltyID				= @LoyaltyID,	
           CreatedDate				= @CreatedDate,
           ModifiedDate				= @ModifiedDate
			
 WHERE 
	PaxID = @PaxID
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_Into_Manifest_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Insert a new manifest into the database.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_Into_Manifest_Record]	
		   @PaxID nvarchar(25),
           @FolioNumber nvarchar(30),
           @PassengerName nvarchar(50),
           @Cabin nvarchar(15),
           @UniquePassengerID int,
           @OriginalPassengerID int,
           @GuestStatus char(1),
           @Gender char(1),
           @NativeLanguage nvarchar(3),
           @PassportNation nvarchar(3),
           @GroupID nvarchar(20),
           @GroupSubNum nvarchar(20),
           @StewardSection nvarchar(20),
           @LoyaltyTier nvarchar(10),
           @EmbarkationDate datetime,
           @EmbarkationPort nvarchar(10),
           @DebarkationDate datetime,
           @DebarkationPort nvarchar(10),
           @DiningTable nvarchar(8),
           @DiningRoom nvarchar(25),
           @Sitting nvarchar(8),
           @LoyaltyID nvarchar(20),
           @CreatedDate datetime,
           @ModifiedDate datetime

AS
BEGIN
	INSERT INTO dbo.Manifest 
           (
			ManifestKey
           ,PaxID
           ,FolioNumber
           ,PassengerName
           ,Cabin
           ,UniquePassengerID
           ,OriginalPassengerID
           ,GuestStatus
           ,Gender
           ,NativeLanguage
           ,PassportNation
           ,GroupID
           ,GroupSubNum
           ,StewardSection
           ,LoyaltyTier
           ,EmbarkationDate
           ,EmbarkationPort
           ,DebarkationDate
           ,DebarkationPort
           ,DiningTable
           ,DiningRoom
           ,Sitting
           ,LoyaltyID
           ,CreatedDate
           ,ModifiedDate
			)
     VALUES
           (
			NULL
           ,@PaxID
           ,@FolioNumber
           ,@PassengerName
           ,@Cabin
           ,@UniquePassengerID
           ,@OriginalPassengerID
           ,@GuestStatus
           ,@Gender
           ,@NativeLanguage
           ,@PassportNation
           ,@GroupID
           ,@GroupSubNum
           ,@StewardSection
           ,@LoyaltyTier
           ,@EmbarkationDate
           ,@EmbarkationPort
           ,@DebarkationDate
           ,@DebarkationPort
           ,@DiningTable
           ,@DiningRoom
           ,@Sitting
           ,@LoyaltyID
           ,@CreatedDate
           ,@ModifiedDate
			)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Manifest_By_Passenger_And_Cabin_Count]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Get the count for passenger by PaxID and cabinnumber
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Manifest_By_Passenger_And_Cabin_Count]
	@UniquePassengerID varchar(20), 
	@Cabin varchar(20)
AS
-- test (exec Cab_Get_Manifest_By_PaxID_And_Cabin_Count ''001417922'', ''6132'')
BEGIN
	SELECT count(*) FROM Manifest WHERE UniquePassengerID = @UniquePassengerID AND Cabin = @Cabin
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Manifest_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Manifest_Select]
AS
	SET NOCOUNT ON;
SELECT Cabin, Passengername, GuestStatus, Gender, NativeLanguage, PassportNation, GroupID, GroupSubNum, StewardSection, LoyaltyTier, EmbarkationDate, EmbarkationPort, DebarkationDate, DebarkationPort, DiningTable, DiningRoom, Sitting, LoyaltyID, UniquePassengerID, OriginalPassengerID, CreatedDate, ModifiedDate, FolioNumber, PaxID, ManifestKey FROM dbo.Manifest
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Manifest_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Manifest_Update]
(
	@Cabin nvarchar(15),
	@Passengername nvarchar(50),
	@GuestStatus char(1),
	@Gender char(1),
	@NativeLanguage nvarchar(3),
	@PassportNation nvarchar(3),
	@GroupID nvarchar(20),
	@GroupSubNum nvarchar(20),
	@StewardSection nvarchar(20),
	@LoyaltyTier nvarchar(10),
	@EmbarkationDate datetime,
	@EmbarkationPort nvarchar(10),
	@DebarkationDate datetime,
	@DebarkationPort nvarchar(10),
	@DiningTable nvarchar(8),
	@DiningRoom nvarchar(25),
	@Sitting nvarchar(8),
	@LoyaltyID nvarchar(20),
	@UniquePassengerID int,
	@OriginalPassengerID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@FolioNumber nvarchar(30),
	@PaxID nvarchar(25),
	@ManifestKey int,
	@Original_Cabin nvarchar(15),
	@Original_Passengername nvarchar(50),
	@Original_GuestStatus char(1),
	@Original_Gender char(1),
	@Original_NativeLanguage nvarchar(3),
	@Original_PassportNation nvarchar(3),
	@Original_GroupID nvarchar(20),
	@Original_GroupSubNum nvarchar(20),
	@Original_StewardSection nvarchar(20),
	@Original_LoyaltyTier nvarchar(10),
	@IsNull_EmbarkationDate datetime,
	@Original_EmbarkationDate datetime,
	@Original_EmbarkationPort nvarchar(10),
	@IsNull_DebarkationDate datetime,
	@Original_DebarkationDate datetime,
	@Original_DebarkationPort nvarchar(10),
	@Original_DiningTable nvarchar(8),
	@Original_DiningRoom nvarchar(25),
	@Original_Sitting nvarchar(8),
	@Original_LoyaltyID nvarchar(20),
	@Original_UniquePassengerID int,
	@Original_OriginalPassengerID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@Original_FolioNumber nvarchar(30),
	@Original_PaxID nvarchar(25),
	@Original_ManifestKey int
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[Manifest] SET [Cabin] = @Cabin, [Passengername] = @Passengername, [GuestStatus] = @GuestStatus, [Gender] = @Gender, [NativeLanguage] = @NativeLanguage, [PassportNation] = @PassportNation, [GroupID] = @GroupID, [GroupSubNum] = @GroupSubNum, [StewardSection] = @StewardSection, [LoyaltyTier] = @LoyaltyTier, [EmbarkationDate] = @EmbarkationDate, [EmbarkationPort] = @EmbarkationPort, [DebarkationDate] = @DebarkationDate, [DebarkationPort] = @DebarkationPort, [DiningTable] = @DiningTable, [DiningRoom] = @DiningRoom, [Sitting] = @Sitting, [LoyaltyID] = @LoyaltyID, [UniquePassengerID] = @UniquePassengerID, [OriginalPassengerID] = @OriginalPassengerID, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate, [FolioNumber] = @FolioNumber, [PaxID] = @PaxID, [ManifestKey] = @ManifestKey WHERE (([Cabin] = @Original_Cabin) AND ([Passengername] = @Original_Passengername) AND ([GuestStatus] = @Original_GuestStatus) AND ([Gender] = @Original_Gender) AND ([NativeLanguage] = @Original_NativeLanguage) AND ([PassportNation] = @Original_PassportNation) AND ([GroupID] = @Original_GroupID) AND ([GroupSubNum] = @Original_GroupSubNum) AND ([StewardSection] = @Original_StewardSection) AND ([LoyaltyTier] = @Original_LoyaltyTier) AND ((@IsNull_EmbarkationDate = 1 AND [EmbarkationDate] IS NULL) OR ([EmbarkationDate] = @Original_EmbarkationDate)) AND ([EmbarkationPort] = @Original_EmbarkationPort) AND ((@IsNull_DebarkationDate = 1 AND [DebarkationDate] IS NULL) OR ([DebarkationDate] = @Original_DebarkationDate)) AND ([DebarkationPort] = @Original_DebarkationPort) AND ([DiningTable] = @Original_DiningTable) AND ([DiningRoom] = @Original_DiningRoom) AND ([Sitting] = @Original_Sitting) AND ([LoyaltyID] = @Original_LoyaltyID) AND ([UniquePassengerID] = @Original_UniquePassengerID) AND ([OriginalPassengerID] = @Original_OriginalPassengerID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ([FolioNumber] = @Original_FolioNumber) AND ([PaxID] = @Original_PaxID) AND ([ManifestKey] = @Original_ManifestKey));
	
SELECT Cabin, PassengerName, GuestStatus, Gender, NativeLanguage, PassportNation, GroupID, GroupSubNum, StewardSection, LoyaltyTier, EmbarkationDate, EmbarkationPort, DebarkationDate, DebarkationPort, DiningTable, DiningRoom, Sitting, LoyaltyID, UniquePassengerID, OriginalPassengerID, CreatedDate, ModifiedDate, FolioNumber, PaxID, ManifestKey FROM Manifest WHERE (ManifestKey = @ManifestKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Manifest_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Manifest_Insert]
(
	@Cabin nvarchar(15),
	@Passengername nvarchar(50),
	@GuestStatus char(1),
	@Gender char(1),
	@NativeLanguage nvarchar(3),
	@PassportNation nvarchar(3),
	@GroupID nvarchar(20),
	@GroupSubNum nvarchar(20),
	@StewardSection nvarchar(20),
	@LoyaltyTier nvarchar(10),
	@EmbarkationDate datetime,
	@EmbarkationPort nvarchar(10),
	@DebarkationDate datetime,
	@DebarkationPort nvarchar(10),
	@DiningTable nvarchar(8),
	@DiningRoom nvarchar(25),
	@Sitting nvarchar(8),
	@LoyaltyID nvarchar(20),
	@UniquePassengerID int,
	@OriginalPassengerID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@FolioNumber nvarchar(30),
	@PaxID nvarchar(25),
	@ManifestKey int
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Manifest] ([Cabin], [Passengername], [GuestStatus], [Gender], [NativeLanguage], [PassportNation], [GroupID], [GroupSubNum], [StewardSection], [LoyaltyTier], [EmbarkationDate], [EmbarkationPort], [DebarkationDate], [DebarkationPort], [DiningTable], [DiningRoom], [Sitting], [LoyaltyID], [UniquePassengerID], [OriginalPassengerID], [CreatedDate], [ModifiedDate], [FolioNumber], [PaxID], [ManifestKey]) VALUES (@Cabin, @Passengername, @GuestStatus, @Gender, @NativeLanguage, @PassportNation, @GroupID, @GroupSubNum, @StewardSection, @LoyaltyTier, @EmbarkationDate, @EmbarkationPort, @DebarkationDate, @DebarkationPort, @DiningTable, @DiningRoom, @Sitting, @LoyaltyID, @UniquePassengerID, @OriginalPassengerID, @CreatedDate, @ModifiedDate, @FolioNumber, @PaxID, @ManifestKey);
	
SELECT Cabin, PassengerName, GuestStatus, Gender, NativeLanguage, PassportNation, GroupID, GroupSubNum, StewardSection, LoyaltyTier, EmbarkationDate, EmbarkationPort, DebarkationDate, DebarkationPort, DiningTable, DiningRoom, Sitting, LoyaltyID, UniquePassengerID, OriginalPassengerID, CreatedDate, ModifiedDate, FolioNumber, PaxID, ManifestKey FROM Manifest WHERE (ManifestKey = @ManifestKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Manifest_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_Manifest_Delete]
(
	@Original_Cabin nvarchar(15),
	@Original_Passengername nvarchar(50),
	@Original_GuestStatus char(1),
	@Original_Gender char(1),
	@Original_NativeLanguage nvarchar(3),
	@Original_PassportNation nvarchar(3),
	@Original_GroupID nvarchar(20),
	@Original_GroupSubNum nvarchar(20),
	@Original_StewardSection nvarchar(20),
	@Original_LoyaltyTier nvarchar(10),
	@IsNull_EmbarkationDate datetime,
	@Original_EmbarkationDate datetime,
	@Original_EmbarkationPort nvarchar(10),
	@IsNull_DebarkationDate datetime,
	@Original_DebarkationDate datetime,
	@Original_DebarkationPort nvarchar(10),
	@Original_DiningTable nvarchar(8),
	@Original_DiningRoom nvarchar(25),
	@Original_Sitting nvarchar(8),
	@Original_LoyaltyID nvarchar(20),
	@Original_UniquePassengerID int,
	@Original_OriginalPassengerID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@Original_FolioNumber nvarchar(30),
	@Original_PaxID nvarchar(25),
	@Original_ManifestKey int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[Manifest] WHERE (([Cabin] = @Original_Cabin) AND ([Passengername] = @Original_Passengername) AND ([GuestStatus] = @Original_GuestStatus) AND ([Gender] = @Original_Gender) AND ([NativeLanguage] = @Original_NativeLanguage) AND ([PassportNation] = @Original_PassportNation) AND ([GroupID] = @Original_GroupID) AND ([GroupSubNum] = @Original_GroupSubNum) AND ([StewardSection] = @Original_StewardSection) AND ([LoyaltyTier] = @Original_LoyaltyTier) AND ((@IsNull_EmbarkationDate = 1 AND [EmbarkationDate] IS NULL) OR ([EmbarkationDate] = @Original_EmbarkationDate)) AND ([EmbarkationPort] = @Original_EmbarkationPort) AND ((@IsNull_DebarkationDate = 1 AND [DebarkationDate] IS NULL) OR ([DebarkationDate] = @Original_DebarkationDate)) AND ([DebarkationPort] = @Original_DebarkationPort) AND ([DiningTable] = @Original_DiningTable) AND ([DiningRoom] = @Original_DiningRoom) AND ([Sitting] = @Original_Sitting) AND ([LoyaltyID] = @Original_LoyaltyID) AND ([UniquePassengerID] = @Original_UniquePassengerID) AND ([OriginalPassengerID] = @Original_OriginalPassengerID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ([FolioNumber] = @Original_FolioNumber) AND ([PaxID] = @Original_PaxID) AND ([ManifestKey] = @Original_ManifestKey))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductTextItem_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductTextItem_Insert]
(
	@ProductID int,
	@ItemNumber int,
	@DefaultText nvarchar(100),
	@Font nvarchar(50),
	@FontSize float,
	@FontStyle int,
	@FontColour int,
	@TextLeft float,
	@TextTop float,
	@TextWidth float,
	@TextHeight float,
	@TextRotate int,
	@TextAlign int,
	@Editable smallint
)
AS
	SET NOCOUNT OFF;
INSERT INTO [ProductTextItem] ([ProductID], [ItemNumber], [DefaultText], [Font], [FontSize], [FontStyle], [FontColour], [TextLeft], [TextTop], [TextWidth], [TextHeight], [TextRotate], [TextAlign], [Editable]) VALUES (@ProductID, @ItemNumber, @DefaultText, @Font, @FontSize, @FontStyle, @FontColour, @TextLeft, @TextTop, @TextWidth, @TextHeight, @TextRotate, @TextAlign, @Editable);
	
SELECT TextItemKey, ProductID, ItemNumber, DefaultText, Font, FontSize, FontStyle, FontColour, TextLeft, TextTop, TextWidth, TextHeight, TextRotate, TextAlign, Editable FROM ProductTextItem WHERE (TextItemKey = SCOPE_IDENTITY())
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_TextItemKey_For_ProductID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		CabinetUK
-- Create date: 21/07/2008
-- Description:	Get TextItemKey for a given product id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_TextItemKey_For_ProductID]
	@ProductID int,
	@Editable int = 1
AS
BEGIN
	SELECT TextItemKey
	FROM ProductTextItem
	WHERE ProductID = @ProductID
	AND Editable = @Editable
END




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductTextItem_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		RBP
-- Create date: 02/09/2008
-- Description:	Select ProductTxtItem for a ProductID
-- =============================================
CREATE PROCEDURE [dbo].[HSP_ProductTextItem_Select]
	-- Add the parameters for the stored procedure here
    @ProductID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	   SELECT TextItemKey, ProductID, ItemNumber, DefaultText,
       Font, FontSize, FontStyle, FontColour, TextLeft, TextTop,  
       TextWidth, TextHeight, TextRotate, TextAlign, Editable 
       FROM ProductTextItem WHERE ProductID =  @ProductID

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Template_Text_Details_For_ProductID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get template text details for a product.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Template_Text_Details_For_ProductID]
	@ProductID int
AS
SELECT DefaultText, Font, FontSize, FontStyle, FontColour, TextLeft, TextTop, TextWidth,
	   TextHeight, TextRotate, TextAlign, Editable, ItemNumber
FROM ProductTextItem
WHERE ProductID = @ProductID
ORDER BY ItemNumber
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductTextItem_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductTextItem_Update]
(
	@ProductID int,
	@ItemNumber int,
	@DefaultText nvarchar(100),
	@Font nvarchar(50),
	@FontSize float,
	@FontStyle int,
	@FontColour int,
	@TextLeft float,
	@TextTop float,
	@TextWidth float,
	@TextHeight float,
	@TextRotate int,
	@TextAlign int,
	@Editable smallint,
	@Original_TextItemKey int,
	@Original_ProductID int,
	@Original_ItemNumber int,
	@Original_DefaultText nvarchar(100),
	@Original_Font nvarchar(50),
	@Original_FontSize float,
	@Original_FontStyle int,
	@Original_FontColour int,
	@Original_TextLeft float,
	@Original_TextTop float,
	@Original_TextWidth float,
	@Original_TextHeight float,
	@Original_TextRotate int,
	@Original_TextAlign int,
	@Original_Editable smallint,
	@TextItemKey int
)
AS
	SET NOCOUNT OFF;
UPDATE [ProductTextItem] SET [ProductID] = @ProductID, [ItemNumber] = @ItemNumber, [DefaultText] = @DefaultText, [Font] = @Font, [FontSize] = @FontSize, [FontStyle] = @FontStyle, [FontColour] = @FontColour, [TextLeft] = @TextLeft, [TextTop] = @TextTop, [TextWidth] = @TextWidth, [TextHeight] = @TextHeight, [TextRotate] = @TextRotate, [TextAlign] = @TextAlign, [Editable] = @Editable WHERE (([TextItemKey] = @Original_TextItemKey) AND ([ProductID] = @Original_ProductID) AND ([ItemNumber] = @Original_ItemNumber) AND ([DefaultText] = @Original_DefaultText) AND ([Font] = @Original_Font) AND ([FontSize] = @Original_FontSize) AND ([FontStyle] = @Original_FontStyle) AND ([FontColour] = @Original_FontColour) AND ([TextLeft] = @Original_TextLeft) AND ([TextTop] = @Original_TextTop) AND ([TextWidth] = @Original_TextWidth) AND ([TextHeight] = @Original_TextHeight) AND ([TextRotate] = @Original_TextRotate) AND ([TextAlign] = @Original_TextAlign) AND ([Editable] = @Original_Editable));
	
SELECT TextItemKey, ProductID, ItemNumber, DefaultText, Font, FontSize, FontStyle, FontColour, TextLeft, TextTop, TextWidth, TextHeight, TextRotate, TextAlign, Editable FROM ProductTextItem WHERE (TextItemKey = @TextItemKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ProductTextItem_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ProductTextItem_Delete]
(
	@Original_TextItemKey int,
	@Original_ProductID int,
	@Original_ItemNumber int,
	@Original_DefaultText nvarchar(100),
	@Original_Font nvarchar(50),
	@Original_FontSize float,
	@Original_FontStyle int,
	@Original_FontColour int,
	@Original_TextLeft float,
	@Original_TextTop float,
	@Original_TextWidth float,
	@Original_TextHeight float,
	@Original_TextRotate int,
	@Original_TextAlign int,
	@Original_Editable smallint
)
AS
	SET NOCOUNT OFF;
DELETE FROM [ProductTextItem] WHERE (([TextItemKey] = @Original_TextItemKey) AND ([ProductID] = @Original_ProductID) AND ([ItemNumber] = @Original_ItemNumber) AND ([DefaultText] = @Original_DefaultText) AND ([Font] = @Original_Font) AND ([FontSize] = @Original_FontSize) AND ([FontStyle] = @Original_FontStyle) AND ([FontColour] = @Original_FontColour) AND ([TextLeft] = @Original_TextLeft) AND ([TextTop] = @Original_TextTop) AND ([TextWidth] = @Original_TextWidth) AND ([TextHeight] = @Original_TextHeight) AND ([TextRotate] = @Original_TextRotate) AND ([TextAlign] = @Original_TextAlign) AND ([Editable] = @Original_Editable))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Promotion_By_PCruiseID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description: Get the promotion voucher discount for a promotion cruise id.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Promotion_By_PCruiseID]
	@Promotions_Cruise_ID int
AS
BEGIN
	SELECT Promotions_Voucher_Discount
	FROM Promotions_CabUK
	WHERE Promotions_Status=''1''
	AND Promotions_Cruise_ID = @Promotions_Cruise_ID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_VoucherDiscount_For_PromotionsID_And_PromotionDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get voucher discount for a promotion.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_VoucherDiscount_For_PromotionsID_And_PromotionDate]
	@PromotionID int,
	@Date nvarchar(50)
AS
	SELECT Promotions_Voucher_Discount
	FROM Promotions_CabUK
	WHERE Promotions_Id = @PromotionID
	AND @Date >= Promotions_Start_Date
	AND @Date <= Promotions_End_Date
	AND Promotions_Status=''1''

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Promotion_By_VCode_And_VCruiseID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Get the percentage saving for the given voucher.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Promotion_By_VCode_And_VCruiseID] 
	@Promotions_Vouchers_Code varchar (100),
	@Promotions_Vouchers_Cruise_Id int
	
AS
BEGIN
	SELECT Promotions_Voucher_Discount 
	FROM Promotions_CabUK 
	JOIN Promotions_Vouchers_CabUK ON Promotions_Vouchers_Promotion_Id=Promotions_Id 
	WHERE Promotions_Vouchers_Code = @Promotions_Vouchers_Code 
	AND Promotions_Vouchers_Cruise_Id = @Promotions_Vouchers_Cruise_Id

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_OrderImageItem_By_OrderDetailID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <04/07/08>
-- Description:	<delete order details by order detail id>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Delete_OrderImageItem_By_OrderDetailID]

	@OrderDetailID INT

AS


IF EXISTS (SELECT * FROM OrderImageItem
		   WHERE OrderDetailID = @OrderDetailID)
	

	BEGIN
		DELETE FROM OrderImageItem WHERE OrderDetailID = @OrderDetailID
	END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderImageItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 24/07/08
-- Description:	Update an order image item.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Update_OrderImageItem]
	@ImageItemType int, 
	@ItemNumber int,
	@CropTop float,
	@CropLeft float, 
	@CropHeight float, 
	@CropWidth float, 
	@BulkImageID int, 
	@OrderDetailID int
AS
BEGIN
	UPDATE OrderImageItem 
	SET
		ImageItemType	= @ImageItemType, 
		ItemNumber		= @ItemNumber, 
		CropTop			= @CropTop, 
		CropLeft		= @CropLeft,
		CropHeight		= @CropHeight, 
		CropWidth		= @CropWidth, 
		BulkImageID		= @BulkImageID
	WHERE 
		OrderDetailID	= @OrderDetailID 
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_OrderImageItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		CabinetUK
-- Create date: 26/06/2008
-- Description:	Get a record from the order image item table.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_OrderImageItem] 
	@orderDetailKey int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT BulkImageID, CropLeft, CropTop, CropWidth, CropHeight 
	FROM OrderImageItem 
	WHERE OrderDetailID = @orderDetailKey
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_OrderImageItem_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Add an image to an order.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_OrderImageItem_Record]
	@OrderDetailID int, 
	@cropTop float,
	@cropLeft float,
	@cropHeight float,
	@cropWidth float,
	@bulkImageID int,
	@ImageItemType int =1,
	@ItemNumber int =1
AS
	INSERT INTO OrderImageItem (OrderDetailID, ImageItemType, ItemNumber, CropTop, CropLeft, CropHeight, CropWidth, BulkImageID) 
	VALUES (@OrderDetailID, @ImageItemType,@ItemNumber, @cropTop, @cropLeft, @cropHeight,@cropWidth, @bulkImageID)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_OrderImageItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 24/07/08
-- Description:	Inserts a new OrderImageItem.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Add_OrderImageItem] 
	@OrderDetailID int,
	@ImageItemType int,
	@ItemNumber int,
	@CropTop float,
	@CropLeft float,
	@CropHeight float,
	@CropWidth float,
	@BulkImageID int
AS
BEGIN
	INSERT INTO OrderImageItem (
		OrderDetailID, ImageItemType, ItemNumber, CropTop, CropLeft, CropHeight, CropWidth, BulkImageID
	) VALUES (
		@OrderDetailID, @ImageItemType,	@ItemNumber, @CropTop, @CropLeft, @CropHeight, @CropWidth, @BulkImageID
	)
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PassengerSegmentLinks_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PassengerSegmentLinks_Update]
(
	@VoyageSegmentID int,
	@ManifestID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Counter numeric(18, 0),
	@Original_VoyageSegmentID int,
	@Original_ManifestID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@Original_Counter numeric(18, 0)
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[PassengerSegmentLinks] SET [VoyageSegmentID] = @VoyageSegmentID, [ManifestID] = @ManifestID, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate, [Counter] = @Counter WHERE (([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([ManifestID] = @Original_ManifestID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ([Counter] = @Original_Counter));
	
SELECT VoyageSegmentID, ManifestID, CreatedDate, ModifiedDate, Counter FROM PassengerSegmentLinks WHERE (ManifestID = @ManifestID) AND (VoyageSegmentID = @VoyageSegmentID)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PassengerSegmentLinks_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PassengerSegmentLinks_Insert]
(
	@VoyageSegmentID int,
	@ManifestID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Counter numeric(18, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[PassengerSegmentLinks] ([VoyageSegmentID], [ManifestID], [CreatedDate], [ModifiedDate], [Counter]) VALUES (@VoyageSegmentID, @ManifestID, @CreatedDate, @ModifiedDate, @Counter);
	
SELECT VoyageSegmentID, ManifestID, CreatedDate, ModifiedDate, Counter FROM PassengerSegmentLinks WHERE (ManifestID = @ManifestID) AND (VoyageSegmentID = @VoyageSegmentID)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PassengerSegmentLinks_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PassengerSegmentLinks_Select]
AS
	SET NOCOUNT ON;
SELECT VoyageSegmentID, ManifestID, CreatedDate, ModifiedDate, Counter FROM dbo.PassengerSegmentLinks
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PassengerSegmentLinks_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PassengerSegmentLinks_Delete]
(
	@Original_VoyageSegmentID int,
	@Original_ManifestID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@Original_Counter numeric(18, 0)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[PassengerSegmentLinks] WHERE (([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([ManifestID] = @Original_ManifestID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ([Counter] = @Original_Counter))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PassengerSegmentLinksByPrimaryKey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_PassengerSegmentLinksByPrimaryKey]
(
	@manifestID int,
	@VoyageSegmentID int
)
AS
	SET NOCOUNT ON;
SELECT VoyageSegmentID, ManifestID, CreatedDate, ModifiedDate, Counter FROM dbo.PassengerSegmentLinks
WHERE manifestID = @manifestID AND VoyageSegmentID = @VoyageSegmentID
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_OrderTextItem_By_OrderDetailID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <04/07/08>
-- Description:	<delete order text item by order detail id>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Delete_OrderTextItem_By_OrderDetailID]

	@OrderDetailID INT

AS


IF EXISTS (SELECT * FROM OrderTextItem
		   WHERE OrderDetailID = @OrderDetailID)
	

	BEGIN
		DELETE FROM OrderTextItem WHERE OrderDetailID = @OrderDetailID
	END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_OrderTextItem_Record]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Add text details for an order.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Insert_OrderTextItem_Record]
	@OrderDetailID int,
	@ItemNumber int, 
	@Text nvarchar (255), 
	@Font nvarchar (50), 
	@FontSize smallint, 
	@FontColour int,
	@FontStyle int
AS
	INSERT INTO OrderTextItem (OrderDetailID, ItemNumber, Text, Font, FontSize, FontColour, FontStyle) 
	VALUES (@OrderDetailID, @ItemNumber, @Text, @Font,@FontSize, @FontColour,@FontStyle)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Template_Text_Details_For_OrderDetailID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [dbo].[Cab_Get_Template_Text_Details_For_OrderDetailID]
	@OrderDetailID int
AS
	SELECT Text, Font, FontSize, FontColour, FontStyle
	FROM OrderTextItem
	WHERE OrderDetailID = @OrderDetailID
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_OrderTextItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 24/07/08
-- Description:	Inserts a new OrderTextItem.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Add_OrderTextItem]
	@OrderDetailID int, 
	@ItemNumber int, 
	@Text varchar (100), 
	@Font varchar (100), 
	@FontSize int, 
	@FontColour varchar(100), 
	@FontStyle varchar(100)
AS
BEGIN
	INSERT INTO OrderTextItem (
			OrderDetailID, 
			ItemNumber, 
			Text, 
			Font, 
			FontSize, 
			FontColour, 
			FontStyle
		) VALUES (
			@OrderDetailID, 
			@ItemNumber, 
			@Text, 
			@Font, 
			@FontSize, 
			@FontColour, 
			@FontStyle
		)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Set_PromotionVoucherStatus_By_PromotionVoucherID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 21/07/08
-- Description:	Set a voucher to used.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Set_PromotionVoucherStatus_By_PromotionVoucherID]
	@PromotionVoucherID int,
	@Status int = 1
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE Promotions_Vouchers_CabUK
	SET Promotions_Vouchers_Status = @Status
	WHERE Promotions_Vouchers_Id = @PromotionVoucherID
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Voucher_By_VCruiseID_And_VCode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK - Rodrigo
-- Create date: 25/07/08
-- Description:	Check for a valid voucher code.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_Voucher_By_VCruiseID_And_VCode] 
	@Promotions_Vouchers_Cruise_Id int,
	@Promotions_Vouchers_Code varchar(100)
AS
BEGIN
	SELECT Promotions_Vouchers_Promotion_Id, Promotions_Vouchers_Id
	FROM Promotions_Vouchers_CabUK
	WHERE Promotions_Vouchers_Cruise_Id = @Promotions_Vouchers_Cruise_Id
	AND Promotions_Vouchers_Code = @Promotions_Vouchers_Code
	AND Promotions_Vouchers_Status = 0
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_VouchersPromotionDetails_For_CruiseID_And_VouchersCode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Get vouchers promotion details for a voucher code (and a cruise Id).
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Get_VouchersPromotionDetails_For_CruiseID_And_VouchersCode]
	@CruiseID int,
	@VouchersCode nvarchar(10)
AS
	SELECT Promotions_Vouchers_Promotion_Id, Promotions_Vouchers_Id
	FROM Promotions_Vouchers_CabUK
	WHERE Promotions_Vouchers_Cruise_Id = @CruiseID
	AND Promotions_Vouchers_Code = @VouchersCode
	AND Promotions_Vouchers_Status = ''0''

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_PromotionVouchersStatus_By_Code_And_CruiseID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Cabinet UK>
-- Create date: <04/07/08>
-- Description:	<update promotions vouchers status by code and cruise id>
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_PromotionVouchersStatus_By_Code_And_CruiseID]

@PromotionsVouchersCode varchar(50),
@PromotionsVouchersCruiseID bigint

AS


IF EXISTS (SELECT * FROM Promotions_Vouchers_CabUK
		   WHERE Promotions_Vouchers_Code = @PromotionsVouchersCode 
		   AND Promotions_Vouchers_Cruise_Id = @PromotionsVouchersCruiseID)
	

	BEGIN
		UPDATE Promotions_Vouchers_CabUK SET Promotions_Vouchers_Status=''0''
		WHERE Promotions_Vouchers_Code = @PromotionsVouchersCode
		AND Promotions_Vouchers_Cruise_Id = @PromotionsVouchersCruiseID
	END 

-- execute dbo.Cab_Update_PromotionVouchersStatus_By_Code_And_CruiseID @PromotionsVouchersCode=''THX_9654'', @PromotionsVouchersCruiseID=6



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_ServicesAvailability_By_KioskID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 22/07/08
-- Description:	Delete a Services Availability.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_ServicesAvailability_By_KioskID]
	@KioskID int
AS
	DECLARE @Column varchar(30)
BEGIN
	DELETE FROM ServiceAvailability_CabUK WHERE ServiceAvailability_Kiosk_Id = @KioskID
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Insert_ServicesAvailability]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Cabinet UK
-- Create date: 22/07/08
-- Description:	Insert a new Services Availability.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Insert_ServicesAvailability]
	@Final_Start_Date nvarchar(50),
	@ServiceID int,
	@CruiseID int,
	@KioskID int,
	@DayCount int,
	@00 int, @01 int, @02 int, @03 int,
	@04 int, @05 int, @06 int, @07 int,
	@08 int, @09 int, @10 int, @11 int,
	@12 int, @13 int, @14 int, @15 int,
	@16 int, @17 int, @18 int, @19 int,
	@20 int, @21 int, @22 int, @23 int
AS
BEGIN
	INSERT INTO ServiceAvailability_CabUK (
		ServiceAvailability_Date_Time, ServiceAvailability_Service_Id, ServiceAvailability_Cruise_Id, ServiceAvailability_Kiosk_Id,
		ServiceAvailability_Day_Count, ServiceAvailability_00, ServiceAvailability_01, ServiceAvailability_02, ServiceAvailability_03,
		ServiceAvailability_04, ServiceAvailability_05, ServiceAvailability_06, ServiceAvailability_07, ServiceAvailability_08,
		ServiceAvailability_09, ServiceAvailability_10, ServiceAvailability_11, ServiceAvailability_12, ServiceAvailability_13,
		ServiceAvailability_14, ServiceAvailability_15, ServiceAvailability_16, ServiceAvailability_17, ServiceAvailability_18,
		ServiceAvailability_19, ServiceAvailability_20, ServiceAvailability_21, ServiceAvailability_22, ServiceAvailability_23 
	) VALUES (
		@Final_Start_Date, @ServiceID, @CruiseID, @KioskID, @DayCount,
		@00, @01, @02, @03, @04, @05, @06, @07, @08,
		@09, @10, @11, @12, @13, @14, @15, @16, @17,
		@18, @19, @20, @21, @22, @23
	)
	
	SELECT @@IDENTITY AS lastId
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Services]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 22/07/08
-- Description:	Get Services.
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Services]
AS
BEGIN
	SELECT Services_Id, Services_Name, Services_Set_Time
	FROM Services_CabUK
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_BulkImagePartyLink]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Author,RBP>
-- Create date: <Create Date, 07/08/2008>
-- Description:	<Description,,Link BulkImage to Party>
-- =============================================
CREATE PROCEDURE [dbo].[HSP_BulkImagePartyLink]
	 @BulkImageID   int,
	 @PartyID       int  
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 if  exists (
   SELECT PartyID FROM PartiesInImage
     WHERE PartyID = @PartyID AND BulkImageID = @BulkImageID
   )
   BEGIN   
    UPDATE PartiesInImage
    Set AssociationSource = 0,  -- Swipe
    ModifiedDate = Getdate() 
    WHERE PartyID = @PartyID AND BulkImageID = @BulkImageID
    return 0
    end 
ELSE
  begin 
  INSERT INTO PartiesInImage 
    (BulkImageID,PartyID,AssociationSource,AssociationType,CreatedDate,FRStatus )
    VALUES (@BulkImageID,@PartyID,0,1,GetDate(),0) 
    return 0
  end
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_BulkImagePartyUnLink]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Author,RBP>
-- Create date: <Create Date, 07/08/2008>
-- Description:	<Description,,Link BulkImage to Party>
-- =============================================
CREATE PROCEDURE [dbo].[HSP_BulkImagePartyUnLink]
	 @BulkImageID   int,
	 @PartyID       int  
AS
BEGIN
Update partiesInImage 
  Set AssociationSource = 3, 
    ModifiedDate = Getdate() 
  WHERE PartyID = @PartyID AND BulkImageID = @BulkImageID
end
Return 0




' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartiesInImage_NewOrDeleted_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HSP_PartiesInImage_NewOrDeleted_Update]
(
	@BulkImageID int,
	@PartyID int,
	@AssociationSource int,
	@AssociationType int,
	@ModifiedDate datetime,
	@FRStatus int,
	@Original_BulkImageID int,
	@Original_PartyID int,
	@Original_AssociationSource int,
	@Original_AssociationType int,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@Original_PartiesInImageKey numeric,
	@Original_FRStatus int,
	@PartiesInImageKey numeric
)
AS
	SET NOCOUNT OFF;
UPDATE [PartiesInImage] SET [BulkImageID] = @BulkImageID, [PartyID] = @PartyID, 
[AssociationSource] = @AssociationSource, 
[AssociationType] = @AssociationType, [ModifiedDate] = @ModifiedDate, [FRStatus] = @FRStatus 
WHERE (([BulkImageID] = @Original_BulkImageID) AND ([PartyID] = @Original_PartyID) 
AND ([AssociationSource] = @Original_AssociationSource) AND ([AssociationType] = @Original_AssociationType) 
AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) 
AND ([PartiesInImageKey] = @Original_PartiesInImageKey) 
AND ([FRStatus] = @Original_FRStatus));
	
SELECT BulkImageID, PartyID, AssociationSource, AssociationType, ModifiedDate, PartiesInImageKey, FRStatus FROM PartiesInImage WHERE (PartiesInImageKey = @PartiesInImageKey)

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartiesInImage_NewOrDeleted_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HSP_PartiesInImage_NewOrDeleted_Insert]
(
	@BulkImageID int,
	@PartyID int,
	@AssociationSource int,
	@AssociationType int,
	@ModifiedDate datetime,
	@FRStatus int
)
AS
	SET NOCOUNT OFF;
INSERT INTO [PartiesInImage] ([BulkImageID], [PartyID], [AssociationSource], [AssociationType], [ModifiedDate], [FRStatus]) VALUES (@BulkImageID, @PartyID, @AssociationSource, @AssociationType, @ModifiedDate, @FRStatus);
	
SELECT BulkImageID, PartyID, AssociationSource, AssociationType, ModifiedDate, PartiesInImageKey, FRStatus FROM PartiesInImage WHERE (PartiesInImageKey = SCOPE_IDENTITY())

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartiesInImage_NewOrDeleted_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HSP_PartiesInImage_NewOrDeleted_Delete]
(
	@Original_BulkImageID int,
	@Original_PartyID int,
	@Original_AssociationSource int,
	@Original_AssociationType int,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@Original_PartiesInImageKey numeric,
	@Original_FRStatus int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [PartiesInImage] WHERE (([BulkImageID] = @Original_BulkImageID) AND ([PartyID] = @Original_PartyID) 
AND ([AssociationSource] = @Original_AssociationSource) 
AND ([AssociationType] = @Original_AssociationType) 
AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) 
AND ([PartiesInImageKey] = @Original_PartiesInImageKey) 
AND ([FRStatus] = @Original_FRStatus))

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_PartiesInImage_NewOrDeleted_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[HSP_PartiesInImage_NewOrDeleted_Select]
AS
	SET NOCOUNT ON;
SELECT     BulkImageID, PartyID, AssociationSource, AssociationType, 
ModifiedDate, PartiesInImageKey, FRStatus
FROM         PartiesInImage
WHERE     (FRStatus IN (0, 2))


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_Slideshow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	Get slideshow
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_Slideshow]

	@slideshowID int

AS
	
BEGIN

	SET NOCOUNT ON;
	SELECT *
	FROM Slideshow_CabUK 
	WHERE SlideshowKey = @slideshowID

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_Slideshow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	delete slideshow
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_Slideshow]

	@slideshowID int

AS
	
BEGIN

  DELETE FROM Slideshow_CabUK 
  WHERE SlideshowKey = @slideshowID

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_Slideshow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	insert slideshow
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Add_Slideshow]

  @orderLotId int, 
  @productKey int,
  @orderDetailKey int

AS
	
BEGIN

  INSERT INTO Slideshow_CabUK (
    Created, 
    OrderLotId, 
    ProductKey, 
    OrderDetailKey
  )VALUES (
    0, 
    @orderLotId, 
    @productKey,
    @orderDetailKey
  )

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Delete_SlideshowDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	Delete Slideshow details
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Delete_SlideshowDetails]

	@slideshowID int

AS
	
BEGIN

  DELETE FROM Slideshow_Details_CabUK 
  WHERE SlideshowId = @slideshowID

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Get_SlideshowDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	Get slideshow details
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Get_SlideshowDetails]

	@slideshowID int

AS
	
BEGIN

	SET NOCOUNT ON;
	SELECT *
	FROM Slideshow_Details_CabUK 
	WHERE SlideshowId = @slideshowID

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_SlideshowDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Chris Moore, CabinetUK
-- Create date: 22 Oct 2008
-- Description:	insert slideshow details
-- =============================================
CREATE PROCEDURE [dbo].[Cab_Add_SlideshowDetail]

  @picturePaths varchar(500),
  @captionTxt varchar(500),
  @position int,
  @pictureID int,
  @slideshowID int

AS

BEGIN

  INSERT INTO Slideshow_Details_CabUK (
    Picture_Path, 
    Caption_Text, 
    Position, 
    PictureId, 
    SlideshowId 
  ) VALUES (
    @picturePaths, 
    @captionTxt, 
    @position, 
    @pictureID, 
    @slideshowID
  )

END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Generate_New_OrderID_Counter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Generate / Get a new order id and return it.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Generate_New_OrderID_Counter]
	@OrderCounter  int OUTPUT
AS
	-- Get Order Id Counter
	declare @new_o_c int

	SELECT  @OrderCounter = Cab_OrderID_Counter 		
	FROM OrderID_Counter_CabUK

	SET @new_o_c = 1

	-- Update the OrderID_Counter_CabUK table and set @OrderCounter
	if @OrderCounter > 0
		BEGIN
			SET @OrderCounter = @OrderCounter + 1
			
			UPDATE OrderID_Counter_CabUK SET Cab_OrderID_Counter=@OrderCounter
		END
	ELSE
		BEGIN
			INSERT INTO OrderID_Counter_CabUK (Cab_OrderID_Counter) VALUES (@new_o_c)
		END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ManifestHistory_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ManifestHistory_Insert]
(
	@ManifestHistoryKey int,
	@ManifestID int,
	@Cabin nvarchar(15),
	@Passengername nvarchar(50),
	@GuestStatus char(1),
	@Gender char(1),
	@NativeLanguage nvarchar(3),
	@PassportNation nvarchar(3),
	@GroupID nvarchar(20),
	@GroupSubNum nvarchar(20),
	@StewardSection nvarchar(20),
	@LoyaltyTier nvarchar(10),
	@EmbarkationDate datetime,
	@EmbarkationPort nvarchar(10),
	@DebarkationDate datetime,
	@DebarkationPort nvarchar(10),
	@DiningTable nvarchar(8),
	@DiningRoom nvarchar(25),
	@Sitting nvarchar(8),
	@LoyaltyID nvarchar(20),
	@UniquePassengerID int,
	@OriginalPassengerID int,
	@PaxID nvarchar(25),
	@FolioNumber nvarchar(30),
	@CreatedDate datetime,
	@ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[ManifestHistory] ([ManifestHistoryKey], [ManifestID], [Cabin], [Passengername], [GuestStatus], [Gender], [NativeLanguage], [PassportNation], [GroupID], [GroupSubNum], [StewardSection], [LoyaltyTier], [EmbarkationDate], [EmbarkationPort], [DebarkationDate], [DebarkationPort], [DiningTable], [DiningRoom], [Sitting], [LoyaltyID], [UniquePassengerID], [OriginalPassengerID], [PaxID], [FolioNumber], [CreatedDate], [ModifiedDate]) VALUES (@ManifestHistoryKey, @ManifestID, @Cabin, @Passengername, @GuestStatus, @Gender, @NativeLanguage, @PassportNation, @GroupID, @GroupSubNum, @StewardSection, @LoyaltyTier, @EmbarkationDate, @EmbarkationPort, @DebarkationDate, @DebarkationPort, @DiningTable, @DiningRoom, @Sitting, @LoyaltyID, @UniquePassengerID, @OriginalPassengerID, @PaxID, @FolioNumber, @CreatedDate, @ModifiedDate);
	
SELECT ManifestHistoryKey, ManifestID, Cabin, Passengername, GuestStatus, Gender, NativeLanguage, PassportNation, GroupID, GroupSubNum, StewardSection, LoyaltyTier, EmbarkationDate, EmbarkationPort, DebarkationDate, DebarkationPort, DiningTable, DiningRoom, Sitting, LoyaltyID, UniquePassengerID, OriginalPassengerID, PaxID, FolioNumber, CreatedDate, ModifiedDate FROM ManifestHistory WHERE (ManifestHistoryKey = @ManifestHistoryKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ManifestHistory_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ManifestHistory_Select]
AS
	SET NOCOUNT ON;
SELECT ManifestHistoryKey, ManifestID, Cabin, Passengername, GuestStatus, Gender, NativeLanguage, PassportNation, GroupID, GroupSubNum, StewardSection, LoyaltyTier, EmbarkationDate, EmbarkationPort, DebarkationDate, DebarkationPort, DiningTable, DiningRoom, Sitting, LoyaltyID, UniquePassengerID, OriginalPassengerID, PaxID, FolioNumber, CreatedDate, ModifiedDate FROM dbo.ManifestHistory
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ManifestHistory_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ManifestHistory_Update]
(
	@ManifestHistoryKey int,
	@ManifestID int,
	@Cabin nvarchar(15),
	@Passengername nvarchar(50),
	@GuestStatus char(1),
	@Gender char(1),
	@NativeLanguage nvarchar(3),
	@PassportNation nvarchar(3),
	@GroupID nvarchar(20),
	@GroupSubNum nvarchar(20),
	@StewardSection nvarchar(20),
	@LoyaltyTier nvarchar(10),
	@EmbarkationDate datetime,
	@EmbarkationPort nvarchar(10),
	@DebarkationDate datetime,
	@DebarkationPort nvarchar(10),
	@DiningTable nvarchar(8),
	@DiningRoom nvarchar(25),
	@Sitting nvarchar(8),
	@LoyaltyID nvarchar(20),
	@UniquePassengerID int,
	@OriginalPassengerID int,
	@PaxID nvarchar(25),
	@FolioNumber nvarchar(30),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Original_ManifestHistoryKey int,
	@Original_ManifestID int,
	@Original_Cabin nvarchar(15),
	@Original_Passengername nvarchar(50),
	@Original_GuestStatus char(1),
	@Original_Gender char(1),
	@Original_NativeLanguage nvarchar(3),
	@Original_PassportNation nvarchar(3),
	@Original_GroupID nvarchar(20),
	@Original_GroupSubNum nvarchar(20),
	@Original_StewardSection nvarchar(20),
	@Original_LoyaltyTier nvarchar(10),
	@IsNull_EmbarkationDate datetime,
	@Original_EmbarkationDate datetime,
	@Original_EmbarkationPort nvarchar(10),
	@IsNull_DebarkationDate datetime,
	@Original_DebarkationDate datetime,
	@Original_DebarkationPort nvarchar(10),
	@Original_DiningTable nvarchar(8),
	@Original_DiningRoom nvarchar(25),
	@Original_Sitting nvarchar(8),
	@Original_LoyaltyID nvarchar(20),
	@Original_UniquePassengerID int,
	@Original_OriginalPassengerID int,
	@Original_PaxID nvarchar(25),
	@Original_FolioNumber nvarchar(30),
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
UPDATE [dbo].[ManifestHistory] SET [ManifestHistoryKey] = @ManifestHistoryKey, [ManifestID] = @ManifestID, [Cabin] = @Cabin, [Passengername] = @Passengername, [GuestStatus] = @GuestStatus, [Gender] = @Gender, [NativeLanguage] = @NativeLanguage, [PassportNation] = @PassportNation, [GroupID] = @GroupID, [GroupSubNum] = @GroupSubNum, [StewardSection] = @StewardSection, [LoyaltyTier] = @LoyaltyTier, [EmbarkationDate] = @EmbarkationDate, [EmbarkationPort] = @EmbarkationPort, [DebarkationDate] = @DebarkationDate, [DebarkationPort] = @DebarkationPort, [DiningTable] = @DiningTable, [DiningRoom] = @DiningRoom, [Sitting] = @Sitting, [LoyaltyID] = @LoyaltyID, [UniquePassengerID] = @UniquePassengerID, [OriginalPassengerID] = @OriginalPassengerID, [PaxID] = @PaxID, [FolioNumber] = @FolioNumber, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate WHERE (([ManifestHistoryKey] = @Original_ManifestHistoryKey) AND ([ManifestID] = @Original_ManifestID) AND ([Cabin] = @Original_Cabin) AND ([Passengername] = @Original_Passengername) AND ([GuestStatus] = @Original_GuestStatus) AND ([Gender] = @Original_Gender) AND ([NativeLanguage] = @Original_NativeLanguage) AND ([PassportNation] = @Original_PassportNation) AND ([GroupID] = @Original_GroupID) AND ([GroupSubNum] = @Original_GroupSubNum) AND ([StewardSection] = @Original_StewardSection) AND ([LoyaltyTier] = @Original_LoyaltyTier) AND ((@IsNull_EmbarkationDate = 1 AND [EmbarkationDate] IS NULL) OR ([EmbarkationDate] = @Original_EmbarkationDate)) AND ([EmbarkationPort] = @Original_EmbarkationPort) AND ((@IsNull_DebarkationDate = 1 AND [DebarkationDate] IS NULL) OR ([DebarkationDate] = @Original_DebarkationDate)) AND ([DebarkationPort] = @Original_DebarkationPort) AND ([DiningTable] = @Original_DiningTable) AND ([DiningRoom] = @Original_DiningRoom) AND ([Sitting] = @Original_Sitting) AND ([LoyaltyID] = @Original_LoyaltyID) AND ([UniquePassengerID] = @Original_UniquePassengerID) AND ([OriginalPassengerID] = @Original_OriginalPassengerID) AND ([PaxID] = @Original_PaxID) AND ([FolioNumber] = @Original_FolioNumber) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)));
	
SELECT ManifestHistoryKey, ManifestID, Cabin, Passengername, GuestStatus, Gender, NativeLanguage, PassportNation, GroupID, GroupSubNum, StewardSection, LoyaltyTier, EmbarkationDate, EmbarkationPort, DebarkationDate, DebarkationPort, DiningTable, DiningRoom, Sitting, LoyaltyID, UniquePassengerID, OriginalPassengerID, PaxID, FolioNumber, CreatedDate, ModifiedDate FROM ManifestHistory WHERE (ManifestHistoryKey = @ManifestHistoryKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_ManifestHistory_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_ManifestHistory_Delete]
(
	@Original_ManifestHistoryKey int,
	@Original_ManifestID int,
	@Original_Cabin nvarchar(15),
	@Original_Passengername nvarchar(50),
	@Original_GuestStatus char(1),
	@Original_Gender char(1),
	@Original_NativeLanguage nvarchar(3),
	@Original_PassportNation nvarchar(3),
	@Original_GroupID nvarchar(20),
	@Original_GroupSubNum nvarchar(20),
	@Original_StewardSection nvarchar(20),
	@Original_LoyaltyTier nvarchar(10),
	@IsNull_EmbarkationDate datetime,
	@Original_EmbarkationDate datetime,
	@Original_EmbarkationPort nvarchar(10),
	@IsNull_DebarkationDate datetime,
	@Original_DebarkationDate datetime,
	@Original_DebarkationPort nvarchar(10),
	@Original_DiningTable nvarchar(8),
	@Original_DiningRoom nvarchar(25),
	@Original_Sitting nvarchar(8),
	@Original_LoyaltyID nvarchar(20),
	@Original_UniquePassengerID int,
	@Original_OriginalPassengerID int,
	@Original_PaxID nvarchar(25),
	@Original_FolioNumber nvarchar(30),
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[ManifestHistory] WHERE (([ManifestHistoryKey] = @Original_ManifestHistoryKey) AND ([ManifestID] = @Original_ManifestID) AND ([Cabin] = @Original_Cabin) AND ([Passengername] = @Original_Passengername) AND ([GuestStatus] = @Original_GuestStatus) AND ([Gender] = @Original_Gender) AND ([NativeLanguage] = @Original_NativeLanguage) AND ([PassportNation] = @Original_PassportNation) AND ([GroupID] = @Original_GroupID) AND ([GroupSubNum] = @Original_GroupSubNum) AND ([StewardSection] = @Original_StewardSection) AND ([LoyaltyTier] = @Original_LoyaltyTier) AND ((@IsNull_EmbarkationDate = 1 AND [EmbarkationDate] IS NULL) OR ([EmbarkationDate] = @Original_EmbarkationDate)) AND ([EmbarkationPort] = @Original_EmbarkationPort) AND ((@IsNull_DebarkationDate = 1 AND [DebarkationDate] IS NULL) OR ([DebarkationDate] = @Original_DebarkationDate)) AND ([DebarkationPort] = @Original_DebarkationPort) AND ([DiningTable] = @Original_DiningTable) AND ([DiningRoom] = @Original_DiningRoom) AND ([Sitting] = @Original_Sitting) AND ([LoyaltyID] = @Original_LoyaltyID) AND ([UniquePassengerID] = @Original_UniquePassengerID) AND ([OriginalPassengerID] = @Original_OriginalPassengerID) AND ([PaxID] = @Original_PaxID) AND ([FolioNumber] = @Original_FolioNumber) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_CapturedData_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_CapturedData_Delete]
(
	@IsNull_FolioNumber nvarchar(30),
	@Original_FolioNumber nvarchar(30),
	@Original_BulkImageID int,
	@Original_VoyageSegmentID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_Cabin nvarchar(15),
	@Original_Cabin nvarchar(15),
	@IsNull_PaxID nvarchar(25),
	@Original_PaxID nvarchar(25),
	@Original_PartyID int,
	@Original_CapturedDataKey decimal(18, 0),
	@IsNull_ManifestID int,
	@Original_ManifestID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [CapturedData] WHERE (((@IsNull_FolioNumber = 1 AND [FolioNumber] IS NULL) OR ([FolioNumber] = @Original_FolioNumber)) AND ([BulkImageID] = @Original_BulkImageID) AND ([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ((@IsNull_Cabin = 1 AND [Cabin] IS NULL) OR ([Cabin] = @Original_Cabin)) AND ((@IsNull_PaxID = 1 AND [PaxID] IS NULL) OR ([PaxID] = @Original_PaxID)) AND ([PartyID] = @Original_PartyID) AND ([CapturedDataKey] = @Original_CapturedDataKey) AND ((@IsNull_ManifestID = 1 AND [ManifestID] IS NULL) OR ([ManifestID] = @Original_ManifestID)))
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_CapturedData_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_CapturedData_Insert]
(
	@FolioNumber nvarchar(30),
	@BulkImageID int,
	@VoyageSegmentID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Cabin nvarchar(15),
	@PaxID nvarchar(25),
	@PartyID int,
	@CapturedDataKey decimal(18, 0),
	@ManifestID int
)
AS
	SET NOCOUNT OFF;
INSERT INTO [CapturedData] ([FolioNumber], [BulkImageID], [VoyageSegmentID], [CreatedDate], [ModifiedDate], [Cabin], [PaxID], [PartyID], [CapturedDataKey], [ManifestID]) VALUES (@FolioNumber, @BulkImageID, @VoyageSegmentID, @CreatedDate, @ModifiedDate, @Cabin, @PaxID, @PartyID, @CapturedDataKey, @ManifestID);
	
SELECT FolioNumber, BulkImageID, VoyageSegmentID, CreatedDate, ModifiedDate, Cabin, PaxID, PartyID, CapturedDataKey, ManifestID FROM CapturedData WHERE (CapturedDataKey = @CapturedDataKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_CapturedData_InsertUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HSP_CapturedData_InsertUpdate]
	-- Add the parameters for the stored procedure here
    @CapturedDatakey  int,
    @BulkImageID      int,
    @Cabin            varchar(15),
    @FolioNumber      varchar(30),
    @PartyID          int  , 
    @PaxID            varchar(25),
    @VoyageSegmentID  int,
    @ManifestID       int
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  IF EXISTS ( SELECT * FROM CapturedData WHERE CapturedDataKey = @CapturedDatakey )
    BEGIN
          UPDATE CapturedData  
           SET  BulkImageID     = @BulkImageID,
                Cabin           = @Cabin ,
                FolioNumber     = @FolioNumber ,
                PartyID         = @PartyID ,
                PaxID           = @PaxID ,
                VoyageSegmentID = @VoyageSegmentID ,
                ManifestID      = @ManifestID ,
                CreatedDate     = GetDate()
          WHERE ( CapturedDataKey = @CapturedDataKey )
    END
  ELSE
    BEGIN
          INSERT INTO CapturedData (
                    CapturedDataKey,      BulkImageID,
                    Cabin,                CreatedDate,
                    FolioNumber,          PartyID,
                    PaxID,                VoyageSegmentID,
                    ManifestID            ) 
           VALUES ( @CapturedDataKey,     @BulkImageID,
                    @Cabin ,              GetDate(),
                    @FolioNumber ,        @PartyID ,
                    @PaxID ,              @VoyageSegmentID ,
                    @ManifestID           ) 
    END
END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_CapturedData_Select]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_CapturedData_Select]
AS
	SET NOCOUNT ON;
SELECT     FolioNumber, BulkImageID, VoyageSegmentID, CreatedDate, ModifiedDate, Cabin, PaxID, PartyID, CapturedDataKey, ManifestID
FROM         CapturedData
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_CapturedDataGetByPK]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_CapturedDataGetByPK]
(
	@CapturedDataKey decimal(18, 0)
)
AS
	SET NOCOUNT ON;
SELECT     FolioNumber, BulkImageID, VoyageSegmentID, CreatedDate, ModifiedDate, Cabin, PaxID, PartyID, CapturedDataKey, ManifestID
FROM         CapturedData
WHERE (CapturedDataKey = @CapturedDataKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_CapturedData_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[HSP_CapturedData_Update]
(
	@FolioNumber nvarchar(30),
	@BulkImageID int,
	@VoyageSegmentID int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@Cabin nvarchar(15),
	@PaxID nvarchar(25),
	@PartyID int,
	@CapturedDataKey decimal(18, 0),
	@ManifestID int,
	@IsNull_FolioNumber nvarchar(30),
	@Original_FolioNumber nvarchar(30),
	@Original_BulkImageID int,
	@Original_VoyageSegmentID int,
	@Original_CreatedDate datetime,
	@IsNull_ModifiedDate datetime,
	@Original_ModifiedDate datetime,
	@IsNull_Cabin nvarchar(15),
	@Original_Cabin nvarchar(15),
	@IsNull_PaxID nvarchar(25),
	@Original_PaxID nvarchar(25),
	@Original_PartyID int,
	@Original_CapturedDataKey decimal(18, 0),
	@IsNull_ManifestID int,
	@Original_ManifestID int
)
AS
	SET NOCOUNT OFF;
UPDATE [CapturedData] SET [FolioNumber] = @FolioNumber, [BulkImageID] = @BulkImageID, [VoyageSegmentID] = @VoyageSegmentID, [CreatedDate] = @CreatedDate, [ModifiedDate] = @ModifiedDate, [Cabin] = @Cabin, [PaxID] = @PaxID, [PartyID] = @PartyID, [CapturedDataKey] = @CapturedDataKey, [ManifestID] = @ManifestID WHERE (((@IsNull_FolioNumber = 1 AND [FolioNumber] IS NULL) OR ([FolioNumber] = @Original_FolioNumber)) AND ([BulkImageID] = @Original_BulkImageID) AND ([VoyageSegmentID] = @Original_VoyageSegmentID) AND ([CreatedDate] = @Original_CreatedDate) AND ((@IsNull_ModifiedDate = 1 AND [ModifiedDate] IS NULL) OR ([ModifiedDate] = @Original_ModifiedDate)) AND ((@IsNull_Cabin = 1 AND [Cabin] IS NULL) OR ([Cabin] = @Original_Cabin)) AND ((@IsNull_PaxID = 1 AND [PaxID] IS NULL) OR ([PaxID] = @Original_PaxID)) AND ([PartyID] = @Original_PartyID) AND ([CapturedDataKey] = @Original_CapturedDataKey) AND ((@IsNull_ManifestID = 1 AND [ManifestID] IS NULL) OR ([ManifestID] = @Original_ManifestID)));
	
SELECT FolioNumber, BulkImageID, VoyageSegmentID, CreatedDate, ModifiedDate, Cabin, PaxID, PartyID, CapturedDataKey, ManifestID FROM CapturedData WHERE (CapturedDataKey = @CapturedDataKey)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_Image_Item_To_Order]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 07/08/2008
-- Description:	Add an image item to and order (fill: OrderPackages, OrderDetails and OrderImageItem).
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Add_Image_Item_To_Order]
	@productID int, 
	@quantity int, 
	@orderLotID int, 
	@productDescription nvarchar(1000), 
	@pictureId int,	
 	@cropTop float,
	@cropLeft float,
	@cropHeight float,
	@cropWidth float,
	@ImageItemType int=1,
	@ItemNumber int=1

AS

	-- STEP 1: calculate the product price which takes into account the qty required we get the product price
	declare @productPrice smallmoney, @totalProductPrice smallmoney	
	SELECT @productPrice = ProductPrice FROM Products WHERE ProductKey=@productID
	SET @totalProductPrice = CAST (@productPrice * @quantity AS smallmoney)
	

	-- STEP 2:  insert OrderPackages record
	declare @orderpackageid int
	EXEC dbo.Cab_insert_OrderPackage_Record @orderLotID, @productDescription, @totalProductPrice, 1, 0, @orderpackageid OUTPUT


	-- STEP 3:  insert OrderDetails record
	declare @OrderDetailKey int
	EXEC dbo.Cab_insert_OrderDetails_Record @orderpackageid, @productID, @quantity, @OrderDetailKey OUTPUT
	SELECT @OrderDetailKey 


	-- STEP 4: insert OrderImageItem record
	EXEC dbo.Cab_insert_OrderImageItem_Record @OrderDetailKey, @cropTop, @cropLeft, @cropHeight, @cropWidth, @pictureId,  @ImageItemType, @ItemNumber


	-- NOTE:  insert OrderTextItem: this step has to be done in a separate procedure as it involves
	-- looping through all the text items for that image (there may be more than one)



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Add_Item_To_Order]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 07/08/2008
-- Description:	Add an item to and order (fill: OrderPackages and OrderDetails).
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Add_Item_To_Order]
	@productID int, 
	@quantity int, 
	@orderLotID int, 
	@productDescription nvarchar(1000), 	
	@package bit = 0,
	@OrderPackageKey int OUTPUT


AS

	declare @productPrice smallmoney, @totalProductPrice smallmoney, @orderpackageid int, @OrderDetailKey int

	-- if this item is not a package (consisting of more than one product)
	IF @package = 0
		BEGIN

	
			-- STEP 1: calculate the product price which takes into account the qty required we get the product price
			--declare @productPrice smallmoney, @totalProductPrice smallmoney	
			SELECT @productPrice = ProductPrice FROM Products WHERE ProductKey=@productID
			SET @totalProductPrice = CAST (@productPrice * @quantity AS smallmoney)

			-- STEP 2:  insert OrderPackages record
			--declare @orderpackageid int
			EXEC dbo.Cab_insert_OrderPackage_Record @orderLotID, @productDescription, @totalProductPrice, 1, 0, @orderpackageid OUTPUT
			SET @OrderPackageKey = @orderpackageid
		
			-- STEP 3:  insert OrderDetails record
			--declare @OrderDetailKey int
			EXEC dbo.Cab_insert_OrderDetails_Record @orderpackageid, @productID, @quantity, @OrderDetailKey OUTPUT
			SELECT @OrderDetailKey 


		END

	ELSE
		BEGIN

			--  code needs to be written for adding packages to the order
			SET @OrderPackageKey = 0

		END


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Generate_New_OrderId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008
-- Description:	Generate a unique order id.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Generate_New_OrderId]
	@cruiseId bigint,
	@newOrderId nvarchar(50) OUTPUT

AS

	-- get the corresponding Ship code for the given cruise id
	declare @cruiseShipCode varchar (50)
	EXEC dbo.Cab_get_cruiseShipCode @cruiseId, @cruiseShipCode OUTPUT
	--SELECT @cruiseShipCode


	-- Get the latest order counter (call to SP here)
	declare @OrderCounter int
	EXEC dbo.Cab_Generate_New_OrderID_Counter @OrderCounter OUTPUT
	--SELECT @OrderCounter

    
	--create the unique order string
  	set @newOrderId = Cast (@cruiseShipCode AS nvarchar) + ''_'' +  Cast (@cruiseId AS nvarchar) + ''_'' +  Cast (@OrderCounter AS nvarchar)



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HSP_Get_ScreenSaver_Images]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Halse GRH
-- Create date: October 1, 2008
-- Description:	Gets the latest n Images for a Cabin Number (for the current voyage)
--				If n images are not available, the difference 
--				is made up of a random selection of stock images
----------------CHANGES------------------
--<GRH>171008 Was getting images by folio, changed to Cabin
-- =============================================

CREATE PROCEDURE [dbo].[HSP_Get_ScreenSaver_Images]
@StateRoom nvarchar(30),
@ResultSize int
AS
BEGIN
SET NOCOUNT ON;
DECLARE @RC int
DECLARE @ActiveSegmentKey int
DECLARE @ASKeySetting nvarchar(255)
DECLARE @PageSize int
DECLARE @CurrentPage int
exec Gen_Get_Setting ''ActiveSegmentkey'', @ASKeySetting OUTPUT
set @ActiveSegmentKey = cast (@ASKeySetting as int)
DECLARE @URL nvarchar(255)
exec Gen_Get_Setting ''URL_IATV'', @URL OUTPUT
set @PageSize =@ResultSize
Set @CurrentPage =1

declare @TP Table (BIID int, [FileName] nvarchar(255), IsStock bit, PrintDate Datetime)
insert into @TP (BIID)
EXEC @RC = [Gen_Get_Images_For_StateRoom] 
   @ActiveSegmentKey
  ,@StateRoom
, @PageSize 
, @CurrentPage 

	print ''returned '' +  cast (@RC as nvarchar) + ''non -stock images''

declare @Bal int
Set @Bal = @PageSize-@RC
if @Bal > 0
BEGIN
	print ''Need '' +  cast (@Bal as nvarchar(10)) + '' more images from stock ''

	insert into @TP (BIID)
		EXEC Gen_Get_Stock_Images @PageSize= @Bal ,
								@PageNumber = 1,
								@Randomise = 1
END
Update @TP
SET [Filename] = @URL + replace(ImagePaths.ImagePath, ''\'',''/'') + Images.PreviewImage + ''_S.jpg'', 
IsStock = case When ImageTypeID = 2 then 1 else 0 end,
PrintDate = Images.PrintDate 
FROM Images INNER JOIN ImagePaths ON ImagePaths.ImagePathKey = Images.ImagePathID 
inner join @tp on BIID = BulkImageID
select * from @TP
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Update_OrderDetailsQuantity_By_OrderLotID_AND_ProductID_AND_BulkImageID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Cabinet UK - (Alter)Rodrigo Dias
-- Create date: 25/07/08
-- Description:	update order details quantity by order detail key and delete a package if the quantity is 0
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Update_OrderDetailsQuantity_By_OrderLotID_AND_ProductID_AND_BulkImageID]
	@OrderLotID int,
	@ProductID int,
	@BulkImageID int,
	@Quantity numeric(6,2)
AS
	BEGIN
		DECLARE @OrderDetailKey int
		DECLARE @PackageID int
		DECLARE @OldPrice numeric(6,2)
		DECLARE @NewPrice numeric(6,2)
		
		exec [Cab_Get_Image_OrderDetailKey_For_Order] @OrderLotID, @ProductID, @BulkImageID, @OrderDetailKey OUTPUT

		SELECT @OldPrice = ProductPrice FROM Products WHERE ProductKey = @ProductID
		SET @NewPrice = @OldPrice * @Quantity
		SELECT @PackageID = OrderPackageId FROM OrderDetails WHERE OrderDetailKey = @OrderDetailKey
		IF @Quantity > 1
			BEGIN
				UPDATE OrderPackages SET Price = @NewPrice WHERE OrderPackageKey = @PackageID  
				UPDATE OrderDetails SET Quantity = @Quantity WHERE OrderDetailKey = @OrderDetailKey
			END
		ELSE
			BEGIN
				DELETE OrderPackages WHERE OrderPackageKey = @PackageID  
				--DELETE OrderDetails WHERE OrderDetailKey = @OrderDetailKey 
				-- this one is cascaded by the first one
			END
	END


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Create_New_Open_Order]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008	
-- Description:	Generate a unique order id and create a new order header for a given manifest.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Create_New_Open_Order]
	@UPaxID nvarchar(30)='''',
	@PaxID nvarchar(30)='''',
	@FolioNumber nvarchar(30)='''',
	@PassengerName nvarchar(50)='''',
	@CabinNumber nvarchar(10)='''',
	@OrderedFromStr nvarchar(10)='''',
	@cruiseId bigint,
	@orderLotId int OUTPUT
AS
	--STEP 1  : Create a unique order id which consists of ShipID+CruiseID+Order_Counter
	declare @newOrderId  nvarchar(50) 
	EXEC dbo.Cab_Generate_New_OrderId @cruiseId, @newOrderId OUTPUT

	--STEP 2  : Create the new order header for this passenger
	INSERT INTO Orders_MultiLine (
		OrderID, PaxID, UniquePassengerID, PassengerName,
		FolioNumber, CabinNr, Orderdate, OrderedFrom,
		TotalPrice, OrderStatus
	) VALUES (
		@newOrderId, @PaxID, @UPaxID, @PassengerName,
		@FolioNumber, @CabinNumber, getdate(), @OrderedFromStr,
		''0'',''-1''
	)

	--STEP 3  : Finally get the current order id from the INSERT query above
	SELECT MAX(OrderLotKey) FROM Orders_MultiLine
	--SET @orderLotId = (SELECT @@IDENTITY)









' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cab_Create_New_Open_Order_For_Passenger]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		Cabinet UK
-- Create date: 08/07/2008	
-- Description:	Generate a unique order id and create a new order header for a given manifest.
-- =============================================

CREATE PROCEDURE [dbo].[Cab_Create_New_Open_Order_For_Passenger]
	@UPaxID nvarchar(30),
	@PaxID nvarchar(30),
	@FolioNumber nvarchar(30),
	@PassengerName nvarchar(50),
	@CabinNumber nvarchar(10),
	@OrderedFromStr nvarchar(10),
	@cruiseId bigint,
	@orderLotId int OUTPUT
AS
	--STEP 1  : Create a unique order id which consists of ShipID+CruiseID+Order_Counter
	declare @newOrderId  nvarchar(50) 
	EXEC dbo.Cab_Generate_New_OrderId @cruiseId, @newOrderId OUTPUT

	--STEP 2  : Create the new order header for this passenger
	INSERT INTO Orders_MultiLine (
		OrderID, PaxID, UniquePassengerID, PassengerName,
		FolioNumber, CabinNr, Orderdate, OrderedFrom,
		TotalPrice, OrderStatus
	) VALUES (
		@newOrderId, @PaxID, @UPaxID, @PassengerName,
		@FolioNumber, @CabinNumber, getdate(), @OrderedFromStr,
		''0'',''-1''
	)

	--STEP 3  : Finally get the current order id from the INSERT query above
	--SELECT MAX(OrderLotKey) FROM Orders_MultiLine
	SET @orderLotId = (SELECT @@IDENTITY)







' 
END
