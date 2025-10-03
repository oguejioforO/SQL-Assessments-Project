/* ======================================================
   SQL Project Queries
   Author: Your Name
   Description: This file contains SQL scripts for
                three different database assessments.
                Each section includes table creation,
                sample queries, and documentation.
   ====================================================== */


/* ======================================================
   ASSESSMENT 1: Sales Orders Database
   Purpose:
   - Create and load sales data into normalized tables.
   - Analyze orders by joining customer, product, and region.
   ====================================================== */

-- Create Database
CREATE DATABASE assessment1;
USE assessment1;

-- Create Tables
CREATE TABLE customer(
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(30)
);

CREATE TABLE product(
  product_id INT PRIMARY KEY,
  product_name VARCHAR(30)
);

CREATE TABLE region(
  region_id INT PRIMARY KEY,
  city VARCHAR(30),
  country VARCHAR(30)
);

CREATE TABLE sales_orders(
  order_number VARCHAR(50),
  order_date VARCHAR(30),
  customer_id INT,
  `channel` VARCHAR(50),
  warehouse_code VARCHAR(50),
  region_id INT,
  product_id INT,
  order_quantity INT,
  unit_price DECIMAL(35,4),
  total_revenue DECIMAL(35,4),
  total_unitcost DECIMAL(35,4)
);

-- Load data into sales_orders (CSV file must exist in path)
LOAD DATA INFILE 'C:/sales_order.csv'
INTO TABLE sales_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Explore Data
SELECT * FROM product;
SELECT * FROM region;
SELECT * FROM sales_orders;
SELECT * FROM customer;

-- Main Analysis Query: Join all tables to view full sales details
SELECT so.order_number,
       c.customer_id, c.customer_name, 
       r.region_id, r.city, r.country,
       p.product_id, p.product_name, 
       so.order_date, so.`channel`, so.warehouse_code, 
       so.order_quantity, so.unit_price, 
       so.total_revenue, so.total_unitcost
FROM sales_orders so
INNER JOIN product p ON so.product_id = p.product_id
INNER JOIN customer c ON so.customer_id = c.customer_id
INNER JOIN region r ON so.region_id = r.region_id
ORDER BY so.order_number;


/* ======================================================
   ASSESSMENT 2: Pet Owners Database
   Purpose:
   - Create tables for owners and pets.
   - Use joins to explore owner-pet relationships.
   ====================================================== */

-- Create Database
CREATE DATABASE assessment2;
USE assessment2;

-- Create Tables
CREATE TABLE owners(
  owner_id INT,
  name VARCHAR(30),
  surname VARCHAR(30),
  street_address VARCHAR(50),
  city VARCHAR(30),
  state VARCHAR(30),
  state_full VARCHAR(30),
  zipcode INT
);

CREATE TABLE pet_s(
  pet_id VARCHAR(30),
  name VARCHAR(30),
  kind VARCHAR(30),
  gender VARCHAR(30),
  age INT,
  owner_id INT
);

-- Explore Data
SELECT * FROM pet_s;

-- Query 1: Find all dog owners, showing the oldest dogs first
SELECT o.name, o.surname, p.name, p.age
FROM owners o
INNER JOIN pet_s p ON o.owner_id = p.owner_id
WHERE p.kind = 'Dog'
ORDER BY p.age DESC;

-- Query 2: List all owners and their pets (including owners without pets)
SELECT o.name, o.surname, p.kind
FROM owners o
LEFT JOIN pet_s p ON o.owner_id = p.owner_id
ORDER BY o.surname;

-- Query 3: Count the number of pets per owner
SELECT owner_id, COUNT(pet_id) AS num_of_dogs
FROM pet_s
GROUP BY owner_id;


/* ======================================================
   ASSESSMENT 3: Templar HR Database
   Purpose:
   - Analyze employee pay, gender, and department data.
   - Perform grouping and comparisons on HR data.
   ====================================================== */

-- Create Database
CREATE DATABASE assessment3;
USE assessment3;

-- Create Table
CREATE TABLE templarHR (
  employee_id INT,
  job_title VARCHAR(30),
  department VARCHAR(30),
  job_level INT,
  hourly_rate DECIMAL(35,2),
  annual_rate INT,
  employment VARCHAR(30),
  annual_hours INT,
  years_at_company INT,
  years_in_company INT,
  age INT,
  gender VARCHAR(30),
  visible_minority VARCHAR(50)
);

-- Load data into templarHR (CSV file must exist in path)
LOAD DATA INFILE 'C:/TemplarHR.csv'
INTO TABLE templarHR
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Explore Data
SELECT * FROM templarHR;

-- Query 1: Compare employee salary by gender in departments
SELECT department, gender, AVG(hourly_rate * annual_hours) AS average_salary
FROM templarHR
GROUP BY department, gender
ORDER BY department, gender DESC;

-- Query 2: Compare salaries by gender and minority status for higher job levels
SELECT job_level, gender, visible_minority, 
       AVG(hourly_rate * annual_hours) AS average_salary
FROM templarHR
WHERE job_level >= 2
GROUP BY job_level, gender, visible_minority;

-- Query 3: Find pay differences for same job titles across departments
SELECT job_title, department, 
       AVG(hourly_rate * annual_hours) AS pay
FROM templarHR
GROUP BY job_title, department
ORDER BY job_title;

-- Query 4: List managers and directors by department
SELECT job_title, department 
FROM templarHR 
WHERE job_title IN ('manager', 'director');
