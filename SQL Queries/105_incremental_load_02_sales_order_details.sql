SELECT
	sod.SalesOrderID AS SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	ProductID,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal
FROM sales.SalesOrderDetail AS sod
INNER JOIN sales.SalesOrderHeader AS soh
	ON sod.SalesOrderID = soh.SalesOrderID
WHERE OnlineOrderFlag = 1
and 

soh.ModifiedDate >= '2011-01-01 00:00:00' /*replace it with mapping variable*/









