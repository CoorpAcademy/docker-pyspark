[![Build Status](https://travis-ci.org/CoorpAcademy/docker-pyspark.svg)](https://travis-ci.org/CoorpAcademy/docker-pyspark)

# docker-pyspark

This Docker image helps you to run Spark (on Docker) with the following
installed:

1. [Apache Spark](https://spark.apache.org/) 2.0.0
  + running on Hadoop 2.7.2 and Java openjdk version "1.8.0_92-internal"
2. Python 3.4.3
3. Spark's python interface [pyspark](
https://spark.apache.org/docs/1.5.2/programming-guide.html#linking-with-spark)

# How to install

## On Mac OS X

### 1. Install [homebrew](http://brew.sh)

### 2. Install docker and launch docker daemon
    brew cask install docker

Launch the Docker.app application, and make sure it displays "Docker is running".

## On other OSes

Follow the installation guide from the [official docker guide](
https://docs.docker.com/machine/install-machine/).

# Starting pyspark

## On any OS

### 1. Pull the docker image
    docker pull coorpacademy/docker-pyspark:latest

### 2. Start the container
Run the following command to start the container and get a bash prompt

    docker run -it coorpacademy/docker-pyspark:latest /bin/bash

### 3. Start pyspark
    ./bin/pyspark  # open an interactive python shell with SparkContext as sc

### 4. Verify installation
To verify pyspark, run the following example Spark program:

    sc.parallelize(range(1000)).count()

This should print a bunch of debugging output, and on the last line,
print the output, "1000".

To quit the interpreter, hit `<Ctrl> + D`.

# How to run a cluster of containers with [Docker Compose](http://docs.docker.com/compose)

## docker-compose.yml example files

    cd example
    docker-compose up  # launch cluster (Ctrl-C to stop)

The SparkUI will be running at `http://${YOUR_DOCKER_HOST}:8080` with one
worker listed. To run `pyspark`, exec into a container:

    docker exec -it example_master_1 /bin/bash
    bin/pyspark

# (OPTIONAL) Building the docker image yourself

You can build this docker image, by running the following command in
the same directory as this =README= file. The command will be slow (a
few minutes) the first time, since all dependencies need to be fetched and
compiled from source, but the result is then cached. This step should
only be necessary if you modify the `Dockerfile`.

    docker build -t docker-pyspark .

# Troubleshooting
If you are unable to access HDFS from pyspark, try running pyspark with the
`--master yarn` flag.

If you are unable to access the HTTP SparkUI, verify that the open ports are
redirected from your virtual machine to your host machine. Under VirtualBox,
see the machine's `Settings > Network > Port Forwarding`.
