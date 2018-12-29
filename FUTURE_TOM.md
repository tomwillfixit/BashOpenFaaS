When trying to get the bash function working the bash service failed to start. It was using the bash:latest image which Tom assumed was the one he had built but it actually pulled bash:latest from dockerhub and used that.

```
root@tom:/home/tom/openfaas/faas/openfaas_bourne# faas build -no-cache -f bash.yml  && faas deploy -f bash.yml
[0] > Building bash.
Building: bash:latest with Dockerfile. Please wait..
Sending build context to Docker daemon  3.584kB
Step 1/19 : FROM alpine:3.8
 ---> 11cd0b38bc3c
Step 2/19 : RUN apk add --no-cache bash
 ---> Running in 7ee50ffcde6b
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ncurses-terminfo-base (6.1_p20180818-r1)
(2/5) Installing ncurses-terminfo (6.1_p20180818-r1)
(3/5) Installing ncurses-libs (6.1_p20180818-r1)
(4/5) Installing readline (7.0.003-r0)
(5/5) Installing bash (4.4.19-r1)
Executing bash-4.4.19-r1.post-install
Executing busybox-1.28.4-r0.trigger
OK: 13 MiB in 18 packages
Removing intermediate container 7ee50ffcde6b
 ---> 5135545e89ac
Step 3/19 : RUN mkdir -p /home/app
 ---> Running in fccfe3167de6
Removing intermediate container fccfe3167de6
 ---> 49fed1c3273d
Step 4/19 : RUN apk --no-cache add curl     && echo "Pulling watchdog binary from Github."     && curl -sSL https://github.com/openfaas/faas/releases/download/0.9.6/fwatchdog > /usr/bin/fwatchdog     && chmod +x /usr/bin/fwatchdog     && cp /usr/bin/fwatchdog /home/app     && apk del curl --no-cache
 ---> Running in b691c6b0229e
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ca-certificates (20171114-r3)
(2/5) Installing nghttp2-libs (1.32.0-r0)
(3/5) Installing libssh2 (1.8.0-r3)
(4/5) Installing libcurl (7.61.1-r1)
(5/5) Installing curl (7.61.1-r1)
Executing busybox-1.28.4-r0.trigger
Executing ca-certificates-20171114-r3.trigger
OK: 15 MiB in 23 packages
Pulling watchdog binary from Github.
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/5) Purging curl (7.61.1-r1)
(2/5) Purging libcurl (7.61.1-r1)
(3/5) Purging ca-certificates (20171114-r3)
Executing ca-certificates-20171114-r3.post-deinstall
(4/5) Purging nghttp2-libs (1.32.0-r0)
(5/5) Purging libssh2 (1.8.0-r3)
Executing busybox-1.28.4-r0.trigger
OK: 13 MiB in 18 packages
Removing intermediate container b691c6b0229e
 ---> db1bfccfda2e
Step 5/19 : RUN apk add --no-cache whois iputils
 ---> Running in a6f2b0bbc99c
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
(1/5) Installing libcap (2.25-r1)
(2/5) Installing iputils (20161105-r1)
(3/5) Installing libidn (1.34-r1)
(4/5) Installing libintl (0.19.8.1-r2)
(5/5) Installing whois (5.3.1-r0)
Executing busybox-1.28.4-r0.trigger
OK: 14 MiB in 23 packages
Removing intermediate container a6f2b0bbc99c
 ---> aad8e708bd42
Step 6/19 : RUN addgroup -S app && adduser app -S -G app
 ---> Running in 594d1ba493f7
Removing intermediate container 594d1ba493f7
 ---> 49754728fcf3
Step 7/19 : RUN chown app /home/app
 ---> Running in a6b77bc5f1e6
Removing intermediate container a6b77bc5f1e6
 ---> 5f715f01d72e
Step 8/19 : WORKDIR /home/app
 ---> Running in 6196c2b067b2
Removing intermediate container 6196c2b067b2
 ---> f52cebcfcd79
Step 9/19 : USER app
 ---> Running in 42c5d80b61ea
Removing intermediate container 42c5d80b61ea
 ---> e24a2083b49b
Step 10/19 : ADD test.sh /tmp/test.sh
 ---> e9e6936e5bc2
Step 11/19 : ENV fprocess="xargs bash /tmp/test.sh"
 ---> Running in 6742f7eac32b
Removing intermediate container 6742f7eac32b
 ---> 781ddbe18d41
Step 12/19 : ENV write_debug="true"
 ---> Running in c3309a37b9fb
Removing intermediate container c3309a37b9fb
 ---> 7fbf699d725a
Step 13/19 : EXPOSE 8080
 ---> Running in 8f908fface26
Removing intermediate container 8f908fface26
 ---> 75a74581d753
Step 14/19 : ENV PWD /home/app
 ---> Running in 6947ae42d83f
Removing intermediate container 6947ae42d83f
 ---> 47cdb0ca9a0a
Step 15/19 : ENV HOME /home/app
 ---> Running in 3fb8e927d5ad
Removing intermediate container 3fb8e927d5ad
 ---> 35211e65db5d
Step 16/19 : RUN env
 ---> Running in 5be7b184c0f1
HOSTNAME=5be7b184c0f1
fprocess=xargs bash /tmp/test.sh
SHLVL=1
HOME=/home/app
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
write_debug=true
PWD=/home/app
Removing intermediate container 5be7b184c0f1
 ---> 4d2dac6e982b
Step 17/19 : RUN ls /home/app
 ---> Running in 8ce38cbfb32d
fwatchdog
Removing intermediate container 8ce38cbfb32d
 ---> 83090bf87a86
Step 18/19 : HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
 ---> Running in 1a324258f3c8
Removing intermediate container 1a324258f3c8
 ---> 675245afe8fb
Step 19/19 : CMD [ "fwatchdog" ]
 ---> Running in b6ca76c539ff
Removing intermediate container b6ca76c539ff
 ---> 245619108070
Successfully built 245619108070
Successfully tagged bash:latest
Image: bash:latest built.
[0] < Building bash done.
[0] worker done.
Deploying: bash.

Deployed. 202 Accepted.
URL: http://127.0.0.1:8080/function/bash

root@tom:/home/tom/openfaas/faas/openfaas_bourne# docker images |grep bash
bash                                                test                                       5e997f459427        4 minutes ago       18.1MB
bash                                                latest                                     863b2b45693e        8 days ago          12.8MB
```
