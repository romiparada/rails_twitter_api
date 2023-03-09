# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'aws-sdk-s3', '~> 1.119', '>= 1.119.1', require: false
gem 'blueprinter', '~> 0.25.3'
gem 'bootsnap', require: false
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'devise-jwt', '~> 0.10.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  gem 'letter_opener', '~> 1.8', '>= 1.8.1'
end

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.1', '>= 3.1.1'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.1'
  gem 'rubocop', '~> 1.45', '>= 1.45.1', require: false
  gem 'rubocop-rails', '~> 2.17', '>= 2.17.4', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 5.3'
end
