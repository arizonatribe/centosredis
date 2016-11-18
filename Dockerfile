FROM arizonatribe/centos
MAINTAINER David Nunez <arizonatribe@gmail.com>

ENV APP_NAME centosredis

# Default version and download loccation for Redis
ENV REDIS_VERSION 3.2.0
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.2.0.tar.gz
ENV REDIS_DOWNLOAD_SHA1 0c1820931094369c8cc19fc1be62f598bc5961ca

# Download, make and configure Redis
RUN wget -O redis.tar.gz $REDIS_DOWNLOAD_URL \
    && echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
  	&& mkdir -p /usr/src/redis \
  	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
  	&& rm redis.tar.gz \
  	&& make -C /usr/src/redis \
  	&& make -C /usr/src/redis install \
  	&& rm -r /usr/src/redis

# Create the redis group/user and set directory ownership
RUN groupadd -r redis && useradd -r -g redis redis
RUN mkdir /data && chown redis:redis /data

# The data volume for the redis store
VOLUME ["/data"]
EXPOSE 6379-6380
WORKDIR /data
CMD ["redis-server"]

# Overlay, containing supervisord configs and other shell scripts
COPY docker /

