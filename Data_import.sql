Create database SupplyChainDatabase;
 
USE SupplyChainDatabase;

CREATE TABLE supply_chain_data (

    Type VARCHAR(100),
    Days_for_shipping_real INT,
    Days_for_shipment_scheduled INT,
    Benefit_per_order NUMERIC,
    Sales_per_customer NUMERIC,
    Delivery_Status VARCHAR(100),
    Late_delivery_risk INT,

    Category_Id INT,
    Category_Name VARCHAR(200),

    Customer_City VARCHAR(200),
    Customer_Country VARCHAR(200),
    Customer_Email VARCHAR(200),
    Customer_Fname VARCHAR(100),
    Customer_Id INT,
    Customer_Lname VARCHAR(100),
    Customer_Password VARCHAR(200),
    Customer_Segment VARCHAR(100),
    Customer_State VARCHAR(100),
    Customer_Street VARCHAR(200),
    Customer_Zipcode VARCHAR(20),

    Department_Id INT,
    Department_Name VARCHAR(200),

    Latitude NUMERIC(10,6),
    Longitude NUMERIC(10,6),

    Market VARCHAR(100),

    Order_City VARCHAR(40),
    Order_Country VARCHAR(40),
    Order_Customer_Id INT,

    order_date varchar(20),
    Order_Id INT,
    Order_Item_Cardprod_Id INT,
    Order_Item_Discount NUMERIC,
    Order_Item_Discount_Rate NUMERIC,
    Order_Item_Id INT,
    Order_Item_Product_Price NUMERIC,
    Order_Item_Profit_Ratio NUMERIC,
    Order_Item_Quantity INT,
    Sales NUMERIC,
    Order_Item_Total NUMERIC,
    Order_Profit_Per_Order NUMERIC,

    Order_Region VARCHAR(100),
    Order_State VARCHAR(100),
    Order_Status VARCHAR(100),
    Order_Zipcode VARCHAR(20),

    Product_Card_Id INT,
    Product_Category_Id INT,
    Product_Description TEXT,
    Product_Image TEXT,
    Product_Name VARCHAR(200),
    Product_Price NUMERIC,
    Product_Status VARCHAR(100),

    shipping_date VARCHAR(100),
    Shipping_Mode VARCHAR(100)
);

SHOW VARIABLES LIKE 'secure_file_priv';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/DataCoSupplyChainDataset_utf8.csv'
INTO TABLE supply_chain_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



Select Count(*) from supply_chain_data;







