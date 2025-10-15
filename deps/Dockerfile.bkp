FROM spark:3.5.6-python3

USER 0
RUN  apt-get update -y && \
     apt-get install -y curl zip maven tini procps gettext-base


ENV SPARK_HOME /opt/spark
WORKDIR /opt

COPY pom.xml .

RUN mvn validate

RUN mvn install

RUN mvn dependency:copy-dependencies package

COPY requirements.txt .

RUN pip install -r requirements.txt

WORKDIR /opt/spark/work-dir
USER 185