FROM starefossen/ruby-node:2-10

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client && \
    rm -rf /var/lib/apt/lists/*

RUN gem update --system

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY . .

RUN rake RAILS_ENV=production assets:precompile
