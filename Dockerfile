FROM phusion/baseimage
MAINTAINER GnuRadio <info@redoracle.com>

ENV num_threads 2
ENV uhd_branch maint
ENV gr_branch maint

RUN apt-get update && apt-get dist-upgrade -yf && apt-get clean && apt-get autoremove
RUN apt-get install -y \
        build-essential \
        cmake \
        git \
        libasound2-dev \
        liblog4cpp5-dev \
        libboost-all-dev \
        libfftw3-3 \
        libfftw3-dev \
        libgsl-dev \
        libqwt-dev \
        libqwt5-qt4 \
        libusb-1.0-0 \
        libusb-1.0-0-dev \
        libzmq3-dev \
        pkg-config \
        python-cairo-dev \
        python-cheetah \
        python-dev \
        python-gtk2 \
        python-lxml \
        python-mako \
        python-numpy \
        python-qt4 \
        python-qwt5-qt4 \
        python-zmq \
        python-pip \
        swig

RUN pip install --upgrade pip setuptools
RUN pip install requests

WORKDIR /opt/
RUN git clone https://github.com/EttusResearch/uhd.git
WORKDIR /opt/uhd/host
RUN git remote update
RUN git fetch
RUN git checkout -b EttusResearch/${uhd_branch}

RUN mkdir build && cd build
WORKDIR /opt/uhd/host/build
RUN cmake -DENABLE_B100=1 -DENABLE_B200=1 -DENABLE_E100=0 -DENABLE_E300=0 -DENABLE_EXAMPLES=1 -DENABLE_DOXYGEN=0 -DENABLE_MANUAL=0 -DENABLE_MAN_PAGES=0 -DENABLE_OCTOCLOCK=0 -DENABLE_USRP1=0 -DENABLE_USRP2=1 -DENABLE_UTILS=1 -DENABLE_X300=1 ../
RUN make -j${num_threads}
RUN make install
RUN ldconfig



WORKDIR /opt/
RUN git clone --recursive https://github.com/gnuradio/gnuradio.git
WORKDIR /opt/gnuradio
RUN git remote update
RUN git fetch
RUN git checkout -b gnuradio/${gr_branch}

RUN mkdir build && cd build
WORKDIR /opt/gnuradio/build
RUN cmake ../
RUN make -j${num_threads}
RUN make install
RUN ldconfig

CMD ["/bin/bash"]
