source 'http://rubygems.org'

gem 'aws-sdk-s3'
gem 'configatron'
gem 'figaro'
gem 'grape'
gem 'grape-entity'
gem 'i18n'
gem 'mimemagic'
gem 'mini_magick'
gem 'rack'
gem 'require_all'

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'puma'
  gem 'rack-console'
  gem 'rack-test', require: false
  gem 'rspec'
  gem 'rspec-its', require: false
  gem 'rubocop'
end
