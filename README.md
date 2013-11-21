[![Code Climate](https://codeclimate.com/github/GordonDiggs/rayons.png)](https://codeclimate.com/github/GordonDiggs/rayons)
[![Dependency Status](https://gemnasium.com/GordonDiggs/rayons.png)](https://gemnasium.com/GordonDiggs/rayons)
[![Build Status](https://travis-ci.org/GordonDiggs/rayons.png?branch=master)](https://travis-ci.org/GordonDiggs/rayons)

## Rayons

Rayons is a rails port and specification of [https://github.com/GordonDiggs/cataloguais](https://github.com/GordonDiggs/cataloguais). While cataloguais sought to be a reusable, generalized, way to catalog anything, Rayons is more specialized for a record collection.

Rails was chosen over Sinatra mainly for the chainability and ease of ActiveRecord over DataMapper. Other advantages include better authentication, more RESTful APIs, and an admin dashboard.

### Setup

Rayons requires a Postgres installation and is tested on ruby 1.9.3.

```bash
$ gem install bundler
$ bundle install
$ rake db:create
$ rake db:migrate
$ foreman start
```

The app will be available at [0.0.0.0:5000](http://0.0.0.0:5000). When running in production mode, the app requires SSL (Heroku supplies this automatically), and an `ENV[SECRET_TOKEN]` to be set.

### Grunt

Rayons comes with [Grunt](http://gruntjs.com) for js hinting. Install and run it with:

```bash
$ npm install -g grunt-cli
$ grunt
```

*NOTE: You must have node 0.8 or higher*

### License

Rayons is licensed under the MIT License

Copyright (c) 2013 Gordon Diggs

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
