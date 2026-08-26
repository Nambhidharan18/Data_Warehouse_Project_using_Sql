# SQL Data Warehouse Project

## 1. Project Description

A modern data warehouse built using **SQL Server** to integrate data from multiple source systems, clean and transform raw data, implement automated ETL pipelines, and create a structured analytical data model. The project provides a centralized and reliable foundation for data analysis and reporting.

---

## 2. Project Overview

This project focuses on building a centralized data warehouse using SQL Server to transform raw source data into a clean, structured, and analysis-ready format.

### Key Highlights

* Built a data warehouse using **SQL Server**
* Created **Bronze**, **Silver** and **Gold** layers
* Implemented **ETL pipelines** for data extraction, transformation, and loading
* Cleaned and transformed raw data from multiple source systems
* Performed **data quality validation** to ensure data consistency and integrity
* Created **fact and dimension tables** using a dimensional data model
* Prepared the warehouse for SQL-based analytical and reporting workloads

---

## 3. Business Problem

In companies without centralized data management, data analysts often need to manually extract data from multiple source systems and spend days or weeks transforming raw data into meaningful reports. These reports may be distributed across isolated Excel sheets, PowerPoint presentations, or Power BI files.

This manual approach is **inefficient, time-consuming, and prone to human error**. Since reports may also be refreshed at different times, stakeholders can end up working with inconsistent and outdated information. For example, one report may contain data that is 40 days old, while another may be based on data from only 10 or 5 days ago. This makes consistent and accurate decision-making difficult.

Working with large datasets manually also becomes impractical, while combining data from different source systems can introduce additional complexity and risk.

To address these challenges, this project implements a **Data Warehouse as a centralized single source of truth**. An ETL process is used to extract raw data from **CRM and ERP systems**, clean and transform the data, integrate information from multiple sources, and load it into a structured warehouse.

This centralized approach provides a consistent and organized foundation for downstream analysis and reporting, while supporting historical data and reducing the reliance on repetitive manual data preparation.

---

## 4. Project Objectives

The main objectives of this project are:

1. Consolidate data from multiple source systems.
2. Clean and standardize raw data.
3. Build an ETL process for extracting, transforming, and loading data.
4. Implement a layered data warehouse architecture.
5. Design a star schema for analytical workloads.
6. Validate data quality and integrity.
7. Enable SQL-based business analysis.

---

## 5. Technology Stack

| Category        | Technology                                        |
| --------------- | ------------------------------------------------- |
| Database        | **SQL Server**                                    |
| Query Language  | **T-SQL**                                         |
| ETL             | **SQL / Stored Procedures**                       |
| Data Modeling   | **Star Schema**                                   |
| Architecture    | **Medallion Architecture (Bronze, Silver, Gold)** |
| Documentation   | **Markdown / Draw.io** **/ ChatGPT**              |
| Version Control | **Git / GitHub**                                  |

---

## 6. Data Architecture

It is a **Medallion Architecture** consisting of three layers: **Bronze, Silver, and Gold**.

<!-- Replace with your Data Architecture image -->

![Data Architecture](docs/images/data_architecture.png)

### Bronze Layer

The Bronze layer stores the raw data as received from the source systems. Data is loaded with minimal transformation to preserve the original source data for further processing.

### Silver Layer

The Silver layer contains cleaned and transformed data. Data quality issues are addressed, formats are standardized, and information from different source systems is integrated.

### Gold Layer

The Gold layer contains the final, business-ready data model. It consists of fact and dimension tables designed for analytical queries and reporting.

---

## 7. Data Flow and Integration

### Data Sources

The project integrates data from two source systems: **CRM (Customer Relationship Management)** and **ERP (Enterprise Resource Planning)** systems.

<!-- Replace with your Data Sources image -->

![Data Sources](docs/images/data_sources.png)

#### CRM System

The CRM system provides sales, customer, and product information through three source files:

