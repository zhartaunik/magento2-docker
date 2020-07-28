# Magento 2 Docker

## Quick Start

* Prepare env files:
```shell script
cp .env.dist .env
cp composer.env.sample composer.env
```
* In .env file fill MAGENTO_APP_SECRET (32 random symbols, you may use some password generator A-Za-z0-9) and LOCAL_HOST_IP (required for xdebug).
* Generate certificates for your domain. (There are two certificates for domain 'magento2.docker' in this folder, remove '.dist' from the name)
```shell script
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout magento.key -out magento.crt

Generating a RSA private key
...............+++++
...............+++++
writing new private key to 'magento.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:BY
State or Province Name (full name) [Some-State]:Minsk
Locality Name (eg, city) []:Minsk
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Company
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:magento2.docker
Email Address []:dummy@gmail.com

```
* For elasticsearch work execute from your OS command line:
```shell script
sudo sysctl -w vm.max_map_count=262144
```
* Create new folder `magento` and put your magento into it.  
* To install magento enter the container with the command `make mg` and execute magento installation:
```shell script
magento-build && magento-install
```