source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end
ruby '2.3.4'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end
group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
gem 'activeadmin'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'bourbon'
gem 'devise'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'pg'
gem 'pundit'
gem 'simple_token_authentication'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'versionist'
gem 'xeroizer'
group :development do
  gem 'better_errors'
  gem 'foreman'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'hub', require: nil
  gem 'rails_layout'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'spring-commands-rspec'
end
group :development, :test do
  gem 'awesome_print'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'rubocop'
end
group :test do
  gem 'database_cleaner'
  gem 'launchy'
end
