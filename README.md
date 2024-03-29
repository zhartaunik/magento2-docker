# Magento 2 Docker

## Quick Start

### 1. Infrastructure part

Follow the next points:
1. Run shell script in the root directory (this may update files in your docker directory). Keep in mind, execution of this script is idempotent (_can be applied multiple times without changing the result_).
```shell
sh check.sh
```
2. Update your magento keys in composer.env [Get your authentication keys](https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/prerequisites/authentication-keys.html?lang=en)
3. For elasticsearch work execute from your OS command line:
```shell script
sudo sysctl -w vm.max_map_count=262144
```
4. Add to hosts file the following information (your magento will be accessible via https://magento2.docker/):
```text
127.0.0.1   magento2.docker
```

### 2. Application part (install Magento)

1. Execute from the project root `make docker:magic` command to create and run all necessary containers (without cron).
2. Enter the container with the command `make mg` and run from the container
```shell script
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
```
3. To install magento run inside container magento installation:
```shell script
magento-build && magento-install
```

## These points will be done by shell script (just for information no action needed):
### Update uid/gid 

Ensure that your current user has uid/gid equals 1000/1000.
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
### Generate certificates for your domain.
(There are two certificates for domain 'magento2.docker' in ```docker/nginx/etc/certs folder```, remove '.dist' from the name). Path to certificates - `magento2-docker/nginx/etc/certs`. The command below is required only if you need to generate different certificates and not necessary to be executed.
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

## Troubleshooting

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
