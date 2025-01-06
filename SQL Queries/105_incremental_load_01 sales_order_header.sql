    SELECT SalesOrderHeader.SalesOrderID, 
	SalesOrderHeader.OrderDate, 
	SalesOrderHeader.DueDate,
	SalesOrderHeader.ShipDate, 
	SalesOrderHeader.OnlineOrderFlag, 
	SalesOrderHeader.CustomerID, 
	SalesOrderHeader.TerritoryID,
	SalesOrderHeader.TaxAmt, 
	SalesOrderHeader.Freight, 
	SalesOrderHeader.ModifiedDate, 
	SalesOrderHeader.SalesOrderNumber 
FROM
sales.SalesOrderHeader
where sales.SalesOrderHeader.OnlineOrderFlag=1
and sales.SalesOrderHeader.ModifiedDate>= ' 2011-01-07 00:00:00' /*replace it with mapping variable*/



-- Check existing records in Sales.SalesOrderHeader
SELECT MAX(SalesOrderID) AS LastSalesOrderID FROM Sales.SalesOrderHeader;

-- Check existing records in Sales.SalesOrderDetail
SELECT MAX(SalesOrderDetailID) AS LastSalesOrderDetailID FROM Sales.SalesOrderDetail;

--Test the Incremental Load
SET IDENTITY_INSERT Sales.SalesOrderHeader ON

SET IDENTITY_INSERT Sales.SalesOrderHeader Off

SET IDENTITY_INSERT sales.SalesOrderDetail ON

SET IDENTITY_INSERT sales.SalesOrderDetail off

insert into Sales.SalesOrderHeader
(SalesOrderID,OrderDate,DueDate,ShipDate,CustomerID,BillToAddressID,ShipToAddressID,ShipMethodID,ModifiedDate)
values
(1,'2019-09-18 00:00:00','2019-09-19 00:00:00','2019-09-18',11019,921,921,5,'2019-09-18 00:00:00');

insert into sales.SalesOrderDetail
(SalesOrderID,SalesOrderDetailID,ProductID,OrderQty,UnitPrice,SpecialOfferID)
values
(1,1,771,1,1,1)

delete from Sales.SalesOrderHeader where DueDate = '2019-09-19 00:00:00'
select * from sales.SalesOrderDetail where SalesOrderID = 1
delete from sales.SalesOrderDetail where SalesOrderID = 1






