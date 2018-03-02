# NGINX  INSTALL
mkdir /app
cd /app
sudo rm -rf nginx*
echo "기존것들 삭제완료"
sudo yum install gcc-c++
echo "gcc , c++ 설치완료"
wget https://nginx.org/download/nginx-1.13.9.tar.gz
echo "nginx 다운로드 완료 "
tar -xvf nginx-1.13.9.tar.gz
echo "nginx 압축해제 완료"
rm -rf nginx-1.13.9.tar.gz
echo "nginx 디렉토리명 변경 완료 "
mv nginx-1.13.9 nginx
cd nginx


wget http://downloads.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.tar.gz
wget http://zlib.net/zlib-1.2.11.tar.gz
wget http://www.openssl.org/source/openssl-1.0.2f.tar.gz

echo "nginx 플러그인 다운로드 완료 "

tar -zxf pcre-8.37.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf openssl-1.0.2f.tar.gz

rm -rf pcre-8.37.tar.gz
rm -rf zlib-1.2.11.tar.gz
rm -rf openssl-1.0.2f.tar.gz

echo "nginx 플러그인 압축해제 완료 "



echo "nginx 환경변수 완료 "

cd conf
echo '#made by sh.won@zieels.com' > nginx.conf
echo 'worker_processes  1;' >> nginx.conf
echo 'error_log  /log/nginx/error.log;' >> nginx.conf
echo 'pid        /log/nginx/nginx.pid;' >> nginx.conf
echo 'events {' >> nginx.conf
echo '    worker_connections  1024;' >> nginx.conf
echo '}' >> nginx.conf
echo '' >> nginx.conf
echo 'http {' >> nginx.conf
echo '    include       mime.types;' >> nginx.conf
echo '    default_type  application/octet-stream;' >> nginx.conf
echo '' >> nginx.conf
echo '    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '' >> nginx.conf
echo '                      '$status $body_bytes_sent "$http_referer" '' >> nginx.conf
echo '                      '"$http_user_agent" "$http_x_forwarded_for"';' >> nginx.conf
echo '' >> nginx.conf
echo '    access_log /log/nginx/access.log  main;' >> nginx.conf
echo '' >> nginx.conf
echo '    sendfile        on;' >> nginx.conf
echo '    keepalive_timeout  65;' >> nginx.conf
echo '' >> nginx.conf
echo '    server {' >> nginx.conf
echo '        listen 443;' >> nginx.conf
echo '        server_name  zieels;' >> nginx.conf
echo '        ssl on;' >> nginx.conf
echo '        ssl_certificate /app/cert/zieels.com.crt;' >> nginx.conf
echo '        ssl_certificate_key     /app/cert/zieels.com.key;' >> nginx.conf
echo '        access_log  /log/nginx/host.access.log  main;' >> nginx.conf
echo '' >> nginx.conf
echo '	location / {' >> nginx.conf
echo '	        proxy_set_header X-Real-IP $remote_addr;' >> nginx.conf
echo '	        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> nginx.conf
echo '	        proxy_set_header Host $http_host;' >> nginx.conf
echo '	      	proxy_set_header X-NginX-Proxy true;' >> nginx.conf
echo '	      	proxy_pass https://127.0.0.1:3000/;' >> nginx.conf
echo '	      	proxy_redirect off;' >> nginx.conf
echo '	         }' >> nginx.conf
echo '    }' >> nginx.conf
echo '' >> nginx.conf
echo '}' >> nginx.conf

echo "nginx 서비스등록시작 "
#서비스 등록
rm -rf /etc/sysconfig/nginx
cd /etc/sysconfig
sudo touch nginx
sudo chmod 777 nginx
sudo echo NGINX=/app/nginx/sbin/nginx > nginx
sudo echo CONFFILE=/app/nginx/conf/nginx.conf >> nginx

