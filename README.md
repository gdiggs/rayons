[![Code Climate](https://codeclimate.com/github/GordonDiggs/rayons.png)](https://codeclimate.com/github/GordonDiggs/rayons)
[![Test Coverage](https://codeclimate.com/github/GordonDiggs/rayons/badges/coverage.svg)](https://codeclimate.com/github/GordonDiggs/rayons)
[![CircleCI](https://circleci.com/gh/gdiggs/rayons.svg)](https://circleci.com/gh/gdiggs/rayons)

# Rayons

Rayons is a rails application dedicated to catalogging a record collection. It
offers authentication, management of the collection, as well as statistics on
the collection.

## Local Setup

Copy `.env.example` to `.env` and fill in the necessary fields.

Rayons requires Docker/Docker Compose to run:

```bash
make dev
```

The app will be available at [0.0.0.0:5000](http://0.0.0.0:5000). When running
in production mode, the app requires SSL (Heroku supplies this automatically),
and an `ENV['SECRET_TOKEN']` to be set.

## Tests

You can run tests with `make test`.

## Dropbox Backup Setup

You can back up the collection by using `docker-compose run web rake backup:dropbox`. Before you can
do this, you must create an application on Dropbox and follow
[these instructions](https://www.dropbox.com/developers/core/start/ruby) to get
your Dropbox access token.

## License

Rayons is licensed under the MIT License

Copyright (c) 2013 Gordon Diggs

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
