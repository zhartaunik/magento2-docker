#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

# If asked, we'll ensure that the www-data is set to the same uid/gid as the
# mounted volume.  This works around permission issues with virtualbox shared
# folders.
if [[ "$UPDATE_UID_GID" = "true" ]]; then
    echo "Updating www-data uid and gid"

    DOCKER_UID=`stat -c "%u" $MAGENTO_ROOT`
    DOCKER_GID=`stat -c "%g" $MAGENTO_ROOT`

    INCUMBENT_USER=`getent passwd $DOCKER_UID | cut -d: -f1`
    INCUMBENT_GROUP=`getent group $DOCKER_GID | cut -d: -f1`

    echo "Docker: uid = $DOCKER_UID, gid = $DOCKER_GID"
    echo "Incumbent: user = $INCUMBENT_USER, group = $INCUMBENT_GROUP"

    # Once we've established the ids and incumbent ids then we need to free them
    # up (if necessary) and then make the change to www-data.

    [ ! -z "${INCUMBENT_USER}" ] && usermod -u 99$DOCKER_UID $INCUMBENT_USER
    usermod -u $DOCKER_UID www-data

    [ ! -z "${INCUMBENT_GROUP}" ] && groupmod -g 99$DOCKER_GID $INCUMBENT_GROUP
    groupmod -g $DOCKER_GID www-data
fi

# Ensure our Magento directory exists
mkdir -p $MAGENTO_ROOT
chown www-data:www-data $MAGENTO_ROOT



# Configure Sendmail if required
if [ "$ENABLE_SENDMAIL" == "true" ]; then
    /etc/init.d/sendmail start
fi

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


# XDebug Stuff
if [[ "${PHP_XDEBUG_ENABLE}" =~ ^(true|on|1)$ ]]; then
    docker-php-ext-enable xdebug
    echo "Xdebug is enabled"

    if [[ "${PHP_XDEBUG_REMOTE}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_REMOTE}}|${PHP_XDEBUG_REMOTE}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        sed -i "s|{{PHP_XDEBUG_REMOTE_HOST}}|${PHP_XDEBUG_REMOTE_HOST}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        sed -i "s|{{PHP_XDEBUG_REMOTE_PORT}}|${PHP_XDEBUG_REMOTE_PORT}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Xdebug remote is enabled"
    else
        sed -i "s|{{PHP_XDEBUG_REMOTE}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Xdebug remote is disable"
    fi

    if [[ "${PHP_XDEBUG_REMOTE_AUTOSTART}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_REMOTE_AUTOSTART}}|${PHP_XDEBUG_REMOTE_AUTOSTART}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Remote autostart is enable"
    else
        sed -i "s|{{PHP_XDEBUG_REMOTE_AUTOSTART}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Remote autostart is disable"
    fi

    if [[ "${PHP_XDEBUG_PROFILER_ENABLE}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_PROFILER_ENABLE}}|${PHP_XDEBUG_PROFILER_ENABLE}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Profiler is enable"
    else
        sed -i "s|{{PHP_XDEBUG_PROFILER_ENABLE}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Profiler is disable"
    fi

    if [[ "${PHP_XDEBUG_COVERAGE_ENABLE}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_COVERAGE_ENABLE}}|${PHP_XDEBUG_COVERAGE_ENABLE}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Coverage is enable"
    else
        sed -i "s|{{PHP_XDEBUG_COVERAGE_ENABLE}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Coverage is disable"
    fi

    if [[ "${PHP_XDEBUG_REMOTE_LOG_PATH}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_REMOTE_LOG_PATH}}|${PHP_XDEBUG_REMOTE_LOG_PATH}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Coverage is enable"
    else
        sed -i "s|{{PHP_XDEBUG_REMOTE_LOG_PATH}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Coverage is disable"
    fi

    if [[ "${PHP_XDEBUG_SCREAM}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_SCREAM}}|${PHP_XDEBUG_SCREAM}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Scream is enable"
    else
        sed -i "s|{{PHP_XDEBUG_SCREAM}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Scream is disable"
    fi

    if [[ "${PHP_XDEBUG_SHOW_LOCAL_VARS}" =~ ^(true|on|1)$ ]]; then
        sed -i "s|{{PHP_XDEBUG_SHOW_LOCAL_VARS}}|${PHP_XDEBUG_SHOW_LOCAL_VARS}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Show local vars is enable"
    else
        sed -i "s|{{PHP_XDEBUG_SHOW_LOCAL_VARS}}|0|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
        echo "Show local vars is disable"
    fi

    sed -i "s|{{PHP_XDEBUG_IDEKEY}}|${PHP_XDEBUG_IDEKEY}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
    sed -i "s|{{PHP_XDEBUG_REMOTE_CONNECT_BACK}}|${PHP_XDEBUG_REMOTE_CONNECT_BACK}|g" $PHP_INI_DIR/conf.d/zz-xdebug.ini
else
    echo "Xdebug is disabled"
fi


# Configure PHP-FPM
[ ! -z "${MAGENTO_RUN_MODE}" ] && sed -i "s/!MAGENTO_RUN_MODE!/${MAGENTO_RUN_MODE}/" /usr/local/etc/php-fpm.conf


exec "$@"

