#!/bin/bash

tput sgr0
# Colors
BGRED='\033[41m'
BGYELLOW='\033[43m'
BGGREEN='\033[42m'

# 1. Check .env file, local IP address and Magento secret key
DOT_ENV=.env

if [ ! -f "${DOT_ENV}" ]; then
  cp .env.dist .env
  echo "${BGGREEN}[OK] ${DOT_ENV} was created successfully.";
else
  echo "${BGGREEN}[OK] ${DOT_ENV} exists.";
fi

#if [ -f "${DOT_ENV}" ]; then
#
#  YOUR_IP=$(grep -oP 'LOCAL_HOST_IP=\K([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' "${DOT_ENV}");
#
#  if [ ! -z "$YOUR_IP" ]; then
#    if [ "$(command -v ifconfig)" = "/usr/sbin/ifconfig" ] && (ifconfig | grep -q "inet ${YOUR_IP}"); then
#      echo "${BGGREEN}[OK] IP Address is fine and equals ${YOUR_IP}. This address is registered in .env file.";
#    else
#      echo "${BGYELLOW}[WARN] net-tools application is not installed. Unable to validate IP address. To verify the address please run 'sudo apt-get install net-tools'";
#    fi
#  elif grep -q -E "^LOCAL_HOST_IP=$" "${DOT_ENV}"; then
#    echo "${BGYELLOW}[WARNING] IP Address is empty. xDebug for PHP may not work properly.";
#  else
#    echo "${BGRED}[FAIL] IP Address is wrong. Please check if your local address is really ${YOUR_IP}.";
#  fi

#  if grep -q -E "^MAGENTO_APP_SECRET=[a-zA-Z0-9]{32}$" "${DOT_ENV}"; then
#    echo "${BGGREEN}[OK] Magento Secret key is correct.";
#  else
#    echo "${BGRED}[FAIL] Magento Secret key is wrong.";
#  fi
#fi

# 2. Check composer.env file and it's content.

COMPOSER_ENV=composer.env

if [ ! -f "${COMPOSER_ENV}" ]; then
  cp composer.env.sample composer.env
  echo "${BGGREEN}[OK] ${COMPOSER_ENV} was created successfully."
else
  echo "${BGGREEN}[OK] ${COMPOSER_ENV} exists."
fi

if [ -f "${COMPOSER_ENV}" ]; then
#-o
  if (grep -q -E "^COMPOSER_MAGENTO_USERNAME=[A-Za-z0-9]{32}$" "${COMPOSER_ENV}") || (grep -q -E "^COMPOSER_MAGENTO_PASSWORD=[A-Za-z0-9]{32}$" "${COMPOSER_ENV}"); then
    echo "${BGGREEN}[OK] Composer keys are fulfilled.";
  else
    echo "${BGRED}[FAIL] Composer secret key are empty or incorrect. Please fulfill these values in ${COMPOSER_ENV}";
  fi
fi

# 3. Check nginx certificates.

NGINX_SSL_CERT="$(grep -oP "NGINX_SSL_CERT=\K(\w+.\w+)" "${DOT_ENV}")"
NGINX_SSL_CERT_KEY=$(grep -oP "NGINX_SSL_CERT_KEY=\K(\w+.\w+)" "${DOT_ENV}")
cp docker/nginx/etc/certs/${NGINX_SSL_CERT}.dist docker/nginx/etc/certs/${NGINX_SSL_CERT}
cp docker/nginx/etc/certs/${NGINX_SSL_CERT_KEY}.dist docker/nginx/etc/certs/${NGINX_SSL_CERT_KEY}

echo "${BGGREEN}[OK] Certificates were generated successfully.";

# 4. Check uid and gid for the current user.

CURRENT_UID="$(id -u $USER)"
CURRENT_GID="$(id -g $USER)"

sed -i 's/RUN groupadd -g 1000 magento/RUN groupadd -g '"$CURRENT_GID"' magento/g' ./docker/php-fpm/Dockerfile
sed -i 's/-u 1000 -g 1000 magento/-u '"$CURRENT_UID"' -g '"$CURRENT_GID"' magento/g' ./docker/php-fpm/Dockerfile
sed -i 's/RUN groupadd -g 1000 magento/RUN groupadd -g '"$CURRENT_GID"' magento/g' ./docker/php-cli/Dockerfile
sed -i 's/-u 1000 -g 1000 magento/-u '"$CURRENT_UID"' -g '"$CURRENT_GID"' magento/g' ./docker/php-cli/Dockerfile

echo "${BGGREEN}[OK] Your UID=${CURRENT_UID}, GID=${CURRENT_GID} have been updated for php-fpm and php-cli.";

# 5. Create magento folder.
mkdir magento
echo "${BGGREEN}[OK] Magento folder has been created successfully.";

tput sgr0
