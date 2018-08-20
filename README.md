# gnuradio-docker
GnuRadio Docker

## Dockerfile

This Dockerfile builds an Ubuntu 16.04 container with a working GNU Radio install. There are a number of other GNU Radio Dockerfiles that work fine for most people, but I like to make my customization which also work on OSX.

Build the container:
```
docker build . -t gnuradio:basic
```

Running the container with a bunch of magic parameters that make X applications work in OSX.

### Host Machine IP
- You will need to replace `$IP` with the IP address of your active NIC. 
- Also, in order for X to work, you need to have XQuartz installed on OSX.

Here a command line row which it will do it for you.

```IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}') ```

this should set the IP variable as the ip of your local machine. 

Note: If you’re on wifi you may want to use en1 instead of en0, check the value of the variable using ```echo $IP ```.



### Run XQuartz
Start XQuartz from command line using ```open -a XQuartz```. 
- In the XQuartz preferences, go to the “Security” tab and make sure you’ve got “Allow connections from network clients” ticked:

Now add the IP using Xhost with ```xhost + $IP```. 
- If the xhost command is not found check /usr/X11/bin/xhost as that might not be in your path.


### Run the Container
While below the docker command to run it 

```
docker run -it --name Gnuradio -e XAUTHORITY=/tmp/xauth -v ~/.Xauthority:/tmp/xauth -v /tmp/.X11-unix/:/tmp/ -e DISPLAY=$IP:0 --net host gnuradio:basic
```


### Automating Script to download and run the Container
There is also a script ```GnuRadioContainer.sh``` which will download the latest version of the container image from RedOracle's DockerHub and run it.


