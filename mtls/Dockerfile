FROM eclipse-temurin:17

ENV MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
ENV SPARK_VERSION=4.0.0-preview2
ENV SPARK_HOME=/opt/spark
ENV SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}.tgz

WORKDIR /opt

ARG spark_uid=185

RUN groupadd --system --gid=${spark_uid} spark && \
    useradd --system --uid=${spark_uid} --gid=spark spark

RUN apt-get update; \
    apt-get install -y wget patch gettext-base gnupg2 bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu libnss-wrapper; \
    rm -rf /var/lib/apt/lists/*


RUN set -ex; \
    mkdir -p $SPARK_HOME; \
    wget -nv -O /opt/spark.tgz "$SPARK_TGZ_URL"; \
    tar -zxf /opt/spark.tgz --strip-components=1 --directory=$SPARK_HOME; \
    chown -R spark:spark .; \
    rm /opt/spark.tgz
    

WORKDIR $SPARK_HOME

COPY mtls/0001-feat-support-mtls-spark-4.0.0.patch .
COPY mtls/0002-fix-convertors-deps-update.patch .

RUN patch -p1 < $SPARK_HOME/0001-feat-support-mtls-spark-4.0.0.patch 
RUN patch -p1 < $SPARK_HOME/0002-fix-convertors-deps-update.patch

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
COPY docker/pom.xml .
COPY docker/requirements.txt .
RUN mvn validate

RUN mvn install

RUN mvn dependency:copy-dependencies package

RUN pip install -r requirements.txt
