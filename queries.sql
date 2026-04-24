-- ============================================
-- Mint Classics Inventory Optimization Analysis
-- Author: Deepak Das
-- Description: SQL analysis to identify overstocking,
-- demand patterns, and inventory inefficiencies
-- ============================================

USE mintclassics;

-- STEP 1: Identify Products with Highest Inventory (Overstock Risk)
SELECT
    productName,
    quantityInStock
FROM products
ORDER BY quantityInStock DESC;

-- STEP 2: Analyze Sales Performance by Product
SELECT
    p.productName,
    SUM(od.quantityOrdered) AS total_sold
FROM products p
JOIN orderdetails od
   ON p.productCode = od.productCode
GROUP BY p.productName
ORDER BY total_sold DESC;

-- STEP 3: Compare Inventory vs Sales (Demand Alignment)
SELECT
    p.productName,
    p.quantityInStock,
    SUM(od.quantityOrdered) AS total_sold
FROM products p
JOIN orderdetails od
   ON p.productCode = od.productCode
GROUP BY p.productName, p.quantityInStock
ORDER BY P.quantityInStock DESC;

-- STEP 4: Detect Overstocked and Understocked Products
SELECT
    productline,
    COUNT(*) AS total_products,
    SUM(quantityInStock) AS total_inventory
FROM products
GROUP BY productline
ORDER BY total_inventory DESC;

-- STEP 5: Identify Top-Selling Products (Revenue Drivers)
SELECT
    p.productName,
    p.quantityInStock,
    IFNULL(SUM(od.quantityOrdered), 0) AS total_sold
FROM products p
LEFT JOIN orderdetails od
    ON p.productCode = od.productCode
WHERE productline = 'Classic Cars'
GROUP BY productName, quantityInStock
ORDER BY quantityInStock DESC;

-- STEP 6: Warehouse-wise Inventory Distribution
SELECT
    warehouseCode,
    SUM(quantityInStock) AS total_inventory
FROM products
GROUP BY warehouseCode
ORDER BY total_inventory DESC;
