# SaaS Churn & Revenue Analysis (SQL)

## 📌 Project Overview
This project analyzes customer churn in a SaaS business by combining **payments**, **subscriptions**, and **product engagement** data.  
Customers are segmented into actionable churn personas to enable **targeted retention strategies**.

---

## 🎯 Business Problem
Customer churn directly impacts revenue and growth.  
The goal is to answer:
- Why do customers churn?
- Can churn be segmented by behavior?
- What actions should the business take for each churn type?

---

## 🧠 Hypotheses
1. Customers churn by **stopping payments** (Financial Churn)
2. Customers churn by **stopping engagement** (Engagement Churn)
3. Some customers **pay but don’t use** the product (Silent Churn)
4. Actively paying and engaged users are **Healthy Customers**

---

## 🗂️ Datasets Used
- **customers**: customer_id, name, email, signup_date, country  
- **subscriptions**: subscription_id, customer_id, plan_type, start_date, end_date, status  
- **transactions**: transaction_id, customer_id, amount, transaction_date  
- **user_activity**: activity_id, customer_id, event_date, event_type  

---

## 🛠️ Tools & Technologies
- PostgreSQL
- pgAdmin
- SQL (Joins, Aggregations, Window Functions)

---

## 🔍 Methodology
- Defined churn using a **90-day inactivity window**
- Analyzed **revenue, engagement, and subscriptions**
- Segmented users into churn personas using SQL
- Validated results via aggregation and filtering logic

---

## 📊 Key Insights
- The platform has **50,000 customers** and strong overall engagement
- **~30% subscriptions are canceled**, making churn a real concern
- Revenue shows **steady monthly growth**
- **Basic plan** dominates subscriptions; Premium users are fewer but valuable
- **No silent churn observed**, indicating strong product value realization
- Revenue is concentrated among **high-LTV customers**
- Customer distribution varies significantly by **country**

---

## 🧩 Churn Personas
- **Financial Churn**: No payment in the last 90 days
- **Engagement Churn**: No login in the last 90 days
- **Silent Churn**: Paying but not logging in (none observed)
- **Healthy Customer**: Paying and actively engaged

---

## 💡 Business Recommendations
- **Financial Churn**: Discounts, exit surveys, flexible pricing
- **Engagement Churn**: Re-onboarding, feature education, win-back campaigns
- **High-LTV Users**: Proactive customer success & upsell
- **Geographic Focus**: Localized marketing and support

---

## ✅ Conclusion
This project demonstrates how SQL-driven analytics can transform raw event data into **actionable business strategy** by identifying churn behaviors and enabling targeted retention.
