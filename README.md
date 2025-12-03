# Data streaming lakehouse

Fluss is a streaming storage built for real-time analytics which can serve as the real-time data layer for Lakehouse architectures. Check [fluss GitHub](https://github.com/apache/fluss/)

It can be seen as a "Kafka alternative" by implementing immutable log storage, with much higher focus on analytics with some interesting features with Data LakeHouse tiering with "Union Read": fetch both hot and cold layers on single query. 

It relies on the open format [Apache Paimon](https://github.com/apache/paimon/) but tends to be compatible with Iceberg and other formats (even kafka).


## How to


### Start cluster

```shell
cd infra/

# Spin up minio & create bucket 
docker compose up minio-init -d

# Spin up the rest: Fluss cluster and Flink cluster (with custom docker images) 
docker compose up -d --build
```

Visit Flink UI [localhost:8073](http://localhost:8073)

Must run the Lakehouse tiering service as flink job: 

```shell
docker compose exec flink-jobmanager \
/opt/flink/bin/flink run \
-Dparallelism.default=3 \
/opt/flink/opt/fluss-flink-tiering-0.8.0-incubating.jar \
--fluss.bootstrap.servers fluss-coordinator:9123 \
--datalake.format paimon \
--datalake.paimon.metastore filesystem \
--datalake.paimon.warehouse "s3://poc-data-fluss/data" \
--datalake.paimon.s3.endpoint "http://minio:9000" \
--datalake.paimon.s3.allow_http true \
--datalake.paimon.s3.region local-01 \
--datalake.paimon.s3.access-key root \
--datalake.paimon.s3.secret-key root-pwd \
--datalake.paimon.s3.path.style.access true
```

### Ingest and play with some data


```shell
# -i to init SQL session with mounted sql
docker compose exec flink-jobmanager ./bin/sql-client.sh -i ./sql/init-fluss-with-fake.sql

Flink SQL> SHOW CATALOGS;
Flink SQL> SHOW TABLES; # in current fluss catalog
Flink SQL> SHOW TABLES IN default_catalog.default_database;
Ctrl+D to exit
```

```shell
# -f to run the SQL file
docker compose exec flink-jobmanager ./bin/sql-client.sh -i ./sql/init-fluss-with-fake.sql -f ./sql/create-tables.sql
docker compose exec flink-jobmanager ./bin/sql-client.sh -i ./sql/init-fluss-with-fake.sql -f ./sql/sync-tables.sql
```

### Analyse results


```shell
docker compose exec flink-jobmanager ./bin/sql-client.sh -i ./sql/init-fluss-with-fake.sql
Flink SQL> SHOW TABLES;
Flink SQL> SET 'execution.runtime-mode' = 'batch';
Flink SQL> SET 'sql-client.execution.result-mode' = 'tableau';
Flink SQL> SELECT * FROM enriched_orders LIMIT 10;

# only datalake tiered data, eg missing last 30s data
Flink SQL> SELECT count(*) FROM enriched_orders$lake;

# all rows: hot & cold
Flink SQL> SELECT count(*) FROM enriched_orders;

# scan tiering history
Flink SQL> SELECT commit_time, snapshot_id, delta_record_count, total_record_count FROM enriched_order$lake$snapshots order by commit_time ASC;
Ctrl+D to exit
```


## Next steps

* [ ] Setup remote tiering for fluss internal data
* [ ] Try Iceberg integration instead of Paimon
* [ ] Run some performance benchmarks


## Acknowledgments

* [fluss quickstart](https://fluss.apache.org/docs/quickstart/lakehouse/)
* [fluss blog](https://fluss.apache.org/blog/hands-on-fluss-lakehouse/)
