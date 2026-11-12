USE pds_analytics;

-- 1. Basic filtering: active ration shops.
SELECT *
FROM Ration_Shops
WHERE shop_status = 'Active';

-- 2. INNER JOIN: list beneficiaries with their district.
SELECT
    b.beneficiary_name,
    b.ration_card_number,
    b.card_category,
    d.district_name,
    d.state_name
FROM Beneficiaries b
INNER JOIN Districts d ON d.district_id = b.district_id
ORDER BY d.district_name, b.beneficiary_name;

-- 3. Multiple JOINs: distribution transaction details.
SELECT
    t.transaction_id,
    b.beneficiary_name,
    s.shop_name,
    c.commodity_name,
    t.distribution_date,
    t.quantity_kg,
    t.transaction_status
FROM Distribution_Transactions t
JOIN Beneficiaries b ON b.beneficiary_id = t.beneficiary_id
JOIN Ration_Shops s ON s.shop_id = t.shop_id
JOIN Commodities c ON c.commodity_id = t.commodity_id
ORDER BY t.distribution_date;

-- 4. GROUP BY: total successful quantity distributed per commodity.
SELECT
    c.commodity_name,
    SUM(t.quantity_kg) AS total_distributed_kg
FROM Distribution_Transactions t
JOIN Commodities c ON c.commodity_id = t.commodity_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.commodity_name
ORDER BY total_distributed_kg DESC;

-- 5. GROUP BY + HAVING: shops with more than 30 kg successful distribution.
SELECT
    s.shop_name,
    SUM(t.quantity_kg) AS total_quantity_kg
FROM Ration_Shops s
JOIN Distribution_Transactions t ON t.shop_id = s.shop_id
WHERE t.transaction_status = 'Successful'
GROUP BY s.shop_id, s.shop_name
HAVING SUM(t.quantity_kg) > 30;

-- 6. LEFT JOIN: beneficiaries with no successful transaction.
SELECT
    b.beneficiary_id,
    b.beneficiary_name,
    b.ration_card_number
FROM Beneficiaries b
LEFT JOIN Distribution_Transactions t
    ON t.beneficiary_id = b.beneficiary_id
    AND t.transaction_status = 'Successful'
WHERE t.transaction_id IS NULL;

-- 7. CASE: classify transaction records.
SELECT
    transaction_id,
    quantity_kg,
    transaction_status,
    CASE
        WHEN transaction_status = 'Successful' THEN 'Completed'
        WHEN transaction_status = 'Pending' THEN 'Awaiting confirmation'
        ELSE 'Unsuccessful'
    END AS transaction_label
FROM Distribution_Transactions;

-- 8. Subquery: shops whose successful distribution is above the average shop distribution.
SELECT
    shop_name,
    total_quantity
FROM (
    SELECT
        s.shop_id,
        s.shop_name,
        COALESCE(SUM(CASE WHEN t.transaction_status = 'Successful' THEN t.quantity_kg ELSE 0 END), 0) AS total_quantity
    FROM Ration_Shops s
    LEFT JOIN Distribution_Transactions t ON t.shop_id = s.shop_id
    GROUP BY s.shop_id, s.shop_name
) AS shop_totals
WHERE total_quantity > (
    SELECT AVG(total_per_shop)
    FROM (
        SELECT
            COALESCE(SUM(CASE WHEN t2.transaction_status = 'Successful' THEN t2.quantity_kg ELSE 0 END), 0) AS total_per_shop
        FROM Ration_Shops s2
        LEFT JOIN Distribution_Transactions t2 ON t2.shop_id = s2.shop_id
        GROUP BY s2.shop_id
    ) AS average_source
);

-- 9. Date function: total successful quantity distributed by month.
SELECT
    DATE_FORMAT(distribution_date, '%Y-%m') AS distribution_month,
    SUM(quantity_kg) AS total_quantity_kg
FROM Distribution_Transactions
WHERE transaction_status = 'Successful'
GROUP BY DATE_FORMAT(distribution_date, '%Y-%m')
ORDER BY distribution_month;

-- 10. Compare allocated vs distributed quantity by shop and commodity.
SELECT
    a.shop_name,
    a.commodity_name,
    a.allocation_month,
    a.allocated_quantity,
    COALESCE(SUM(
        CASE
            WHEN t.transaction_status = 'Successful'
             AND DATE_FORMAT(t.distribution_date, '%Y-%m') = DATE_FORMAT(a.allocation_month, '%Y-%m')
            THEN t.quantity_kg
            ELSE 0
        END
    ), 0) AS distributed_quantity,
    a.allocated_quantity - COALESCE(SUM(
        CASE
            WHEN t.transaction_status = 'Successful'
             AND DATE_FORMAT(t.distribution_date, '%Y-%m') = DATE_FORMAT(a.allocation_month, '%Y-%m')
            THEN t.quantity_kg
            ELSE 0
        END
    ), 0) AS remaining_allocated_quantity
FROM shop_monthly_allocation a
LEFT JOIN Distribution_Transactions t
    ON t.shop_id = a.shop_id
    AND t.commodity_id = (
        SELECT c2.commodity_id FROM Commodities c2
        WHERE c2.commodity_name = a.commodity_name
    )
GROUP BY a.shop_id, a.shop_name, a.commodity_name, a.allocation_month, a.allocated_quantity
ORDER BY a.shop_name, a.commodity_name;

-- 11. View usage.
SELECT * FROM successful_distributions ORDER BY distribution_date;
SELECT * FROM shop_monthly_allocation ORDER BY shop_name, commodity_name;

-- 12. EXPLAIN: inspect transaction date/shop index usage.
EXPLAIN
SELECT transaction_id, distribution_date, quantity_kg
FROM Distribution_Transactions
WHERE shop_id = 1
  AND distribution_date >= '2026-10-01'
  AND distribution_date < '2026-11-01';

-- 13. Stored procedure: monthly summary for a selected shop.
DROP PROCEDURE IF EXISTS GetShopMonthlySummary;
DELIMITER $$
CREATE PROCEDURE GetShopMonthlySummary(IN p_shop_id INT, IN p_month DATE)
BEGIN
    SELECT
        s.shop_name,
        c.commodity_name,
        a.allocated_quantity,
        COALESCE(SUM(
            CASE WHEN t.transaction_status = 'Successful'
                 THEN t.quantity_kg ELSE 0 END
        ), 0) AS distributed_quantity
    FROM Ration_Shops s
    JOIN Monthly_Allocations a ON a.shop_id = s.shop_id
    JOIN Commodities c ON c.commodity_id = a.commodity_id
    LEFT JOIN Distribution_Transactions t
        ON t.shop_id = s.shop_id
        AND t.commodity_id = c.commodity_id
        AND DATE_FORMAT(t.distribution_date, '%Y-%m') = DATE_FORMAT(p_month, '%Y-%m')
    WHERE s.shop_id = p_shop_id
      AND a.allocation_month = DATE_FORMAT(p_month, '%Y-%m-01')
    GROUP BY s.shop_name, c.commodity_name, a.allocated_quantity
    ORDER BY c.commodity_name;
END$$
DELIMITER ;

-- Example call: shop 1, October 2026.
CALL GetShopMonthlySummary(1, '2026-10-01');
