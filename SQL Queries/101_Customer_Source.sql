create view Person.Customer_Source as 
(

SELECT CustomerID AS customer_id, PersonID
FROM Sales.Customer
WHERE PersonID IS NOT NULL

 )

 select * from person.customer_source

 drop view Person.Customer_Source