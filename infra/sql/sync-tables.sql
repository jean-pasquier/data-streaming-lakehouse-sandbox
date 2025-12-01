
-- Each DML query creates a Flink job.


--- Sync data from source tables to fluss raw tables

EXECUTE STATEMENT SET
BEGIN
INSERT INTO fluss_nation SELECT * FROM `default_catalog`.`default_database`.source_nation;
INSERT INTO fluss_customer SELECT * FROM `default_catalog`.`default_database`.source_customer;
INSERT INTO fluss_order SELECT * FROM `default_catalog`.`default_database`.source_order;
END;


-- Run the ETL query

INSERT INTO enriched_order
SELECT o.order_key,
       o.cust_key,
       o.total_price,
       o.order_date,
       o.order_priority,
       o.clerk,
       c.name,
       c.phone,
       c.acctbal,
       c.mktsegment,
       n.name
FROM fluss_order o
     LEFT JOIN fluss_customer FOR SYSTEM_TIME AS OF `o`.`ptime` AS `c`
               ON o.cust_key = c.cust_key
     LEFT JOIN fluss_nation FOR SYSTEM_TIME AS OF `o`.`ptime` AS `n`
               ON c.nation_key = n.nation_key;
