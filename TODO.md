# Todo

### Todo List
- create data volume container
  - preserve during make, make rebuild
- check on `make start-cli`
- launch cron
- add "dev" mode to:
  - disable postfix
  - disable cron
  - add php debug
- add proper usage message to Makefile
- add instructions about when to use app.install vs. Dockerfile
- add example puppet manifest?
- add ability to copy images between docker machines
- add app name to list of environment variables
- make app.backup and app.restore use app-specific names for backup files
- fix mysql and app_home purging in app.restore
