FROM alpine:3.12.3
MAINTAINER celsomarques <celso.marques82@gmail.com>

# packages
RUN apk add --no-cache curl bash openjdk8-jre python3 py-pip nss libc6-compat

# Overall ENV vars
ENV SPARK_VERSION 2.4.7
ENV HADOOP_VERSION 2.7
ENV LIVY_VERSION 0.7.0-incubating
ENV SPARK_FILE spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
ENV LIVY_FILE apache-livy-$LIVY_VERSION-bin

# Set directories
ENV SPARK_HOME /usr/local/$SPARK_FILE
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV LIVY_HOME /app/$LIVY_FILE

# Spark ENV vars
ENV SPARK_DOWNLOAD_URL https://downloads.apache.org/spark/spark-$SPARK_VERSION/$SPARK_FILE.tgz
ENV LIVY_DOWNLOAD_URL https://downloads.apache.org/incubator/livy/$LIVY_VERSION/$LIVY_FILE.zip

# Download and unzip Spark
RUN wget $SPARK_DOWNLOAD_URL && \
    tar xvf $SPARK_FILE.tgz && \
    mv $SPARK_FILE /usr/local/. && \
    rm $SPARK_FILE.tgz

# Download and unzip Livy
RUN mkdir -p /app/ && \
    wget $LIVY_DOWNLOAD_URL && \
    unzip $LIVY_FILE.zip && \
    mv $LIVY_FILE /app/. && \
    rm $LIVY_FILE.zip

RUN mkdir /$LIVY_HOME/logs && mkdir /$LIVY_HOME/upload

# Add custom files, set permissions
ADD entrypoint.sh .
ADD conf/livy.conf /app/$LIVY_FILE/conf/livy.conf

RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998

ENTRYPOINT ["/entrypoint.sh"]
