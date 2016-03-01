## braucher/app 1.4

### Features
- Added restore process
- Added latest symlink to backup process

### Bugfixes
- Fixed Makefile environment variable issue
- "make clean" now removes sub-directories named 'export'
  other than 'volumes/export'

## braucher/app 1.3.1

### Bugfixes
- Reverted having 'make release' update CHANGELOG.md and README.md
- Fixed environment variables in Makefile targets
- Fixed syntax error in Makefile

## braucher/app 1.3.0

### Features
- make release now updates CHANGELOG.md and README.md
- make release pushes each update one at a time
- restyled CHANGELOG

## braucher/app 1.2.1

### Bugfixes
- Removed sample-project from release process
- Updated Makefile to use inline bash scripts for targets

## braucher/app 1.2.0

### Features
- added 'make release', VERSION
- added 'make volumes'
- app-web can write to app volume to create document root
- improved dev documentation

### Bugfixes
- improved 'make clean'

## braucher/app 1.1.0

### Features
- excluded volumes/export from 'make clean'

### Bugfixes
- fixed datestamp in backup filename (hour was missing)

## braucher/app 1.0.0

### Features
- Makefile
- /app entrypoint
- /fix-uids
- docker-compose example
- wait for database container (app.configure)

