
ARG FLINK_VERSION=1.20.0

FROM flink:${FLINK_VERSION}-scala_2.12-java17


ENV FLINK_HOME=/opt/flink


ARG FLINK_VERSION=1.20.0
ARG FLINK_MINOR=1.20

ARG FLUSS_VERSION=0.8.0-incubating

ARG PAIMON_VERSION=1.2.0

ARG FLINK_FAKER_VERSION=0.5.3



### Download jars from Maven repository ###

# Fluss Flink tiering job in opt/
RUN curl -s https://repo1.maven.org/maven2/org/apache/fluss/fluss-flink-tiering/${FLUSS_VERSION}/fluss-flink-tiering-${FLUSS_VERSION}.jar -Lo ${FLINK_HOME}/opt/fluss-flink-tiering-${FLUSS_VERSION}.jar

# Flink faker
RUN curl -s https://github.com/knaufk/flink-faker/releases/download/v${FLINK_FAKER_VERSION}/flink-faker-${FLINK_FAKER_VERSION}.jar -Lo ${FLINK_HOME}/lib/flink-faker-${FLINK_FAKER_VERSION}.jar

# Fluss Flink connector
RUN curl -s https://repo1.maven.org/maven2/org/apache/fluss/fluss-flink-${FLINK_MINOR}/${FLUSS_VERSION}/fluss-flink-${FLINK_MINOR}-${FLUSS_VERSION}.jar -Lo ${FLINK_HOME}/lib/fluss-flink-${FLINK_MINOR}-${FLUSS_VERSION}.jar

# Fluss lake iceberg
RUN curl -s https://repo1.maven.org/maven2/org/apache/fluss/fluss-lake-iceberg/${FLUSS_VERSION}/fluss-lake-iceberg-${FLUSS_VERSION}.jar -Lo ${FLINK_HOME}/lib/fluss-lake-iceberg-${FLUSS_VERSION}.jar

# Fluss lake paimon
RUN curl -s https://repo1.maven.org/maven2/org/apache/fluss/fluss-lake-paimon/${FLUSS_VERSION}/fluss-lake-paimon-${FLUSS_VERSION}.jar -Lo ${FLINK_HOME}/lib/fluss-lake-paimon-${FLUSS_VERSION}.jar

# Paimon Flink connector
RUN curl -s https://repo1.maven.org/maven2/org/apache/paimon/paimon-flink-${FLINK_MINOR}/${PAIMON_VERSION}/paimon-flink-${FLINK_MINOR}-${PAIMON_VERSION}.jar -Lo ${FLINK_HOME}/lib/paimon-flink-${FLINK_MINOR}-${PAIMON_VERSION}.jar

# Paimon s3
RUN curl -s https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-s3/${PAIMON_VERSION}/paimon-s3-${PAIMON_VERSION}.jar -Lo ${FLINK_HOME}/lib/paimon-s3-${PAIMON_VERSION}.jar

# Fluss S3
RUN curl -s https://repo1.maven.org/maven2/org/apache/fluss/fluss-fs-s3/${FLUSS_VERSION}/fluss-fs-s3-${FLUSS_VERSION}.jar -Lo ${FLINK_HOME}/lib/fluss-fs-s3-${FLUSS_VERSION}.jar

# Hadoop HDFS
RUN curl -s https://repo1.maven.org/maven2/io/trino/hadoop/hadoop-apache/3.3.5-2/hadoop-apache-3.3.5-2.jar -Lo ${FLINK_HOME}/lib/hadoop-apache-3.3.5-2.jar

# Flink S3 in plugin/

RUN mkdir ${FLINK_HOME}/plugins/s3-fs-hadoop && \
    cp ${FLINK_HOME}${FLINK_HOME}-s3-fs-hadoop-${FLINK_VERSION}.jar ${FLINK_HOME}/plugins/s3-fs-hadoop/ \
