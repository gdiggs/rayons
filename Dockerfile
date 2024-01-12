FROM ruby:3.3.0

ENV NODE_MAJOR 20

# Install custom ruby
RUN apt-get update -qq && \
    apt-get install -y build-essential wget autoconf && \
    wget https://github.com/postmodern/ruby-install/releases/download/v0.9.3/ruby-install-0.9.3.tar.gz && \
    tar -xzvf ruby-install-0.9.3.tar.gz && \
    cd ruby-install-0.9.3/ && \
    make install && \
    ruby-install -p https://github.com/ruby/ruby/pull/9371.diff ruby 3.3.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Make the Ruby binary available on the PATH
ENV PATH="/opt/rubies/ruby-3.3.0/bin:${PATH}"

RUN apt-get update -qq && \
    apt-get install -y -qq ca-certificates curl gnupg build-essential libpq-dev postgresql-client && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
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
