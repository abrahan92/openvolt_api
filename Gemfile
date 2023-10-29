source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0', '>= 7.0.4.2'
gem 'zeitwerk', '~> 2.6', '>= 2.6.7'
# Use mysql as the database for Active Record
gem 'pg', '~> 1.4', '>= 1.4.5'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "devise", "~> 4.8"
gem "doorkeeper"
gem 'doorkeeper-grants_assertion', '~> 0.3.1'
gem "doorkeeper-jwt"
gem "rack-cors"
gem "omniauth-google-oauth2"
# gem 'omniauth', '~> 2.1'
gem "dotenv-rails"
gem 'jwt', '~> 2.4', '>= 2.4.1'
gem 'rolify', '~> 6.0'
gem 'cancancan', '~> 3.4'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem "rspec-expectations"
  gem 'factory_bot_rails', '~> 6.2'
  gem 'pry', '~> 0.14.1'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.1', '>= 4.1.1'
  gem 'spring-watcher-listen', '~> 2.1'
end

group :test do
  gem 'shoulda-matchers'
end

gem 'sidekiq'
gem 'redis-rails'
gem 'google-id-token', '~> 1.4', '>= 1.4.2'
gem 'config', '~> 4.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "shrine", "~> 3.0"
gem 'google-cloud-storage'
gem 'shrine-google_cloud_storage'
gem 'jsonapi-serializer'
gem 'json-schema'

gem "trailblazer", "~> 2.0.7"
gem 'trailblazer-cells', '~> 0.0.3'
gem 'trailblazer-operation', git: 'https://github.com/abrahan92/trailblazer_operation',
                             branch: "master"
gem "trailblazer-rails", "~> 1.0.11"
gem 'naught', '~> 1.1'
gem "dry-container"
gem "dry-monads", "~> 1.2.0", require: "dry/monads/result"
gem "dry-struct"
gem "dry-struct-setters"
gem "dry-validation"
gem "dry-types"
gem 'reform', '~> 2.6', '>= 2.6.2'
gem 'reform-rails', '~> 0.2.3'
gem 'attr_extras', '~> 7.0'
gem 'representable', '~> 3.2'
gem "pipetree"
gem "faker"
gem "stripe"
gem "money-rails"
gem "vcr"
gem "webmock"
gem 'colorize'
gem 'memoist', '~> 0.16.2'