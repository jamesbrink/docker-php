# PHP 7.1 with Apache
#
# VERSION 7.1

FROM alpine:3.7
LABEL maintainer="James Brink, brink.james@gmail.com"
LABEL decription="PHP 7.1 with Apache"
LABEL version="7.1"

COPY docker-assets/ /

ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    PHP_CPPFLAGS="$PHP_CFLAGS" \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
    GPG_KEYS="A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172" \
    PHP_VERSION="7.1.15" \
    PHP_URL="https://secure.php.net/get/php-7.1.15.tar.xz/from/this/mirror" \
    PHP_ASC_URL="https://secure.php.net/get/php-7.1.15.tar.xz.asc/from/this/mirror" \
    PHP_SHA256="0e17192fb43532e4ebaa190ecec9c7e59deea7dadb7dab67b19c2081a68bd817" \
    PHP_MD5="" \
    PHP_INI_DIR="/usr/local/etc/php"

# persistent / runtime deps
RUN set -xe; \
    apk add --no-cache --virtual .persistent-deps \
        ca-certificates \
        curl \
        tar \
        xz \
        apache2 \
        libressl; \
    mkdir -p $PHP_INI_DIR/conf.d; \
    apk add --no-cache --virtual .fetch-deps gnupg; \
    mkdir -p /usr/src; \
    cd /usr/src; \
    wget -O php.tar.xz "$PHP_URL"; \
    if [ -n "$PHP_SHA256" ]; then echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; fi; \
    if [ -n "$PHP_MD5" ]; then echo "$PHP_MD5 *php.tar.xz" | md5sum -c -; fi; \
    if [ -n "$PHP_ASC_URL" ]; then \
        wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
        export GNUPGHOME="$(mktemp -d)"; \
        for key in $GPG_KEYS; do \
            gpg --keyserver  ipv4.pool.sks-keyservers.net --recv-keys "$key"; \
        done; \
        gpg --batch --verify php.tar.xz.asc php.tar.xz; \
        rm -rf "$GNUPGHOME"; \
    fi; \
    apk del .fetch-deps; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        dpkg-dev dpkg \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        coreutils \
        curl-dev \
        libedit-dev \
        libressl-dev \
        libxml2-dev \
        sqlite-dev \
        apache2-dev; \
    export CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS"; \
    docker-php-source extract; \
    cd /usr/src/php; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    ./configure \
        --build="$gnuArch" \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --with-apxs2=/usr/bin/apxs \
        --disable-cgi \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-curl \
        --with-libedit \
        --with-openssl \
        --with-zlib \
        $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
        $PHP_EXTRA_CONFIGURE_ARGS; \
    make -j "$(nproc)"; \
    make install; \
    { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; }; \
    make clean; \
    cd /; \
    docker-php-source delete; \
    runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      	| tr ',' '\n' \
      	| sort -u \
      	| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --virtual .php-rundeps $runDeps; \
    apk del .build-deps; \
    pecl update-channels; \
    rm -rf /tmp/pear ~/.pearrc; \
    mkdir /run/apache2; \
    rm /var/www/localhost/htdocs/index.html

ENTRYPOINT ["docker-php-entrypoint"]

CMD ["/usr/local/bin/apache2-foreground"]
