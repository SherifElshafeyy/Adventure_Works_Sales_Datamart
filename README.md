# Project Documentation: AdventureWorks Sales Datamart

---

## 1. Introduction

This project involves converting the **AdventureWorks OLTP database** into a **Sales Datamart** using **dimensional modeling principles**. The datamart is designed to support sales analysis and reporting. It includes the creation of dimension tables (`dim_Customer`, `dim_Territory`, `dim_Product`, `dim_Date`) and a central fact table (`Fact_Sales`).

The ETL process is implemented using **Informatica PowerCenter**, ensuring accurate and efficient data loading. This documentation provides a comprehensive overview of the schema design, ETL process, mappings, challenges, and future enhancements.

---

## 2. Why Create a Datamart?

A **datamart** is a subset of a data warehouse, focused on a specific business function (e.g., sales, finance, marketing). It is designed to support analytical queries and reporting, unlike an **OLTP (Online Transaction Processing)** system, which is optimized for transactional operations.

### Advantages of a Datamart Over OLTP Design

1. **Optimized for Analytics**:
   - OLTP systems are designed for fast transaction processing (e.g., inserting, updating, deleting records), which makes them inefficient for complex analytical queries.
   - A datamart is optimized for **read-heavy operations**, enabling faster and more efficient reporting and analysis.

2. **Simplified Data Model**:
   - OLTP systems often have a **normalized schema** (e.g., 3NF) to reduce redundancy and ensure data integrity. This makes queries complex and slow for analytical purposes.
   - A datamart uses a **dimensional model** (e.g., star schema), which simplifies queries and improves performance for reporting.

3. **Historical Data Tracking**:
   - OLTP systems typically store only the current state of data, making it difficult to track historical changes.
   - A datamart supports **Slowly Changing Dimensions (SCD)**, enabling historical data analysis and trend identification.

4. **Improved Performance**:
   - OLTP systems are not designed for large-scale aggregations or joins, which are common in analytical queries.
   - A datamart pre-aggregates and organizes data, reducing query execution time and improving performance.

5. **Business-Focused**:
   - A datamart is tailored to the needs of a specific business function (e.g., sales), providing relevant and actionable insights.
   - OLTP systems are generic and not optimized for specific business use cases.

6. **Data Integration**:
   - A datamart integrates data from multiple sources (e.g., OLTP systems, external data) into a single, unified view.
   - OLTP systems are typically isolated and do not support cross-functional data integration.

---

## 3. Schema Design

The datamart follows a **star schema** design, with one central fact table (`Fact_Sales`) and multiple dimension tables.





### Data Warehouse (DWH) Schema

Below is the schema diagram for the **Data Warehouse (DWH)**:

![DWH Schema](Images\Sales_Datamart_Schema.png)  
*Figure 1: Data Warehouse (DWH) Schema*

### Dimension Tables

| **Table**         | **Description**                                                                 | **Key Fields**                                                                 |
|--------------------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| `dim_Customer`     | Tracks customer information, including name, address, and contact details.      | `customer_key`, `customer_id`, `customer_name`, `address`, `start_date`, etc. |
| `dim_Territory`    | Stores sales territory information, including region and country.               | `territory_key`, `territory_id`, `territory_name`, `territory_country`, etc.  |
| `dim_Product`      | Contains product details, such as name, category, and cost.                     | `product_key`, `product_id`, `product_name`, `product_category`, etc.         |
| `dim_Date`         | Provides time-based context for sales transactions.                             | `date_key`, `date`, `year`, `quarter`, `month`, etc.                          |

### Fact Table

| **Table**         | **Description**                                                                 | **Key Fields**                                                                 |
|--------------------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| `Fact_Sales`       | Tracks sales transactions, including quantities, prices, and costs.             | `sales_key`, `customer_key`, `territory_key`, `product_key`, `order_date_key`, etc. |

---

## 4. ETL Process

The ETL process extracts data from the **AdventureWorks OLTP database**, transforms it using **Informatica PowerCenter**, and loads it into the datamart.

### Key Steps

1. **Extraction**:
   - Data is extracted from source tables (e.g., `Sales.SalesOrderHeader`, `Sales.SalesOrderDetail`, `Person.Person`).
   - **Incremental loading** is implemented using a mapping variable (`$$last_order_date`) to fetch only new or updated records.

2. **Transformation**:
   - Data is cleaned, enriched, and transformed using **Expression**, **Joiner**, and **Lookup** transformations.
   - **SCD Type 2 logic** is applied to track historical changes in dimension tables.

