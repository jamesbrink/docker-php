[Travis CI:  
![Build Status](https://travis-ci.org/jamesbrink/docker-php.svg?branch=master)](https://travis-ci.org/jamesbrink/docker-php)  

[![Docker Automated build](https://img.shields.io/docker/automated/jamesbrink/php.svg)](https://hub.docker.com/r/jamesbrink/php/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jamesbrink/php.svg)](https://hub.docker.com/r/jamesbrink/php/)
[![Docker Stars](https://img.shields.io/docker/stars/jamesbrink/php.svg)](https://hub.docker.com/r/jamesbrink/php/)

[![](https://images.microbadger.com/badges/image/jamesbrink/php.svg)](https://microbadger.com/images/jamesbrink/php "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/jamesbrink/php.svg)](https://microbadger.com/images/jamesbrink/php "Get your own version badge on microbadger.com")  

# Minimal PHP/Apache Docker image built on Alpine Linux.
<img src="https://alpinelinux.org/alpinelinux-logo.svg" width="250">

Available versions:
  * `jamesbrink/php:latest` (80MB) - PHP 7.2.3 [Dockerfile][7.2/Dockerfile]
  * `jamesbrink/php:7.1`(72MB) - PHP 7.1.15 [Dockerfile][7.1/Dockerfile]
  * `jamesbrink/php:7.0` (71MB) - PHP 7.0.28 [Dockerfile][7.0/Dockerfile]  


All images are based off of the official [Alpine Linux 3.7][Alpine Linux Image] image.

## About

For the most part I use nearly the identical build process as the official  
[php:7-cli-alpine][official php-cli-alpine] images. I have including the `docker-php-*` helper scripts  
that are included in  the official images as well. The biggest difference is the inclusion of Apache 2.4
and compiling PHP against the packaged version of **pcre**.

Pull requests or suggestions are always welcome.

## Goals

The primary goal of this container is to stay small and light weight, yet still useful for general use/consumption.
This should serve as a solid base image and can be easily extended as I have done with my [Magento2 image][JamesBrink/Magento2] resulting in a very slim yet complete Magento2 container.  

## Usage Examples

Run exposing HTTP port 80.  
This will serve up index.php at `http://localhost` that will printing out phpinfo.    
```shell
docker run -p 80:80 jamesbrink/php
```  

Use as a base image.  
```Dockerfile
FROM jamesbrink/php:7.2
COPY ./MyApp /var/www/localhost/htdocs/
RUN apk add --update my-deps...
```

## Environment Variables

Environment Variables:
* APACHE_LOG_LEVEL - Default: "warn", adjusts the verbosity of the apache server  
which by default prints to STDOUT. Refer to the [apache2 manual][apache2 manaual] for available LogLevels.

[Alpine Linux Image]: https://github.com/gliderlabs/docker-alpine
[7.2/Dockerfile]: https://github.com/jamesbrink/docker-php/tree/master/7.2
[7.1/Dockerfile]: https://github.com/jamesbrink/docker-php/tree/master/7.1
[7.0/Dockerfile]: https://github.com/jamesbrink/docker-php/tree/master/7.0
[official php-cli-alpine]: https://github.com/docker-library/php/blob/master/7.2/alpine3.7/cli/Dockerfile
[JamesBrink/Magento2]: https://github.com/jamesbrink/docker-magento
[apache2 manaual]: https://httpd.apache.org/docs/2.4/mod/core.html#loglevel
