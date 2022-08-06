#from arm64v8/alpine:latest
#from arm32v7/alpine:latest
#from alpine
#as base
RUN adduser builder -D #-D is don't assign a password
RUN echo -e "m17project\nm17project\n" | passwd builder
RUN adduser builder wheel
RUN apk add alpine-sdk git screen vim doas sudo 

#for MMDVM firmware
RUN apk add newlib-arm-none-eabi binutils-arm-none-eabi gcc-arm-none-eabi

RUN apk add cmake

RUN addgroup builder abuild
RUN echo "permit persist :wheel" >> /etc/doas.conf

COPY --chown=builder ./abuild /home/builder/.abuild
COPY --chown=root ./abuild /root/.abuild
COPY --chown=root ./abuild/*.pub /etc/apk/keys/
WORKDIR /src
USER builder
#RUN git clone https://gitlab.alpinelinux.org/alpine/aports.git  /home/builder/aports

#abuild -r
#import abuild keys
#user root
