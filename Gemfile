source 'https://rubygems.org'
ruby '1.9.3'
#ruby-gemset=railstutorial_rails_4_0

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'pg', '0.15.1'
gem 'bootstrap-sass', '2.3.2.0'
gem 'bcrypt-ruby', '3.0.1' # to irreversibly encrypt the password

# gem included only in a development environment 
# Use SCSS for stylesheets
# Use Uglifier as compressor for JavaScript assets
# Use CoffeeScript for .js.coffee assets and views
# Use jquery as the JavaScript library
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'childprocess', '0.3.9'
end

# We include the Capybara gem, which allows us to simulate a user’s interaction with the sample application using a natural English-like syntax, together with Selenium, one of Capybara’s dependencies.
group :test do
  gem 'selenium-webdriver', '2.0.0'
  gem 'capybara', '2.1.0'
end

gem 'sass-rails', '4.0.0'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.0'
gem 'jquery-rails', '2.2.1'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'rails_12factor', '0.0.2'
end


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
