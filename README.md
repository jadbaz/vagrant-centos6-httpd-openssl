# Vagrantfile to create a CentOS 6 machine with the latest Apache httpd and OpenSSL

## Details
* Starts from the [centos/6 Vagrant image](https://app.vagrantup.com/centos/boxes/7)
* Uses Virtualbox provider with port forwarding
* Downloads and builds OpenSSL 1.1.1a ([centos6_openssl.sh](centos6_openssl.sh))
* Downloads and builds Apache httpd 2.4.38 with the downloaded OpenSSL version ([centos6_httpd.sh](centos6_httpd.sh))
* Starts apache with mod_ssl on 443 (host = 10443) and 80 (host = 10080)

## Note
* This builds the default layout (ref [Apache DistrosDefaultLayout](https://wiki.apache.org/httpd/DistrosDefaultLayout)) in /usr/local/apache2
* This does not build an rpm. An attempt has been made at building an rpm in [test_httpd_rpmbuild.sh](test_httpd_rpmbuild.sh)

## Usage
Clone, start and test (will display server information)
* `git clone https://github.com/jadbaz/vagrant-centos6-httpd-openssl`
* `cd vagrant-centos6-httpd-openssl`
* `time vagrant up; echo "*****************************"; curl -v -k https://127.0.0.1:10443 > index.html`
