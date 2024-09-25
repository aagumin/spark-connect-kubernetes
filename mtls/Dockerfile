# I want to build Spark with PySpark support for Python 3.10, so I need a docker image with both Python and Java.
# It is faster to start from an image with Python and install the JDK later.
FROM eclipse-temurin:11

ENV MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
ENV SCALA_VERSION=2.12
ENV SPARK_VERSION=3.5.3
ENV SPARK_HOME=/opt/spark
ENV HADOOP_VERSION=3.3.4
WORKDIR /opt

# Install packages
RUN apt-get update \
    && apt-get install -y wget patch curl zip tini procps gettext-base \
    && rm -rf /var/lib/apt/lists/*


RUN wget -O /opt/spark.tar.gz https://github.com/apache/spark/archive/refs/tags/v${SPARK_VERSION}.tar.gz
RUN mkdir -p $SPARK_HOME
RUN tar zxf /opt/spark.tar.gz --strip-components=1 --directory=$SPARK_HOME
RUN rm /opt/spark.tar.gz

# Setting up Maven's Memory Usage

# Patch (see: https://issues.apache.org/jira/browse/SPARK-45201) and build a runnable Spark distribution

#
WORKDIR $SPARK_HOME


COPY mtls/spark-42411.patch .

RUN patch -p1 < $SPARK_HOME/spark-42411.patch


#RUN ./dev/change-scala-version.sh 2.13
RUN ./dev/make-distribution.sh \
      --name spark-mtls \
      --pip \
      -P"scala-${SCALA_VERSION}" \
      -Pconnect \
      -Pkubernetes \
      -Phive \
      -Pparquet-provided \
      -Porc-provided \
      -Phive-thriftserver \
      -Phadoop-3 \
      -Phadoop-cloud \
      -Dhadoop.version=${HADOOP_VERSION} \
      -Dscala-maven-plugin.version=4.7.2

#
##
##
## IMPORTANT! We must delete the spark-connect-commom jar from the jars directory!
## see: https://issues.apache.org/jira/browse/SPARK-45201
#RUN rm "${SPARK_HOME}/jars/spark-connect-common_${SCALA_VERSION}-${SPARK_VERSION}.jar"
#
#COPY docker/pom.xml .
#COPY docker/requirements.txt .
#
#RUN mvn validate
##
##RUN mvn install
##
##RUN mvn dependency:copy-dependencies package
##
##RUN pip install -r requirements.txt
