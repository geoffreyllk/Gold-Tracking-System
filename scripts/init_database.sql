-- init_database.sql

CREATE DATABASE IF NOT EXISTS gold_tracker;
USE gold_tracker;

CREATE TABLE IF NOT EXISTS gold_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    price_date DATE NOT NULL,
    price_time TIME NOT NULL,
    gold_price_usd DECIMAL(10,2) NOT NULL,
    change_amount DECIMAL(10,2),
    change_percentage DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_gold_date ON gold_prices(price_date);
CREATE INDEX idx_gold_datetime ON gold_prices(price_date, price_time);