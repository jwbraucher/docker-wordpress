# braucher/wordpress unrelease

## Features
* Added unzip to base image
* Customized restore process for backupwordpress

# braucher/wordpress 1.5.0

## Features
* Merged in braucher/app-1.3.0

# braucher/wordpress 1.4.1

## Features
* Made 'make install' start the app

# braucher/wordpress 1.4.0

## Features
* add app.install.local script

# braucher/wordpress 1.3.0

## Features
* added wordpress app.backup script
* added backupwordpress plugin to app.install

# braucher/wordpress 1.2.1

## Bugfixes
* added /app.configure to the beginning of /app.install

# braucher/wordpress 1.2.0

## Features
* merged in features from braucher/php-1.2.0

# braucher/wordpress 1.1.1

## Features
* WORKDIR change

# braucher/wordpress 1.1.0

## Features
* merged in features from braucher/php-1.2.0

# braucher/wordpress 1.0.0

## Features
* manages Wordpress via supplied /app.* scripts
* installs wp-cli configured to run from the Docker root account
* full Wordpress stack in*docker-compose.yml
