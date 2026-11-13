CREATE DATABASE DATALOADING;
USE DATALOADING;

CREATE TABLE Orders (
    Order_ID VARCHAR(10),
    Customer_ID VARCHAR(10),
    Sales_Amount VARCHAR(50),
    Order_Date VARCHAR(50)
);
INSERT INTO Orders
(Order_ID, Customer_ID, Sales_Amount, Order_Date)
VALUES
('O101', 'C001', '4500', '12-01-2024'),
('O102', 'C002', NULL, '15-01-2024'),
('O103', 'C003', '3200', '2024/01/18'),
('O101', 'C001', '4500', '12-01-2024'),
('O104', 'C004', 'Three Thousand', '20-01-2024'),
('O105', 'C005', '5100', '25-01-2024');
# Q1. Data Understanding
#Identify all data quality issues present in the dataset that can cause problems during data loading
#--**Q1. Data Understanding**
/*The dataset contains the following data quality issues that can cause problems during data loading:

1. **Duplicate Records:** Order_ID O101 appears twice in the dataset.
2. **Missing Values:** Sales_Amount is NULL for Order_ID O102.
3. **Incorrect Data Type:** Order_ID O104 contains "Three Thousand" instead of a numeric value in Sales_Amount.
4. **Inconsistent Date Formats:** Order_Date contains different date formats, such as DD-MM-YYYY and YYYY/MM/DD.
5. **Primary Key Violation:** Order_ID O101 is repeated, which violates the uniqueness rule of a Primary Key.

Q2. Primary Key Validation
Assume is the Primary Key.
a) Is the dataset violating the Primary Key rule? 
b) Which record(s) cause this violation?

a--Yes, the dataset violates the Primary Key rule because a Primary Key must contain unique values. It cannot have duplicate values.
b--Order_ID O101 appears twice in the dataset.
Q3. Missing Value Analysis
Which column(s) contain missing values?
a) List the affected records 
b) Explain why loading these records without handling missing values is risky
*/
# q3 ans-
SELECT *
FROM Orders
WHERE Order_ID IS NULL
   OR Customer_ID IS NULL
   OR Sales_Amount IS NULL
   OR Order_Date IS NULL;
   /* AnswerQ3(b):
Loading records with missing values without handling them can create several problems:
1. Incorrect Calculations: Missing Sales_Amount can affect total and average sales calculations.
2. Incomplete Reports: Dashboards may show incomplete sales information.
3. Poor Data Quality: Missing values reduce the completeness and reliability of data.
4. Wrong Business Decisions: Managers may make incorrect decisions based on incomplete information.*/

SELECT *
FROM Orders;
/* Q4. Data Type Validation
Question: Identify records where Sales_Amount violates expected data type rules.

a) Which record(s) will fail numeric validation?

**b) What would happen if this dataset is loaded into a SQL table with Sales_Amount as DECIMAL?
ans (a)*/
SELECT *
FROM Orders
WHERE Sales_Amount IS NOT NULL
AND Sales_Amount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
/* 4(b)
If the data is loaded into a SQL column with the DECIMAL data type, the value "Three Thousand" cannot be converted into a numeric value. This may cause a data conversion error or the record may be rejected during loading. Therefore, invalid values must be cleaned before loading.

Q5. Date Format Consistency
Question:
(a) Identify the different date formats present in the dataset.
(b) Why is inconsistent date formatting a problem during data loading?
ans(a)The dataset contains two different date formats:
- DD-MM-YYYY (e.g., 12-01-2024)
- YYYY/MM/DD (e.g., 2024/01/18)
ans(b)-Inconsistent date formats can create problems during data loading because SQL may fail to recognize or convert some dates correctly. This can cause loading errors or incorrect date values. Therefore, all dates should be converted into a standard format before loading.

Q6. Load Readiness Decision
Question: Can this dataset be directly loaded into the target database? Give at least 3 reasons.
ans(a)-No, the dataset is not ready to be directly loaded into the target database because:
ans(b)- It contains duplicate Order_ID (O101).
It has missing values in the Sales_Amount column.
It contains invalid numeric data ("Three Thousand").
It has inconsistent date formats.

Question: What checks should be performed before loading data into the target database?
Before loading data into the target database, the following validation checks should be performed:
- Check for duplicate records.
- Identify and handle missing values.
- Validate data types.
- Standardize date formats.
- Verify primary key uniqueness and NOT NULL constraints.
- Ensure all required fields contain valid data.

Question: Explain the step-by-step cleaning actions required to make the dataset ready for loading.
-- The following cleaning steps should be performed before loading:
1. Remove duplicate records.
2. Handle missing values in the Sales_Amount column.
3. Convert invalid numeric values into valid numbers after verification.
4. Standardize all dates into a common format (YYYY-MM-DD).
5. Validate and convert columns into their correct data types.
6. Perform final validation before loading the cleaned data.

Question: For daily sales data, which loading strategy is more suitable: Full Load or Incremental Load? Justify your answer.
Incremental Load is more suitable for daily sales data because it loads only new or updated records instead of loading the entire dataset every day. It saves time, reduces processing costs, and improves loading efficiency.

Q10. BI Impact Scenario
Question: If the dataset is loaded without cleaning and connected to a BI dashboard:

(a) What incorrect results may appear in Total Sales KPI?

(b) Which records may create misleading results?

(c) Why will BI tools not automatically detect these issues?

ans
(a) Incorrect Total Sales KPI may appear due to duplicate records, missing values, and invalid numeric data.

(b) The following records may create misleading results:
- O101 – Duplicate record.
- O102 – Missing Sales_Amount.
- O104 – Invalid Sales_Amount ("Three Thousand").
(c) BI tools do not automatically detect all data quality issues because they mainly analyze and visualize the available data. Data cleaning and validation must be performed before connecting the dataset to a BI dashboard.
*/