3. **Loading**:
   - Transformed data is loaded into the target tables (`dim_Customer`, `dim_Territory`, `dim_Product`, `dim_Date`, `Fact_Sales`).

---

## 5. Mappings

The project includes several mappings to load data into the dimension and fact tables. Below are the key mappings:

### M_Dim_Customer

- **Purpose**: Loads data into the `dim_Customer` table.
- **Source Tables**: `Customer_Source`, `Customer_lookup`.
- **Key Transformations**:
  - **Expression Transformation**: Combines `FirstName`, `MiddleName`, and `LastName` to create `customer_name`.
  - **Lookup Transformation**: Fetches existing customer records from `dim_Customer`.
  - **Router Transformation**: Routes rows for insertion or update based on changes detected using an **MD5 hash**.
  - **Update Strategy Transformation**: Updates existing records and inserts new records.

![M_Dim_Customer Mapping](Images\M_Dim_Customer.png)  
*Figure 2: M_Dim_Customer Mapping Diagram*

---

### M_Dim_Territory

- **Purpose**: Loads data into the `dim_Territory` table.
- **Source Tables**: `Sales.SalesTerritory`, `lookup_country`.
- **Key Transformations**:
  - **Lookup Transformation (LKP_Country)**: Enriches territory data with country and region information.
  - **Expression Transformation (EXPTRANS)**: Prepares data for loading.
  - **Update Strategy Transformation (UPDTRANS)**: Determines whether to insert or reject records.

![M_Dim_Territory Mapping](Images\M_Dim_Territiry.png)  
*Figure 3: M_Dim_Territory Mapping Diagram*

---

### M_Dim_Product

- **Purpose**: Loads data into the `dim_Product` table.
- **Source Tables**: `Product`, `model_description`, `subcategory_category`.
- **Key Transformations**:
  - **Expression Transformation**: Handles data cleansing and default value assignments.
  - **Lookup Transformation**: Fetches product model descriptions and category information.
  - **Update Strategy Transformation**: Implements **SCD Type 2 logic** to track historical changes.

![M_Dim_Product Mapping](Images\M_Dim_Product.png)  
*Figure 4: M_Dim_Product Mapping Diagram*

---

### M_Dim_Date

- **Purpose**: Loads data into the `dim_Date` table.
- **Source**: Flat file (`dim_date_table`) or date generation logic.
- **Key Transformations**:
  - **Expression Transformation**: Derives time-based attributes (e.g., year, quarter, month, week, day).
  - **Lookup Transformation**: Checks if a date already exists in `dim_Date`.
  - **Update Strategy Transformation**: Inserts new records if they do not already exist.

![M_Dim_Date Mapping](Images\M_Dim_Date.png)  
*Figure 5: M_Dim_Date Mapping Diagram*

---

### M_Fact_Sales

- **Purpose**: Loads data into the `Fact_Sales` table.
- **Source Tables**: `Sales.SalesOrderHeader`, `Sales.SalesOrderDetail`.
- **Key Transformations**:
  - **Joiner Transformation**: Combines data from `SalesOrderHeader` and `SalesOrderDetail` on `SalesOrderID`.
  - **Lookup Transformation**: Fetches surrogate keys from dimension tables (`dim_Customer`, `dim_Territory`, `dim_Product`, `dim_Date`).
  - **Expression Transformation**: Calculates derived facts (e.g., `extended_sales`, `extended_cost`).

![M_Fact_Sales Mapping](Images\M_Fact_Slaes.png)  
*Figure 6: M_Fact_Sales Mapping Diagram*

---

## 6. Challenges and Solutions

1. **Incremental Loading**:
   - **Challenge**: Loading only new or updated records from large source tables.
   - **Solution**: Implemented incremental loading using a mapping variable (`$$last_order_date`) to track the last modified date.

2. **SCD Type 2 Implementation**:
   - **Challenge**: Tracking historical changes in dimension tables.
   - **Solution**: Used **MD5 hash comparison** to detect changes and applied **Update Strategy Transformation** to handle inserts and updates.

---

## 7. Future Enhancements

1. **Add More Dimensions**:
   - Include additional dimensions (e.g., `dim_Employee`, `dim_Promotion`) to support more granular analysis.

2. **Enhance Reporting**:
   - Create additional reports and dashboards using tools like **Power BI** or **Tableau**.

---

## 8. Conclusion

The **AdventureWorks Sales Datamart** project successfully transforms OLTP data into a dimensional model optimized for sales analysis. The ETL process, implemented using **Informatica PowerCenter**, ensures accurate and efficient data loading. This documentation provides a comprehensive overview of the schema design, ETL process, mappings, challenges, and future enhancements.

---