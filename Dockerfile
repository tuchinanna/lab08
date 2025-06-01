FROM ubuntu:18.04

RUN apt update && apt install -y \
    build-essential \
    gcc \
    g++ \
    wget \
    libssl-dev \
    git \
    curl

WORKDIR /tmp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.4/cmake-3.24.4.tar.gz && \
    tar -zxvf cmake-3.24.4.tar.gz && \
    cd cmake-3.24.4 && \
    ./bootstrap && make -j$(nproc) && make install && \
    cd / && rm -rf /tmp/*

COPY . /print
WORKDIR /print

RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
RUN cmake --build _build
RUN cmake --build _build --target install

ENV LOG_PATH=/home/logs/log.txt

VOLUME /home/logs

WORKDIR /print/_install/bin

ENTRYPOINT ["./hello_world"]

