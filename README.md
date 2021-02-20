## Description
This Dockerfile allowes to built a Docker image with **Samtools** and **Biobambam** in *Ubuntu 18.04*.

The image built on this file contains the following applications and dependencies as separate layers:
 - samtools 1.11
 - htslib 1.11
 - libdeflate 1.7
 - libmause 0.0.196
 - biobambam 0.0.191
  
  Also each executable file is avaliable as *$FILENAME* (without punctuation marks)
    
## Usage

### Install 
Require Docker (test was performed on version 20.10.3)
    
    git clone https://github.com/darbark/docker_test.git
    cd docker_test
    docker image build -t bioapp .
    
To run a container (interactive)

    docker container run -it bioapp
