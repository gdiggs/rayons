FROM ruby:2.4.2

RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs postgresql-client && \
    curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > /usr/bin/cc-test-reporter && \
    chmod +x /usr/bin/cc-test-reporter
