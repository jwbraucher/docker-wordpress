# braucher/app 1.2.1 unreleased

## Bugfixes
- Removed sample-project from release process

# braucher/app 1.2.0

## Features
- added 'make release', VERSION
- added 'make volumes'
- app-web can write to app volume to create document root
- improved dev documentation

## Bugfixes
- improved 'make clean'

# braucher/app 1.1.0

## Features
- excluded volumes/export from 'make clean'

## Bugfixes
- fixed datestamp in backup filename (hour was missing)

# braucher/app 1.0.0

## Features
- Makefile
- /app entrypoint
- /fix-uids
- docker-compose example
- wait for database container (app.configure)

