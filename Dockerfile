FROM ruby:3.0.2

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update -qq && \
    apt-get install -y -qq build-essential libpq-dev postgresql-client nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_BUILD__SASSC="--disable-march-tune-native"
ENV BINSTUBS_DIR="/usr/local/binstubs"
ENV PATH="$BINSTUBS_DIR:$PATH"

RUN mkdir -p "$BINSTUBS_DIR"

RUN gem update --system
RUN gem install bundler --version 2.1.2

RUN mkdir /app
WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install \
    --jobs "$(nproc)" \
    --binstubs="$BINSTUBS_DIR"

COPY . .

RUN rake RAILS_ENV=production assets:precompile
