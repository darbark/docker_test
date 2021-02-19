FROM ubuntu:18.04
LABEL maintainer="daria.barkhova@gmail.com"
ENV DELLME="/download"
ENV SOFT="/soft" 
ENV PATH="${PATH}:${SOFT}/samtools-1.11/bin:${SOFT}/htslib-1.11/bin"
RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget \
    libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
	
WORKDIR $DELLME

RUN wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    tar -jxf samtools-1.11.tar.bz2 && \
    rm samtools-1.11.tar.bz2 && \
    cd samtools-1.11 && \
    ./configure --prefix=$SOFT/samtools-1.11 && \
    make && \
    make install && \
    cd .. && \
    wget https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && \
    tar -jxf htslib-1.11.tar.bz2 && \
    rm htslib-1.11.tar.bz2 && \
    cd htslib-1.11 && \
    ./configure --prefix=$SOFT/htslib-1.11 && \
    make && \
    make install

