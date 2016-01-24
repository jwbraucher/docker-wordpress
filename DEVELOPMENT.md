# Development Instructions

## Installation

This project requires Docker Toolbox and GNU make.

## Usage

# Create and start a docker machine
make machine

# Display the machine env command to be pasted into the current shell
# (Mac OS users just type 'pbpaste')
make env

# Clean up stopped containers, <none> images, untracked git files
make clean

# Build all images
make

# Rebuild foo
make rebuild IMAGE=foo

# Start/Stop/Restart services
make start
make stop SERVICE="foo foo-db"
make cli SERVICE=foo

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
