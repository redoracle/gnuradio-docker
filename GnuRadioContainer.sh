IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}');


docker run -it --name GnuRadio  -e XAUTHORITY=/tmp/xauth -v ~/.Xauthority:/tmp/xauth -v /tmp/.X11-unix/:/tmp/ -e DISPLAY=$IP:0 --net host redoracle/gnuradio-docker:latest

