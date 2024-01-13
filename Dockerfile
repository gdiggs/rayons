FROM gordondiggs/ruby3

ENV NODE_MAJOR 20

RUN apt-get update -qq && \
    apt-get install -y -qq ca-certificates curl gnupg build-essential libpq-dev postgresql-client && \
    curl -fsSL "https://deb.nodesource.com/setup_$NODE_MAJOR.x" | bash - && \
    apt-get update -qq && \
    apt-get install -y -qq nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_BUILD__SASSC="--disable-march-tune-native"
ENV BINSTUBS_DIR="/usr/local/binstubs"
ENV PATH="$BINSTUBS_DIR:$PATH"

RUN mkdir -p "$BINSTUBS_DIR"

RUN gem update --system

RUN mkdir /app
WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install \
    --jobs "$(nproc)" \
    --binstubs="$BINSTUBS_DIR"

COPY . .

RUN rake RAILS_ENV=production assets:precompile
