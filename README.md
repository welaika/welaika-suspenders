# weLaika's Suspenders [![Build Status](https://travis-ci.org/welaika/welaika-suspenders.svg?branch=master)](https://travis-ci.org/welaika/welaika-suspenders)
=======

This is a [suspenders](https://github.com/thoughtbot/suspenders) fork in use at [weLaika](http://dev.welaika.com).
Big thanks to [thoughtbot](http://thoughtbot.com/community) for providing such a great starting point.

## Installation

First ensure you have PostgreSQL, npm, yarn and chromedriver

    $ brew install postgresql
    $ brew install node
    $ npm install npm@latest -g # To update npm if you have already installed it
    $ brew install yarn
    $ brew casks install chromedriver

then install the suspenders gem:

    gem install welaika-suspenders

If you want to use heroku, please install the [heroku toolbelt](https://toolbelt.heroku.com/) and run

    heroku login

Then run:

    welaika-suspenders projectname

This will create a Rails app in `projectname` using the latest version of Rails.

You can optionally specify alternate Heroku flags:

    welaika-suspenders projectname \
      --heroku true \
      --heroku-flags "--addons sendgrid,logentries,scheduler"

See all possible Heroku flags:

    heroku help create

This will create a rails app in `projectname`. This script creates a
new git repository. It is not meant to be used against an existing repo.

    cd projectname && bin/setup

If you want to add an empty bare repository as origin, run

    git remote add origin git@github.com:welaika/projectname.git

## Version number

`welaika-suspenders` version number isn't related to thoughbot's [suspenders](https://github.com/thoughtbot/suspenders).
