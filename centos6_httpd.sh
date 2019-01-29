HTTPD_VERSION=2.4.38
APR_VERSION=1.6.5
APR_UTIL_VERSION=1.6.1
OPENSSL_DIR=/usr/local/ssl
APACHE_DIR=/usr/local/apache2 # (default)

# http://httpd.apache.org/docs/2.4/install.html
# https://blog.ivanristic.com/2013/08/compiling-apache-with-static-openssl.html
# https://stackoverflow.com/questions/20112355/apache-2-4-x-manual-build-and-install-on-rhel-6-4/20244098#20244098

# apache pre-requisites
yum install -y pcre-devel expat-devel

cd /usr/src

wget http://mirror.cc.columbia.edu/pub/software/apache//httpd/httpd-${HTTPD_VERSION}.tar.gz
tar -xzf httpd-${HTTPD_VERSION}.tar.gz

wget http://mirror.olnevhost.net/pub/apache//apr/apr-${APR_VERSION}.tar.gz
tar -xzf apr-${APR_VERSION}.tar.gz
cp -R apr-${APR_VERSION} httpd-${HTTPD_VERSION}/srclib/apr

wget http://mirror.olnevhost.net/pub/apache//apr/apr-util-${APR_UTIL_VERSION}.tar.gz
tar -xzf apr-util-${APR_UTIL_VERSION}.tar.gz
cp -R apr-util-${APR_UTIL_VERSION} httpd-${HTTPD_VERSION}/srclib/apr-util

cd /usr/src/httpd-${HTTPD_VERSION}
time ./configure --enable-so --with-included-apr --with-included-apr-util --enable-ssl --with-ssl=${OPENSSL_DIR}
time make
time make install


echo "Enabling SSL"
sed -i 's/#[ ]*Include[ ]*conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/g' ${APACHE_DIR}/conf/httpd.conf
sed -i 's/#[ ]*LoadModule[ ]*ssl_module.*/LoadModule ssl_module modules\/mod_ssl.so/g' ${APACHE_DIR}/conf/httpd.conf
sed -i 's/^[ ]*SSLSessionCache /#SSLSessionCache /g' ${APACHE_DIR}/conf/extra/httpd-ssl.conf

cd ${APACHE_DIR}/conf

# https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl/41366949#41366949
openssl req -x509 -nodes -newkey rsa:4096 -keyout server.key -out server.crt -days 365 -subj /CN=example.com -addext subjectAltName=DNS:example.com,DNS:example.net

nohup ${APACHE_DIR}/bin/httpd &

