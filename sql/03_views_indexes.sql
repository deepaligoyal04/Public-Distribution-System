USE pds_analytics;

-- View 1: successful ration distributions with beneficiary, shop and commodity details.
CREATE OR REPLACE VIEW successful_distributions AS
SELECT
    t.transaction_id,
    t.distribution_date,
    b.beneficiary_name,
    b.ration_card_number,
    s.shop_name,
    d.district_name,
    c.commodity_name,
    t.quantity_kg
FROM Distribution_Transactions t
JOIN Beneficiaries b ON b.beneficiary_id = t.beneficiary_id
JOIN Ration_Shops s ON s.shop_id = t.shop_id
JOIN Districts d ON d.district_id = s.district_id
JOIN Commodities c ON c.commodity_id = t.commodity_id
WHERE t.transaction_status = 'Successful';

-- View 2: shop-wise allocated quantity by commodity and month.
CREATE OR REPLACE VIEW shop_monthly_allocation AS
SELECT
    s.shop_id,
    s.shop_name,
    d.district_name,
    c.commodity_name,
    a.allocation_month,
    a.allocated_quantity
FROM Monthly_Allocations a
JOIN Ration_Shops s ON s.shop_id = a.shop_id
JOIN Districts d ON d.district_id = s.district_id
JOIN Commodities c ON c.commodity_id = a.commodity_id;

-- Useful indexes for frequent filters.
CREATE INDEX idx_beneficiary_district ON Beneficiaries(district_id);
CREATE INDEX idx_transaction_date_status ON Distribution_Transactions(distribution_date, transaction_status);
CREATE INDEX idx_transaction_shop_date ON Distribution_Transactions(shop_id, distribution_date);
CREATE INDEX idx_transaction_beneficiary ON Distribution_Transactions(beneficiary_id);
