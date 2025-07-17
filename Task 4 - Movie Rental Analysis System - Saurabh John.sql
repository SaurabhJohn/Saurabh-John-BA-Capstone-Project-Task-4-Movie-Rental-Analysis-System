-- Create the database
CREATE DATABASE MovieRental;
use MovieRental;

-- Create the rental_data table
CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE DECIMAL(6,2)
);

-- Insert sample data into rental_data table
INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(1, 101, 'Action', '2024-12-10', '2024-12-15', 3.99),
(2, 102, 'Drama', '2025-06-01', '2025-06-05', 4.50),
(3, 103, 'Comedy', '2025-05-20', '2025-05-22', 2.99),
(4, 104, 'Action', '2025-07-01', '2025-07-04', 3.50),
(5, 105, 'Horror', '2025-04-10', '2025-04-12', 4.25),
(6, 106, 'Drama', '2025-06-15', '2025-06-18', 4.50),
(7, 107, 'Action', '2025-07-05', '2025-07-08', 3.75),
(8, 108, 'Comedy', '2025-05-10', '2025-05-12', 2.99),
(9, 109, 'Drama', '2025-07-01', '2025-07-03', 4.75),
(10, 110, 'Horror', '2025-06-20', '2025-06-22', 4.00),
(11, 111, 'Action', '2025-07-10', '2025-07-14', 4.25),
(12, 112, 'Drama', '2025-03-15', '2025-03-18', 3.99),
(13, 113, 'Comedy', '2025-01-12', '2025-01-15', 2.50),
(14, 114, 'Horror', '2025-02-20', '2025-02-23', 3.99),
(15, 115, 'Action', '2025-07-12', '2025-07-15', 3.99);

-- OLAP OPERATIONS

-- a) Drill Down: Analyze rentals from genre to individual movie level
SELECT GENRE, MOVIE_ID, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;


-- b) Rollup: Summarize total rental fees by genre and overall
SELECT GENRE, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE WITH ROLLUP;

-- c) Cube: Analyze total rental fees across genre, rental date, and customer
      -- since MySQL does not support cube, I am using Union All

SELECT GENRE, RENTAL_DATE, CUSTOMER_ID, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE, RENTAL_DATE, CUSTOMER_ID
UNION ALL
SELECT GENRE, RENTAL_DATE, NULL AS CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE, RENTAL_DATE
UNION ALL
SELECT GENRE, NULL, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE, CUSTOMER_ID
UNION ALL
SELECT NULL, RENTAL_DATE, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY RENTAL_DATE, CUSTOMER_ID
UNION ALL
SELECT GENRE, NULL, NULL, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE
UNION ALL
SELECT NULL, RENTAL_DATE, NULL, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY RENTAL_DATE
UNION ALL
SELECT NULL, NULL, CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY CUSTOMER_ID
UNION ALL
SELECT NULL, NULL, NULL, SUM(RENTAL_FEE)
FROM rental_data;

-- d) Slice: Extract rentals only from the ‘Action’ genre
-- Slice: Filter only Action genre rentals
SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- e) Dice: Rentals where GENRE is Action or Drama AND RENTAL_DATE is in the last 3 months
-- Dice: Rentals of Action or Drama in the last 3 months
SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
  AND RENTAL_DATE >= CURDATE() - INTERVAL 3 MONTH;