sudo rm -rf /etc/init.d/nginx
cd /etc/init.d
sudo touch nginx
sudo chmod 777 nginx
sudo echo ' #!/bin/sh '> nginx
sudo echo ' # '>> nginx
sudo echo ' # nginx - this script starts and stops the nginx daemin '>> nginx
sudo echo ' # '>> nginx
sudo echo ' # chkconfig:   - 85 15  '>> nginx
sudo echo ' # description:  Nginx is an HTTP(S) server, HTTP(S) reverse \ '>> nginx
sudo echo ' #               proxy and IMAP/POP3 proxy server '>> nginx
sudo echo ' # processname: nginx '>> nginx
sudo echo ' # config:      /app/nginx/conf/nginx.conf '>> nginx
sudo echo ' # pidfile:     /log/nginx/nginx.pid '>> nginx
sudo echo '    '>> nginx
sudo echo ' # Source function library. '>> nginx
sudo echo ' . /etc/rc.d/init.d/functions '>> nginx
sudo echo '    '>> nginx
sudo echo ' # Source networking configuration. '>> nginx
sudo echo ' . /etc/sysconfig/network '>> nginx
sudo echo '    '>> nginx
sudo echo ' # Check that networking is up. '>> nginx
sudo echo ' [ "$NETWORKING" = "no" ] && exit 0 '>> nginx
sudo echo '    '>> nginx
sudo echo ' nginx="/app/nginx/sbin/nginx" '>> nginx
sudo echo ' prog=$(basename $nginx) '>> nginx
sudo echo '    '>> nginx
sudo echo ' NGINX_CONF_FILE="/app/nginx/conf/nginx.conf" '>> nginx
sudo echo '    '>> nginx
sudo echo ' lockfile=/var/lock/subsys/nginx '>> nginx
sudo echo '    '>> nginx
sudo echo ' start() { '>> nginx
sudo echo '     [ -x $nginx ] || exit 5 '>> nginx
sudo echo '     [ -f $NGINX_CONF_FILE ] || exit 6 '>> nginx
sudo echo '     echo -n $"Starting $prog: " '>> nginx
sudo echo '     daemon $nginx -c $NGINX_CONF_FILE '>> nginx
sudo echo '     retval=$? '>> nginx
sudo echo '     echo '>> nginx
sudo echo '     [ $retval -eq 0 ] && touch $lockfile '>> nginx
sudo echo '     return $retval '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' stop() { '>> nginx
sudo echo '     echo -n $"Stopping $prog: " '>> nginx
sudo echo '     killproc $prog -QUIT '>> nginx
sudo echo '     retval=$? '>> nginx
sudo echo '     echo '>> nginx
sudo echo '     [ $retval -eq 0 ] && rm -f $lockfile '>> nginx
sudo echo '     return $retval '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' restart() { '>> nginx
sudo echo '     configtest || return $? '>> nginx
sudo echo '     stop '>> nginx
sudo echo '     start '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' reload() { '>> nginx
sudo echo '     configtest || return $? '>> nginx
sudo echo '     echo -n $"Reloading $prog: " '>> nginx
sudo echo '     killproc $nginx -HUP '>> nginx
sudo echo '     RETVAL=$? '>> nginx
sudo echo '     echo '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' force_reload() { '>> nginx
sudo echo '     restart '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' configtest() { '>> nginx
sudo echo '   $nginx -t -c $NGINX_CONF_FILE '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' rh_status() { '>> nginx
sudo echo '     status $prog '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' rh_status_q() { '>> nginx
sudo echo '     rh_status >/dev/null 2>&1 '>> nginx
sudo echo ' } '>> nginx
sudo echo '    '>> nginx
sudo echo ' case "$1" in '>> nginx
sudo echo '     start) '>> nginx
sudo echo '         rh_status_q && exit 0 '>> nginx
sudo echo '         $1 '>> nginx
sudo echo '         ;; '>> nginx
sudo echo '     stop) '>> nginx
sudo echo '         rh_status_q || exit 0 '>> nginx
sudo echo '         $1 '>> nginx
sudo echo '         ;; '>> nginx
sudo echo '     restart|configtest) '>> nginx
sudo echo '         $1 '>> nginx
sudo echo '         ;; '>> nginx
sudo echo '     reload) '>> nginx
sudo echo '         rh_status_q || exit 7 '>> nginx
sudo echo '         $1 '>> nginx
sudo echo '         ;; '>> nginx
sudo echo '     force-reload) '>> nginx
sudo echo '         force_reload '>> nginx
sudo echo '         ;; '>> nginx
sudo echo '     status) '>> nginx
sudo echo '         rh_status '>> nginx
sudo echo '         ;; '>> nginx
sudo echo '     condrestart|try-restart) '>> nginx
sudo echo '         rh_status_q || exit 0 '>> nginx
sudo echo '             ;; '>> nginx
sudo echo '     *) '>> nginx
sudo echo '         echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}" '>> nginx
sudo echo '         exit 2 '>> nginx
sudo echo ' esac '>> nginx
sudo chmod +x /etc/init.d/nginx



echo "nginx 서비스등록완료 "

echo "nginx 컴파일 완료 "
cd /app/nginx
./configure --prefix=/app/nginx --with-zlib=./zlib-1.2.11 --with-pcre=./pcre-8.37 --with-openssl=./openssl-1.0.2f --with-http_ssl_module --with-http_stub_status_module

make install

rm -rf nginx-1.13.9

mkdir /app/nginx/logs

# NODEJS INSTALL
cd /app
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz

tar -xvf node-v8.9.4-linux-x64.tar.xz

rm -rf node-v8.9.4-linux-x64.tar.xz

mv node-v8.9.4-linux-x64 node

sudo chmod 777 /etc/profile
sudo echo '#made by sh.won@zieels.com' >> /etc/profile
sudo echo 'export NODEJS_HOME=/app/node' >> /etc/profile
sudo echo 'export PATH=$PATH:$NODEJS_HOME/bin' >> /etc/profile
sudo echo 'export NGINX_HOME=/app/nginx' >> /etc/profile
sudo echo 'export PATH=$PATH:$NGINX_HOME/sbin' >> /etc/profile
source /etc/profile

rm -rf /app/node-v8.9.4-linux-x64

npm insatll pm2 -g

rm -rf /app/cert
cd /app
mkdir cert

cd cert

#httpd 설정

openssl req -new -newkey rsa:2048 -nodes -keyout zieels.com.key -out zieels.com.csr
openssl x509 -req -days 365 -in zieels.com.csr -signkey zieels.com.key -out zieels.com.crt
