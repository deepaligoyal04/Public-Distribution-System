USE pds_analytics;

INSERT INTO Districts (district_name, state_name) VALUES
('East Delhi', 'Delhi'),
('Ghaziabad', 'Uttar Pradesh'),
('Gautam Buddha Nagar', 'Uttar Pradesh');

INSERT INTO Ration_Shops (district_id, shop_name, shop_code, address, shop_status) VALUES
(1, 'Shakti Fair Price Shop', 'DL-E-101', 'Mayur Vihar, Delhi', 'Active'),
(1, 'Jan Seva Ration Centre', 'DL-E-102', 'Patparganj, Delhi', 'Active'),
(2, 'Nagar Ration Shop', 'UP-GZB-201', 'Indirapuram, Ghaziabad', 'Active'),
(2, 'District Supply Store', 'UP-GZB-202', 'Vasundhara, Ghaziabad', 'Active'),
(3, 'People Welfare Shop', 'UP-NOIDA-301', 'Sector 62, Noida', 'Active');

INSERT INTO Beneficiaries
(district_id, ration_card_number, beneficiary_name, family_members, card_category, registration_date) VALUES
(1, 'RC-DL-1001', 'Aarav Sharma', 4, 'PHH', '2025-01-12'),
(1, 'RC-DL-1002', 'Diya Verma', 3, 'PHH', '2025-02-18'),
(1, 'RC-DL-1003', 'Kabir Singh', 6, 'AAY', '2025-03-05'),
(1, 'RC-DL-1004', 'Meera Gupta', 2, 'PHH', '2025-04-22'),
(2, 'RC-UP-2001', 'Rohan Mehta', 5, 'PHH', '2025-01-28'),
(2, 'RC-UP-2002', 'Sara Khan', 4, 'AAY', '2025-02-11'),
(2, 'RC-UP-2003', 'Ishaan Jain', 3, 'PHH', '2025-05-16'),
(2, 'RC-UP-2004', 'Anaya Das', 2, 'PHH', '2025-06-09'),
(3, 'RC-UP-3001', 'Vivaan Roy', 5, 'PHH', '2025-03-14'),
(3, 'RC-UP-3002', 'Myra Nair', 3, 'AAY', '2025-07-01');

INSERT INTO Commodities (commodity_name, unit) VALUES
('Rice', 'kg'),
('Wheat', 'kg'),
('Sugar', 'kg'),
('Pulses', 'kg');

INSERT INTO Monthly_Allocations (shop_id, commodity_id, allocation_month, allocated_quantity) VALUES
(1, 1, '2026-10-01', 500), (1, 2, '2026-10-01', 350), (1, 3, '2026-10-01', 100),
(2, 1, '2026-10-01', 420), (2, 2, '2026-10-01', 300), (2, 3, '2026-10-01', 80),
(3, 1, '2026-10-01', 600), (3, 2, '2026-10-01', 400), (3, 4, '2026-10-01', 120),
(4, 1, '2026-10-01', 380), (4, 2, '2026-10-01', 260), (4, 3, '2026-10-01', 70),
(5, 1, '2026-10-01', 450), (5, 2, '2026-10-01', 320), (5, 4, '2026-10-01', 90);

INSERT INTO Distribution_Transactions
(beneficiary_id, shop_id, commodity_id, distribution_date, quantity_kg, transaction_status) VALUES
(1, 1, 1, '2026-10-03', 20, 'Successful'),
(1, 1, 2, '2026-10-03', 12, 'Successful'),
(2, 1, 1, '2026-10-04', 15, 'Successful'),
(3, 1, 1, '2026-10-05', 25, 'Successful'),
(4, 2, 1, '2026-10-06', 10, 'Successful'),
(2, 2, 2, '2026-10-07', 8, 'Pending'),
(5, 3, 1, '2026-10-08', 20, 'Successful'),
(6, 3, 2, '2026-10-09', 15, 'Successful'),
(7, 3, 1, '2026-10-10', 12, 'Successful'),
(8, 4, 1, '2026-10-11', 8, 'Failed'),
(9, 5, 1, '2026-10-12', 18, 'Successful'),
(10, 5, 2, '2026-10-13', 10, 'Successful'),
(5, 3, 3, '2026-10-15', 2, 'Successful'),
(1, 1, 3, '2026-10-16', 3, 'Successful'),
(7, 3, 4, '2026-10-18', 5, 'Successful');
