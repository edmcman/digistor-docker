FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libssl-dev \
    libusb-1.0-0-dev \
    make

# Download and build sedutil-cli
RUN git clone https://github.com/Drive-Trust-Alliance/sedutil.git
WORKDIR /sedutil
RUN git checkout 1.20.0
RUN make && make install

# Create script for initializing TCG OPAL drive
RUN echo '#!/bin/bash

# Replace /dev/nvme1 with your actual drive path
sudo sedutil-cli --initialsetup debug /dev/nvme1
sudo sedutil-cli --enablelockingrange 0 debug /dev/nvme1
sudo sedutil-cli --setlockingrange 0 lk debug /dev/nvme1
sudo sedutil-cli --setmbrdone off debug /dev/nvme1

# Load PBA image (optional)
# Replace ./UEFI64.img with your actual PBA image path
# sudo sedutil-cli --loadpbaimage debug ./UEFI64.img /dev/nvme1

echo "TCG OPAL drive initialized."
' > /initialize_opal.sh

# Make script executable
RUN chmod +x /initialize_opal.sh

# Set working directory
WORKDIR /

# Define command to run on container start
CMD ["/initialize_opal.sh"]
