# Customer 360 Data Integration

This project focuses on integrating data from multiple retail sources to build a **unified Customer 360 view** that supports data-driven business decision-making.

## 📊 Overview

To enable better visibility into customer behavior and operational performance, this project brings together data from:

- **Online Transactions**
- **In-Store Purchases**
- **Customer Service Interactions**
- **Loyalty Programs**

## 🚀 Tech Stack

- **Azure Synapse Analytics**
- **Azure Data Lake Storage Gen2 (ADLS)**
- **Azure SQL Database**
- **Power BI**
- **Microsoft Fabric**

## 📐 Architecture

The architecture follows a structured, scalable, and layered approach.
Find Architecture Diagram in the repo.

### 🔹 Bronze Layer (Raw)
- Raw CSV data is ingested from external sources and stored in **ADLS Gen2 (Bronze Folder)**.

### 🔸 Silver Layer (Curated)
- Data is cleaned and transformed using **Synapse Data Flows**.
- The cleaned data is stored in an **Azure SQL Database**.

### 🟡 Gold Layer (Analytics)
- Business-ready views are created using SQL statements.
- Views are loaded into **Azure SQL DB** for analytics consumption.

## 📈 KPIs Created

- **Average Order Value**
- **Customer Segmentation**
- **Peak Purchase Times**
- **Customer Service Agent Performance**

## 📊 Reporting & Analytics

- Final data is visualized using **Power BI**.
- Advanced **data modeling** is performed in Power BI.
- Reports are published to **Microsoft Fabric** for secure access and sharing.

## ✅ Outcome

This end-to-end data pipeline and dashboard enable actionable insights across departments, including:

- **Sales**
- **Marketing**
- **Customer Support**

---

