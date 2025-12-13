-- init_database.sql

DROP DATABASE IF EXISTS gold_tracker;
CREATE DATABASE gold_tracker;
USE gold_tracker;

-- main price data
CREATE TABLE gold_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    price_date DATE NOT NULL,
    price_time TIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    price_change DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_datetime (price_date, price_time)
);

-- additional purity prices
CREATE TABLE purity_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    gold_price_id INT NOT NULL,
    purity VARCHAR(10) NOT NULL,
    price_per_gram DECIMAL(10,4) NOT NULL,
    FOREIGN KEY (gold_price_id) REFERENCES gold_prices(id) ON DELETE CASCADE,
    INDEX idx_gold_price (gold_price_id),
    UNIQUE KEY unique_purity_entry (gold_price_id, purity)
);