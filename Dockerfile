FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
LABEL maintainer="wang-junjian@qq.com"

RUN mkdir ~/.pip && \
    cd ~/.pip/  && \
    echo "[global] \ntrusted-host =  pypi.douban.com \nindex-url = http://pypi.douban.com/simple" >  pip.conf

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.1.0-cp36-cp36m-linux_x86_64.whl && \
    pip3 install https://download.pytorch.org/whl/cu100/torchvision-0.3.0-cp36-cp36m-linux_x86_64.whl && \
    pip3 install grpcio grpcio-tools future cython

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install the mmcv
# ADD ./mmcv/ /mmcv/
# RUN cd /mmcv && pip3 install .
RUN git clone https://github.com/open-mmlab/mmcv.git \
    && cd /mmcv \
    && pip3 install .

# Install the mmdetection
# AssertionError: PyTypeTest on non extension type https://github.com/cython/cython/issues/2730
# 解决：pip3 install -U .
# ADD ./mmdetection/ /mmdetection/
# RUN cd mmdetection && pip3 install -U . && python3 setup.py develop
RUN git clone https://github.com/open-mmlab/mmdetection.git \
    && cd mmdetection \
    && pip3 install -U . \
    && python3 setup.py develop

RUN apt-get update && apt-get install -y \
    libsm6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /mmdetection