* `crm_sales_details` — Sales transaction details
* `crm_cust_info` — Customer information
* `crm_prd_info` — Product information

#### ERP System

The ERP system provides additional customer, location, and product information through three source files:

* `erp_cust_az12` — Additional customer information, including birthdate
* `erp_loc_a101` — Customer location information, including country
* `erp_px_cat_g1v2` — Product category and subcategory information

### Data Flow

<!-- Replace with your Data Flow image -->

![Data Flow](docs/images/data_flow.png)

Data flows from the **CRM and ERP source systems** through the three warehouse layers:

```text
CRM + ERP Sources
       ↓
   Bronze Layer
       ↓
   Silver Layer
       ↓
    Gold Layer
```

The Bronze layer stores the extracted source data, the Silver layer performs cleansing and integration, and the Gold layer contains the final analytical model.

### Data Integration

The CRM and ERP systems contain complementary information that must be integrated to create a complete view of customers and products.

The `crm_sales_details` file contains `prd_id` and `cst_id`, which are used to connect sales transactions with the corresponding product and customer information.

* `crm_sales_details.cst_id` → `crm_cust_info.cst_id`
* `crm_sales_details.prd_id` → `crm_prd_info.prd_id`
* `crm_cust_info.cst_id` → `erp_cust_az12.cid`
* `crm_cust_info.cst_id` → `erp_loc_a101.cid`
* `crm_prd_info.prd_id` → `erp_px_cat_g1v2.id`

Through these relationships, additional ERP information such as **customer birthdate, country, product category, and product subcategory** is integrated with the CRM sales, customer, and product data.

---

## 8. ETL Process

<!-- Replace with your ETL Process image -->

![ETL Process](docs/images/etl_process.png)

The ETL pipeline extracts data from the source CSV files, processes it through the Bronze and Silver layers, and loads the transformed data into the Gold layer.

The main characteristics of the ETL process are:

| Process                  | Implementation                                                                                                                   |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Extraction Method**    | **Pull Extraction (Receiver-Driven)** — Initiated by the database through stored procedures from CSV sources.                    |
| **Extraction Type**      | **Full Extract (Full Refresh)** — The complete source CSV file is processed during each run.                                     |
| **Extraction Technique** | **Automated File Parsing** — Uses `BULK INSERT` for programmatic loading into SQL staging structures.                            |
| **Processing Type**      | **Batch Processing** — Data is processed as a batch rather than in real time.                                                    |
| **Transformation**       | **Multi-Stage Enrichment & Logic** — Includes cleansing, normalization, integration, aggregation, and business-rule application. |
| **Load Method**          | **Full Load (Truncate & Insert)** — Target data is cleared before the transformed dataset is inserted.                           |
| **SCD Type**             | **SCD Type 1 (Overwrite)** — Existing values are overwritten with the latest available information.                              |

The complete ETL implementation, including extraction, transformation, validation, and loading details, is documented separately.

**[Read More → ETL Process Documentation](docs/etl_process.md)**

---

## 9. Data Modeling

The Gold layer uses a **Star Schema** to organize the analytical data.

<!-- Replace with your Data Modeling image -->

![Data Model](docs/images/data_model.png)

The model consists of one central fact table and two dimension tables:

* **`fact_sales`** — Stores sales transaction measures and references the related dimensions.
* **`dim_customers`** — Contains descriptive customer information.
* **`dim_products`** — Contains descriptive product information.

The fact table connects to the dimension tables using surrogate keys:

```text
dim_customers
      │
customer_key
      │
      ▼
  fact_sales
      ▲
product_key
      │
      │
dim_products
```

The remaining columns in `fact_sales` describe the sales transaction:

| Column          | Description                           |
| --------------- | ------------------------------------- |
| `order_number`  | Unique identifier for the sales order |
| `order_date`    | Date when the order was placed        |
| `shipping_date` | Date when the order was shipped       |
| `due_date`      | Expected delivery/due date            |
| `sales_amount`  | Total sales amount                    |
| `quantity`      | Number of products sold               |
| `price`         | Product price                         |

