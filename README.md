DonorHub Transformer
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This application helps organizations to present their internal donation data as a donorhub compliant API.
This makes it easy to enable people to import donation data into tools like [MPDX](https://mpdx.org).

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
3. Add environment variables in .env
4. Get MPDX Developer to run `OrganizationFromQueryUrlWorker.perform_async('org_name', 'https://organizationcode.donationcore.com/api/v1/query')`

Integration Setup
-----------------

1. Add Heroku Scheduler daily task `rails integration:sync`

Credits
-------
- Tataihono Nikora
- Nathaniel Watts
