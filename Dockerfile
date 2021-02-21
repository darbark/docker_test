FROM ubuntu:18.04
LABEL maintainer="daria.barkhova@gmail.com"
ARG cores=1
ENV CORE=$cores
ENV SOFT="/soft" 
ENV SOURCE="${SOFT}/source"
ENV LIBDEFLATE="${SOFT}/libdeflate-1.7"
ENV HTSLIB="${SOFT}/htslib-1.11"
ENV LIBMAUS="${SOFT}/libmaus-bade19f"
ENV PATH="${PATH}:${SOFT}/libdeflate-1.7/usr/local/bin:${SOFT}/htslib-1.11/bin:${SOFT}/samtools-1.11/bin:${SOFT}/biobambam-ab7b33d/bin"
RUN apt-get update && \
    apt-get -y upgrade && \
	apt-get install -y \
	build-essential \
	dh-autoreconf git \
	libbz2-dev \
	libcurl3-dev \
	liblzma-dev \
	libncurses5-dev \
	pkg-config \
	wget \
	zlib1g-dev && \
	apt-get clean && \
	apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
WORKDIR $SOFT
# LIBDEFLATE VERSION 1.7 released on Nov 10, 2020
RUN mkdir $SOURCE && \
    wget -O $SOURCE/v1.7.tar.gz \
    https://github.com/ebiggers/libdeflate/archive/v1.7.tar.gz && \
    tar -zxf $SOURCE/v1.7.tar.gz -C $SOURCE && \
    cd $SOURCE/libdeflate-1.7 && \
    make -j $CORE && \
    make install DESTDIR=$LIBDEFLATE
# HTSLIB VERSION 1.11 released on Sep 22, 2020
RUN wget -O $SOURCE/htslib-1.11.tar.bz2 \
    https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && \
    tar -jxf $SOURCE/htslib-1.11.tar.bz2 -C $SOURCE && \
    cd $SOURCE/htslib-1.11 && \
    ./configure \
    CPPFLAGS=-I/$LIBDEFLATE/usr/local/include \
    LDFLAGS="-L/$LIBDEFLATE/usr/local/lib -Wl,-R/$LIBDEFLATE/usr/local/lib" \
    --with-libdeflate \
    --prefix=$HTSLIB && \
    make -j $CORE && \
    make install
# SAMTOOLS VERSION 1.11 released on Sep 22, 2020
RUN wget -O $SOURCE/samtools-1.11.tar.bz2 \
    https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    tar -jxf $SOURCE/samtools-1.11.tar.bz2 -C $SOURCE && \
    cd $SOURCE/samtools-1.11 && \
    ./configure \
    CPPFLAGS=-I/$HTSLIB/include \
    LDFLAGS="-L/$HTSLIB/lib -Wl,-R/$HTSLIB/lib" \
    --with-htslib=$HTSLIB \
    --prefix=$SOFT/samtools-1.11 && \
    make -j $CORE && \
    make install && \
    rm -rf $SOURCE/*
# LIBMAUS VERSION 0.0.196 released on Mar 26, 2015
RUN cd $SOURCE && \
    git clone https://github.com/gt1/libmaus.git && \
    cd libmaus && \
    git checkout bade19f && \
    autoreconf -if && \
    ./configure --prefix=$SOFT/libmaus-bade19f && \
    make -j $CORE && \
    make install
# BIOBAMBAM VERSION 0.0.191 on Apr 1, 2015
RUN cd $SOURCE && \
    git clone https://github.com/gt1/biobambam.git && \
    cd biobambam && \
    git checkout ab7b33d && \
    autoreconf -if && \
    ./configure --with-libmaus=$LIBMAUS --prefix=$SOFT/biobambam-ab7b33d && \
    make -j $CORE && \
    make install && \
    rm -rf $SOURCE
CMD for path in $(find /soft -executable -type f | grep '/bin/'); \
    do \
    export $(basename -- $path | sed -e 's/\(.*\)/\U\1/' -e 's/[^a-zA-Z0-9]//g')=$path; \
    done && \
    bash
