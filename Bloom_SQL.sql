USE bloom_assignment;

SELECT * FROM bv_details;

DESCRIBE bv_details;

ALTER TABLE bv_details
MODIFY COLUMN bill_date DATETIME;

SELECT COUNT(*) FROM bv_details;

SELECT Last_Pay_Mode, SUM(Net_Amount) AS Total_Amount
FROM bv_details
GROUP BY Last_Pay_Mode;

## ADDING THE ASKED NEW COLUMN
ALTER TABLE bv_details
ADD COLUMN `Discount %` FLOAT;

SET SQL_SAFE_UPDATES = 0;

UPDATE bv_details
SET `Discount %` = 
    CASE 
        WHEN Bill_Amount != 0 
        THEN (Discount / Bill_Amount) * 100 
        ELSE NULL
    END;

SET SQL_SAFE_UPDATES = 1;
##

SELECT * FROM bv_details;

SELECT DISTINCT(Bill_Type) FROM bv_details;

## CREATING THE ASKED STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE Summary_Table()
BEGIN
    DROP TABLE IF EXISTS bills_summary;
    CREATE TABLE ip_bills_summary AS
    SELECT Last_Pay_Mode,
        SUM(CASE WHEN Bill_Type = 'Ip Bill' THEN Net_Amount ELSE 0 END) AS `IP Bill`,
        SUM(CASE WHEN Bill_Type = 'Lab' THEN Net_Amount ELSE 0 END) AS `Lab`,
        SUM(CASE WHEN Bill_Type = 'Pharmacy' THEN Net_Amount ELSE 0 END) AS `Pharmacy`,
        SUM(CASE WHEN Bill_Type = 'Procedure' THEN Net_Amount ELSE 0 END) AS `Procedure`,
        SUM(CASE WHEN Bill_Type = 'Rad' THEN Net_Amount ELSE 0 END) AS `Rad`,
        SUM(CASE WHEN Bill_Type = 'Reg/Cons' THEN  Net_Amount ELSE 0 END) AS `Reg/Cons`
FROM bv_details
GROUP BY Last_Pay_Mode;
END //

DELIMITER ;
## 

CALL Summary_Table;

SELECT * FROM ip_bills_summary;

DESCRIBE ip_bills_summary;

SELECT count(*) FROM total_bill;
DESCRIBE total_bill;

ALTER TABLE total_bill
MODIFY COLUMN bill_date_only DATETIME;

DROP TABLE weekly_sales_summary;

CREATE TABLE weekly_sales_summary (
    Day_Name VARCHAR(15),
    Avg_Sales DECIMAL(10,2)
);

INSERT INTO weekly_sales_summary (Day_Name, Avg_Sales)
SELECT dayname(bill_date_only) AS Day_Name, ROUND(AVG(Net_total), 2)
FROM total_bill
GROUP BY dayname(bill_date_only)
ORDER BY AVG(Net_total) DESC;


Select dayname(Date), sum(Forecast_Net_Amount)
from total_bill_forecast
group by dayname(Date)
order by sum(Forecast_Net_Amount) desc;

SELECT * FROM weekly_sales_summary;

