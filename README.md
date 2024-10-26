# MediaWiki Flink CDC Experiments

- [T370354 [SPIKE] Experiment with approaches for a incremental updates of MediaWiki data in the Data Lake](https://phabricator.wikimedia.org/T370354)

- [T373144 [SPIKE] Learn and document how to use Flink-CDC from MediaWiki MariaDB locally](https://phabricator.wikimedia.org/T373144)



## Set up MediaWiki
This is meant to be used with MediaWiki core's docker compose.

To set up MediaWiki with docker compose, follow

https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/core/+/refs/heads/master/DEVELOPERS.md#quickstart

and also

https://www.mediawiki.org/wiki/MediaWiki-Docker/Configuration_recipes/Alternative_databases#MariaDB_(database_replication)



The docker-compose.override.yml file here is meant to be placed in the mediawiki root:

```
cd mediawiki/
# git clone this repository to ./flink-cdc-spike
ln -s ./flink-cdc-spike/docker-compose.override.yml ./
```


## build flink-cdc-spike image
```
cd flink-cdc-spike/dockerfiles
./docker_build.sh
```


## Start the services

Start all the services, including MediaWiki, MariaDB with replication binlog, Kafka, and Flink.
```
docker compose up -d
```

## Launch pipelines
The flink-launcher container can be used to launch flink-cdc pipelines, or flink-sql shells.

Launch the MySQL -> Kafka flink-cdc pipeline:

### launch mediawiki mariadb -> kafka flink-cdc pipeline

```bash
# /tmp/flink-cdc-pipeline-conf is mounted in the container from flink-cdc-spike/flink-cdc-pipeline-conf
docker compose run flink-launcher /opt/flink-cdc-3.1.0/bin/flink-cdc.sh \
    /tmp/flink-cdc-pipeline-conf/mysql-cdc-to-kafka.yaml
```

NOTE: This has to be launched into a Flink session cluster. According to
https://nightlies.apache.org/flink/flink-cdc-docs-release-3.2/docs/deployment/kubernetes/,

> Please note that submitting with native application mode and Flink Kubernetes operator are not supported for now.


### Launch Paimon kafka_sync_database action
TODO!

THIS DOES NOT WORK YET! https://phabricator.wikimedia.org/T373144#10264493

This is set up in docker-compose.override.yml as a standalone flink application cluster.

```bash
docker-compose up -d flink-jobmanager-kafka-to-paimon flink-taskmanager-kafka-to-paimon
```




