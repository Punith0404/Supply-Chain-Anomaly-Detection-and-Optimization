# Supply-Chain-Anomaly-Detection-and-Optimization

## About the Project
This project analyzes supply chain performance to identify operational inefficiencies such as **late deliveries, SLA breaches, and loss-making orders**.

Using a structured SQL-based data model and an interactive Power BI dashboard, the project highlights **where and why the supply chain breaks**, enabling data-driven optimization of shipping modes, SLAs, and pricing strategies.

(Detailed technical stack and architecture will be added.)

---

## Data Model
The project follows a **star schema** design with a central fact table and supporting dimension tables.  
All business logic is implemented in SQL views before visualization.

(Data model diagram will be added.)

---

## Overall Summary: Anomalies & Optimization 

### Anomalies Identified

- ~**60% of total orders** are delivered late across all customer segments, confirming a **system-wide logistics issue** rather than isolated failures.
- **Loss-making orders remain stable at ~18–19%** across customer segments, indicating that losses are **not segment-driven**.
- Multiple cities record **late delivery rates above 75%**, highlighting **severe last-mile delivery bottlenecks**.
- Loss percentage remains **nearly constant for on-time and late deliveries**, proving that **delivery delays are not the primary driver of losses**.
- A small set of product categories (e.g., **Men’s Clothing, Health & Beauty, Video Games**) shows **loss percentages significantly above the overall average**.
- A limited number of **high-risk SKUs account for a disproportionate share of late and loss-making orders**, concentrating operational risk.
- **Fast shipping modes** (Same Day, First Class) exhibit **extremely high late delivery rates**, despite premium service expectations.
- **Standard shipping** contributes the **highest absolute count of high-risk orders** due to its large order volume.
- Customers with **three or more late deliveries** represent a **high churn-risk segment** requiring proactive intervention.

---

### Optimization Recommendations

- Reduce late deliveries by addressing logistics and fulfillment processes impacting **~60% of total orders**.
- **Redefine SLA commitments** for fast shipping modes where late delivery rates exceed acceptable thresholds.
- Prioritize **city-level last-mile optimization** in locations with **>75% late delivery rates**.
- Optimize fulfillment costs and discount strategies for product categories driving **~18–19% loss rates**.
- Review pricing, sourcing, or fulfillment strategies for **high-risk SKUs** responsible for repeated losses.
- Proactively manage customers experiencing **repeated delivery delays** to reduce churn risk.

---

### Business Conclusion

Late deliveries and losses are **quantifiable, systemic issues**, not isolated incidents.  
The analysis indicates that meaningful improvement requires focused action on **logistics efficiency, realistic SLA definitions, and SKU-level cost control** to materially reduce the **~60% delay rate** and **~18–19% loss rate**.

---

## Dashboard Overview
The dashboard provides a high-level view of supply chain performance, highlighting late deliveries, SLA breaches, and loss-making orders across time, geography, shipping modes, and product categories.

(Dashboard image will be added.)

---

## Dataset & License

This project uses the **DataCo Supply Chain Dataset**, sourced from Mendeley Data.

- Dataset source: https://data.mendeley.com/datasets/8gx2fvg2k6/5  
- License: Creative Commons Attribution 4.0 International (CC BY 4.0)  
  https://creativecommons.org/licenses/by/4.0/

The dataset is **not included in this repository**.  
The data was cleaned, transformed, and analyzed for educational and portfolio purposes.  
The original data creators do not endorse this project or its findings.
