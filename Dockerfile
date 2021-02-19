FROM ubuntu:18.04
LABEL maintainer="daria.barkhova@gmail.com"
ENV SOFT="/soft" 
ENV DELME="${SOFT}/delme"
ENV PATH="${PATH}:${SOFT}/samtools-1.11/bin:${SOFT}/htslib-1.11/bin:${SOFT}/libdeflate-1.7/usr/local/bin"
RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y build-essential wget git dh-autoreconf pkg-config \
    libncurses5-dev zlib1g-dev libbz2-dev liblzma-dev libcurl3-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
	
WORKDIR $SOFT

RUN mkdir $DELME && \
    wget -O $DELME/samtools-1.11.tar.bz2 https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    tar -jxf $DELME/samtools-1.11.tar.bz2 -C $DELME && \
    cd $DELME/samtools-1.11 && \
    ./configure --prefix=$SOFT/samtools-1.11 && \
    make && \
    make install && \
    wget -O $DELME/htslib-1.11.tar.bz2 https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && \
    tar -jxf $DELME/htslib-1.11.tar.bz2 -C $DELME && \
    cd $DELME/htslib-1.11 && \
    ./configure --prefix=$SOFT/htslib-1.11 && \
    make && \
    make install && \
    wget -O $DELME/v1.7.tar.gz https://github.com/ebiggers/libdeflate/archive/v1.7.tar.gz && \
    tar -zxf $DELME/v1.7.tar.gz -C $DELME && \
    cd $DELME/libdeflate-1.7 && \
    make && \
    make install DESTDIR=$SOFT/libdeflate-1.7 && \
    rm -rf $DELME/*
    
RUN cd $DELME && \
    git clone https://github.com/gt1/libmaus.git && \
    cd libmaus && \
    git checkout bade19f && \
    autoreconf -if && \
    ./configure --prefix=$SOFT/libmaus-bade19f && \
    make -j 4 && \
    make install && \
    rm -rf $DELME/*
    
    
    

    

    
    
    
    
    

 
    

