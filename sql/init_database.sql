-- init_database.sql

CREATE DATABASE IF NOT EXISTS gold_tracker;
USE gold_tracker;

CREATE TABLE gold_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    price_date DATE NOT NULL,
    price_time TIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    price_change DECIMAL(10,2),
    price_gram_24k DECIMAL(10,4),
    price_gram_22k DECIMAL(10,4),
    price_gram_21k DECIMAL(10,4),
    price_gram_20k DECIMAL(10,4),
    price_gram_18k DECIMAL(10,4),
    price_gram_16k DECIMAL(10,4),
    price_gram_14k DECIMAL(10,4),
    price_gram_10k DECIMAL(10,4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);