FROM debian:buster-slim
LABEL maintainer "JacyL4 - jacyl4@gmail.com"

ENV NGINX_VERSION 1.17.10

ENV OPENSSL_VERSION 1.1.1g

RUN set -x \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& dpkg-reconfigure debconf \
	&& apt-get update -y \
	&& apt-get install --no-install-recommends --no-install-suggests -y apt-utils dialog \
	&& apt-get install --no-install-recommends --no-install-suggests -y ca-certificates wget curl unzip git build-essential autoconf libtool \
		tzdata libpcre3-dev zlib1g-dev libatomic-ops-dev \
	&& echo "Asia/Shanghai" > /etc/timezone \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& mkdir -p /usr/src \
	&& mkdir -p /etc/nginx \
	&& mkdir -p /etc/nginx/conf.d \
	&& mkdir -p /var/log/nginx \
	&& mkdir -p /var/cache/nginx/client_temp \
	&& mkdir -p /var/cache/nginx/proxy_temp \
	&& mkdir -p /var/cache/nginx/fastcgi_temp \
	&& mkdir -p /var/cache/nginx/scgi_temp \
	&& mkdir -p /var/cache/nginx/uwsgi_temp \
	&& cd /usr/src \
	&& git clone https://github.com/cloudflare/zlib.git \
	&& cd /usr/src/zlib \
	&& make -f Makefile.in distclean \
	&& cd /usr/src \
	&& git clone https://github.com/google/ngx_brotli.git \
	&& cd /usr/src/ngx_brotli \
	&& git submodule update --init \
	&& cd /usr/src \
	&& wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz \
	&& tar -zxvf pcre-8.43.tar.gz \
	&& cd /usr/src \
	&& wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz \
	&& tar zxvf openssl-$OPENSSL_VERSION.tar.gz \
	&& cd /usr/src \
	&& wget https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
	&& tar zxvf nginx-$NGINX_VERSION.tar.gz \
	&& sed -i 's/CFLAGS="$CFLAGS -g"/#CFLAGS="$CFLAGS -g"/' /usr/src/nginx-$NGINX_VERSION/auto/cc/gcc \
	&& cd /usr/src/nginx-$NGINX_VERSION \
	&& curl https://raw.githubusercontent.com/kn007/patch/master/nginx.patch | patch -p1 \
	&& curl https://raw.githubusercontent.com/kn007/patch/master/use_openssl_md5_sha1.patch | patch -p1 \
	&& ./configure \
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/run/nginx.pid \
		--lock-path=/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--user=www-data \
		--group=www-data \
		--with-compat \
		--with-file-aio \
		--with-threads \
		--with-libatomic \
		--with-mail \
		--with-mail_ssl_module \
		--with-http_realip_module \
		--with-http_ssl_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_stub_status_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_slice_module \
		--with-http_gzip_static_module \
		--with-http_auth_request_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_degradation_module \
		--with-http_v2_module \
		--with-http_v2_hpack_enc \
		--with-stream \
		--with-stream_realip_module \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-zlib=/usr/src/zlib \
		--with-pcre=/usr/src/pcre-8.43 \
		--with-pcre-jit \
		--with-openssl=/usr/src/openssl-$OPENSSL_VERSION \
		--with-openssl-opt='zlib enable-weak-ssl-ciphers enable-ec_nistp_64_gcc_128 -Wl,-flto' \
		--with-cc-opt='-DTCP_FASTOPEN=23 -g -O2 -pipe -Wall -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
		--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
		--add-module=/usr/src/ngx_brotli \
	&& make && make install \
	&& rm -rf /usr/src \
	&& rm -rf /tmp/* \
	&& apt-get remove --purge --auto-remove -y apt-utils dialog ca-certificates wget curl unzip git build-essential autoconf libtool \
	&& apt-get clean all \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
