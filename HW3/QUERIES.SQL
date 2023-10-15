/* Query 1: List names and sellers of products no longer available */
SELECT products.name, merchants.name AS "merchant" FROM products 
	INNER JOIN sell USING(pid) 
		INNER JOIN merchants USING(mid) 
	WHERE sell.quantity_available=0;

/* Query 2: List names and descriptions of products no longer sold */
SELECT name,description FROM products 
	WHERE products.pid NOT IN 
		(SELECT DISTINCT products.pid FROM products INNER JOIN sell USING(pid));

/* Query 3: Find all customers that bought SATA drives but not routers*/
SELECT count(DISTINCT cid) FROM customers 
	INNER JOIN place USING(cid) 
		INNER JOIN orders USING(oid) 
			INNER JOIN contain USING(oid) 
				INNER JOIN products USING(pid)
	WHERE (products.description LIKE "%SATA%") AND cid NOT IN 
		(SELECT DISTINCT cid FROM customers 
			INNER JOIN place USING(cid) 
				INNER JOIN orders USING(oid) 
					INNER JOIN contain USING(oid) 
						INNER JOIN products USING(pid) 
			WHERE name="Router");

/*Query 4: HP has a 20 percent off sale on networking gear*/
UPDATE sell SET price=price*.8 
WHERE mid=(SELECT mid FROM merchants WHERE name="HP") 
	AND pid IN (SELECT pid FROM products WHERE category="Networking");

/*Query Five: What did Uriel Whitney order from ACER?*/
SELECT products.name, products.description, sell.price, place.order_date
FROM customers
	INNER JOIN place USING(cid)
		INNER JOIN orders using(oid)
			INNER join contain USING(oid)
				INNER JOIN products USING(pid)
                INNER JOIN sell USING(pid)
					INNER JOIN merchants USING(mid)
WHERE customers.fullname = "Uriel Whitney" AND merchants.name="ACER"
ORDER BY place.order_date;

/*Query Six: List the annual total sales for each company (sort the results along the company and year attributes)*/
SELECT merchants.name, SUM(sell.price), YEAR(place.order_date)
FROM merchants
	INNER JOIN sell USING(mid)
        INNER JOIN contain USING(pid)
			INNER JOIN place USING(oid)
GROUP BY mid, YEAR(place.order_date)
ORDER BY merchants.name, YEAR(place.order_date);

/*Query Seven: Which company had the highest annual revenue and in what year? */
WITH AnnualSales as
	(SELECT merchants.name, SUM(sell.price) as Total, YEAR(place.order_date) AS Year
	FROM merchants
		INNER JOIN sell USING(mid)
			INNER JOIN contain USING(pid)
				INNER JOIN place USING(oid)
	GROUP BY mid, YEAR(place.order_date)
	ORDER BY merchants.name, YEAR(place.order_date) )
SELECT * FROM AnnualSales
WHERE Total = (SELECT MAX(Total) FROM AnnualSales);

/*Query 8: On average, what was the cheapest shipping method used ever?*/
WITH ShippingMethods AS
	(SELECT shipping_method, AVG(shipping_cost) as "AvgCost" 
    FROM orders GROUP BY shipping_method)
SELECT * FROM ShippingMethods
WHERE AvgCost = (SELECT MIN(AvgCost) FROM ShippingMethods);

/*Query 9: What is the best sold category for each company? */
WITH SalesByMerchantAndCategory AS 
	(SELECT merchants.name AS Merchant, products.category, SUM(sell.price) AS Sales
	FROM merchants
		INNER JOIN sell USING(mid)
			INNER JOIN products USING(pid)
            INNER JOIN contain USING(pid)
				INNER JOIN place USING(oid)
	GROUP BY merchants.name, products.category) 
SELECT Merchant, category, Sales FROM SalesByMerchantAndCategory AS SBMC
WHERE Sales = (SELECT MAX(Sales) FROM SalesByMerchantAndCategory WHERE Merchant=SBMC.Merchant);

