FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libssl-dev \
    libusb-1.0-0-dev \
    make \
    wget \
    ca-certificates \
    autoconf \
    automake \
    build-essential \
    fdisk \
    smartmontools

# Download and build sedutil-cli
RUN git clone https://github.com/Drive-Trust-Alliance/sedutil.git
WORKDIR /sedutil
RUN git checkout 1.20.0
RUN autoreconf -i && ./configure && make && make install

WORKDIR /

# Download PBA image
RUN wget https://github.com/Drive-Trust-Alliance/exec/raw/master/UEFI64.img.gz && gzip -d UEFI64.img.gz

ADD initialize_opal.sh .

# Make script executable
RUN chmod +x initialize_opal.sh

ENTRYPOINT [ "./initialize_opal.sh" ]