																					
														--create database sales
create database sales
go
use sales
go
													--create schema sales
create schema Sales
go
													--create schema Person
create schema Person
go

										           --create schema Purcharsing
create schema Purcharsing
go
												--create tables 

													--Customer

create table Sales.Customer(
customerid int primary key not null,
personid int,
storeid int,
territoryid int,
accountnumber varchar(10) not null,
rowguid  uniqueidentifier not null,
modifiedgate datetime
)


													--SalesPerson

create table Sales.SalesPerson(
buisnessentityid int primary key not null,
territoryid int, 
salesquota money, 
bonus money not null,
commissionpct smallmoney not null,
salesytd money not null,
saleslastyear money not null,
rowguid  uniqueidentifier not null,
modifiedgate datetime)

													--SalesTerritory

create table Sales.SalesTerritory(
territoryid int primary key not null,
name nvarchar(50) not null,
countryregioncode nvarchar(3) not null,
[group] nvarchar(50) not null,
salesytd money not null,
saleslastyear money not null,
costytd money not null,
costlastyear money not null,
rowguid  uniqueidentifier not null,
modifiedgate datetime
)

													--CurrencyRate

create table Sales.CurrencyRate(
currecyrateid int primary key not null,
currencyratedate datetime not null,
fromcurrencycode nchar(3) not null ,
tocurrencycode nchar(3),
averagerate money not null,
endofdayrate money not null,
modifieddate datetime not null
)

													--CreditCard

create table Sales.CreditCard(
creditcardid int primary key not null,
cardtype nvarchar(50) not null,
cardnumber nvarchar(25) not null,
expmonth tinyint not null,
expyear smallint not null,
modifieddate datetime not null
)

												--SalesOrderDetail

create table Sales.SalesOrderDetail(
SalesOrderID int  not null,
salesorderdetailID int not null,
carriertrackingnumber nvarchar(25),
orderqty smallint not null,
productid int not null,
specialofferid int not null,
unitprice money not null,
unitpricediscount money not null,
linetotal numeric(38,6) not null,
rowguid  uniqueidentifier not null,
modifiedgate datetime
primary key(SalesOrderId,salesorderdetailID)
)

											--create table Person.Address

create table Person.Address(
AddressID int primary key not null,
Addressline1 nvarchar(60) not null,
Addressline2 nvarchar(60),
City nvarchar(30)  null,
StateProvinceID int not null,
PostalCode nvarchar(15) not null,
SpatialLocation geography,
rowguid uniqueidentifier not null,
modifiedgate datetime 
)

											--create table Purcharsing.ShipMethod

create table Purcharsing.ShipMethod(
ShipmethodID int primary key not null,
name nvarchar(50) not null,
shipbase money not null,
shiprate money not null,
rowguid uniqueidentifier not null,
modifiedgate datetime not null
)


												--SalesOrderHeader

create table Sales.SalesOrderHeader(
SalesOrderID int primary key not null,
revisionnumber tinyint not null,
orderdate datetime not null,
duedate datetime not null,
shipdate datetime,
status tinyint not null,
onlineorderflag bit,
salesordernumber nvarchar(25) not null,
purchaseordernumber nvarchar(25) ,
accountnumber nvarchar(15),
customerid int not null,
salespersonid int ,
territoryid int, 
billtoaddressid int not null,
shiptoaddressid int not null,
shipmethodid int not null,
creditcardid int,
creditcardapprovalcode varchar (15),
currencyrateid int ,
subtotal money not null,
taxamt money not null,
freight money not null,

								--connections to TABLE Sales.SalesOrderHeader

 FOREIGN KEY (customerid) REFERENCES Sales.Customer(customerid),
  FOREIGN KEY (territoryid) REFERENCES Sales.SalesTerritory(territoryid),
    FOREIGN KEY (salespersonid) REFERENCES Sales.SalesPerson(buisnessentityid),
	  FOREIGN KEY (creditcardid) REFERENCES Sales.CreditCard(creditcardid),
  FOREIGN KEY (shiptoaddressid) REFERENCES Person.Address(AddressID),
FOREIGN KEY (billtoaddressid) REFERENCES Person.Address(AddressID),
FOREIGN KEY (shipmethodid) REFERENCES Purcharsing.ShipMethod(ShipmethodID),
FOREIGN KEY (currencyrateid) REFERENCES Sales.CurrencyRate(currecyrateid)
)

												--SpecialOfferProduct

create table Sales.SpecialOfferProduct( 
specialofferid int not null,
ProductID int not null,
rowguid  uniqueidentifier not null,
modifiedgate datetime
primary key(specialofferid,productid) 
)

												--connections
ALTER TABLE sales.customer
ADD CONSTRAINT FK_customer2territory FOREIGN KEY (territoryid) REFERENCES Sales.SalesTerritory(territoryid);

ALTER TABLE Sales.SalesPerson
ADD CONSTRAINT FK_salesperson2territory FOREIGN KEY (territoryid) REFERENCES Sales.SalesTerritory(territoryid);

