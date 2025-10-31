
---

## 🧾 `Practice_Explanation.md`

```markdown
# 🧾 Practice Explanation – Task 8 (PharmaPlus)

---

## 🔍 Overview
This exercise involved implementing and testing **ten stored routines** (five procedures and five functions) inside the **PharmaPlus** database.  
The routines automate business reporting for pharmaceutical product sales and regional performance.  

---

## ⚙️ Design Approach
- Used clear, consistent naming conventions (`sp_` and `fn_`).  
- Focused on **business-oriented logic**: sales tracking, revenue, and pricing.  
- Each procedure targets one practical scenario, such as updating prices or retrieving sales data by region.  

---

## 🧩 Logic Summary

### Procedures
1. **sp_TotalSalesByRep** – Aggregates total sales for a single sales representative.  
2. **sp_UpdateProductPrice** – Updates a product’s price and outputs its previous amount.  
3. **sp_OrdersByCustomer** – Lists all sales orders linked to a given customer ID.  
4. **sp_SalesByManufacturer** – Joins manufacturers → products → orders → items to compute manufacturer revenue.  
5. **sp_SalesSummaryByRegion** – Groups total order amounts by rep region for summary reporting.  

### Functions
1. **fn_TotalRevenue** – Returns company-wide total order value.  
2. **fn_RevenueByRep** – Computes total revenue handled by one rep.  
3. **fn_AvgOrderValue** – Calculates the mean of all order totals.  
4. **fn_ProductRevenue** – Determines the total income generated from a product.  
5. **fn_OrderItemTotal** – Calculates `quantity × unit_price` for a specific order item.  

---

## 💡 Concepts Demonstrated
- **Parameter handling:** IN/OUT usage to pass and return data.  
- **Mathematical aggregation:** `SUM()`, `AVG()`, and grouping.  
- **Join operations:** Combining related data across five tables.  
- **Data reusability:** Functions reused in multiple analytical queries.  
- **Result validation:** Compared manual aggregates with function outputs.  

---

## 🧪 Example Tests
```sql
CALL sp_TotalSalesByRep(103);
CALL sp_OrdersByCustomer(1001);
SELECT fn_ProductRevenue(2);
CALL sp_SalesByManufacturer(1);
SELECT fn_TotalRevenue(), fn_AvgOrderValue();
