FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    git \
    curl \
    clang \
    cmake \
    zlib1g-dev \
    libboost-dev \
    libboost-thread-dev

RUN git clone --recursive https://github.com/Microsoft/bond.git

RUN curl -sSL https://get.haskellstack.org/ | sh

RUN mkdir bond/build

WORKDIR /bond/build

RUN cmake -DBOND_ENABLE_GRPC=FALSE ..
RUN make
RUN make install