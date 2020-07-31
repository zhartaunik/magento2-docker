<?php
/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */

return [
    'db-host' => 'mysql',
    'db-user' => 'magento2',
    'db-password' => 'magento2',
    'db-name' => 'magento_integration_tests',
    'db-prefix' => '',
    'backend-frontname' => 'admin',
    'admin-user' => \Magento\TestFramework\Bootstrap::ADMIN_NAME,
    'admin-password' => \Magento\TestFramework\Bootstrap::ADMIN_PASSWORD,
    'admin-email' => \Magento\TestFramework\Bootstrap::ADMIN_EMAIL,
    'admin-firstname' => \Magento\TestFramework\Bootstrap::ADMIN_FIRSTNAME,
    'admin-lastname' => \Magento\TestFramework\Bootstrap::ADMIN_LASTNAME,
    'elasticsearch-host' => 'magento2.docker',
    'elasticsearch-port' => '9200',
    'amqp-host' => 'magento2.docker',
    'amqp-port' => '5672',
    'amqp-user' => 'user',
    'amqp-password' => 'password',
];
