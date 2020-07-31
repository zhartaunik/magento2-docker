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

## Configure PHPStorm

Variables for interpreter:
```xml
<configuration_options>
  <configuration_option name="memory_limit" value="4G" />
  <configuration_option name="apc.enabled" value="0" />
  <configuration_option name="apc.shm_size" value="0" />
  <configuration_option name="apc.ttl" value="3600" />
  <configuration_option name="apc.gc_ttl" value="32M" />
  <configuration_option name="opcache.enable" value="0" />
  <configuration_option name="opcache.memory_consumption" value="512MB" />
  <configuration_option name="opcache.max_accelerated_files" value="60000" />
  <configuration_option name="opcache.consistency_checks" value="0" />
  <configuration_option name="opcache.validate_timestamps" value="1" />
  <configuration_option name="upload_max_filesize" value="1" />
  <configuration_option name="post_max_size" value="100M" />
  <configuration_option name="xdebug.remote_enable" value="1" />
  <configuration_option name="xdebug.remote_connect_back" value="1" />
  <configuration_option name="xdebug.remote_autostart" value="1" />
  <configuration_option name="xdebug.remote_host" value="0.0.0.0" />
  <configuration_option name="xdebug.remote_port" value="9000" />
  <configuration_option name="xdebug.scream" value="0" />
  <configuration_option name="xdebug.show_local_vars" value="1" />
  <configuration_option name="xdebug.idekey" value="PHPSTORM" />
  <configuration_option name="xdebug.profiler_enable" value="0" />
  <configuration_option name="xdebug.coverage_enable" value="0" />
</configuration_options>
```

## Configure Tests

### Integration Tests:
