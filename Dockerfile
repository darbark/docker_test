FROM ubuntu:18.04
LABEL maintainer="daria.barkhova@gmail.com"
ENV SOFT="/soft" \
    PATH=$PATH:$SOFT/samtools_1.11
RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
    libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

