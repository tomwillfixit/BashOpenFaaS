# Bash Functions as a Service

Goal : Run bash scripts as serverless functions. 

## Blog post

There is a more detailed blog post [here](https://medium.com/@thomas.shaw78/bash-functions-as-a-service-b4033bc1ee97).

OpenFaaS is very straight forward to setup.  This setup uses a local Docker Swarm. Instructions can be found [here](https://docs.openfaas.com/deployment/docker-swarm/).

Follow the instructions [here](https://blog.alexellis.io/cli-functions-with-openfaas). When you reach the "2.1 nmap" section then you can try the following.

## Setup 


### Create scaffolding
```
faas new --lang dockerfile bash --prefix tshaw
```

The prefix will be included in the container image name. For example the image for this function will be called : tshaw/bash:latest.
Without the prefix the image will be named bash:latest and this may cause issues if there is a publicly available image with the same name.

### Add in bash script and update Dockerfile 

Copy [test.sh](./bash/test.sh) into the "bash" directory.


Update Dockerfile to include :
```
RUN apk add --no-cache bash whois iputils 
 
ADD test.sh /tmp/test.sh

ENV fprocess="xargs bash /tmp/test.sh"

```

## Build and Deploy

```
faas build -f bash.yml  && faas deploy -f bash.yml
```

## Test it works

echo -n "google.com" | faas invoke bash

echo -n "bbc.com" | faas invoke bash

echo -n "amazon.com" | faas invoke bash

Example Output :
```
=========================================
Running WHOIS for : google.com
=========================================
Name Server: ns4.google.com
Name Server: ns2.google.com
Name Server: ns3.google.com
Name Server: ns1.google.com
=========================================
Ping Check
=========================================
PING google.com (74.125.193.100) 56(84) bytes of data.
64 bytes from ig-in-f100.1e100.net (74.125.193.100): icmp_seq=1 ttl=46 time=14.0 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 14.004/14.004/14.004/0.000 ms
=========================================

```

## Add more replicas to handle incoming requests

```
docker service scale bash=3

bash scaled to 3
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

Verify the hostname changes when running this a number of times :

echo -n "amazon.com" | faas invoke bash

```

# Selecting different scripts from same function container

In the example above we have put one script into a container image and invoked it as a FaaS.  If you have a bunch of similar scripts, they are small and share the same dependencies then you could put them into the same container image.  

There is an example [here](./collection). We use a small piece of bash as the top level function and then select the function we require when invoking the collection function.

## Build and deploy the "Collection" function
```
faas build collection.yml  && faas deploy -f collection.yml

```

## Invoke different functions from the collection function

Invoke Weather function
```
echo -n "--function weather --argument Dublin" | faas invoke collection
```

Invoke Movie function
```
echo -n "--function movies --argument Seven" | faas invoke collection
```

Invoke cryptocurrency function
```
echo -n "--function cryptocurrency" | faas invoke collection
```

Invoke lyrics function
```
echo -n "--function lyrics --argument \"-a U2 -s Beautiful Day\"" | faas invoke collection

```

This method might be frowned upon but it's convenient for evaluation purposes.
