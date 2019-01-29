# This did not work fully
HTTPD_VERSION=2.4.38
APR_VERSION=1.6.5
APR_UTIL_VERSION=1.6.1
OPENSSL_DIR=/usr/local/ssl
APACHE_DIR=/usr/local/apache2 # (default)

# https://medium.com/@nicolwk/build-apache-http-server-2-4-x-rpm-package-on-centos-6-4c0c6bd4ee21


yum -y install autoconf libuuid-devel lua-devel libxml2-devel
mkdir -p /root/rpmbuild/SOURCES/

cd /usr/src
wget http://mirror.cc.columbia.edu/pub/software/apache//httpd/httpd-${HTTPD_VERSION}.tar.bz2
cp httpd-${HTTPD_VERSION}.tar.bz2 /root/rpmbuild/SOURCES

# needed for building apr
yum -y install libtool doxygen

wget http://mirror.olnevhost.net/pub/apache//apr/apr-${APR_VERSION}.tar.bz2
rpmbuild -tb apr-${APR_VERSION}.tar.bz2

yum -y install /root/rpmbuild/RPMS/x86_64/apr-*

# needed for building apr-util
yum -y install postgresql-devel mysql-devel sqlite-devel unixODBC-devel nss-devel openldap-devel
wget http://mirror.olnevhost.net/pub/apache//apr/apr-util-${APR_UTIL_VERSION}.tar.bz2
rpmbuild -tb apr-util-${APR_UTIL_VERSION}.tar.bz2

yum -y install /root/rpmbuild/RPMS/x86_64/apr-util-*

cd /usr/src
tar -xjf httpd-${HTTPD_VERSION}.tar.bz2

cd /usr/src/httpd-${HTTPD_VERSION}
sed -i "s|--with-ssl |--with-ssl=${OPENSSL_DIR} |g" httpd.spec
rpmbuild -bb httpd.spec

yum -y install /root/rpmbuild/RPMS/x86_64/httpd-${HTTPD_VERSION}-* 
yum -y install /root/rpmbuild/RPMS/x86_64/mod_ssl-${HTTPD_VERSION}-* 
