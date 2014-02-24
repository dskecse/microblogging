# Microblogging

Ruby on Rails Tutorial: a microblogging service

## Installation

    git clone git@github.com:dskecse/microblogging.git
    cd microblogging/
    cp config/database.example.yml config/database.yml
    bin/bundle install --without production
    bin/bundle update
    bin/bundle install
    bin/rake db:setup

## Testing

In common case, to run the full test suite you should type in:

    bin/rake

Since the project uses Guard to automate the running of the tests, you might want
to run it to monitor changes in the filesystem:

    bundle exec guard
