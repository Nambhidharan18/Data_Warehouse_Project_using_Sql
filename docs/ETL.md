# Data Warehouse ETL Architecture & Data Loading Strategy

This document outlines the extraction, transformation, and loading (ETL) pipeline architecture, detailing the extraction strategy, transformation techniques, processing model, loading method, and Slowly Changing Dimension (SCD) strategy employed for target table updates.

---

## 1. Executive Summary

| Parameter | Strategy / Pattern | Description |
| :--- | :--- | :--- |
| **Extraction Method** | **Pull Extraction (Receiver-Driven)** | Initiated by the database engine via stored procedures from a CSV source. |
| **Extraction Type** | **Full Extract (Full Refresh)** | Reads and processes the source CSV file in its entirety per run. |
| **Extraction Technique** | **Automated File Parsing** | Programmatic bulk loading (`BULK INSERT`) into SQL staging structures. |
| **Processing Type** | **Batch Processing** | Scheduled, non-real-time execution executing at designated time intervals. |
| **Transformation** | **Multi-Stage Enrichment & Logic** | Cleansing, normalization, aggregation, integration, and rule application. |
| **Load Method** | **Full Load (Truncate & Insert)** | Complete wipe of target data followed by full insertion of transformed state. |
| **SCD Type** | **SCD Type 1 (Overwrite)** | Target table retains only the latest snapshot; historical changes are overwritten. |

---

## 2. Data Extraction Strategy

### 1. Extraction Method: Pull Extraction (Receiver-Driven / On-Demand)
* **Execution Trigger:** The extraction is actively initiated by the target database engine via a scheduled stored procedure execution.
* **Architecture:** The process functions as a receiver-driven pull mechanism where the SQL engine actively reaches out to retrieve data from a passive CSV source file, pulling the latest available state into the database environment.

### 2. Extraction Type: Full Extract (Full Refresh)
* **Scope:** Entire source dataset.
* **Behavior:** Every pipeline run reads and processes the source CSV file in its entirety from start to finish. Instead of tracking modified rows via change data capture (CDC) or delta timestamps, it retrieves a comprehensive snapshot of the entire file.

### 3. Extraction Technique: Automated File Parsing
* **Pattern:** Programmatic Parsing & Bulk Loading.
* **Mechanism:** Extraction is executed automatically using engine-level `BULK INSERT` operations. The database system opens the target file, parses custom row and column delimiters, casts raw text into structured native SQL types, and streams the output directly into database tables without manual interaction.

---

## 3. Data Transformation Architecture

Data passing through the pipeline undergoes strict transformation logic during staging to prepare records for target loading:

| Logic | Description |
|:--- | :--- |
| **Data Cleansing:** | Filters out corrupted rows, handles missing/null values, and trims trailing whitespace. |
| **Data Normalization & Standardization:** | Aligns varied source data structures into standard domain data formats (e.g., standardizing string casing and code lookups). |
| **Date Integration:** | Standardizes diverse raw date strings into uniform SQL date/timestamp formats.|
| **Derived Columns & Aggregation:** | Calculates performance metrics, computes summary totals, and Create columns from exiting one (e.g, 'recency', 'customer_ID') |
| **Business Rules & Logic:** | Validates records against custom organizational business logic prior to writing into target structures. |

---

## 4. ETL Processing Model: Batch Processing

The data pipeline operates on a **Batch Processing** model. 

* **Execution Mechanism:** High-volume data extracted from source systems is collected, staged, and transformed in discrete batches.
* **Scheduling:** Triggers run on a defined cron schedule (e.g., daily/nightly) during maintenance windows to minimize operational system impact.
* **Latency Profile:** Designed for analytics, reporting, and BI consumption where real-time streaming is not required.

---

## 5. Data Load Method: Full Load (Truncate & Insert)

The target table replenishment utilizes a **Full Load via Truncate and Insert** pattern.

### Process Workflow
1. **Extraction & Transform:** Full CSV snapshot is pulled, parsed, and transformed in staging.
2. **Truncation:** A high-performance `TRUNCATE TABLE` command is executed on the target table, executing structural data removal and resetting high-water marks without logging individual row deletions.
3. **Insertion:** Clean, transformed records are bulk-inserted into the emptied target structure in a single transaction block.

---

## 6. Dimension Management: SCD Type 1 (Overwrite)

Under this pipeline configuration, dimension management natively behaves as **Slowly Changing Dimension Type 1 (SCD 1)**.

### Characteristics
* **Current State Retention:** The target table strictly reflects the current snapshot of source data as of the latest batch run.
* **History Management:** No historical lineage, validity date ranges (`start_date`, `end_date`), or version numbers are preserved.
* **Data Updates:** Any change in source attribute values directly replaces the previous state on subsequent batch execution.

---

## 7. Pipeline Performance & Implementation Considerations

1. **Transaction Safety:** Wrap the `TRUNCATE` and `INSERT` steps inside a unified database transaction to ensure target availability and zero downtime during pipeline failures.
2. **Table Locking:** Be aware that `TRUNCATE` places an `EXCLUSIVE` schema lock on target tables; schedule batch runs outside active query/reporting peak hours.
3. **Idempotency:** The pipeline is 100% idempotent — executing the pipeline multiple times with the same source input yields identical target table states.