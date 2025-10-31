# 💊 Task 8 – Working with Stored Procedures and Functions in PharmaPlus

### Internship Program – SQL Development & Database Operations  
**Database:** PharmaPlus  
**Focus:** Understanding procedural SQL and user-defined functions  
**Date:** October 31 2025   

---

## 🎯 Aim of the Task
The goal of this exercise was to **learn modular SQL programming** using stored procedures and functions inside a realistic business database.  
The **PharmaPlus** schema models a pharmaceutical company dealing with manufacturers, sales representatives, customers, and product orders.  

By completing this task, I gained practical experience in:
- Automating business calculations
- Reusing logic through stored routines
- Returning dynamic results using parameters and functions  

---

## 🧠 Key Learning Areas
- Creation and execution of stored procedures (`CREATE PROCEDURE`, `CALL`)  
- Creation and usage of user-defined functions (`CREATE FUNCTION`, `SELECT fn_name()`)  
- Applying **IN**, **OUT**, and **RETURN** parameters  
- Using joins and aggregations to compute results  
- Structuring SQL code for maintainability and scalability  

---

## 🧩 Routines Implemented

### Stored Procedures
| Name | Purpose |
|------|----------|
| **sp_TotalSalesByRep** | Displays each representative’s total sales volume |
| **sp_UpdateProductPrice** | Updates a product’s price and reports its previous value |
| **sp_OrdersByCustomer** | Lists orders placed by any given customer |
| **sp_SalesByManufacturer** | Calculates manufacturer-wise revenue |
| **sp_SalesSummaryByRegion** | Summarizes regional sales handled by all reps |

### Functions
| Name | Purpose |
|------|----------|
| **fn_TotalRevenue** | Returns company-wide total sales |
| **fn_RevenueByRep** | Returns sales made by a particular representative |
| **fn_AvgOrderValue** | Finds the average order size |
| **fn_ProductRevenue** | Calculates total revenue from a product |
| **fn_OrderItemTotal** | Computes quantity × unit price for a specific order item |

---

## 🧪 Example Execution
```sql
CALL sp_TotalSalesByRep(103);
CALL sp_UpdateProductPrice(4, 260.00, @old_price);
SELECT fn_ProductRevenue(2);
SELECT fn_TotalRevenue(), fn_AvgOrderValue();
