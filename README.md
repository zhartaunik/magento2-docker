# Magento 2 Docker

## Quick Start

* **!Important** ensure that your current user has uid/gid equals 1000/1000.
```shell
user@user-Laptop:~/Projects/clean$ id
uid=1000(user) gid=1000(user) groups=1000(user),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),116(lpadmin),126(sambashare),129(docker)
```
If you have different uid/gid you need to modify `docker/php-fpm/Dockerfile` and `docker/php-cli/Dockerfile` replace:
```shell
RUN groupadd -g 1000 magento
RUN useradd --no-log-init -d /home/magento -s /bin/bash -u 1000 -g 1000 magento
```
With
```shell
RUN groupadd -g {your_gid} magento
RUN useradd --no-log-init -d /home/magento -s /bin/bash -u {your_uid} -g {your_gid} magento
```
* Prepare env files:
```shell script
cp .env.dist .env
cp composer.env.sample composer.env
```
* In .env file fill MAGENTO_APP_SECRET (32 random symbols, you may use some password generator A-Za-z0-9) and LOCAL_HOST_IP (required for xdebug).
* Generate certificates for your domain. (There are two certificates for domain 'magento2.docker' in ```docker/nginx/etc/certs folder```, remove '.dist' from the name). Path to certificates - `magento2-docker/nginx/etc/certs`
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
* Create new folder `magento` and put your magento into it. New Magento can be downloaded from https://magento.com/tech-resources/download 
* Execute `make docker:build && make docker:magento` command to create and run all necessary containers (without cron).  
* To install magento enter the container with the command `make mg` and execute magento installation:
```shell script
magento-build && magento-install
```

## Configure applications
### Mysql
Attention. Installed default value for innodb_buffer_pool_size = 4 Gb

## Configure PHPStorm

### Establish code sniffers.

The best way would be configuration *PHP / Quality tools* manually (setup interpreter). Then create following file. With it *Settings / Editor / Inspections / Quality Tools* settings will be configured as desired. 

> inspectionProfiles/Project_Default.xml
```xml
<component name="InspectionProjectProfileManager">
  <profile version="1.0">
    <option name="myName" value="Project Default" />
    <inspection_tool class="MessDetectorValidationInspection" enabled="true" level="WARNING" enabled_by_default="true">
      <option name="CODESIZE" value="true" />
      <option name="CONTROVERSIAL" value="true" />
      <option name="DESIGN" value="true" />
      <option name="UNUSEDCODE" value="true" />
      <option name="NAMING" value="true" />
      <option name="customRulesets">
        <list>
          <RulesetDescriptor>
            <option name="name" value="Magento PHPMD rule set" />
            <option name="path" value="$PROJECT_DIR$/magento/dev/tests/static/testsuite/Magento/Test/Php/_files/phpmd/ruleset.xml" />
          </RulesetDescriptor>
        </list>
      </option>
    </inspection_tool>
    <inspection_tool class="PhpCSFixerValidationInspection" enabled="true" level="WARNING" enabled_by_default="true" />
    <inspection_tool class="PhpCSValidationInspection" enabled="true" level="WARNING" enabled_by_default="true">
      <option name="CODING_STANDARD" value="Custom" />
      <option name="CUSTOM_RULESET_PATH" value="$PROJECT_DIR$/magento/vendor/magento/magento-coding-standard/Magento2/ruleset.xml" />
      <option name="SHOW_SNIFF_NAMES" value="true" />
      <option name="USE_INSTALLED_PATHS" value="true" />
      <option name="INSTALLED_PATHS" value="$PROJECT_DIR$/magento/vendor/phpcompatibility/php-compatibility/PHPCompatibility" />
      <option name="EXTENSIONS" value="php,js,css,inc" />
    </inspection_tool>
    <inspection_tool class="PhpStanGlobal" enabled="false" level="WARNING" enabled_by_default="false">
      <option name="FULL_PROJECT" value="true" />
      <option name="level" value="8" />
      <option name="config" value="$PROJECT_DIR$/magento/vendor/bitexpert/phpstan-magento/extension.neon" />
      <option name="autoload" value="$PROJECT_DIR$/magento/vendor/bitexpert/phpstan-magento/autoload.php" />
    </inspection_tool>
  </profile>
</component>

```

## Configure Tests

### Integration Tests:

##Troubleshooting

* Error during magento-build command (Magento 2.4.1)

Error `Fatal error: Uncaught Error: Call to undefined function xdebug_disable() in /var/www/magento/vendor/magento/magento2-functional-testing-framework/src/Magento/FunctionalTestingFramework/_bootstrap.php on line 81
` can be fixed the following way:

Go to vendor/magento/magento2-functional-testing-framework/src/Magento/FunctionalTestingFramework/_bootstrap.php and change it

From :

      if (!(bool)$debugMode && extension_loaded('xdebug')) {
          xdebug_disable();
      }
      
To :
      
      if (!(bool)$debugMode && extension_loaded('xdebug')) {
          if (function_exists('xdebug_disable')) {
              xdebug_disable();
          }
      }
