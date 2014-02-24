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

    bin/rake
