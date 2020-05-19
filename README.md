# Magento 2 Docker

## Quick Start

* Prepare env files:
```shell script
cp .env.dist .env
cp composer.env.sample composer.env
```
* In .env file fill MAGENTO_APP_SECRET and LOCAL_HOST_IP (required for xdebug).
* Generate certificates for your domain. (There are two certificates for domain 'magento2.docker' in this folder, remove '.dist' from the name)
* For elasticsearch work execute from your OS command line:
```shell script
sudo sysctl -w vm.max_map_count=262144
```
* Create new folder `magento` and put your magento into it.  
* To install magento enter the container with the command `make mg` and execute magento installation:
```shell script
magento-build && magento-install
```