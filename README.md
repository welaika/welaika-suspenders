# weLaika's Suspenders [![Build Status](https://travis-ci.org/welaika/welaika-suspenders.svg?branch=master)](https://travis-ci.org/welaika/welaika-suspenders)

This is a [suspenders](https://github.com/thoughtbot/suspenders) fork in use at [weLaika](http://dev.welaika.com).
Big thanks to [thoughtbot](http://thoughtbot.com/community) for providing such a great starting point.

## Installation

First install the suspenders gem:

    gem install welaika-suspenders

If you are using RVM, please create a new gemset named like `projectname`:

    rvm gemset create projectname
    rvm gemset use projectname

If you want to use heroku, please install the [heroku toolbelt](https://toolbelt.heroku.com/) and run

    heroku login

Then run:

    welaika-suspenders projectname

This will create a Rails app in `projectname` using the latest version of Rails.

You can optionally specify alternate Heroku flags:

    welaika-suspenders projectname \
      --heroku true \
      --heroku-flags "--region eu --addons newrelic,pgbackups,sendgrid,ssl"

See all possible Heroku flags:

    heroku help create

This will create a rails app in `projectname`. This script creates a
new git repository. It is not meant to be used against an existing repo.

Then run:

    cd projectname && bin/setup

If you want to add an empty bare repository as origin, run

    git remote add origin git@github.com:welaika/projectname.git

## Version number

`welaika-suspenders` version number isn't related to thoughbot's [suspenders](https://github.com/thoughtbot/suspenders).

## Changelog

We merge commits from thoughbot's [suspenders](https://github.com/thoughtbot/suspenders) periodically.

List of changes we made since [this is commit](https://github.com/thoughtbot/suspenders/tree/d24d6eab4cc254f8bebfd73fd2b26fbbd2647e86):
- remove `host` key in database.yml
- add [priscilla](https://github.com/Arkham/priscilla) gem
- add [pry-bloodline](https://github.com/Arkham/pry-bloodline) gem
- add [rails-i18n](https://github.com/svenfuchs/rails-i18n) gem and use italian, english as available locales
- add [letter_opener](https://github.com/ryanb/letter_opener) gem
- add [faker](https://github.com/stympy/faker) gem
- remove segment.io javascript code
- add [slim-rails](https://github.com/slim-template/slim-rails) gem
- add some html meta tags
- use EU region as default for Heroku
- use pry-byebug instead of byebug
- use CDATA wrapper for javascript
- create a .ruby-gemset file with app name
- create common folders like `app/queries`, `app/services`, etc.
- use `application.css.sass` instead of `application.css.scss`
- add `quiet_assets` gem
- add `brakeman` gem
- change `i18n_tasks` configuration: set `it` as base locale
- set `Rome` as `time_zone`
- set `:it` as `default_locale`
- add [simplecov](https://github.com/colszowka/simplecov)
- add fixtures helper for `rspec`
- add queries helper for `rspec`
- configure asset host for capybara
- add helpers for capybara (`page!`, `screenshot!`)
- drop support for IE 9 in AutoPrefixer
- removed [hound](https://houndci.com) configuration
- add [bullet](https://github.com/flyerhzm/bullet)
