#from arm64v8/alpine:latest
#from arm32v7/alpine:latest
#from alpine
#as base
RUN ulimit -Hn && ulimit -Sn
RUN adduser builder -D #-D is don't assign a password
RUN echo -e "m17project\nm17project\n" | passwd builder
RUN addgroup builder wheel
RUN apk add alpine-sdk git screen vim doas sudo 

RUN apk add cmake

RUN addgroup builder abuild
RUN echo "permit persist :wheel" >> /etc/doas.conf
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers

COPY --chown=builder ./abuild /home/builder/.abuild
COPY --chown=root ./abuild /root/.abuild
COPY --chown=root ./abuild/*.pub /etc/apk/keys/
RUN echo "/home/builder/packages/src/" >> /etc/apk/repositories
WORKDIR /src
USER builder
#RUN git clone https://gitlab.alpinelinux.org/alpine/aports.git  /home/builder/aports

#abuild -r
#import abuild keys
#user root
