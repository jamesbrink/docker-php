[Travis CI:  
![Build Status](https://travis-ci.org/jamesbrink/docker-php.svg?branch=master)](https://travis-ci.org/jamesbrink/docker-php)  

[![Docker Automated build](https://img.shields.io/docker/automated/jamesbrink/php.svg)](https://hub.docker.com/r/jamesbrink/php/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jamesbrink/php.svg)](https://hub.docker.com/r/jamesbrink/php/)
[![Docker Stars](https://img.shields.io/docker/stars/jamesbrink/php.svg)](https://hub.docker.com/r/jamesbrink/php/)

[![](https://images.microbadger.com/badges/image/jamesbrink/php.svg)](https://microbadger.com/images/jamesbrink/php "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/jamesbrink/php.svg)](https://microbadger.com/images/jamesbrink/php "Get your own version badge on microbadger.com")
# Docker PHP container with Apache
All images are based off of Alpine Linux 3.7 official docker image.  

Docker PHP container with Apache (Very similar to official php image but added Apache server)

This image is build using nearly the same build process as the official alpine-php image, with the exception of
the installation of apache and compiling of apache mod for php.

The focus of this container is to be efficient in size and still provide a wide range of functionality.
