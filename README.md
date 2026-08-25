# SQL Data Warehouse Project

> **Thank you for taking the time to explore my work!**
> This is a **short overview** of the project, designed to give you a quick understanding of the project, my skills, and the technologies I used.
> If you would like to explore the implementation and documentation in more detail, please scroll to the bottom and visit the **Full README**.



## 📌 About the Project

This project demonstrates the development of a **SQL-based Data Warehouse** that integrates data from **CRM and ERP source systems** into a centralized analytical environment.

The project implements a **Medallion Architecture** consisting of **Bronze, Silver, and Gold layers**, with ETL pipelines used to extract, clean, transform, integrate, and load the data.

The final Gold layer uses a **Star Schema** consisting of:

* `fact_sales`
* `dim_customers`
* `dim_products`

The warehouse is designed to provide clean, consistent, and analysis-ready data for SQL-based business analysis.



## 🛠️ Skills & Tools

| Category              | Skills / Tools                                       |
| --------------------- | ---------------------------------------------------- |
| **Database**          | SQL Server                                           |
| **Query Language**    | T-SQL                                                |
| **ETL**               | Extract, Transform, Load                             |
| **Data Architecture** | Medallion Architecture                               |
| **Data Modeling**     | Star Schema, Fact & Dimension Tables                 |
| **Data Integration**  | CRM & ERP Data Integration                           |
| **Data Quality**      | Validation, Consistency, Accuracy & Integrity Checks |
| **Documentation**     | Markdown, Draw.io, ChatGPT                           |
| **Version Control**   | Git / GitHub                                         |

### Key Skills Demonstrated

* SQL & T-SQL
* ETL Pipeline Development
* Data Cleaning & Transformation
* Data Integration
* Dimensional Data Modeling
* Data Warehouse Architecture
* Data Quality Validation
* Analytical SQL



## 💼 Business Problem & Solution

### Problem

Organizations may store business data across multiple CRM and ERP systems. When analysts manually collect and transform this data into separate Excel, PowerPoint, or Power BI reports, the process becomes **time-consuming, inconsistent, difficult to maintain, and prone to human error**.

Different reports may also contain different refresh dates, making it difficult for stakeholders to work with a consistent version of the data.

### Solution

This project addresses the problem by building a **centralized Data Warehouse as a single source of truth**.

```text
CRM + ERP Sources
       ↓
Bronze Layer
       ↓
Silver Layer
       ↓
Gold Layer
       ↓
Business Analysis
```

The ETL process extracts data from the source systems, cleans and transforms it, integrates related CRM and ERP information, validates data quality, and loads the final analytical model into the Gold layer.

This provides a **structured, consistent, and analysis-ready dataset** for business analysis.


## 🎯 Conclusion

This project demonstrates my practical understanding of **SQL, ETL, data warehousing, dimensional modeling, data integration, and data quality validation**.

Rather than focusing only on writing SQL queries, the project demonstrates the complete flow from **raw source data → transformation → integration → analytical data model**.

It also provided hands-on experience in designing a structured data warehouse and documenting the technical implementation.


## 📖 Want to Explore the Project in Detail?

Thank you again for taking the time to review my project.

If you are interested in understanding the **architecture, data flow, ETL process, data modeling, data catalog, data quality checks, project structure, limitations, and future improvements**, please explore the complete documentation below.

### 👉 [Full README — Detailed Project Documentation](README_FULL.md)

**Thank you for exploring my work!** 🚀
