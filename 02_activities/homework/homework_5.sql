-- Cross Join
/*1. Suppose every vendor in the `vendor_inventory` table had 5 of each of their products to sell to **every** 
customer on record. How much money would each vendor make per product? 
Show this by vendor_name and product name, rather than using the IDs.

HINT: Be sure you select only relevant columns and rows. 
Remember, CROSS JOIN will explode your table rows, so CROSS JOIN should likely be a subquery. 
Think a bit about the row counts: how many distinct vendors, product names are there (x)?
How many customers are there (y). 
Before your final group by you should have the product of those two queries (x*y).  */

-- Step 1: Define the Common Table Expressions (CTEs)
-- CTE for Distinct Vendor Products: This CTE retrieves unique combinations of vendor names and product names.
WITH distinct_vendor_products AS (
    SELECT 
        v.vendor_name, 
        p.product_name
    FROM 
        vendor_inventory vi
    JOIN 
        vendor v ON vi.vendor_id = v.vendor_id
    JOIN 
        product p ON vi.product_id = p.product_id
    GROUP BY 
        v.vendor_name, p.product_name
)
-- CTE for Total Customers: This CTE calculates the total number of distinct customers.
total_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS count
    FROM customer_purchases
)

-- Step 2: Combine the Results Using CROSS JOIN
SELECT 
    dvp.vendor_name,
    dvp.product_name,
    5 * tc.count AS potential_earnings
FROM 
    distinct_vendor_products dvp
CROSS JOIN 
    total_customers tc;


-- INSERT
/*1.  Create a new table "product_units". 
This table will contain only products where the `product_qty_type = 'unit'`. 
It should use all of the columns from the product table, as well as a new column for the `CURRENT_TIMESTAMP`.  
Name the timestamp column `snapshot_timestamp`. */

-- Step 1: Create the New Table - create the product_units table with the required columns
CREATE TABLE product_units (
    product_id INTEGER,
    product_name TEXT,
    product_size TEXT,
    product_category_id INTEGER,
    product_qty_type TEXT,
    snapshot_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Insert Data into the New Table - insert the relevant data from the product table
INSERT INTO product_units (product_id, product_name, product_size, product_category_id, product_qty_type)
SELECT 
    product_id, 
    product_name, 
    product_size, 
    product_category_id, 
    product_qty_type
FROM 
    product
WHERE 
    product_qty_type = 'unit';

-- Step 3: Check that the table was successfully created
SELECT * 
FROM product_units;


/*2. Using `INSERT`, add a new row to the product_units table (with an updated timestamp). 
This can be any product you desire (e.g. add another record for Apple Pie). */

-- SQL insert statement
INSERT INTO product_units (product_id, product_name, product_size, product_category_id, product_qty_type, snapshot_timestamp)
VALUES (101, 'Apple Pie', '8 inches', 1, 'unit', CURRENT_TIMESTAMP);

-- Running the insert
SELECT * FROM product_units;


-- DELETE
/* 1. Delete the older record for the whatever product you added. 

HINT: If you don't specify a WHERE clause, you are going to have a bad time.*/

-- SQL delete statement
DELETE FROM product_units
WHERE product_id = 101;

-- Running the delete
SELECT * FROM product_units;


-- UPDATE
/* 1.We want to add the current_quantity to the product_units table. 
First, add a new column, current_quantity to the table using the following syntax.

ALTER TABLE product_units
ADD current_quantity INT;

Then, using UPDATE, change the current_quantity equal to the last quantity value from the vendor_inventory details.

HINT: This one is pretty hard. 
First, determine how to get the "last" quantity per product. 
Second, coalesce null values to 0 (if you don't have null values, figure out how to rearrange your query so you do.) 
Third, SET current_quantity = (...your select statement...), remembering that WHERE can only accommodate one column. 
Finally, make sure you have a WHERE statement to update the right row, 
	you'll need to use product_units.product_id to refer to the correct row within the product_units table. 
When you have all of these components, you can run the update statement. */

-- Step 1: Add the New Column
ALTER TABLE product_units
ADD current_quantity INT;

-- Step 2: Update the Current Quantity
-- 2.1. Get the Last Quantity
SELECT 
    vi.product_id,
    COALESCE(vi.quantity, 0) AS last_quantity
FROM 
    vendor_inventory vi
JOIN (
    SELECT 
        product_id, 
        MAX(market_date) AS max_date
    FROM 
        vendor_inventory
    GROUP BY 
        product_id
) latest ON vi.product_id = latest.product_id AND vi.market_date = latest.max_date;

-- 2.2. Update the current_quantity in product_units
UPDATE product_units
SET current_quantity = (
    SELECT 
        COALESCE(vi.quantity, 0)
    FROM 
        vendor_inventory vi
    WHERE 
        vi.product_id = product_units.product_id
    AND 
        vi.market_date = (
            SELECT 
                MAX(market_date)
            FROM 
                vendor_inventory
            WHERE 
                product_id = product_units.product_id
        )
)
WHERE 
    product_id IN (
        SELECT DISTINCT product_id FROM vendor_inventory
    );

-- Verification
SELECT * FROM product_units;