This structure separates **transactional measures** from **descriptive attributes**, making the Gold layer suitable for analytical queries and reporting.

---

## 10. Fact Table Grain

The **grain** defines exactly what one row in the fact table represents.

> **One row represents a discrete sales transaction for a specific product purchased by a specific customer on a specific date.**

Defining the grain before designing the fact table ensures that the measures and dimensions are stored at the correct level of detail and prevents ambiguity when performing aggregations and analysis.

---

## 11. Data Catalog

A detailed data catalog has been created to document the datasets, tables, columns, data types, and descriptions used throughout the project.

Below is a snapshot of the **`fact_sales`** table.

**Purpose:** Stores transactional sales data for analytical purposes.

| Column Name     | Data Type    | Description                                                                                   |
| --------------- | ------------ | --------------------------------------------------------------------------------------------- |
| `order_number`  | NVARCHAR(50) | A unique alphanumeric identifier for each sales order (e.g., `SO54496`).                      |
| `product_key`   | INT          | Surrogate key linking the order to the product dimension table.                               |
| `customer_key`  | INT          | Surrogate key linking the order to the customer dimension table.                              |
| `order_date`    | DATE         | The date when the order was placed.                                                           |
| `shipping_date` | DATE         | The date when the order was shipped to the customer.                                          |
| `due_date`      | DATE         | The date when the order payment was due.                                                      |
| `sales_amount`  | INT          | The total monetary value of the sale for the line item, in whole currency units (e.g., `25`). |
| `quantity`      | INT          | The number of units of the product ordered for the line item (e.g., `1`).                     |
| `price`         | INT          | The price per unit of the product for the line item, in whole currency units (e.g., `25`).    |

The complete data catalog, including detailed information about the remaining tables and columns, is available in the project documentation.

**[Read More → Full Data Catalog](docs/data_catalog.md)**

---

## 12. Data Quality

Data quality checks were performed at both the **Silver** and **Gold** layers to ensure the data is reliable and suitable for analytical use.

### Silver Layer

The Silver layer focuses on validating and improving **data consistency, accuracy, and standardization** after the raw data is loaded from the source systems.

The checks include:

* Null or duplicate primary keys.
* Unwanted spaces in string fields.
* Data standardization and consistency.
* Invalid date ranges and date orders.
* Data consistency between related fields.

### Gold Layer

The Gold layer focuses on validating the **integrity, consistency, and accuracy** of the final analytical data model.

The checks ensure:

* Uniqueness of surrogate keys in dimension tables.
* Referential integrity between fact and dimension tables.
* Validation of relationships in the data model for analytical purposes.

The complete data quality test scripts can be found in the **`tests/`** folder.

**[View Data Quality Tests →](tests/)**

---

## 13. Project Structure

```text
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file showing different ETL techniques and methods
│   ├── ETL_Overview.md                 # Consistent Details about Extraction, Transform and Load performed
|   ├── data_architecture.drawio        # Draw.io file showing the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for the data model (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and data quality checks
│
├── README.md                           # Project overview
```

---

## 14. Limitations

Although this project demonstrates the core concepts of building a data warehouse and implementing an ETL pipeline, it has several limitations compared with a production-level enterprise data warehouse:

* **Static source data:** The project uses CSV files as source systems rather than live CRM and ERP databases.
* **Full refresh loading:** The ETL process uses a full extraction and full load approach, which may not be efficient for very large datasets.
* **Batch processing:** Data is processed in batches rather than through real-time or near-real-time pipelines.
* **SCD Type 1:** Dimension changes overwrite existing values, so historical changes to dimension attributes are not preserved.
* **Manual execution:** The ETL process is not connected to a production scheduler or orchestration platform.
* **Limited scale:** The project is designed as a portfolio and learning project and has not been optimized for enterprise-scale data volumes.
* **Limited monitoring:** Production-level monitoring, alerting, and centralized ETL logging have not been implemented.

