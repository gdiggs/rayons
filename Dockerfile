FROM ruby:2.3.0
MAINTAINER Gordon Diggs <gordon@gordondiggs.com>

# Node is needed for uglifier
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs

WORKDIR /app

COPY Gemfile* /app/
RUN bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin -j4 --deployment

ENV RAILS_ENV production
ENV LANG C.UTF-8

COPY . /app

RUN bundle exec rake assets:precompile --trace && \
    bundle exec rake assets:clean

RUN git rev-parse HEAD > /app/REVISION

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