ALTER TABLE Sales.SalesOrderDetail
ADD CONSTRAINT FK_SalesOrderDetail2SalesOrderheader FOREIGN KEY (SalesOrderId) REFERENCES Sales.SalesOrderHeader(SalesOrderId),
CONSTRAINT FK_SalesOrderDetail2SpecialOfferProduct FOREIGN KEY (specialofferid,productid) REFERENCES Sales.SpecialOfferProduct(specialofferid,productid);


                                     ------adding records from the database

 --CreditCard
 INSERT INTO  Sales.CreditCard(
 creditcardid ,
cardtype ,
cardnumber ,
expmonth ,
expyear ,
modifieddate)
SELECT CreditCardID,CardType,CardNumber,ExpMonth,ExpYear,ModifiedDate   
 FROM AdventureWorks2022.Sales.CreditCard

 --SalesTerritory
  INSERT INTO  Sales.SalesTerritory(
 territoryid ,
name,
[countryregioncode],
[group] ,
salesytd ,
saleslastyear ,
costytd ,
costlastyear ,
rowguid  ,
modifiedgate )
SELECT TerritoryID,Name,CountryRegionCode,[Group],SalesYTD,SalesLastYear,CostYTD,CostLastYEar,rowguid,Modifieddate
 FROM AdventureWorks2022.Sales.SalesTerritory
   
 --address
   INSERT INTO  Person.Address(
AddressID ,
Addressline1 ,
Addressline2 ,
City ,
StateProvinceID ,
PostalCode ,
SpatialLocation ,
rowguid ,
modifiedgate   )
SELECT AddressID,AddressLine1,AddressLine1,City,StateProvinceID,PostalCode,SpatialLocation,rowguid,ModifiedDate 
 FROM AdventureWorks2022.Person.Address 

 --currencyrate
    INSERT INTO  Sales.CurrencyRate(
currecyrateid ,
currencyratedate ,
fromcurrencycode,
tocurrencycode ,
averagerate ,
endofdayrate,
modifieddate )
SELECT CurrencyRateID,CurrencyRateDate,FromCurrencyCode,ToCurrencyCode,AverageRate,EndOfDayRate,ModifiedDate 
 FROM AdventureWorks2022.Sales.CurrencyRate  

 --shipmethod
     INSERT INTO  Purcharsing.ShipMethod(
ShipmethodID ,
name,
shipbase,
shiprate,
rowguid,
modifiedgate)
SELECT ShipMethodID,Name,ShipBase,ShipRate,rowguid,ModifiedDate 
 FROM AdventureWorks2022.Purchasing.ShipMethod   

--salesperson
 INSERT INTO  Sales.SalesPerson(
buisnessentityid ,
territoryid , 
salesquota, 
bonus ,
commissionpct,
salesytd,
saleslastyear ,
rowguid ,
modifiedgate )
SELECT BusinessEntityID,TerritoryID,SalesQuota,Bonus,CommissionPct,SalesYTD,SalesLastYear,rowguid,ModifiedDate
FROM AdventureWorks2022.Sales.SalesPerson 

--salescustomer
INSERT INTO  Sales.Customer(
customerid ,
personid ,
storeid ,
territoryid ,
accountnumber ,
rowguid  ,
modifiedgate )
SELECT CustomerID,PersonID,StoreID,TerritoryID,AccountNumber,rowguid,ModifiedDate
FROM AdventureWorks2022.Sales.Customer 

--salesorderheader
INSERT INTO  Sales.SalesOrderHeader(
SalesOrderID,
revisionnumber,
orderdate,
duedate ,
shipdate,
status ,
onlineorderflag ,
salesordernumber,
purchaseordernumber,
accountnumber ,
customerid ,
salespersonid  ,
territoryid , 
billtoaddressid,
shiptoaddressid ,
shipmethodid ,
creditcardid,
creditcardapprovalcode ,
currencyrateid ,
subtotal,
taxamt,
freight )
SELECT SalesOrderID,RevisionNumber,OrderDate,DueDate,ShipDate,[Status],OnlineOrderFlag,SalesOrderNumber,
PurchaseOrderNumber,AccountNumber,CustomerID,SalesPersonID,TerritoryID,BillToAddressID,ShipToAddressID,ShipMethodID,
CreditCardID,CreditCardApprovalCode,CurrencyRateID,SubTotal,TaxAmt,Freight 
FROM AdventureWorks2022.Sales.SalesOrderHeader 
								
								  
  --specialoffer
  INSERT INTO  Sales.SpecialOfferProduct( 
specialofferid ,
ProductID ,
rowguid  ,
modifiedgate)
SELECT SpecialOfferID,ProductID,rowguid,ModifiedDate
 FROM AdventureWorks2022.Sales.SpecialOfferProduct 
   
   --salesorderdetail
      INSERT INTO  Sales.SalesOrderDetail(
SalesOrderID,
salesorderdetailID,
carriertrackingnumber,
orderqty,
productid,
specialofferid ,
unitprice ,
unitpricediscount,
linetotal,
rowguid,
modifiedgate)
SELECT SalesOrderID,SalesOrderDetailID,CarrierTrackingNumber,OrderQty,ProductID,SpecialOfferID,UnitPrice,UnitPriceDiscount,LineTotal,rowguid,ModifiedDate 
 FROM AdventureWorks2022.Sales.SalesOrderDetail
									   						   
								   --drop database sales
--use master 
--go
--drop database sales

                                --backup
--BACKUP DATABASE sales
--TO DISK = 'C:\bryce\sales.bak

