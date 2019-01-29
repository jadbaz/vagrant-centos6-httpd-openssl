# https://www.howtoforge.com/tutorial/how-to-install-openssl-from-source-on-linux/
OPENSSL_VERSION=1.1.1a
OPENSSL_LIB_VERSION=1.1
OPENSSL_DIR=/opt/openssl-${OPENSSL_VERSION}

# openssl pre-requisites
yum install -y perl-core zlib-devel


cd /usr/src

wget https://ftp.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar -xzf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}
time ./config --prefix=${OPENSSL_DIR} --openssldir=${OPENSSL_DIR} shared zlib
time make
time make install

echo ${OPENSSL_DIR}/lib > /etc/ld.so.conf.d/openssl-${OPENSSL_LIB_VERSION}.conf
ldconfig -v | egrep "lib(ssl|crypto)"

openssl_bin=`which openssl`

current_version=`openssl version`
new_version=`${OPENSSL_DIR}/bin/openssl version`

if [ "${current_version}" != "${new_version}" ]
then
    echo "Upgrading OpenSSL (${current_version}) => (${new_version})"
    mv ${openssl_bin} ${openssl_bin}_old
    ln -s ${OPENSSL_DIR}/bin/openssl ${openssl_bin}
else
    echo "OpenSSL already on the latest version ${current_version}. Done"
fi
