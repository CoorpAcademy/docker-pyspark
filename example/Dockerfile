FROM coorpacademy/docker-pyspark:2.0.0-alpine

# GENERAL DEPENDENCIES
RUN apk update && \
    apk add zip

# PYTHON DEPENDENCIES
COPY example-requirements.txt /etc/example-requirements.txt
RUN pip install -r /etc/example-requirements.txt && \
    rm /etc/example-requirements.txt
