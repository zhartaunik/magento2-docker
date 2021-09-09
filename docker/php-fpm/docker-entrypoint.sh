#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

# Substitute in php.ini values
[ ! -z "${PHP_MEMORY_LIMIT}" ] && sed -i "s|{{PHP_MEMORY_LIMIT}}|${PHP_MEMORY_LIMIT}|g" $PHP_INI_DIR/conf.d/zz-php.ini
[ ! -z "${PHP_UPLOAD_MAX_FILESIZE}" ] && sed -i "s|{{PHP_UPLOAD_MAX_FILESIZE}}|${PHP_UPLOAD_MAX_FILESIZE}|g" $PHP_INI_DIR/conf.d/zz-php.ini
[ ! -z "${PHP_MAX_SIZE}" ] && sed -i "s|{{PHP_MAX_SIZE}}|${PHP_MAX_SIZE}|g" $PHP_INI_DIR/conf.d/zz-php.ini

########################## APC
if [[ "${PHP_APC_ENABLED}" =~ ^(true|on|1)$ ]]; then
    sed -i "s|{{PHP_APC_ENABLED}}|${PHP_APC_ENABLED}|g" $PHP_INI_DIR/conf.d/zz-apc.ini
    echo "APC is enabled"
else
    sed -i "s|{{PHP_APC_ENABLED}}|0|g" $PHP_INI_DIR/conf.d/zz-apc.ini
    echo "APC is disabled"
fi

sed -i "s|{{PHP_APC_SHM_SIZE}}|${PHP_APC_SHM_SIZE}|g" $PHP_INI_DIR/conf.d/zz-apc.ini
sed -i "s|{{PHP_APC_TTL}}|${PHP_APC_TTL}|g" $PHP_INI_DIR/conf.d/zz-apc.ini
sed -i "s|{{PHP_APC_GC_TTL}}|${PHP_APC_GC_TTL}|g" $PHP_INI_DIR/conf.d/zz-apc.ini

######################## OPCache
if [[ "${PHP_OPCACHE_ENABLE}" =~ ^(true|on|1)$ ]]; then
    sed -i "s|{{PHP_OPCACHE_ENABLE}}|${PHP_OPCACHE_ENABLE}|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
    echo "OPCache is enabled"
else
    sed -i "s|{{PHP_OPCACHE_ENABLE}}|0|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
    echo "OPCache is disabled"
fi

if [[ "${PHP_OPCACHE_CONSISTENCY_CHECKS}" =~ ^(true|on|1)$ ]]; then
    sed -i "s|{{PHP_OPCACHE_CONSISTENCY_CHECKS}}|${PHP_OPCACHE_CONSISTENCY_CHECKS}|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
    echo "OPCache Consistency Checks is enabled"
else
    sed -i "s|{{PHP_OPCACHE_CONSISTENCY_CHECKS}}|0|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
    echo "OPCache Consistency Checks is disabled"
fi

if [[ "${PHP_OPCACHE_VALIDATE_TIMESTAMPS}" =~ ^(true|on|1)$ ]]; then
    sed -i "s|{{PHP_OPCACHE_VALIDATE_TIMESTAMPS}}|${PHP_OPCACHE_VALIDATE_TIMESTAMPS}|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
    echo "OPCache Validate Timestamps is enabled"
else
    sed -i "s|{{PHP_OPCACHE_VALIDATE_TIMESTAMPS}}|0|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
    echo "OPCache Validate Timestamps is disabled"
fi

sed -i "s|{{PHP_OPCACHE_MEMORY_CONSUMPTION}}|${PHP_OPCACHE_MEMORY_CONSUMPTION}|g" $PHP_INI_DIR/conf.d/zz-opcache.ini
sed -i "s|{{PHP_OPCACHE_MAX_ACCELERATED_FILES}}|${PHP_OPCACHE_MAX_ACCELERATED_FILES}|g" $PHP_INI_DIR/conf.d/zz-opcache.ini

sed -i "s|{{PHP_XDEBUG_MODE}}|${PHP_XDEBUG_MODE}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
sed -i "s|{{PHP_XDEBUG_REMOTE_HOST}}|${PHP_XDEBUG_REMOTE_HOST}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
sed -i "s|{{PHP_XDEBUG_REMOTE_PORT}}|${PHP_XDEBUG_REMOTE_PORT}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
sed -i "s|{{PHP_XDEBUG_IDEKEY}}|${PHP_XDEBUG_IDEKEY}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini

# Configure PHP-FPM
[ ! -z "${MAGENTO_RUN_MODE}" ] && sed -i "s/!MAGENTO_RUN_MODE!/${MAGENTO_RUN_MODE}/" /usr/local/etc/php-fpm.conf

exec "$@"

