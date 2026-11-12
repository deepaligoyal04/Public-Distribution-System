-- Public Distribution System Analytics
-- MySQL 8.0+
CREATE DATABASE IF NOT EXISTS pds_analytics;
USE pds_analytics;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Distribution_Transactions;
DROP TABLE IF EXISTS Monthly_Allocations;
DROP TABLE IF EXISTS Beneficiaries;
DROP TABLE IF EXISTS Commodities;
DROP TABLE IF EXISTS Ration_Shops;
DROP TABLE IF EXISTS Districts;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Districts (
    district_id INT AUTO_INCREMENT PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_district UNIQUE (district_name, state_name)
);

CREATE TABLE Ration_Shops (
    shop_id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT NOT NULL,
    shop_name VARCHAR(120) NOT NULL,
    shop_code VARCHAR(30) NOT NULL UNIQUE,
    address VARCHAR(255),
    shop_status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_shop_district FOREIGN KEY (district_id)
        REFERENCES Districts(district_id)
);

CREATE TABLE Beneficiaries (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    district_id INT NOT NULL,
    ration_card_number VARCHAR(30) NOT NULL UNIQUE,
    beneficiary_name VARCHAR(120) NOT NULL,
    family_members TINYINT UNSIGNED NOT NULL,
    card_category ENUM('PHH', 'AAY') NOT NULL,
    registration_date DATE NOT NULL,
    CONSTRAINT chk_family_members CHECK (family_members > 0),
    CONSTRAINT fk_beneficiary_district FOREIGN KEY (district_id)
        REFERENCES Districts(district_id)
);

CREATE TABLE Commodities (
    commodity_id INT AUTO_INCREMENT PRIMARY KEY,
    commodity_name VARCHAR(80) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL DEFAULT 'kg'
);

CREATE TABLE Monthly_Allocations (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    commodity_id INT NOT NULL,
    allocation_month DATE NOT NULL,
    allocated_quantity DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_allocated_quantity CHECK (allocated_quantity >= 0),
    CONSTRAINT uq_shop_commodity_month UNIQUE (shop_id, commodity_id, allocation_month),
    CONSTRAINT fk_allocation_shop FOREIGN KEY (shop_id)
        REFERENCES Ration_Shops(shop_id),
    CONSTRAINT fk_allocation_commodity FOREIGN KEY (commodity_id)
        REFERENCES Commodities(commodity_id)
);

CREATE TABLE Distribution_Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiary_id INT NOT NULL,
    shop_id INT NOT NULL,
    commodity_id INT NOT NULL,
    distribution_date DATE NOT NULL,
    quantity_kg DECIMAL(10,2) NOT NULL,
    transaction_status ENUM('Successful', 'Failed', 'Pending') NOT NULL DEFAULT 'Successful',
    CONSTRAINT chk_distribution_quantity CHECK (quantity_kg > 0),
    CONSTRAINT fk_transaction_beneficiary FOREIGN KEY (beneficiary_id)
        REFERENCES Beneficiaries(beneficiary_id),
    CONSTRAINT fk_transaction_shop FOREIGN KEY (shop_id)
        REFERENCES Ration_Shops(shop_id),
    CONSTRAINT fk_transaction_commodity FOREIGN KEY (commodity_id)
        REFERENCES Commodities(commodity_id)
);
