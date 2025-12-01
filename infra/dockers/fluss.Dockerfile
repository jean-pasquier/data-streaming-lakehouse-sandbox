ARG FLUSS_VERSION=0.8.0-incubating

FROM apache/fluss:${FLUSS_VERSION}

ARG FLUSS_VERSION=0.8.0-incubating
ARG PAIMON_VERSION=1.2.0

### Download jars from Maven repository ###

RUN curl -s https://repo1.maven.org/maven2/org/apache/fluss/fluss-fs-s3/${FLUSS_VERSION}/fluss-fs-s3-${FLUSS_VERSION}.jar -Lo /opt/fluss/lib/fluss-fs-s3-${FLUSS_VERSION}.jar
RUN curl -s https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-s3/${PAIMON_VERSION}/paimon-s3-${PAIMON_VERSION}.jar -Lo /opt/fluss/plugins/paimon/paimon-s3-${PAIMON_VERSION}.jar
