# Instructions

``` bash
docker build -t digistor .
docker run -it --privileged --rm --mount type=bind,source=/dev/nvme0,target=/dev/nvme0 digistor /dev/nvme0
```