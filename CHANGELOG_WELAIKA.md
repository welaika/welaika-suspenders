2.34 (?)
* Change: gitlab ci steps from prepare -> quality -> test to prepare -> test -> quality. We already run some quality checks with overcommit
* Change: use :login instead of :plain as smtp authentication system
* Change: use PostgreSQL 11
* Change: edited rubocop rules
* Documentation: update readme about suspenders


2.33 (July 23th, 2019)
* Feature: allow to deploy to heroku with push --force-with-lease (useful for staging)
* Fix: make new Chrome versions (really) headless
* Fix: remove code written for simple_cov on Circle CI
* Change: create database snapshot on heroku at 2 am (UTC) instead of 10 am (UTC)
* Documentation: add info about resetting the db on heroku
* Feature: add factory_bot lint to gitlabci
* Fix: SENTRY_ENV environment name was mismatched in .env file
* Fix: Chrome now runs (again) on docker (for gitlabci)

2.32.2 (June 24, 2019)
* Fix: stylelint on gitlab was not working

2.32.1 (June 24, 2019)
* Change: switch back to bundler 1. I think we are not ready yet for bundler 2

2.32.0 (June 24, 2019)
* Changed: introduced this file (`CHANGELOG_WELAIKA`) to tracks changes. The original file from thoughtbot is called `NEWS.MD`.
* Feature: linter for sass files ([stylelint](https://stylelint.io/)). Defaults are almost the same as thoughtbot. I edited some rules to support sass syntax, but probably we will need more tweaks. Voluteers?
* Change: use system tests instead of feature tests. Rspec now suggests you to use system tests instead of features tests because 1) they are build in in Rails 2) they share the same database connection so we don't need `database_cleaner` anymore. Create system tests in `spec/system`, that's it!
* Change: reintroduced `autoprefixer-rails`. I removed it some weeks ago because I had problems deploying a rails app with in on Heroku. I don't know if anything changed, but I would like to give it a second chance :)
* Change: rubocop is not splitted in several gems
* Feature: use a custom docker image for gitlab.ci. We experimented this already in a couple of projects. We use a docker image so we can install node, yarn and chrome once for all.
* Change: removed the CI configuration for a remote selenium webdriver. We don't need it anymore. Some old projects still uses it, but newer ones will just use headless Chrome and a custom docker image.
* Change: use bundler 2 now that Heroku supports it https://devcenter.heroku.com/articles/ruby-support#libraries
