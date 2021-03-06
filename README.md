# weLaika's Suspenders [![Build Status](https://travis-ci.org/welaika/welaika-suspenders.svg?branch=master)](https://travis-ci.org/welaika/welaika-suspenders)

This is a [suspenders](https://github.com/thoughtbot/suspenders) fork in use at [weLaika](http://dev.welaika.com).
Big thanks to [thoughtbot](http://thoughtbot.com/community) for providing such a great starting point.

** Warning! **

welaika-suspenders version 2 will install rails 5.
welaika-suspenders version 3 will install rails 6.

You may want to use version 2 if you need to use solidus 2.9.x

## Installation

First ensure you have PostgreSQL (use the same version specified in `Suspenders::POSTGRES_VERSION`), npm and yarn.

    $ brew install postgresql
    $ brew install node
    $ npm install npm@latest -g # To update npm if you have already installed it
    $ brew install yarn

then install the suspenders gem:

    gem install welaika-suspenders

If you want to use heroku, please install the [heroku toolbelt](https://toolbelt.heroku.com/) and run

    heroku login

Then run:

    welaika-suspenders projectname --heroku=true

This will create a Rails app in `projectname` using the latest version of Rails.

You can optionally specify alternate Heroku flags:

    welaika-suspenders projectname \
      --heroku true \
      --heroku-flags "--addons sendgrid,logentries,scheduler"

See all possible Heroku flags:

    heroku help create

This will create a rails app in `projectname`. This script creates a
new git repository. It is not meant to be used against an existing repo.

Run the bin/setup script

    cd projectname && bin/setup

## Version number

`welaika-suspenders` version number isn't related to thoughbot's [suspenders](https://github.com/thoughtbot/suspenders).
