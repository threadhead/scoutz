# scoutz

A Scouting (as in [BSA](http://www.scouting.org)) Management Tool. Suitable for Cub Scouts, Boy Scouts, Venturing Crews, Girl Scouts, Service Units, Order of the Arrow, Sea Scouts Ships. Manage rosters, adults and children, group events with notifications, and more.

[![Build Status](https://secure.travis-ci.org/threadhead/scoutz.png)](http://travis-ci.org/threadhead/scoutz) [![Dependency Status](https://gemnasium.com/threadhead/scoutz.svg)](https://gemnasium.com/threadhead/scoutz)


Documentation
-------------

`scoutz` is a Ruby on Rails V3 application for the management of BSA Scouting units. `scoutz` is in no way associated nor endorsed by the [Boy Scouts of America](http://www.scouting.org).

Install it, play with it, let me know what you think.

API? You betcha! Any registered user can access a `scoutz` application and perform all actions they are authorized to perform in the html version.

Mobile? That too. But mobile will have to take a seat in the back of the bus for a while.

Coming: `scoutz` will be hosted on a real live site, freely available to the interweb's cosmonauts.


Getting Started
---------------

It is assumed you have created and served a Rails application before. If you have not, the official [Ruby on Rails Guides](http://guides.rubyonrails.org/) would be a good place to start learning more.

Please note that `scoutz` was written with the intention of being hosted on [Heroku](http://www.heroku.com). This includes:

* Assets hosted on a CDN, like [Amazon S3](http://aws.amazon.com/s3/)
* Served using [thin](https://github.com/macournoyer/thin)
* All assets will be precompiled and *not* committed to the repository (except manifest.yml)


Technologies
------------

Some of the gems `scoutz` is using:

* Compass and SASS - for sanity
* Twitter Bootstrap - via twitter-bootstrap-rails gem
* Devise - authentication
* Cancan - authorization
* Carrierwave - uploads
* delayed_job - the ole' standby
* sextant - will be in rails 4, let the goodness roll for 3.X
* exception_notification - hard to beat free excpetion emails



Contributing
------------

We love contributors! Please follow these simple guidelines:

1. Fork the [master branch](https://github.com/threadhead/scoutz/tree/master).
2. Make your changes in a topic branch.
3. Send a pull request.

Notes:

* Contributions without tests won't be accepted.
* Really, no tests, no pull.


Credits
-------

* Karl Smith
* your_name_goes_here


License
-------

MIT License. Copyright © 2012 Karl Smith and Desert Solitaire, LLC. It is free software, and may be redistributed under the terms specified in the LICENSE file.
