source 'https://rubygems.org'
ruby "2.1.0", :engine => "rbx", :engine_version => "2.1.1"

gem 'rails', '4.0'
gem "rubysl"
gem 'pg'
gem 'puma', '2.6.0'
gem 'rails_12factor'
#gem 'rails_admin'
gem 'devise'
gem 'cancan'
gem 'memcachier'
gem 'rack-cache'
gem 'dalli'
gem 'textacular', '~> 3.0', require: 'textacular/rails'
gem 'newrelic_rpm'
gem 'jist'
gem 'chartkick'
gem 'groupdate'
gem 'sass-rails', '~> 4.0.0'
gem 'haml-rails'
gem 'jquery-rails'
gem 'uglifier'
gem 'jqcloud-rails', :git => 'git://github.com/GordonDiggs/jqcloud-rails.git'

# TODO: remove this
gem 'protected_attributes'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'sextant'
  gem 'foreman'
  gem 'colorize'
  gem 'heroku'
  gem 'better_errors'
  gem 'pry-rails'
end

group :test do
  gem 'shoulda'
end
