DonorHub Transformer
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This application helps you to present your organization's internal donation data as a donorhub compliant API. This makes it easy to enable people to import donation data into tools like [MPDX](https://mpdx.org).

Ruby on Rails
-------------

This application requires:

- Ruby (version in .ruby-version)
- Rails (version in Gemfile)

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Running in Production
---------------------

1. Create new app on Heroku and deploy this repo
2. Add SendGrid plugin to Heroku app
3. Add environment variables in .env.example

Xero Setup
----------

1. Create a private app on [Xero](https://developer.xero.com/myapps/) with a Public Key Certificate
2. Add `XERO_OAUTH_CONSUMER_KEY`, `XERO_OAUTH_CONSUMER_SECRET` environment variables from Xero App OAuth 1.0a Credentials to Heroku
3. Add `XERO_PRIVATE_KEY` from the Public Key Certificate generated in step 1 to Heroku
4. Run `rails xero:sync_all` once on Heroku
5. Add Heroku Scheduler daily task `rails xero:sync`

Credits
-------
- Tataihono Nikora
- Nathaniel Watts
