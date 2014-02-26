# Microblogging

Ruby on Rails Tutorial: a microblogging service

## Installation

    git clone git@github.com:dskecse/microblogging.git
    cd microblogging/
    cp config/database.example.yml config/database.yml
    bundle install --without production
    bin/rake db:setup

## Testing

In common case, to run the full test suite you should type in:

    bin/rspec spec/

Since the project uses Guard to automate the running of the tests by monitoring
changes in the filesystem and Spork DRb server to reduce the overhead each time
a test gets run, start them both at the same time:

    bin/guard
