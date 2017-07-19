FROM java:8-jdk-alpine

# PYTHON 3

ENV PYTHON_VERSION 3.4.3-r2
ENV ALPINE_OLD_VERSION 3.2
# Hack: using older alpine version to install specific python version
RUN sed -n \
    's|^http://dl-cdn\.alpinelinux.org/alpine/v\([0-9]\+\.[0-9]\+\)/main$|\1|p' \
    /etc/apk/repositories > curr_version.tmp && \
    sed -i 's|'$(cat curr_version.tmp)'/main|'$ALPINE_OLD_VERSION'/main|' \
    /etc/apk/repositories
# Installing given python3 version
RUN apk update && \
    apk add python3=$PYTHON_VERSION
# Reverting hack
RUN sed -i 's|'$(cat curr_version.tmp)'/main|'$ALPINE_OLD_VERSION'/main|' \
    /etc/apk/repositories && \
    rm curr_version.tmp
# Upgrading pip to the last compatible version
RUN pip3 install --upgrade pip

# Installing IPython
RUN pip install ipython 

# GENERAL DEPENDENCIES

RUN apk update && \
    apk add curl && \
    apk add bash

# HADOOP

ENV HADOOP_VERSION 2.7.2
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN curl -sL --retry 3 \
    "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
    | gunzip \
    | tar -x -C /usr/ && \
    rm -rf $HADOOP_HOME/share/doc

# SPARK

ENV SPARK_VERSION 2.0.0
ENV SPARK_PACKAGE spark-$SPARK_VERSION-bin-without-hadoop
ENV SPARK_HOME /usr/spark-$SPARK_VERSION
ENV PYSPARK_PYTHON python3 
ENV PYSPARK_DRIVER_PYTHON ipython 
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:$SPARK_HOME/bin
RUN curl -sL --retry 3 \
    "http://d3kbcqa49mib13.cloudfront.net/$SPARK_PACKAGE.tgz" \
    | gunzip \
    | tar x -C /usr/ && \
    mv /usr/$SPARK_PACKAGE $SPARK_HOME && \
    rm -rf $SPARK_HOME/examples $SPARK_HOME/ec2

WORKDIR /$SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
