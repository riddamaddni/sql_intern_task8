DELIMITER $$
CREATE PROCEDURE sp_TotalSalesByRep(IN p_rep_id INT)
BEGIN
  SELECT r.rep_id, CONCAT(r.first_name, ' ', r.last_name) AS rep_name,
         SUM(o.total_amount) AS total_sales
  FROM SalesOrders o
  JOIN SalesReps r ON o.rep_id = r.rep_id
  WHERE o.rep_id = p_rep_id
  GROUP BY r.rep_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_UpdateProductPrice(
  IN p_product_id INT,
  IN p_new_price DECIMAL(10,2),
  OUT p_old_price DECIMAL(10,2)
)
BEGIN
  SELECT price INTO p_old_price FROM Products WHERE product_id = p_product_id;
  UPDATE Products SET price = p_new_price WHERE product_id = p_product_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_OrdersByCustomer(IN p_customer_id INT)
BEGIN
  SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
  FROM SalesOrders o
  JOIN Customers c ON o.customer_id = c.customer_id
  WHERE o.customer_id = p_customer_id
  ORDER BY o.order_date;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_SalesByManufacturer(IN p_manufacturer_id INT)
BEGIN
  SELECT m.manufacturer_name, SUM(oi.quantity * oi.unit_price) AS total_sales
  FROM Manufacturers m
  JOIN Products p ON m.manufacturer_id = p.manufacturer_id
  JOIN OrderItems oi ON p.product_id = oi.product_id
  WHERE m.manufacturer_id = p_manufacturer_id
  GROUP BY m.manufacturer_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_SalesSummaryByRegion()
BEGIN
  SELECT r.region, SUM(o.total_amount) AS total_sales
  FROM SalesOrders o
  JOIN SalesReps r ON o.rep_id = r.rep_id
  GROUP BY r.region;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_TotalRevenue()
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  RETURN (SELECT SUM(total_amount) FROM SalesOrders);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_RevenueByRep(p_rep INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  RETURN (SELECT SUM(total_amount) FROM SalesOrders WHERE rep_id = p_rep);
END$$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION fn_AvgOrderValue()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN (SELECT ROUND(AVG(total_amount),2) FROM SalesOrders);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_ProductRevenue(p_product INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  RETURN (SELECT SUM(quantity * unit_price)
          FROM OrderItems WHERE product_id = p_product);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_OrderItemTotal(p_order_item INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN (SELECT quantity * unit_price FROM OrderItems WHERE order_item_id = p_order_item);
END$$
DELIMITER ;

-- 1. Total sales for rep 104
CALL sp_TotalSalesByRep(104);

-- 2. Total sales for rep 102
CALL sp_TotalSalesByRep(102);

-- 3. Update product price for Product 1
CALL sp_UpdateProductPrice(1, 55.00, @old_price1);
SELECT @old_price1 AS old_price_before_update;

-- 4. List all orders placed by customer 1001
CALL sp_OrdersByCustomer(1001);

-- 5. Orders for customer 1003
CALL sp_OrdersByCustomer(1003);

-- 6. Sales by manufacturer 1 (MediGen)
CALL sp_SalesByManufacturer(1);

-- 7. Sales by manufacturer 2 (PharmaCore)
CALL sp_SalesByManufacturer(2);

-- 8. Region-wise sales summary
CALL sp_SalesSummaryByRegion();

-- 9. Total revenue (function)
SELECT fn_TotalRevenue() AS total_revenue;

-- 10. Revenue by rep 103
SELECT fn_RevenueByRep(103) AS revenue_rep103;

-- 11. Average order value
SELECT fn_AvgOrderValue() AS avg_order_value;

-- 12. Product 2 revenue (Amoxicillin)
SELECT fn_ProductRevenue(2) AS product2_revenue;

-- 13. Product 8 revenue (Vitamin C)
SELECT fn_ProductRevenue(8) AS product8_revenue;

-- 14. Order item 1 total value
SELECT fn_OrderItemTotal(1) AS order_item1_total;

-- 15. Order item 5 total
SELECT fn_OrderItemTotal(5) AS order_item5_total;

-- 16. Compare rep 104 vs 102 revenue
SELECT fn_RevenueByRep(104) AS rep104_rev, fn_RevenueByRep(102) AS rep102_rev;

-- 17. Display customer orders with total
CALL sp_OrdersByCustomer(1002);

-- 18. Use function result in condition
SELECT IF(fn_TotalRevenue() > 200000, 'High', 'Low') AS sales_status;

-- 19. Find top product sales using function
SELECT product_id, fn_ProductRevenue(product_id) AS total_rev FROM Products ORDER BY total_rev DESC;

-- 20. Use OUT proc to update and verify new price
CALL sp_UpdateProductPrice(5, 75.00, @old_price5);
SELECT @old_price5 AS old_price_before_update;

-- 21. Check rep 105 total sales via proc
CALL sp_TotalSalesByRep(105);

-- 22. Validate total revenue from SalesOrders = fn_TotalRevenue
SELECT SUM(total_amount) AS manual_total, fn_TotalRevenue() AS func_total FROM SalesOrders;

-- 23. Region summary for performance comparison
CALL sp_SalesSummaryByRegion();

-- 24. Get rep with max revenue
SELECT rep_id, fn_RevenueByRep(rep_id) AS revenue FROM SalesReps ORDER BY revenue DESC LIMIT 1;

-- 25. Highest revenue product
SELECT product_id, fn_ProductRevenue(product_id) AS revenue FROM Products ORDER BY revenue DESC LIMIT 1;

-- 26. Revenue check per manufacturer 3
CALL sp_SalesByManufacturer(3);

-- 27. Use function in WHERE clause
SELECT product_name, fn_ProductRevenue(product_id) AS revenue
FROM Products WHERE fn_ProductRevenue(product_id) > 10000;

-- 28. Loop testing: Annual simulation (rep 102)
CALL sp_TotalSalesByRep(102);

-- 29. Quick check for avg order
SELECT fn_AvgOrderValue() AS avg_order;

-- 30. Final report combining functions
SELECT fn_TotalRevenue() AS total_rev, fn_AvgOrderValue() AS avg_val;
