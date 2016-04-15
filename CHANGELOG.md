## braucher/app 2.2.0

### Features
- Added ${app} variable to env
- Changed backup/restore file names to include app name

### Bugfixes
- Fixed app.restore purging processs

## braucher/app 2.1.0

### Features
- Made "make release" push origin master because this command
  is often run right after a merge.

### Bugfixes
- Fixed app.restore
- Improved instructions in DEVELOPMENT.md

## braucher/app 2.0.0

### Major Changes
- Machine name now matches app name. This will break projects 
  with existing machines unless "machine=<USERNAME" is specified
  on the command line.
- The default Makefile target is now "help" instead of "build". To build
  you must now issue "make build" instead of just "make".

### Features
- Added "help" / "list-commands" to Makefile
- Made machine name unique to each project

### Bugfixes
- Fixed example app

## braucher/app 1.4.2

### Bugfixes
- Fixed Dockerfile to deploy fix-uids
- Fixed app.start so that container keeps running

## braucher/app 1.4.1

### Bugfixes
- Fixed backup/restore vars

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

