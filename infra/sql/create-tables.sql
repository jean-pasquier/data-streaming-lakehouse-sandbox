
-- Create the 3 "raw" fluss tables (same schema as flink faker source tables)

CREATE TABLE IF NOT EXISTS fluss_order
(
    `order_key`      BIGINT,
    `cust_key`       INT NOT NULL,
    `total_price`    DECIMAL(15, 2),
    `order_date`     DATE,
    `order_priority` STRING,
    `clerk`          STRING,
    `ptime` AS PROCTIME(),
    PRIMARY KEY (`order_key`) NOT ENFORCED
);

CREATE TABLE IF NOT EXISTS fluss_customer
(
    `cust_key`   INT NOT NULL,
    `name`       STRING,
    `phone`      STRING,
    `nation_key` INT NOT NULL,
    `acctbal`    DECIMAL(15, 2),
    `mktsegment` STRING,
    PRIMARY KEY (`cust_key`) NOT ENFORCED
);


CREATE TABLE IF NOT EXISTS fluss_nation
(
    `nation_key` INT NOT NULL,
    `name`       STRING,
    PRIMARY KEY (`nation_key`) NOT ENFORCED
);



-- Create the downstream result table
-- Tiered to cold datalake storage

CREATE TABLE IF NOT EXISTS enriched_order
(
    `order_key`       BIGINT,
    `cust_key`        INT NOT NULL,
    `total_price`     DECIMAL(15, 2),
    `order_date`      DATE,
    `order_priority`  STRING,
    `clerk`           STRING,
    `cust_name`       STRING,
    `cust_phone`      STRING,
    `cust_acctbal`    DECIMAL(15, 2),
    `cust_mktsegment` STRING,
    `nation_name`     STRING,
    PRIMARY KEY (`order_key`) NOT ENFORCED
) WITH (
    'table.datalake.enabled' = 'true',
    'table.datalake.freshness' = '30s'
);
