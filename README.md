# Magento 2 Docker

## Quick Start

* Prepare env files:
```
    cp .env.dist .env
    cp composer.env.sample composer.env
```
* In .env file fill MAGENTO_APP_SECRET and LOCAL_HOST_IP (required for xdebug)
* Generate certificates for your domain