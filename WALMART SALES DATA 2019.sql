-- WALMART SALES PROJECT
-- DATA CLEANING
select * from walmartsalesdata;
describe walmartsalesdata;
-- MODIFY OUR DATE AND TIME COLUMN CAUSE THEY ARE IN TEXT FORMAT INSTEAD OF DATE AND TIME FORMAT RESPECTIVELY
alter table walmartsalesdata modify column Date date;
alter table walmartsalesdata modify column Time time;
describe walmartsalesdata;
-- update walmartsalesdata set Date = format(str_to_date(Date,'m%/%d/%Y'),'%Y-%m-%d');       -- DONT RUN ITS CODE FOR DATE FORMATTING FROM TEXT TO DATE
alter table  walmartsalesdata add column time_of_day varchar (40);
update  walmartsalesdata set time_of_day = 
(case when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:01:00' and '15:00:00' then 'Afternoon' else 'Evening' end);
select * from walmartsalesdata;
-- ADD A NEW COLUMN CALLED DAY_NAME.
alter table walmartsalesdata add column day_name varchar (40);
select * from walmartsalesdata;
update  walmartsalesdata set day_name = dayname(date);
set sql_safe_updates =0;
select * from walmartsalesdata;
-- ADD A NEW COLUMN CALLED MONTH_NAME
alter table walmartsalesdata add column month_name varchar (40);
update  walmartsalesdata set month_name = monthname(date);
select * from walmartsalesdata;
-- EXPLORATORY DATA ANALYSIS
-- Q1 HOW MANY UNIQUE CITIES DOES THE DATA HAVE
select distinct city from walmartsalesdata;                               -- USE DISTINCT JUST TO GIVE YOU TOTAL NUMBER
-- Q2 IN WHICH CITY IS EACH BRANCH?                               -- WHEN YOU HEAR EACH IN A QUESTION YOU SHOULD USE GROUP BY STATEMENT
select city, branch from walmartsalesdata
group by city, branch;
-- PRODUCT-RELATED QUESTIONS
-- Q1 HOW MANY UNIQUE PRODUCT LINE DOES THE DATA HAVE?
select distinct Product_line from walmartsalesdata;
select distinct count(distinct product_line) from walmartsalesdata;          -- ANOTHER WAY TO SEE IT BY COUNT
-- Q2 WHAT IS THE MOST COMMON PAYMENT MODE
select distinct payment from walmartsalesdata;                             -- TO SEE THE NUMBER OF PAYMENT MODE
select payment, count(*) as payment_count                                  -- TO THE TOTAL NUMBER OF EACH PAYMENT MODE
from walmartsalesdata group by payment;
-- order by payment_count desc limit 1;                      -- DID NOT RUN
-- Q3 WHATS THE MOST SELLING PRODUCT LINE
select product_line, count(quantity) as qty_sold 
from walmartsalesdata group by product_line
order by qty_sold Desc;
-- Q4 WHAT IS THE TOTAL REVENUE BY MONTHS?
select month_name, sum(total) as revenue
from walmartsalesdata group by month_name;            -- this can be used for day_name and year and week_name
-- TO ROUND THE ANSWER TO 2 DECIMAL PLACES
select month_name, round(sum(total),2) as revenue
from walmartsalesdata group by month_name; 
-- OR CAST
select month_name, cast(sum(total) as decimal (10,2)) as revenue      -- 10 SIGNIFIES DECIMAL
from walmartsalesdata group by month_name; 
-- Q5. WHAT MONTH HAD THE LARGEST COGS?
select month_name, sum(cogs) as income
from walmartsalesdata group by month_name;                       -- DO SAME FOR ROUND AND CAST AS DONE ABOVE
select month_name, round(sum(cogs),2) as revenue
from walmartsalesdata group by month_name;
-- Q6 .WHAT PRODUCT LINE HAD THE HIGHEST REVENUE?
select product_line, sum(total) as revenue
from walmartsalesdata group by product_line order by revenue Desc;     -- USING ORDER BY IN ORDER TO SEE FROM TOP TO BOTTOM
-- Q7. CITY WITH THE HIGHEST REVENUE
select city, sum(total) as best_city
from walmartsalesdata group by city order by best_city Desc;
-- Q8. WHAT PRODUCT_LINE HAS THE LARGEST VAT?
select * from walmartsalesdata;
select product_line, sum(vat) as VAT
from walmartsalesdata group by product_line;
-- Q9 FETCH EACH PRODUCT_LINE AND ADD A COLUMN TO EACH OF THE PRODUCT_LINE 
-- TO SHOW WHETHER 'GOOD OR 'BAD' GOOD IF ITS GREATER THAN AVG SALES
-- FIRST FIND AVG COGS
select avg(cogs) from walmartsalesdata;
select product_line, cogs, case when cogs >
(select avg(cogs) from walmartsalesdata)
then 'good' else 'bad' end as product_description
from walmartsalesdata;
-- Q10. WHICH BRANCH SOLD MORE PRODUCT THAN THE AVERAGE PRODUCT SOLD?
select branch, count(quantity) as qty_sold from walmartsalesdata group by branch having count(quantity) > 
(select avg(quantity) from walmartsalesdata) order by qty_sold Desc;
-- Q11 MOST COMMON PRODUCTLINE BY GENDER
select distinct product_line, gender, count(quantity) as count_of_product_line
from walmartsalesdata group by product_line, gender order by count_of_product_line Desc;
-- Q12 AVERAGE RATING OF EACH PRODUCTLINE
SELECT * FROM walmartsalesdata;
SELECT PRODUCT_LINE, ROUND(AVG(RATING),2) AS PRODUCT_RATING 
FROM walmartsalesdata group by PRODUCT_LINE ORDER BY PRODUCT_RATING Desc;
-- WE WANT TO SEE AVERAGE RATINGS OF EACH PRODUCTLINE GREATER THAN OR EQUAL TO 7
SELECT PRODUCT_LINE, ROUND(AVG(RATING),2) AS PRODUCT_RATING 
FROM walmartsalesdata group by PRODUCT_LINE having avg(rating) >=7 ORDER BY PRODUCT_RATING Desc;  -- USING HAVING 
-- --------------------------------------- SALES ANALYSIS QUESTIONS
-- Q1 NUMBER OF SALES MADE IN EACH TIME OF THE DAY PER WEEKEDAY
SELECT TIME_OF_DAY, COUNT(*) AS NUMBER_OF_SALES 
FROM walmartsalesdata GROUP BY TIME_OF_DAY ORDER BY NUMBER_OF_SALES Desc;
-- Q2 WHICH OF THE CUSTOMER TYPE BRINGS THE MOST REVENUE
SELECT DISTINCT CUSTOMER_TYPE FROM walmartsalesdata;
select customer_type, round(sum(total),2) as best_customer_type
from walmartsalesdata group by customer_type;
-- Q3 CITY WITH THE LARGEST VAT
SELECT * FROM walmartsalesdata;
select city, round(sum(vat),2) as most_taxed_city
from walmartsalesdata group by city order by most_taxed_city Desc;
-- Q4 WHICH CUSTOMER TYPE PAID THE MOST IN VAT
select customer_type, round(sum(vat),2) as most_taxed
from walmartsalesdata group by customer_type;
-- ---------------------------- CUSTOMER ANALYSIS ------------------------------
-- HOW MANY UNIQUE CUSTOMER TYPE DOES THE DATA HAVE?
SELECT DISTINCT CUSTOMER_TYPE FROM walmartsalesdata;
-- Q2 HOW MANY UNIQUE PAYMENT METHOD DOES THE DATA HAVE?
SELECT DISTINCT PAYMENT FROM walmartsalesdata;
-- Q3 WHATS THE MOST COMMON CUSTOMER TYPE?
SELECT CUSTOMER_TYPE, COUNT(*) AS MOST_COMMON
FROM walmartsalesdata GROUP BY CUSTOMER_TYPE;
-- Q4 WHICH CUSTOMER TYPE BUYS THE MOST?
SELECT CUSTOMER_TYPE, sum(quantity) as best_buyer
from walmartsalesdata group by customer_type;
-- Q5 GENDER OF THE MOST CUSTOMERS
SELECT GENDER, COUNT(*) AS MOST_GENDER
FROM walmartsalesdata GROUP BY GENDER;
-- Q6 GENDER DISTRIBUTION PER BRANCH
SELECT BRANCH, GENDER, COUNT(*) AS GENDER_DISTRIBUTION
FROM walmartsalesdata GROUP BY BRANCH, GENDER ORDER BY GENDER_DISTRIBUTION Desc;
-- Q7 WHICH TIME OF THE DAY DO CUSTOMER GIVE MOST RATING
SELECT TIME_OF_DAY,  COUNT(RATING) AS RATING_DISTRIBUTION
FROM walmartsalesdata GROUP BY TIME_OF_DAY ORDER BY RATING_DISTRIBUTION Desc;
--  Q8 WHICH TIME OF THE DAY DO CUSTOMER GIVE MOST RATING PER BRANCH
SELECT TIME_OF_DAY, BRANCH,  COUNT(RATING) AS RATING_DISTRIBUTION_BRANCH
FROM walmartsalesdata GROUP BY TIME_OF_DAY, BRANCH ORDER BY RATING_DISTRIBUTION_BRANCH Desc;
-- WHICH DAY OF THE WEEK HAS THE BEST AVG RATING
SELECT * FROM walmartsalesdata;
SELECT DAY_NAME, ROUND(AVG(RATING),2) AS BEST_AVG_RATING
FROM walmartsalesdata GROUP BY DAY_NAME ORDER BY BEST_AVG_RATING DESC;
-- WHICH DAY OF THE WEEK HAS THE BEST AVG RATING PER BRANCH
-- Q9 HOW ARE SALES GENERATED MONTHLY?
SELECT MONTH_NAME, ROUND(SUM(COGS),1) AS SALES FROM
walmartsalesdata GROUP BY month_name ORDER BY SALES DESC;
-- HOW ARE SALES GENERATED DAILY?
SELECT DAY_NAME, ROUND(SUM(COGS),1) AS SALES FROM
walmartsalesdata GROUP BY DAY_NAME ORDER BY SALES DESC;
-- RECORDS WITH MORE THAN 500,MALE AND CUSTOMER TYPE OF MEMBER
SELECT * FROM walmartsalesdata WHERE CUSTOMER_TYPE = 'MEMBER'
AND GENDER = 'MALE' AND TOTAL >= 500;
-- LETS GET THE NUMBER OF THE DATA(ROWS) IN ABOVE CODE WE USE SUB QUERY
SELECT COUNT(*) AS COUNT FROM
(SELECT * FROM walmartsalesdata WHERE CUSTOMER_TYPE = 'MEMBER'
AND GENDER = 'MALE' AND TOTAL >= 500)TAB10;                      -- TAB10 IS THE NAME OF THE TABLE
-- WINDOWS FUNCTION IN SQL
-- CONCEPT OF ROWS NUMBER, RANK AND DENSE_RANK
-- ROW NUMBER LOOKS AT A NUMERIC COLUMN AND ASSIGN VALUES TO IT IN ASCENDING OR DESCENDING ORDER
SELECT * FROM EMPLOYEES;
SELECT SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS RN
FROM EMPLOYEES;                                             -- ROW NUMBER IS USE WHEN THE COLUMN DOES NOT HAVE DUPLICATE
-- RANK WE GIVE THE DUPLICATE VALUES ONE NUMBER AND MOVE TO THE NEXT NUMBER
SELECT SALARY, RANK() OVER(ORDER BY SALARY DESC) AS RNK
FROM EMPLOYEES;
-- DENSE RANK
SELECT SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS D_RANK
FROM EMPLOYEES;
-- BACK TO WALMARTSALESDATA ANALYSIS
SELECT * FROM walmartsalesdata;
-- Q9 WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATING
SELECT DAY_NAME, ROUND(AVG(RATING),2) AS AVG_RATING, ROW_NUMBER()
OVER(ORDER BY AVG(RATING) DESC) AS RN FROM walmartsalesdata
GROUP BY DAY_NAME;
-- WE WANT TO GET OUT ONLY MONDAY FROM THE TABLE
SELECT DAY_NAME FROM 
(SELECT DAY_NAME, ROUND(AVG(RATING),2) AS AVG_RATING, ROW_NUMBER()
OVER(ORDER BY AVG(RATING) DESC) AS RN FROM walmartsalesdata
GROUP BY DAY_NAME)FADA WHERE FADA.RN=1;                                -- FADA IS ELIAS THATS WHY WE USE FADA.RN
SELECT * FROM 
(SELECT DAY_NAME, ROUND(AVG(RATING),2) AS AVG_RATING, ROW_NUMBER()
OVER(ORDER BY AVG(RATING) DESC) AS RN FROM walmartsalesdata
GROUP BY DAY_NAME)FADA WHERE FADA.RN=1; 
-- WHICH TIME OF THE DAY GENERATED THE MOST REVENUE
SELECT time_of_day FROM
(SELECT time_of_day, ROUND(sum(COGS),2) AS AVG_RATING, ROW_NUMBER()
OVER(ORDER BY sum(COGS) DESC) AS R_NU FROM walmartsalesdata
GROUP BY TIME_OF_DAY)MADA WHERE MADA.R_NU=1;
select * from walmartsalesdata;  
-- WHICH MONTH GENERATED THE WORST REVENUE
SELECT MONTH_NAME FROM
(SELECT MONTH_NAME, ROUND(sum(COGS),2) AS WORST_SALES, ROW_NUMBER()
OVER(ORDER BY sum(COGS) ASC) AS RNU FROM walmartsalesdata
GROUP BY MONTH_NAME)TADA WHERE TADA.RNU=1;
-- SELF JOIN IN SQL 
-- IS JOINNING A TABLE TO ITSELF WITH A TWO COLUMN WITH COMMON SIMILARITIES MAYBE AS A PRIMARY KEY
CREATE TABLE EMP2 (EMP_ID INT PRIMARY KEY,EMP_NAME TEXT, SALARY INT, MGR_ID INT);
INSERT INTO EMP2 VALUES (1,'JOHN SMITH',10000,3),(2,'JANE ANDERSON',12000,3),
(3,'TOM LANOM',15000,4),(4,'ANNIE CONNOR',20000, null),
(5,'JEREMY YORK',9000,1);
select * from emp2;
-- DISPLAY THE EMPLOYEE'S NAME ON THE SAME ROW WITH HIS/HER MANAGER
SELECT E.EMP_NAME AS EMPLOYEE_NAME, M.EMP_NAME AS MANAGER_NAME 
FROM EMP2 E JOIN EMP2 M ON E.MGR_ID=M.EMP_ID;
















































