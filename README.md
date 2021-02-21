## Description
This Dockerfile allowes to built a Docker image with **Samtools** and **Biobambam** in *Ubuntu 18.04*.

The image built on this file contains the following applications and dependencies as separate layers:

 - libdeflate 1.7
 - htslib 1.11
 - samtools 1.11
 - libmause 0.0.196
 - biobambam 0.0.191
  
  Also each executable file is avaliable as *$FILENAME* (without punctuation marks)
    
## Usage

### Install 
Require Docker (test was performed on version 20.10.3)
    
    git clone https://github.com/darbark/docker_test.git
    cd docker_test
    docker image build -t your_build_name .

To speed up the build process, you can increase the number of cores using the option --build-arg cores=your_number (by default 1)

    docker image build --build-arg cores=your_number -t your_build_name .

To run a container (interactive)

    docker container run -it your_build_name
