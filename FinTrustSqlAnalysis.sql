SELECT 
    COUNT("Transaction_ID") as total_transactions,
    SUM("Amount_NGN") as total_volume,
    AVG("Amount_NGN") as average_transaction_size
FROM "Transation_data";
--This shows total transactions performed,total amount transacted and the average per transaction.

SELECT 
    "Channel",
    COUNT(*) as total_alerts,
    SUM("Amount_NGN") as total_alert_vol,
    AVG("Amount_NGN") as average_alert_vol
FROM "Transation_data"
WHERE "Risk_Review_Flag" = 'Yes' 
GROUP BY "Channel"
ORDER BY total_alerts DESC;
--total transaction perfomed in the different channels together with the total amount and average per channels.


SELECT "Customer_ID",COUNT(*) as total_trans, SUM("Amount_NGN") 
FROM  "Transation_data"
Where "Risk_Review_Flag" = 'Yes'
GROUP BY "Customer_ID"
ORDER BY total_trans DESC
Limit 10;
--Shows which customer has the highest transations that have been flagged for risk evaluation 
--Plus the total amount at risk.


SELECT 
    "Customer_ID", 
    "Transaction_DateTime", 
    COUNT(*) as frequency,
    SUM("Amount_NGN") as combined_amount
FROM "Transation_data"
GROUP BY "Customer_ID", "Transaction_DateTime"
HAVING COUNT(*)> 1 
ORDER BY frequency DESC;
--This shows which customer has committed more than 1 transaction at the same/exact time and the total amount transacted at that time.


SELECT 
    "Transaction_Type",
    COUNT(*) as total_alerts,
    SUM("Amount_NGN") as total_alert_value,
    AVG("Amount_NGN") as average_alert_value
FROM "Transation_data"
WHERE "Risk_Review_Flag" = 'Yes' 
GROUP BY "Transaction_Type"
ORDER BY total_alerts DESC;
--Shows the total transaction ,total amount and average amount per transaction for the different transaction types that have been flagged for risk evaluation.


SELECT 
    "Transaction_Status",
    "Risk_Review_Flag" ,
    COUNT(*) as total_transactions,
    SUM("Amount_NGN") as total_Risk
FROM "Transation_data"
GROUP BY   "Transaction_Status","Risk_Review_Flag" 
ORDER BY  "Risk_Review_Flag" DESC, total_transactions DESC;
--Shows the different transaction status with their risk flagged status ,total transation and total amount.


SELECT 
    "Risk_Review_Flag",
    MIN("Amount_NGN") as lowest_amount,
    MAX("Amount_NGN") as highest_amount,
    AVG("Amount_NGN") as average_amount
FROM "Transation_data"
GROUP BY "Risk_Review_Flag";
--shows the risk review status -lowest/highest/average amount transacted.


SELECT 
    "Customer_ID",
    "Transaction_DateTime"::date as t_date,
    COUNT(DISTINCT "Location") as unique_cities,
    COUNT(DISTINCT "Device_Type") as unique_devices,
    COUNT(*) as total_transactions
FROM "Transation_data"
GROUP BY "Customer_ID", "Transaction_DateTime"::date
HAVING COUNT(DISTINCT "Location") > 1
ORDER BY unique_cities DESC;
--shows which customer transacted in more than 1 location ,how many devices did he/she use to transact and the total transactions performed in a day.  



CREATE VIEW Fintrust_data AS
SELECT 
    t.*, 
    c."age",
	c."gender",
	c."city",
	c."customer_segment",
	c."account_type",
	c."tenure_months",
	c."monthly_income_band",
	c."digital_engagement_score",
	c."preferred_channel",
	c."account_status"
FROM "Transation_data" t
LEFT JOIN "Customer_data" c On t."Customer_ID" = c."customer_id";
--joining Fintrust_transaction data with Fintrust_customer data

Select * From Fintrust_data;


SELECT 
    "account_status",
    COUNT(*) as total_transactions,
    SUM("Amount_NGN") as total_volume_moved,
    AVG("Amount_NGN") as average_transaction_size,
    MAX("Amount_NGN") as largest_single_action
FROM Fintrust_data
GROUP BY  "account_status"
ORDER BY total_volume_moved DESC;
--Shows the total transation ,total amount ,average amount ,largest amount transacted in the diff bnmerent customer's accounts.



SELECT 
    CASE 
        WHEN "digital_engagement_score" <= 33 THEN 'Low Engagement (33 and under)'
        WHEN "digital_engagement_score" BETWEEN 33 AND 67 THEN 'Medium Engagement (34 - 66)'
        ELSE 'High Engagement (Above 66)'
    END as engagement_group,
    "Risk_Review_Flag",
    COUNT(*) as transaction_count,
    AVG("Amount_NGN") as avg_transaction_amount
FROM Fintrust_data
GROUP BY 
    engagement_group,
    "Risk_Review_Flag"
ORDER BY engagement_group, "Risk_Review_Flag" 
--which group of customers who are using the digital platform are alerting risk and what amount is at risk.


SELECT 
    "customer_segment",
    COUNT(*) as total_alerts,
    SUM("Amount_NGN") as total_alert_value,
    AVG("Amount_NGN") as average_alert_value
FROM Fintrust_data
WHERE "Risk_Review_Flag" = 'Yes' 
GROUP BY  "customer_segment"
ORDER BY total_alerts DESC;
--shows which customer segment have performed transactions that have been flagged for risk alerts and what amount is at stake.

SELECT 
    CASE 
        WHEN "age" < 28 THEN 'Gen Z'
        WHEN "age" BETWEEN 28 AND 40 THEN 'Millenial'
        ELSE 'Grandy'
    END as age_group,
    "Risk_Review_Flag",
    COUNT(*) as transaction_count,
	Sum ("Amount_NGN") as total_risk,
    AVG("Amount_NGN") as avg_transaction_amount
FROM Fintrust_data
GROUP BY 
	 age_group,
    "Risk_Review_Flag"
ORDER BY age_group, "Risk_Review_Flag" 
--which age goup is more susceptible to alerting risks and amount at risk.

SELECT 
    "gender",
    "Transaction_Type",
	"Risk_Review_Flag",
    COUNT(*) as frequency,
    SUM("Amount_NGN") as total_spent
FROM Fintrust_data
GROUP BY "Transaction_Type","gender","Risk_Review_Flag"
ORDER BY "Transaction_Type", frequency DESC;
--shows which gender dominates in what transation type and who is arrising the risk alerts.

SELECT 
    "Channel",
    "Transaction_Type",
	"Risk_Review_Flag",
    COUNT(*) as frequency,
    SUM("Amount_NGN") as total_spent
FROM Fintrust_data
GROUP BY "Transaction_Type","Channel","Risk_Review_Flag"
ORDER BY "Transaction_Type", "Channel" , frequency DESC;
--shows distribution of transaction that use the same channel and the type of transation showing which transaction have caused more risks alerts.
	



















