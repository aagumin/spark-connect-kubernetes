FROM eclipse-temurin:17 as builder

ENV MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
ENV SPARK_VERSION=3.5.6
ENV SPARK_HOME=/opt/spark
ENV SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}.tgz

WORKDIR /opt

RUN apt-get update; \
    apt-get install -y wget patch gettext-base gnupg2 bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu libnss-wrapper; \
    rm -rf /var/lib/apt/lists/*


RUN set -ex; \
    mkdir -p $SPARK_HOME; \
    wget -nv -O /opt/spark.tgz "$SPARK_TGZ_URL"; \
    tar -zxf /opt/spark.tgz --strip-components=1 --directory=$SPARK_HOME; \
    rm /opt/spark.tgz
    

WORKDIR $SPARK_HOME

COPY mtls/spark-40909.patch .
COPY celeborn/Celeborn-Optimize-Skew-Partitions-spark3_5_6.patch .
COPY celeborn/Columnar-mypatch-356.patch .

RUN patch -p1 < $SPARK_HOME/spark-40909.patch
RUN patch -p1 < $SPARK_HOME/Columnar-mypatch-356.patch
RUN patch -p1 < $SPARK_HOME/Celeborn-Optimize-Skew-Partitions-spark3_5_6.patch

RUN ./dev/make-distribution.sh \
      --name spark-mtls \
      -Pconnect \
      -Pkubernetes \
      -Phadoop-3 \
      -Phadoop-cloud \
      -Pparquet-provided \
      -Phive \
      -Phive-thriftserver

## IMPORTANT! We must delete the spark-connect-commom jar from the jars directory!
## see: https://issues.apache.org/jira/browse/SPARK-45201
#RUN rm "${SPARK_HOME}/jars/spark-connect-common_${SCALA_VERSION}-${SPARK_VERSION}.jar"
FROM python:3.10.14-slim-bookworm
ARG spark_uid=185
ENV SPARK_HOME=/opt/spark

RUN apt-get update; \
    apt-get install -y --no-install-recommends openjdk-17-jre tini procps gettext-base maven gettext-base curl; \
    rm -rf /var/lib/apt/lists/*


RUN groupadd --system --gid=${spark_uid} spark && \
    useradd --system --uid=${spark_uid} --gid=spark spark

COPY --from=builder /opt/spark/dist/ ${SPARK_HOME}/

RUN chown -R spark:spark ${SPARK_HOME}/

RUN cp ${SPARK_HOME}/kubernetes/dockerfiles/spark/entrypoint.sh /opt/entrypoint.sh; \
    chmod a+x /opt/entrypoint.sh; \
    cp ${SPARK_HOME}/kubernetes/dockerfiles/spark/decom.sh /opt/decom.sh; \
    chmod a+x /opt/decom.sh

COPY mtls/scripts/wait_for_istio_sidecar.sh /opt/scripts/wait_for_istio_sidecar.sh
RUN chmod +x /opt/scripts/wait_for_istio_sidecar.sh

COPY mtls/scripts/stop_istio_sidecar.sh /opt/scripts/stop_istio_sidecar.sh
RUN chmod +x /opt/scripts/stop_istio_sidecar.sh

# switch to spark user

WORKDIR /opt
COPY deps/pom.xml .

RUN mvn validate

RUN mvn install

RUN mvn dependency:copy-dependencies package

COPY ./deps/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/opt/entrypoint.sh"]
USER spark