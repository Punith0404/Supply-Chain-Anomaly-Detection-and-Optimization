# Technical Stack & Architecture

This document describes the tools, technologies, and architectural decisions used in the **Supply Chain Anomaly Detection & Optimization** project.

---

## 1. Data Source

- **Dataset**: DataCo Supply Chain Dataset (Mendeley Data)
- **License**: Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Data Type**: Historical transactional supply chain data
- **Scope**:
  - Orders
  - Customers
  - Products
  - Shipping details
  - Delivery timelines
  - Profit and sales metrics

> Note: The raw dataset is not included in this repository. All analysis is performed on cleaned and transformed data.

---

## 2. Database & Query Layer

### Database
- **MySQL**
- Used for:
  - Data storage
  - Data transformation
  - Business logic implementation

### SQL Usage
- All transformations are performed using **SQL views**
- No direct manipulation of raw data in Power BI
- Business rules are centralized in SQL for consistency and scalability

---

## 3. Data Modeling Approach

### Architecture Pattern
- **Star Schema**

### Fact Table
- **Fact View**: `v_order_delivery_flags`
- Contains:
  - Sales
  - Profit per order
  - Order quantity
  - Discount metrics
  - Anomaly flags:
    - Late delivery
    - SLA breach
    - Loss-making orders

### Dimension Tables
- **Customer Dimension**
  - Segment
  - City
  - State
  - Country

- **Product Dimension**
  - Product name
  - Category
  - Department
  - Price

- **Date Dimension**
  - Year
  - Month
  - Quarter
  - Weekday

- **Shipping Dimension**
  - Shipping mode
  - Region
  - Market

This structure enables efficient slicing and aggregation in Power BI.

---

## 4. Clean Layer Design

- A dedicated **clean view** is used to:
  - Standardize data types
  - Handle missing values
  - Enforce correct grain (one row per order item)
- Prevents raw data issues from propagating into analytics
- Acts as the foundation for all downstream views

---

## 5. Analysis Layer

- SQL-based analysis is performed on top of fact and dimension views
- Focus areas:
  - Late delivery analysis
  - SLA breach analysis
  - Loss-making orders
  - High-risk customers
  - Product and category-level risk
  - Shipping mode performance

Results from this layer directly feed the dashboard KPIs.

---

## 6. Visualization & Reporting

### Tool
- **Power BI Desktop**

### Dashboard Features
- KPI cards:
  - Late Delivery %
  - SLA Breach %
  - Loss Order %
- Trend analysis by month and year
- Geographic risk analysis
- Shipping mode comparison
- Product and category-level loss analysis

### Modeling in Power BI
- Star schema imported from SQL views
- Minimal DAX usage
- Most logic handled in SQL to keep the model clean and maintainable

---

## 7. Version Control & Project Management

- **Git & GitHub**
- Clean repository structure:
  - `Analysis/` → SQL analysis scripts
  - `Views/` → SQL views (clean, fact, dimension)
  - `PowerBI/` → Power BI dashboard file
  - `docs/` → Documentation and images
- `.gitignore` used to exclude raw datasets and system files

---

## 8. Key Design Principles Followed

- Separation of concerns (raw, clean, semantic, visualization)
- Business logic centralized in SQL
- Minimal transformation in Power BI
- License-compliant data handling
- Reproducible and interview-ready project structure
