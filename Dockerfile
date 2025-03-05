FROM alpine
COPY alpine.patch /alpine.patch

RUN apk add --no-cache --update --virtual build-deps alpine-sdk autoconf automake libtool curl tar git && \
\
        adduser -D -H shusr && \
\
        git clone https://github.com/shellinabox/shellinabox.git /shellinabox && \
        cd /shellinabox && \
        git apply /alpine.patch && \
        autoreconf -i && \
        ./configure --prefix=/shellinabox/bin && \
        make && make install && cd / && \
\
        mv /shellinabox/bin/bin/shellinaboxd /shellinaboxd && \
        rm -rf /shellinabox && \
\
        apk del build-deps && rm -rf /var/cache/apk/

RUN apk add openssh-client
EXPOSE 4200

CMD ["/shellinaboxd", "--no-beep", "--disable-ssl", "--service=/:SSH"]
