

# flink-cdc.sh is flink-cdc's pipeline job launcher
# /tmp/flink-cdc/conf is mounted from ./cache/flink/
#


# launch mediawiki mariadb -> kafka flink-cdc pipeline
docker compose run flink-launcher /opt/flink-cdc-3.1.0/bin/flink-cdc.sh \
    /tmp/flink-cdc-pipeline-conf/mysql-cdc-to-kafka.yaml







# launch kafka -> paimon action pipeline
# This is set up


docker compose run flink-launcher \
    bin/flink run \
    --class org.apache.paimon.flink.action.FlinkActions
    /opt/paimon-action/paimon-flink-action-0.9-20240904.002346-77.jar kafka_sync_database \
    --warehouse file:/user/hive/warehouse/paimon0 \
    --database mediawiki1 \
    --kafka_conf properties.bootstrap.servers=PLAINTEXT://broker:29092 \
    --kafka_conf topic=my_database.revision\;my_database.page\;my_database.slots\;my_database.content \
    --kafka_conf scan.startup.mode=earliest-offset \
    --kafka_conf properties.group.id=kafka_paimon0 \
    --kafka_conf value.format=debezium-json \
    --catalog_conf metastore=hive \
    --catalog_conf uri=thrift://hive-metastore:9083 \
    --table_conf bucket=4 \
    --table_conf changelog-producer=input \
    --table_conf sink.parallelism=4