These limitations provide opportunities to extend the project toward a more production-oriented data warehouse solution.

---

## 15. Future Improvements

The project can be further enhanced with the following improvements:

* Implement **incremental data loading** to process only new or modified records instead of performing a full refresh.
* Introduce **Slowly Changing Dimensions (SCD Type 2)** to preserve historical changes in dimension attributes.
* Automate and schedule ETL pipelines using an orchestration tool such as **Apache Airflow, Azure Data Factory, or SQL Server Agent**.
* Implement comprehensive **ETL logging, monitoring, and error handling**.
* Add automated and continuous **data quality testing**.
* Connect the Gold layer to **Power BI** or another BI platform for interactive reporting.
* Deploy the warehouse to a **cloud data platform** for improved scalability and accessibility.
* Introduce more source systems and business domains to expand the analytical capabilities of the warehouse.
* Optimize SQL queries, indexing, and data loading processes for larger datasets.

---

## 16. Credits

This project was developed as a hands-on learning project based on the **SQL Data Warehouse & Analytics Project** tutorial by **Baraa Khatib Salkini**.

The tutorial provided valuable guidance on data warehouse architecture, ETL processes, data integration, dimensional modeling, data quality, and SQL-based analytics.

**Tutorial Creator:** [Baraa Khatib Salkini](https://www.linkedin.com/in/baraa-khatib-salkini/)

**Note:** The implementation and documentation in this repository are presented as my own learning work, with the tutorial serving as the primary source of guidance and project inspiration.
## 14. Limitations

Although this project demonstrates the core concepts of building a data warehouse and implementing an ETL pipeline, it has several limitations compared with a production-level enterprise data warehouse:

* **Static source data:** The project uses CSV files as source systems rather than live CRM and ERP databases.
* **Full refresh loading:** The ETL process uses a full extraction and full load approach, which may not be efficient for very large datasets.
* **Batch processing:** Data is processed in batches rather than through real-time or near-real-time pipelines.
* **SCD Type 1:** Dimension changes overwrite existing values, so historical changes to dimension attributes are not preserved.
* **Manual execution:** The ETL process is not connected to a production scheduler or orchestration platform.
* **Limited scale:** The project is designed as a portfolio and learning project and has not been optimized for enterprise-scale data volumes.
* **Limited monitoring:** Production-level monitoring, alerting, and centralized ETL logging have not been implemented.

These limitations provide opportunities to extend the project toward a more production-oriented data warehouse solution.

---

## 15. Future Improvements

The project can be further enhanced with the following improvements:

* Implement **incremental data loading** to process only new or modified records instead of performing a full refresh.
* Introduce **Slowly Changing Dimensions (SCD Type 2)** to preserve historical changes in dimension attributes.
* Automate and schedule ETL pipelines using an orchestration tool such as **Apache Airflow, Azure Data Factory, or SQL Server Agent**.
* Implement comprehensive **ETL logging, monitoring, and error handling**.
* Add automated and continuous **data quality testing**.
* Connect the Gold layer to **Power BI** or another BI platform for interactive reporting.
* Deploy the warehouse to a **cloud data platform** for improved scalability and accessibility.
* Introduce more source systems and business domains to expand the analytical capabilities of the warehouse.
* Optimize SQL queries, indexing, and data loading processes for larger datasets.

---

## 16. Credits

This project was developed as a hands-on learning project based on the **SQL Data Warehouse & Analytics Project** tutorial by **Baraa Khatib Salkini**.

The tutorial provided valuable guidance on data warehouse architecture, ETL processes, data integration, dimensional modeling, data quality, and SQL-based analytics.

**Tutorial Creator:** [Baraa Khatib Salkini](https://www.linkedin.com/in/baraa-khatib-salkini/)

**Note:** The implementation and documentation in this repository are presented as my own learning work, with the tutorial serving as the primary source of guidance and project inspiration.
