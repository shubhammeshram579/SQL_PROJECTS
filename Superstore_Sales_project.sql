use portpolio

/*SELECT the dataset for Superstore_sales*/

SELECT * FROM Superstore_sales$

/*check data shape of counts*/
SELECT count(*) FROM Superstore_sales$

/*add new year column*/
alter table Superstore_sales$
add Year numeric

/* extract year in oredr_date columns*/
update Superstore_sales$
set Year = year(ORDER_Date)

/* find the top 10 sales most ORDERing date*/
SELECT top 10 ORDER_Date,round(sum(Sales),2) as Total_sales
FROM Superstore_sales$
GROUP by ORDER_Date
ORDER by Total_sales desc

/* year wise sales*/
SELECT Year,round(sum(Sales),2) as Total_sales
FROM Superstore_sales$
GROUP by Year
ORDER by Total_sales


/*Ship mode wise sales*/
SELECT Ship_Mode,round(sum(Sales),2) as Total_Sales
FROM Superstore_sales$
GROUP by Ship_Mode
ORDER by Total_Sales desc

/* find the top 10 whitch cities are most sales*/
SELECT top 10 City ,round(sum(Sales),2) as Total_Sales
FROM Superstore_sales$
GROUP by City
ORDER by Total_Sales desc

/*find the top 10 customer names most sales in new york city*/
SELECT  top 10 City,Customer_Name,round(sum(Sales),2) as Total_Sales
FROM Superstore_sales$
WHERE City like 'New York City'
GROUP by City,Customer_Name
ORDER by Total_Sales desc


/* find the top 10 whitch states are most sales*/
SELECT top 10 State ,round(sum(Sales),2) as Total_Sales
FROM Superstore_sales$
GROUP by State
ORDER by Total_Sales desc

/*find the top 10 customer names most sales in Califonrnia state*/
SELECT  top 10 State,Customer_Name,round(sum(Sales),2) as Total_Sales
FROM Superstore_sales$
WHERE state like 'California'
GROUP by state,Customer_Name
ORDER by Total_Sales desc


/* Region wise sales */
SELECT Region ,round(sum(Sales),2) as Total_Sales
FROM Superstore_sales$
GROUP by Region
ORDER by Total_Sales desc


/* find the west side top 5 customer name most highst sales*/
SELECT top 5 Customer_Name,Sum(Sales) as Total_Sales
FROM Superstore_sales$
WHERE Region like 'West'
GROUP by Customer_Name
ORDER by Total_Sales desc


/*find the most saling product catogory ,sub_category and product_name*/

SELECT Category,sum(Sales) as Total_Sales
FROM Superstore_sales$
GROUP by Category
ORDER by Total_Sales desc

SELECT Sub_Category,sum(Sales) as Total_Sales
FROM Superstore_sales$
WHERE Category = 'Technology'
GROUP by Sub_Category
ORDER by Total_Sales desc

/*find the top 5 phones mostly sales*/
SELECT top 5 Product_Name,sum(Sales) as Total_Sales
FROM Superstore_sales$
WHERE Sub_Category = 'Phones'
GROUP by Product_Name
ORDER by Total_Sales desc

/* check the year wise sales sumsung mobile*/
SELECT Year,Product_Name,sum(Sales) as Total_Sales
FROM Superstore_sales$
WHERE Product_Name = 'Samsung Galaxy Mega 6.3'
GROUP by Year,Product_Name
ORDER by Total_Sales desc



/*part two*/
/*SELECT * ,CAST(ORDER_Date AS DATE) as new_ORDER_date
FROM Superstore_sales$*/

SELECT * FROM Superstore_sales$

/* create new column as ORDERdate*/
alter table Superstore_sales$
add Oredr_date_new Date

/*update new column ORDER change the ORDER date formate*/
update Superstore_sales$
set Oredr_date_new = CAST(ORDER_Date AS DATE)


/* SELECT the finacial year 2018 dataset*/
SELECT * FROM Superstore_sales$
WHERE Year like 2018

/*check shape dataset count*/
SELECT count(*) FROM Superstore_sales$
WHERE Year like 2018



/*find the top 10 ORDER date wise mostly sales */

SELECT top 10 ORDER_Date, max(Sales) as most_ORDER_sales
FROM Superstore_sales$
WHERE Year = 2018
GROUP by ORDER_Date
ORDER by most_ORDER_sales desc


/* find the top 5 most importance data for most saling product or city state, and more*/
SELECT  top 5 ORDER_Date,Segment,Customer_Name,City,State,Region,Category,Sub_Category,sum(Sales) as total_sales
FROM Superstore_sales$
WHERE Year = 2018
GROUP by ORDER_Date,Segment,Customer_Name,City,State,Region,Category,Sub_Category
ORDER by total_sales desc


/* find the top 5 most saling product names*/
SELECT top 5 Product_Name ,sum(Sales) Total_Sales
FROM Superstore_sales$
WHERE Year like 2018
GROUP by Product_Name
ORDER by Total_Sales desc


/* top 10 pruduct details category, sub-category,product_name*/
SELECT top 10 Category,Sub_Category,Product_Name,sum(Sales) Total_Sales
FROM Superstore_sales$
WHERE Year like 2018
GROUP by Category,Sub_Category,Product_Name
ORDER by Total_Sales desc