FROM debian:buster-slim
LABEL maintainer "JacyL4 - jacyl4@gmail.com"

ENV NGINX_VERSION 1.17.10

ENV OPENSSL_VERSION 1.1.1g

RUN set -x \
	&& echo "fs.file-max = 1000000" > /etc/sysctl.conf \
	&& echo "fs.inotify.max_user_instances = 1000000" >> /etc/sysctl.conf \
	&& echo "fs.inotify.max_user_watches = 1000000" >> /etc/sysctl.conf \
	&& echo "net.core.netdev_max_backlog = 32768" >> /etc/sysctl.conf \
	&& echo "net.core.optmem_max = 8388608" >> /etc/sysctl.conf \
	&& echo "net.core.rmem_max = 8388608" >> /etc/sysctl.conf \
	&& echo "net.core.rmem_default = 8388608" >> /etc/sysctl.conf \
	&& echo "net.core.wmem_max = 8388608" >> /etc/sysctl.conf \
	&& echo "net.core.wmem_default = 8388608" >> /etc/sysctl.conf \
	&& echo "net.core.somaxconn = 32768" >> /etc/sysctl.conf \
	&& echo "net.netfilter.nf_conntrack_checksum = 0" >> /etc/sysctl.conf \
	&& echo "net.netfilter.nf_conntrack_max = 1000000" >> /etc/sysctl.conf \
	&& echo "net.nf_conntrack_max = 1000000" >> /etc/sysctl.conf \
	&& echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.all.arp_ignore = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.default.arp_ignore = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.all.rp_filter = 2" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.default.rp_filter = 2" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.all.send_redirects = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.default.send_redirects = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.all.accept_redirects = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.default.accept_redirects = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.all.secure_redirects = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.default.secure_redirects = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.all.accept_source_route = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.conf.default.accept_source_route = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.ip_local_port_range = 1025 65535" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_orphan_retries = 2" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_syn_retries = 2" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_max_syn_backlog = 32768" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_max_tw_buckets = 6000" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_max_orphans = 32768" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_rmem = 4096 87380 8388608" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_wmem = 4096 87380 8388608" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_keepalive_time = 1800" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_keepalive_intvl = 15" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_keepalive_probes = 3" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_rfc1337 = 1" >> /etc/sysctl.conf \
	&& echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf \
	&& echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf \
	&& sysctl -p \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y ca-certificates wget curl unzip git build-essential autoconf libtool tzdata libpcre3-dev zlib1g-dev libatomic-ops-dev \
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
	&& wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz \
	&& tar -zxvf pcre-8.44.tar.gz \
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
		--with-pcre=/usr/src/pcre-8.44 \
		--with-pcre-jit \
		--with-openssl=/usr/src/openssl-$OPENSSL_VERSION \
		--with-openssl-opt='zlib enable-tls1_3 enable-ec_nistp_64_gcc_128 -Wl,-flto' \
		--with-cc-opt='-DTCP_FASTOPEN=23 -g -O2 -pipe -Wall -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
		--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
		--add-module=/usr/src/ngx_brotli \
	&& make && make install \
	&& rm -rf /usr/src \
	&& rm -rf /tmp/* \
	&& apt-get remove --purge --auto-remove -y autoconf autotools-dev binutils binutils-common binutils-x86-64-linux-gnu build-essential bzip2 ca-certificates cpp cpp-8 \
		curl dpkg-dev file g++ g++-8 gcc gcc-8 git git-man libasan5 libatomic1 libbinutils libcc1-0 libcurl3-gnutls libcurl4 libdpkg-perl liberror-perl libexpat1 libgcc-8-dev \
		libgdbm-compat4 libgdbm6 libgomp1 libgssapi-krb5-2 libisl19 libitm1 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libldap-common liblsan0 libmagic-mgc \
		libmagic1 libmpc3 libmpfr6 libmpx2 libnghttp2-14 libpcre2-8-0 libperl5.28 libpsl5 libquadmath0 librtmp1 libsasl2-2 libsasl2-modules-db libsigsegv2 libssh2-1 libstdc++-8-dev libtool libtsan0 libubsan1 \
		m4 make openssl patch perl perl-modules-5.28 unzip wget xz-utils \
	&& apt-get clean all \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 80 
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
