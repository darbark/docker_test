FROM ubuntu:18.04
LABEL maintainer="daria.barkhova@gmail.com"
ENV SOFT="/soft" 
ENV SOURCE="${SOFT}/source"
ENV PATH="${PATH}:${SOFT}/samtools-1.11/bin:${SOFT}/htslib-1.11/bin:${SOFT}/libdeflate-1.7/usr/local/bin:${SOFT}/biobambam-ab7b33d/bin"
ENV LIBMAUS="${SOFT}/libmaus-bade19f"
RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget git dh-autoreconf pkg-config \
    libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
	
WORKDIR $SOFT

# SAMTOOLS VERSION 1.11 released on Sep 22, 2020
RUN mkdir $SOURCE && \
    wget -O $SOURCE/samtools-1.11.tar.bz2 \
    https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    tar -jxf $SOURCE/samtools-1.11.tar.bz2 -C $SOURCE && \
    cd $SOURCE/samtools-1.11 && \
    ./configure --prefix=$SOFT/samtools-1.11 && \
    make && \
    make install
    
# HTSLIB VERSION 1.11 released on Sep 22, 2020
RUN wget -O $SOURCE/htslib-1.11.tar.bz2 \
    https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && \
    tar -jxf $SOURCE/htslib-1.11.tar.bz2 -C $SOURCE && \
    cd $SOURCE/htslib-1.11 && \
    ./configure --prefix=$SOFT/htslib-1.11 && \
    make && \
    make install
    
# LIBDEFLATE VERSIN 1.7 released on Nov 10, 2020
RUN wget -O $SOURCE/v1.7.tar.gz \
    https://github.com/ebiggers/libdeflate/archive/v1.7.tar.gz && \
    tar -zxf $SOURCE/v1.7.tar.gz -C $SOURCE && \
    cd $SOURCE/libdeflate-1.7 && \
    make && \
    make install DESTDIR=$SOFT/libdeflate-1.7 && \
    rm -rf $SOURCE/*
    
# LIBMAUS VERSION 0.0.196 released on Mar 26, 2015
RUN cd $SOURCE && \
    git clone https://github.com/gt1/libmaus.git && \
    cd libmaus && \
    git checkout bade19f && \
    autoreconf -if && \
    ./configure --prefix=$SOFT/libmaus-bade19f && \
    make -j 4 && \
    make install && \
    rm -rf $SOURCE/*

# BIOBAMBAM VERSION 0.0.191 on Apr 1, 2015
RUN cd $SOURCE && \
    git clone https://github.com/gt1/biobambam.git && \
    cd biobambam && \
    git checkout ab7b33d && \
    autoreconf -if && \
    ./configure --with-libmaus=$LIBMAUS --prefix=$SOFT/biobambam-ab7b33d && \
    make -j 4 && \
    make install && \
    rm -rf $SOURCE
    
CMD for path in $(find /soft -executable -type f | grep '/bin/'); \
    do \
    export $(basename -- $path | sed -e 's/\(.*\)/\U\1/' -e 's/[^a-zA-Z0-9]//g')=$path; \
    done && \
    bash
